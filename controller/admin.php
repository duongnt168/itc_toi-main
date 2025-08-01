<?php
// Admin Controller - Quản lý admin panel

require_once 'model/db.php';
require_once 'model/users.php';
require_once 'model/products.php';
require_once 'model/categories.php';
require_once 'model/orders.php';
require_once 'model/reviews.php';
require_once 'model/images.php';
require_once 'model/order_complaints.php';
require_once 'model/order_reviews.php';
require_once 'model/order_cancellations.php';
require_once 'model/vouchers.php';

class AdminController
{
    private $smarty;
    private $userModel;
    private $productModel;
    private $categoryModel;
    private $orderModel;
    private $reviewModel;
    private $imageModel;
    private $complaintModel;
    private $orderReviewModel;
    private $cancellationModel;
    private $voucherModel;

    public function __construct($smarty)
    {
        $this->smarty = $smarty;
        $this->userModel = new users();
        $this->productModel = new products();
        $this->categoryModel = new categories();
        $this->orderModel = new orders();
        $this->reviewModel = new reviews();
        $this->imageModel = new images();
        $this->complaintModel = new OrderComplaintModel();
        $this->orderReviewModel = new OrderReviewModel();
        $this->cancellationModel = new OrderCancellationModel();
        $this->voucherModel = new vouchers();

        // Check admin authentication
        $this->checkAdminAuth();
    }

    private function clearSessionMessages()
    {
        if (isset($_SESSION['success'])) {
            unset($_SESSION['success']);
        }
        if (isset($_SESSION['error'])) {
            unset($_SESSION['error']);
        }
    }

    private function checkAdminAuth()
    {
        if (!isset($_SESSION['user_id']) || $_SESSION['role'] !== 'admin') {
            header('Location: /?c=auth&a=login');
            exit;
        }
    }

    public function dashboard()
    {
        // Get statistics
        $stats = $this->getStatistics();
        $this->smarty->assign('stats', $stats);
        $this->smarty->display('admin/dashboard.tpl');
        $this->clearSessionMessages();
    }

    private function getStatistics()
    {
        global $db;

        // Total users
        $totalUsers = $db->executeQuery_list("SELECT COUNT(*) as total FROM users WHERE role = 'user'")[0]['total'];

        // Total products
        $totalProducts = $db->executeQuery_list("SELECT COUNT(*) as total FROM products")[0]['total'];

        // Total orders
        $totalOrders = $db->executeQuery_list("SELECT COUNT(*) as total FROM orders")[0]['total'];

        // Total revenue
        $revenueResult = $db->executeQuery_list("SELECT SUM(total_amount) as revenue FROM orders WHERE status = 'delivered'");
        $totalRevenue = $revenueResult[0]['revenue'] ?? 0;

        // Recent orders
        $recentOrders = $db->executeQuery_list("SELECT o.*, u.username, o.total_amount as total FROM orders o LEFT JOIN users u ON o.user_id = u.id ORDER BY o.created_at DESC LIMIT 5");

        // Low stock products
        $lowStockProducts = $db->executeQuery_list("SELECT * FROM products WHERE stock < 10 ORDER BY stock ASC LIMIT 5");

        return [
            'total_users' => $totalUsers,
            'total_products' => $totalProducts,
            'total_orders' => $totalOrders,
            'total_revenue' => $totalRevenue,
            'recent_orders' => $recentOrders,
            'low_stock_products' => $lowStockProducts
        ];
    }

    // User Management
    public function users()
    {
        global $db;
        $page = $_GET['page'] ?? 1;
        $limit = 20;
        $offset = ($page - 1) * $limit;

        $users = $db->executeQuery_list("SELECT * FROM users ORDER BY created_at DESC LIMIT $limit OFFSET $offset");
        $totalUsersResult = $db->executeQuery_list("SELECT COUNT(*) as total FROM users");
        $totalUsers = $totalUsersResult[0]['total'];
        $totalPages = ceil($totalUsers / $limit);

        $this->smarty->assign('users', $users);
        $this->smarty->assign('current_page', $page);
        $this->smarty->assign('total_pages', $totalPages);
        $this->smarty->display('admin/users/index.tpl');
        $this->clearSessionMessages();
    }

    public function editUser()
    {
        global $db;
        $id = $_GET['id'] ?? 0;

        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $username = $_POST['username'];
            $email = $_POST['email'];
            $phone = $_POST['phone'];
            $role = $_POST['role'];
            $status = $_POST['status'];
            $address = $_POST['address'];
            $gender = $_POST['gender'];

            $sql = "UPDATE users SET username='$username', email='$email', phone='$phone', role='$role', status='$status', address='$address', gender='$gender' WHERE id=$id";

            if ($db->executeQuery($sql)) {
                $_SESSION['success'] = 'Cập nhật người dùng thành công!';
                header('Location: /?c=admin&a=users');
                exit;
            } else {
                $_SESSION['error'] = 'Có lỗi xảy ra khi cập nhật!';
            }
        }

        $user = $db->executeQuery_list("SELECT * FROM users WHERE id=$id");
        $this->smarty->assign('user', $user[0] ?? []);
        $this->smarty->display('admin/users/edit.tpl');
        $this->clearSessionMessages();
    }

    public function deleteUser()
    {
        global $db;
        $id = $_GET['id'] ?? 0;

        if ($db->executeQuery("DELETE FROM users WHERE id=$id")) {
            $_SESSION['success'] = 'Xóa người dùng thành công!';
        } else {
            $_SESSION['error'] = 'Có lỗi xảy ra khi xóa!';
        }

        header('Location: /?c=admin&a=users');
        exit;
    }

    // Category Management
    public function categories()
    {
        global $db;
        $categories = $db->executeQuery_list("SELECT * FROM categories ORDER BY created_at DESC");
        $this->smarty->assign('categories', $categories);
        $this->smarty->display('admin/categories/index.tpl');
        $this->clearSessionMessages();
    }

    public function addCategory()
    {
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            global $db;
            $name = $_POST['name'];
            $description = $_POST['description'];
            $status = $_POST['status'] ?? 'active';
            $created_at = date('Y-m-d H:i:s');
            $image = null;

            // Handle image upload
            if (isset($_FILES['image']) && $_FILES['image']['error'] === 0) {
                $uploadDir = 'public/img/categories/';
                if (!is_dir($uploadDir)) {
                    mkdir($uploadDir, 0777, true);
                }

                $fileName = time() . '_' . $_FILES['image']['name'];
                $uploadPath = $uploadDir . $fileName;

                if (move_uploaded_file($_FILES['image']['tmp_name'], $uploadPath)) {
                    $image = $fileName;
                }
            }

            $sql = "INSERT INTO categories (name, description, status, image, created_at) VALUES ('$name', '$description', '$status', '$image', '$created_at')";

            if ($db->executeQuery($sql)) {
                $_SESSION['success'] = 'Thêm danh mục thành công!';
                header('Location: /?c=admin&a=categories');
                exit;
            } else {
                $_SESSION['error'] = 'Có lỗi xảy ra khi thêm danh mục!';
            }
        }

        $this->smarty->display('admin/categories/add.tpl');
        $this->clearSessionMessages();
    }

    public function editCategory()
    {
        global $db;
        $id = $_GET['id'] ?? 0;

        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $name = $_POST['name'];
            $description = $_POST['description'];
            $status = $_POST['status'];
            $image = null;

            // Handle image upload
            if (isset($_FILES['image']) && $_FILES['image']['error'] === 0) {
                $uploadDir = 'public/img/categories/';
                if (!is_dir($uploadDir)) {
                    mkdir($uploadDir, 0777, true);
                }

                $fileName = time() . '_' . $_FILES['image']['name'];
                $uploadPath = $uploadDir . $fileName;

                if (move_uploaded_file($_FILES['image']['tmp_name'], $uploadPath)) {
                    $image = $fileName;
                }
            }

            $sql = "UPDATE categories SET name='$name', description='$description', status='$status'";
            if ($image) {
                $sql .= ", image='$image'";
            }
            $sql .= " WHERE id=$id";

            if ($db->executeQuery($sql)) {
                $_SESSION['success'] = 'Cập nhật danh mục thành công!';
                header('Location: /?c=admin&a=categories');
                exit;
            } else {
                $_SESSION['error'] = 'Có lỗi xảy ra khi cập nhật!';
            }
        }

        $category = $db->executeQuery_list("SELECT * FROM categories WHERE id=$id");
        $this->smarty->assign('category', $category[0] ?? []);
        $this->smarty->display('admin/categories/edit.tpl');
        $this->clearSessionMessages();
    }

    public function deleteCategory()
    {
        global $db;
        $id = $_GET['id'] ?? 0;

        if ($db->executeQuery("DELETE FROM categories WHERE id=$id")) {
            $_SESSION['success'] = 'Xóa danh mục thành công!';
        } else {
            $_SESSION['error'] = 'Có lỗi xảy ra khi xóa!';
        }

        header('Location: /?c=admin&a=categories');
        exit;
    }

    // Product Management
    public function products()
    {
        global $db;
        $page = $_GET['page'] ?? 1;
        $limit = 20;
        $offset = ($page - 1) * $limit;

        $products = $db->executeQuery_list("SELECT p.*, c.name as category_name FROM products p LEFT JOIN categories c ON p.category_id = c.id ORDER BY p.created_at DESC LIMIT $limit OFFSET $offset");
        $totalProductsResult = $db->executeQuery_list("SELECT COUNT(*) as total FROM products");
        $totalProducts = $totalProductsResult[0]['total'];
        $totalPages = ceil($totalProducts / $limit);

        $this->smarty->assign('products', $products);
        $this->smarty->assign('current_page', $page);
        $this->smarty->assign('total_pages', $totalPages);
        $this->smarty->display('admin/products/index.tpl');
        $this->clearSessionMessages();
    }

    public function addProduct()
    {
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            global $db;
            $name = $_POST['name'];
            $description = $_POST['description'];
            $price = $_POST['price'];
            $old_price = $_POST['old_price'] ?? null;
            $category_id = $_POST['category_id'];
            $stock = $_POST['stock'];
            $is_featured = isset($_POST['is_featured']) ? 1 : 0;
            $is_flash_sale = isset($_POST['is_flash_sale']) ? 1 : 0;
            $is_sale = isset($_POST['is_sale']) ? 1 : 0;
            $discount = $_POST['discount'] ?? 0;
            $status = $_POST['status'];
            $file_url = null;
            $created_at = date('Y-m-d H:i:s');

            // Handle main image upload
            if (isset($_FILES['file_url']) && $_FILES['file_url']['error'] === 0) {
                $uploadDir = 'public/img/products/';
                if (!is_dir($uploadDir)) {
                    mkdir($uploadDir, 0777, true);
                }

                $fileName = time() . '_' . $_FILES['file_url']['name'];
                $uploadPath = $uploadDir . $fileName;

                if (move_uploaded_file($_FILES['file_url']['tmp_name'], $uploadPath)) {
                    $file_url = $fileName;
                }
            }

            $sql = "INSERT INTO products (name, description, price, old_price, category_id, stock, is_featured, is_flash_sale, is_sale, discount, status, file_url, created_at) VALUES ('$name', '$description', '$price', '$old_price', '$category_id', '$stock', '$is_featured', '$is_flash_sale', '$is_sale', '$discount', '$status', '$file_url', '$created_at')";

            if ($db->executeQuery($sql)) {
                $productId = $db->mysqli_insert_id();



                $_SESSION['success'] = 'Thêm sản phẩm thành công!';
                header('Location: /?c=admin&a=products');
                exit;
            } else {
                $_SESSION['error'] = 'Có lỗi xảy ra khi thêm sản phẩm!';
            }
        }

        global $db;
        $categories = $db->executeQuery_list("SELECT * FROM categories WHERE status='active'");
        $this->smarty->assign('categories', $categories);
        $this->smarty->display('admin/products/add.tpl');
        $this->clearSessionMessages();
    }



    public function editProduct()
    {
        $id = $_GET['id'] ?? 0;

        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $data = [
                'name' => $_POST['name'],
                'description' => $_POST['description'],
                'price' => $_POST['price'],
                'old_price' => $_POST['old_price'] ?? null,
                'category_id' => $_POST['category_id'],
                'stock' => $_POST['stock'],
                'is_featured' => isset($_POST['is_featured']) ? 1 : 0,
                'is_flash_sale' => isset($_POST['is_flash_sale']) ? 1 : 0,
                'is_sale' => isset($_POST['is_sale']) ? 1 : 0,
                'discount' => $_POST['discount'] ?? 0,
                'status' => $_POST['status']
            ];

            // Handle main image upload
            if (isset($_FILES['file_url']) && $_FILES['file_url']['error'] === 0) {
                $uploadDir = 'public/img/products/';
                if (!is_dir($uploadDir)) {
                    mkdir($uploadDir, 0777, true);
                }

                $fileName = time() . '_' . $_FILES['file_url']['name'];
                $uploadPath = $uploadDir . $fileName;

                if (move_uploaded_file($_FILES['file_url']['tmp_name'], $uploadPath)) {
                    $data['file_url'] = $fileName;
                }
            }

            global $db;
            $updateFields = [];
            foreach ($data as $key => $value) {
                if ($value !== null) {
                    $updateFields[] = "$key = '$value'";
                }
            }
            $updateSql = "UPDATE products SET " . implode(', ', $updateFields) . " WHERE id = '$id'";
            $result = $db->executeQuery($updateSql);

            if ($result) {


                $_SESSION['success'] = 'Cập nhật sản phẩm thành công!';
                header('Location: /?c=admin&a=products');
                exit;
            } else {
                $_SESSION['error'] = 'Có lỗi xảy ra khi cập nhật!';
            }
        }

        global $db;
        $productResult = $db->executeQuery_list("SELECT * FROM products WHERE id = '$id'");
        $product = $productResult[0] ?? null;
        $categories = $db->executeQuery_list("SELECT * FROM categories WHERE status='active' ORDER BY name");

        $this->smarty->assign('product', $product);
        $this->smarty->assign('categories', $categories);
        $this->smarty->display('admin/products/edit.tpl');
        $this->clearSessionMessages();
    }

    public function viewProduct()
    {
        $id = $_GET['id'] ?? 0;

        global $db;
        $productQuery = "
            SELECT p.*, c.name as category_name 
            FROM products p 
            LEFT JOIN categories c ON p.category_id = c.id 
            WHERE p.id = '$id'
        ";
        $productResult = $db->executeQuery_list($productQuery);
        $product = $productResult[0] ?? null;

        if (!$product) {
            $_SESSION['error'] = 'Không tìm thấy sản phẩm!';
            header('Location: /?c=admin&a=products');
            exit;
        }

        // Get recent reviews for this product
        $reviewsQuery = "
            SELECT r.*, u.username 
            FROM reviews r 
            LEFT JOIN users u ON r.user_id = u.id 
            WHERE r.product_id = '$id' 
            ORDER BY r.created_at DESC 
            LIMIT 5
        ";
        $reviews = $db->executeQuery_list($reviewsQuery);

        $this->smarty->assign('product', $product);
        $this->smarty->assign('reviews', $reviews);
        $this->smarty->display('admin/products/view.tpl');
        $this->clearSessionMessages();
    }

    public function deleteProduct()
    {
        $id = $_GET['id'] ?? 0;

        global $db;
        $result = $db->executeQuery("DELETE FROM products WHERE id = '$id'");

        if ($result) {
            $_SESSION['success'] = 'Xóa sản phẩm thành công!';
        } else {
            $_SESSION['error'] = 'Có lỗi xảy ra khi xóa!';
        }

        header('Location: /?c=admin&a=products');
        exit;
    }

    // Order Management
    public function orders()
    {
        $page = $_GET['page'] ?? 1;
        $limit = 20;
        $offset = ($page - 1) * $limit;

        global $db;
        $orders = $db->executeQuery_list("
            SELECT o.*, u.username, u.email, o.total_amount as total 
            FROM orders o 
            LEFT JOIN users u ON o.user_id = u.id 
            ORDER BY o.created_at DESC 
            LIMIT $limit OFFSET $offset
        ");
        $totalResult = $db->executeQuery_list("SELECT COUNT(*) as total FROM orders");
        $totalOrders = $totalResult[0]['total'];
        $totalPages = ceil($totalOrders / $limit);

        $this->smarty->assign('orders', $orders);
        $this->smarty->assign('current_page', $page);
        $this->smarty->assign('total_pages', $totalPages);
        $this->smarty->display('admin/orders/index.tpl');
        $this->clearSessionMessages();
    }

    public function viewOrder()
    {
        $id = $_GET['id'] ?? 0;
        global $db;

        // Get order with user information
        $orderQuery = "
            SELECT o.*, u.username, u.email, u.phone, o.total_amount as total
            FROM orders o 
            LEFT JOIN users u ON o.user_id = u.id 
            WHERE o.id = '$id'
        ";
        $orderResult = $db->executeQuery_list($orderQuery);
        $order = $orderResult[0] ?? null;

        // Get order items with product information
        $orderItemsQuery = "
            SELECT oi.*, p.name as product_name, p.file_url as product_file_url
            FROM order_items oi
            LEFT JOIN products p ON oi.product_id = p.id
            WHERE oi.order_id = '$id'
        ";
        $orderItems = $db->executeQuery_list($orderItemsQuery);

        $this->smarty->assign('order', $order);
        $this->smarty->assign('order_items', $orderItems);
        $this->smarty->display('admin/orders/view.tpl');
        $this->clearSessionMessages();
    }

    public function updateOrderStatus()
    {
        $id = $_POST['order_id'] ?? 0;
        $status = $_POST['status'] ?? '';

        global $db;
        $result = $db->executeQuery("UPDATE orders SET status = '$status' WHERE id = '$id'");

        if ($result) {
            $_SESSION['success'] = 'Cập nhật trạng thái đơn hàng thành công!';
        } else {
            $_SESSION['error'] = 'Có lỗi xảy ra khi cập nhật!';
        }

        header('Location: /?c=admin&a=viewOrder&id=' . $id);
        exit;
    }

    // Review Management
    public function reviews()
    {
        $page = $_GET['page'] ?? 1;
        $limit = 20;
        $offset = ($page - 1) * $limit;

        // Build WHERE clause for filters
        $whereConditions = [];
        $params = [];

        if (isset($_GET['rating']) && $_GET['rating'] !== '') {
            $whereConditions[] = "r.rating = ?";
            $params[] = $_GET['rating'];
        }

        if (isset($_GET['status']) && $_GET['status'] !== '') {
            $whereConditions[] = "r.status = ?";
            $params[] = $_GET['status'];
        }

        if (isset($_GET['date']) && $_GET['date'] !== '') {
            $whereConditions[] = "DATE(r.created_at) = ?";
            $params[] = $_GET['date'];
        }

        if (isset($_GET['search']) && $_GET['search'] !== '') {
            $whereConditions[] = "(r.comment LIKE ? OR p.name LIKE ? OR u.username LIKE ?)";
            $searchTerm = '%' . $_GET['search'] . '%';
            $params[] = $searchTerm;
            $params[] = $searchTerm;
            $params[] = $searchTerm;
        }

        $whereClause = !empty($whereConditions) ? 'WHERE ' . implode(' AND ', $whereConditions) : '';

        global $db;
        $reviewsQuery = "
            SELECT r.*, 
                   p.name as product_name, 
                   p.file_url as product_file_url,
                   u.username, 
                   u.email 
            FROM reviews r 
            LEFT JOIN products p ON r.product_id = p.id 
            LEFT JOIN users u ON r.user_id = u.id 
            $whereClause
            ORDER BY r.created_at DESC 
            LIMIT $limit OFFSET $offset
        ";

        $countQuery = "
            SELECT COUNT(*) as total 
            FROM reviews r 
            LEFT JOIN products p ON r.product_id = p.id 
            LEFT JOIN users u ON r.user_id = u.id 
            $whereClause
        ";

        $reviews = $db->executeQuery_list($reviewsQuery);
        $totalResult = $db->executeQuery_list($countQuery);
        $totalReviews = $totalResult[0]['total'] ?? 0;
        $totalPages = ceil($totalReviews / $limit);

        $this->smarty->assign('reviews', $reviews);
        $this->smarty->assign('current_page', $page);
        $this->smarty->assign('total_pages', $totalPages);
        $this->smarty->display('admin/reviews/index.tpl');
        $this->clearSessionMessages();
    }

    public function updateReviewStatus()
    {
        $id = $_POST['review_id'] ?? 0;
        $status = $_POST['status'] ?? '';

        global $db;
        $result = $db->executeQuery("UPDATE reviews SET status = '$status' WHERE id = '$id'");

        if ($result) {
            $_SESSION['success'] = 'Cập nhật trạng thái đánh giá thành công!';
        } else {
            $_SESSION['error'] = 'Có lỗi xảy ra khi cập nhật!';
        }

        header('Location: /?c=admin&a=reviews');
        exit;
    }

    public function approveReview()
    {
        $id = $_GET['id'] ?? 0;

        global $db;
        $result = $db->executeQuery("UPDATE reviews SET status = 'approved' WHERE id = '$id'");

        if ($result) {
            $_SESSION['success'] = 'Duyệt đánh giá thành công!';
        } else {
            $_SESSION['error'] = 'Có lỗi xảy ra khi duyệt!';
        }

        header('Location: /?c=admin&a=reviews');
        exit;
    }

    public function rejectReview()
    {
        $id = $_GET['id'] ?? 0;

        global $db;
        $result = $db->executeQuery("UPDATE reviews SET status = 'rejected' WHERE id = '$id'");

        if ($result) {
            $_SESSION['success'] = 'Từ chối đánh giá thành công!';
        } else {
            $_SESSION['error'] = 'Có lỗi xảy ra khi từ chối!';
        }

        header('Location: /?c=admin&a=reviews');
        exit;
    }

    public function deleteReview()
    {
        $id = $_GET['id'] ?? 0;

        global $db;
        $result = $db->executeQuery("DELETE FROM reviews WHERE id = '$id'");

        if ($result) {
            $_SESSION['success'] = 'Xóa đánh giá thành công!';
        } else {
            $_SESSION['error'] = 'Có lỗi xảy ra khi xóa!';
        }

        header('Location: /?c=admin&a=reviews');
        exit;
    }

    public function viewReview()
    {
        $id = $_GET['id'] ?? 0;

        global $db;
        $reviewQuery = "
            SELECT r.*, 
                   p.name as product_name, 
                   p.file_url as product_file_url,
                   p.price as product_price,
                   c.name as category_name,
                   u.username, 
                   u.email 
            FROM reviews r 
            LEFT JOIN products p ON r.product_id = p.id 
            LEFT JOIN categories c ON p.category_id = c.id
            LEFT JOIN users u ON r.user_id = u.id 
            WHERE r.id = '$id'
        ";
        $reviewResult = $db->executeQuery_list($reviewQuery);
        $review = $reviewResult[0] ?? null;

        if (!$review) {
            $_SESSION['error'] = 'Không tìm thấy đánh giá!';
            header('Location: /?c=admin&a=reviews');
            exit;
        }

        // Get product statistics
        $productStatsQuery = "
            SELECT 
                COUNT(*) as total_reviews,
                COUNT(CASE WHEN status = 'approved' THEN 1 END) as approved_reviews,
                COUNT(CASE WHEN status = 'pending' THEN 1 END) as pending_reviews,
                COALESCE(AVG(rating), 0) as avg_rating
            FROM reviews 
            WHERE product_id = '{$review['product_id']}'
        ";
        $productStatsResult = $db->executeQuery_list($productStatsQuery);
        $productStats = $productStatsResult[0] ?? [];

        // Get other reviews from the same user
        $otherReviewsQuery = "
            SELECT r.*, 
                   p.name as product_name, 
                   p.file_url as product_file_url
            FROM reviews r 
            LEFT JOIN products p ON r.product_id = p.id 
            WHERE r.user_id = '{$review['user_id']}' 
            AND r.id != '$id'
            ORDER BY r.created_at DESC 
            LIMIT 5
        ";
        $otherReviews = $db->executeQuery_list($otherReviewsQuery);

        $this->smarty->assign('review', $review);
        $this->smarty->assign('product_stats', $productStats);
        $this->smarty->assign('other_reviews', $otherReviews);
        $this->smarty->display('admin/reviews/view.tpl');
        $this->clearSessionMessages();
    }

    // User Management
    public function viewUser()
    {
        $id = $_GET['id'] ?? 0;

        global $db;
        $userResult = $db->executeQuery_list("SELECT * FROM users WHERE id = '$id'");
        $user = $userResult[0] ?? null;

        if (!$user) {
            $_SESSION['error'] = 'Không tìm thấy người dùng!';
            header('Location: /?c=admin&a=users');
            exit;
        }

        // Get user statistics
        $statsQuery = "
            SELECT 
                COUNT(DISTINCT o.id) as total_orders,
                COALESCE(SUM(o.total_amount), 0) as total_spent,
                COUNT(DISTINCT r.id) as total_reviews,
                COALESCE(AVG(r.rating), 0) as avg_rating
            FROM users u
            LEFT JOIN orders o ON u.id = o.user_id
            LEFT JOIN reviews r ON u.id = r.user_id
            WHERE u.id = '$id'
        ";
        $statsResult = $db->executeQuery_list($statsQuery);
        $userStats = $statsResult[0] ?? [];

        // Get recent orders
        $recentOrdersQuery = "
            SELECT * FROM orders 
            WHERE user_id = '$id' 
            ORDER BY created_at DESC 
            LIMIT 5
        ";
        $recentOrders = $db->executeQuery_list($recentOrdersQuery);

        // Get recent reviews
        $recentReviewsQuery = "
            SELECT r.*, p.name as product_name 
            FROM reviews r 
            LEFT JOIN products p ON r.product_id = p.id 
            WHERE r.user_id = '$id' 
            ORDER BY r.created_at DESC 
            LIMIT 5
        ";
        $recentReviews = $db->executeQuery_list($recentReviewsQuery);

        $this->smarty->assign('user', $user);
        $this->smarty->assign('user_stats', $userStats);
        $this->smarty->assign('recent_orders', $recentOrders);
        $this->smarty->assign('recent_reviews', $recentReviews);
        $this->smarty->display('admin/users/view.tpl');
        $this->clearSessionMessages();
    }

    // Category Management
    public function viewCategory()
    {
        $id = $_GET['id'] ?? 0;

        global $db;
        $categoryResult = $db->executeQuery_list("SELECT * FROM categories WHERE id = '$id'");
        $category = $categoryResult[0] ?? null;

        if (!$category) {
            $_SESSION['error'] = 'Không tìm thấy danh mục!';
            header('Location: /?c=admin&a=categories');
            exit;
        }

        // Get category statistics
        $statsQuery = "
            SELECT 
                COUNT(DISTINCT p.id) as total_products,
                COUNT(CASE WHEN p.status = 'active' THEN 1 END) as active_products,
                COUNT(DISTINCT r.id) as total_reviews,
                COALESCE(AVG(r.rating), 0) as avg_rating
            FROM categories c
            LEFT JOIN products p ON c.id = p.category_id
            LEFT JOIN reviews r ON p.id = r.product_id
            WHERE c.id = '$id'
        ";
        $statsResult = $db->executeQuery_list($statsQuery);
        $categoryStats = $statsResult[0] ?? [];

        // Get top selling products in this category
        $topProductsQuery = "
            SELECT p.*, 
                   COALESCE(SUM(oi.quantity), 0) as total_sold
            FROM products p
            LEFT JOIN order_items oi ON p.id = oi.product_id
            LEFT JOIN orders o ON oi.order_id = o.id AND o.status = 'completed'
            WHERE p.category_id = '$id'
            GROUP BY p.id
            ORDER BY total_sold DESC
            LIMIT 5
        ";
        $topProducts = $db->executeQuery_list($topProductsQuery);

        // Get recent products in this category
        $recentProductsQuery = "
            SELECT * FROM products 
            WHERE category_id = '$id' 
            ORDER BY created_at DESC 
            LIMIT 10
        ";
        $recentProducts = $db->executeQuery_list($recentProductsQuery);

        $this->smarty->assign('category', $category);
        $this->smarty->assign('category_stats', $categoryStats);
        $this->smarty->assign('top_products', $topProducts);
        $this->smarty->assign('recent_products', $recentProducts);
        $this->smarty->display('admin/categories/view.tpl');
        $this->clearSessionMessages();
    }

    // Reports
    public function reports()
    {
        $this->smarty->display('admin/reports.tpl');
        $this->clearSessionMessages();
    }

    // Complaint Management
    public function complaints()
    {
        $page = $_GET['page'] ?? 1;
        $limit = 20;
        $status = $_GET['status'] ?? '';

        $complaints = $this->complaintModel->getComplaintsForAdmin($page, $limit, $status);
        $totalComplaints = $this->complaintModel->countComplaints($status);
        $totalPages = ceil($totalComplaints / $limit);

        $this->smarty->assign('complaints', $complaints);
        $this->smarty->assign('current_page', $page);
        $this->smarty->assign('total_pages', $totalPages);
        $this->smarty->assign('filter_status', $status);
        $this->smarty->display('admin/complaints/index.tpl');
        $this->clearSessionMessages();
    }

    public function complaint_detail()
    {
        $id = $_GET['id'] ?? 0;

        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $status = $_POST['status'];
            $adminResponse = $_POST['admin_response'];
            $priority = $_POST['priority'] ?? null;
            $adminId = $_SESSION['user_id'];

            if ($this->complaintModel->updateComplaintStatus($id, $status, $adminResponse, $adminId, $priority)) {
                $_SESSION['success'] = 'Cập nhật khiếu nại thành công!';
            } else {
                $_SESSION['error'] = 'Có lỗi xảy ra khi cập nhật!';
            }

            header('Location: /?c=admin&a=complaint_detail&id=' . $id);
            exit;
        }

        $complaint = $this->complaintModel->getComplaintDetail($id);
        if (!$complaint) {
            $_SESSION['error'] = 'Không tìm thấy khiếu nại!';
            header('Location: /?c=admin&a=complaints');
            exit;
        }

        $this->smarty->assign('complaint', $complaint);
        $this->smarty->display('admin/complaints/detail.tpl');
        $this->clearSessionMessages();
    }

    public function delete_complaint()
    {
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $id = $_POST['id'] ?? 0;
            
            if ($this->complaintModel->deleteComplaint($id)) {
                $_SESSION['success'] = 'Xóa khiếu nại thành công!';
            } else {
                $_SESSION['error'] = 'Có lỗi xảy ra khi xóa khiếu nại!';
            }
        }
        
        header('Location: /?c=admin&a=complaints');
        exit;
    }

    // Order Review Management
    public function order_reviews()
    {
        $page = $_GET['page'] ?? 1;
        $limit = 20;
        $status = $_GET['status'] ?? '';

        $reviews = $this->orderReviewModel->getReviewsForAdmin($page, $limit, $status);
        $totalReviews = $this->orderReviewModel->countReviews($status);
        $totalPages = ceil($totalReviews / $limit);



        $this->smarty->assign('order_reviews', $reviews);
        $this->smarty->assign('current_page', $page);
        $this->smarty->assign('total_pages', $totalPages);
        $this->smarty->assign('filter_status', $status);
        $this->smarty->display('admin/order_reviews/index.tpl');
        $this->clearSessionMessages();
    }

    public function order_review_detail()
    {
        $id = $_GET['id'] ?? 0;

        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $status = $_POST['status'];

            if ($this->orderReviewModel->updateReviewStatus($id, $status)) {
                $_SESSION['success'] = 'Cập nhật đánh giá thành công!';
            } else {
                $_SESSION['error'] = 'Có lỗi xảy ra khi cập nhật!';
            }

            header('Location: /?c=admin&a=order_review_detail&id=' . $id);
            exit;
        }

        $review = $this->orderReviewModel->getReviewDetail($id);
        if (!$review) {
            $_SESSION['error'] = 'Không tìm thấy đánh giá!';
            header('Location: /?c=admin&a=order_reviews');
            exit;
        }

        $this->smarty->assign('order_review', $review);
        $this->smarty->display('admin/order_reviews/detail.tpl');
        $this->clearSessionMessages();
    }

    // Order Cancellation Management
    public function cancellations()
    {
        $page = $_GET['page'] ?? 1;
        $limit = 20;
        $status = $_GET['status'] ?? '';

        $cancellations = $this->cancellationModel->getCancellationsForAdmin($page, $limit, $status);
        $totalCancellations = $this->cancellationModel->countCancellations($status);
        $totalPages = ceil($totalCancellations / $limit);

        $this->smarty->assign('cancellations', $cancellations);
        $this->smarty->assign('current_page', $page);
        $this->smarty->assign('total_pages', $totalPages);
        $this->smarty->assign('filter_status', $status);
        $this->smarty->display('admin/cancellations/index.tpl');
        $this->clearSessionMessages();
    }

    public function cancellation_detail()
    {
        $id = $_GET['id'] ?? 0;

        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $action = $_POST['action'];
            $adminResponse = $_POST['admin_response'] ?? '';

            if ($action === 'approve') {
                if ($this->cancellationModel->approveCancellation($id, $adminResponse, $_SESSION['user_id'])) {
                    $_SESSION['success'] = 'Đã chấp nhận yêu cầu hủy đơn hàng!';
                } else {
                    $_SESSION['error'] = 'Có lỗi xảy ra khi xử lý!';
                }
            } elseif ($action === 'reject') {
                if ($this->cancellationModel->rejectCancellation($id, $adminResponse, $_SESSION['user_id'])) {
                    $_SESSION['success'] = 'Đã từ chối yêu cầu hủy đơn hàng!';
                } else {
                    $_SESSION['error'] = 'Có lỗi xảy ra khi xử lý!';
                }
            }

            header('Location: /?c=admin&a=cancellation_detail&id=' . $id);
            exit;
        }

        $cancellation = $this->cancellationModel->getCancellationDetail($id);
        if (!$cancellation) {
            $_SESSION['error'] = 'Không tìm thấy yêu cầu hủy!';
            header('Location: /?c=admin&a=cancellations');
            exit;
        }

        $this->smarty->assign('cancellation', $cancellation);
        $this->smarty->display('admin/cancellations/detail.tpl');
        $this->clearSessionMessages();
    }

    public function edit_cancellation()
    {
        $id = $_GET['id'] ?? 0;

        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $reason = $_POST['reason'];
            $description = $_POST['description'];
            $status = $_POST['status'];
            $admin_response = $_POST['admin_response'] ?? '';

            if ($this->cancellationModel->updateCancellationDetails($id, $reason, $description, $status, $admin_response)) {
                $_SESSION['success'] = 'Cập nhật yêu cầu hủy thành công!';
            } else {
                $_SESSION['error'] = 'Có lỗi xảy ra khi cập nhật!';
            }

            header('Location: /?c=admin&a=cancellation_detail&id=' . $id);
            exit;
        }

        $cancellation = $this->cancellationModel->getCancellationDetail($id);
        if (!$cancellation) {
            $_SESSION['error'] = 'Không tìm thấy yêu cầu hủy!';
            header('Location: /?c=admin&a=cancellations');
            exit;
        }

        $this->smarty->assign('cancellation', $cancellation);
        $this->smarty->display('admin/cancellations/edit.tpl');
        $this->clearSessionMessages();
    }

    public function delete_cancellation()
    {
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $id = $_GET['id'] ?? 0;
            
            if ($this->cancellationModel->deleteCancellation($id)) {
                $_SESSION['success'] = 'Xóa yêu cầu hủy thành công!';
            } else {
                $_SESSION['error'] = 'Có lỗi xảy ra khi xóa yêu cầu hủy!';
            }
        }
        
        header('Location: /?c=admin&a=cancellations');
        exit;
    }

    // Voucher Management
    public function vouchers()
    {
        $page = $_GET['page'] ?? 1;
        $limit = 20;
        $offset = ($page - 1) * $limit;
        $status = $_GET['status'] ?? '';

        $vouchers = $this->voucherModel->getAllVouchers();
        if ($status) {
            $vouchers = $this->voucherModel->getVouchersByStatus($status);
        }

        // Pagination
        $totalVouchers = count($vouchers);
        $vouchers = array_slice($vouchers, $offset, $limit);
        $totalPages = ceil($totalVouchers / $limit);

        $this->smarty->assign('vouchers', $vouchers);
        $this->smarty->assign('current_page', $page);
        $this->smarty->assign('total_pages', $totalPages);
        $this->smarty->assign('filter_status', $status);
        $this->smarty->display('admin/vouchers/index.tpl');
        $this->clearSessionMessages();
    }

    public function add_voucher()
    {
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $data = [
                'code' => $_POST['code'],
                'type' => $_POST['type'],
                'value' => $_POST['value'],
                'min_order_amount' => $_POST['min_order_amount'] ?? 0,
                'max_uses' => $_POST['max_uses'] ?? null,
                'start_date' => $_POST['start_date'] ?? null,
                'end_date' => $_POST['end_date'] ?? null,
                'status' => $_POST['status'] ?? 'active'
            ];

            // Validate voucher code uniqueness
            $existingVoucher = $this->voucherModel->getVoucherByCode($data['code']);
            if ($existingVoucher) {
                $_SESSION['error'] = 'Mã voucher đã tồn tại!';
            } else {
                if ($this->voucherModel->addVoucher($data)) {
                    $_SESSION['success'] = 'Thêm voucher thành công!';
                    header('Location: /?c=admin&a=vouchers');
                    exit;
                } else {
                    $_SESSION['error'] = 'Có lỗi xảy ra khi thêm voucher!';
                }
            }
        }

        $this->smarty->display('admin/vouchers/add.tpl');
        $this->clearSessionMessages();
    }

    public function edit_voucher()
    {
        $id = $_GET['id'] ?? 0;

        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $data = [
                'code' => $_POST['code'],
                'type' => $_POST['type'],
                'value' => $_POST['value'],
                'min_order_amount' => $_POST['min_order_amount'] ?? 0,
                'max_uses' => $_POST['max_uses'] ?? null,
                'start_date' => $_POST['start_date'] ?? null,
                'end_date' => $_POST['end_date'] ?? null,
                'status' => $_POST['status'] ?? 'active'
            ];

            // Check if code exists for other vouchers
            $existingVoucher = $this->voucherModel->getVoucherByCode($data['code']);
            if ($existingVoucher && $existingVoucher['id'] != $id) {
                $_SESSION['error'] = 'Mã voucher đã tồn tại!';
            } else {
                if ($this->voucherModel->updateVoucher($id, $data)) {
                    $_SESSION['success'] = 'Cập nhật voucher thành công!';
                    header('Location: /?c=admin&a=vouchers');
                    exit;
                } else {
                    $_SESSION['error'] = 'Có lỗi xảy ra khi cập nhật voucher!';
                }
            }
        }

        $voucher = $this->voucherModel->getVoucherById($id);
        if (!$voucher) {
            $_SESSION['error'] = 'Không tìm thấy voucher!';
            header('Location: /?c=admin&a=vouchers');
            exit;
        }

        $this->smarty->assign('voucher', $voucher);
        $this->smarty->display('admin/vouchers/edit.tpl');
        $this->clearSessionMessages();
    }

    public function delete_voucher()
    {
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $id = $_POST['id'] ?? 0;
            
            if ($this->voucherModel->deleteVoucher($id)) {
                $_SESSION['success'] = 'Xóa voucher thành công!';
            } else {
                $_SESSION['error'] = 'Có lỗi xảy ra khi xóa voucher!';
            }
        }
        
        header('Location: /?c=admin&a=vouchers');
        exit;
    }

    public function generate_voucher_code()
    {
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $prefix = $_POST['prefix'] ?? 'VOUCHER';
            $code = $this->voucherModel->generateVoucherCode($prefix);
            
            header('Content-Type: application/json');
            echo json_encode(['code' => $code]);
            exit;
        }
    }

    public function logout()
    {
        session_destroy();
        header('Location: /?c=auth&a=login');
        exit;
    }
}
?>