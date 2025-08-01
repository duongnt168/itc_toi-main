<?php
// User Controller - Quản lý user panel

require_once 'model/db.php';
require_once 'model/users.php';
require_once 'model/products.php';
require_once 'model/categories.php';
require_once 'model/orders.php';
require_once 'model/reviews.php';
require_once 'model/cart.php';
require_once 'model/order_complaints.php';
require_once 'model/order_reviews.php';
require_once 'model/order_cancellations.php';

class UserController
{
    private $smarty;
    private $userModel;
    private $productModel;
    private $categoryModel;
    private $orderModel;
    private $reviewModel;
    private $cartModel;
    private $complaintModel;
    private $orderReviewModel;
    private $cancellationModel;

    public function __construct($smarty)
    {
        $this->smarty = $smarty;
        $this->userModel = new users();
        $this->productModel = new products();
        $this->categoryModel = new categories();
        $this->orderModel = new orders();
        $this->reviewModel = new reviews();
        $this->cartModel = new cart();
        $this->complaintModel = new OrderComplaintModel();
        $this->orderReviewModel = new OrderReviewModel();
        $this->cancellationModel = new OrderCancellationModel();

        // Check user authentication
        $this->checkUserAuth();
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

    private function checkUserAuth()
    {
        if (!isset($_SESSION['user_id']) || empty($_SESSION['user_id'])) {
            header('Location: /?c=auth&v=login');
            exit;
        }
    }

    public function index()
    {
        // Trang chủ người dùng
        global $db;

        // Load danh mục sản phẩm
        $categories = $db->executeQuery_list("SELECT * FROM categories WHERE status = 'active' ORDER BY name ASC");

        // Load sản phẩm nổi bật
        $featured_products = $db->executeQuery_list("SELECT * FROM products WHERE status = 'active' AND is_featured = 1 ORDER BY created_at DESC LIMIT 8");

        // Format giá cho sản phẩm nổi bật
        foreach ($featured_products as &$product) {
            $product['formatted_price'] = number_format($product['price'], 0, ',', '.') . ' VNĐ';
            if ($product['old_price'] && $product['old_price'] > 0) {
                $product['formatted_old_price'] = number_format($product['old_price'], 0, ',', '.') . ' VNĐ';
            }
        }

        // Load sản phẩm khuyến mãi
        $sale_products = $db->executeQuery_list("SELECT * FROM products WHERE status = 'active' AND is_sale = 1 ORDER BY created_at DESC LIMIT 8");

        // Format giá cho sản phẩm khuyến mãi
        foreach ($sale_products as &$product) {
            $product['formatted_price'] = number_format($product['price'], 0, ',', '.') . ' VNĐ';
            if ($product['old_price'] && $product['old_price'] > 0) {
                $product['formatted_old_price'] = number_format($product['old_price'], 0, ',', '.') . ' VNĐ';
            }
        }

        // Load sản phẩm flash sale
        $flash_sale_products = $db->executeQuery_list("SELECT * FROM products WHERE status = 'active' AND is_flash_sale = 1 ORDER BY created_at DESC LIMIT 8");

        // Format giá cho sản phẩm flash sale
        foreach ($flash_sale_products as &$product) {
            $product['formatted_price'] = number_format($product['price'], 0, ',', '.') . ' VNĐ';
            if ($product['old_price'] && $product['old_price'] > 0) {
                $product['formatted_old_price'] = number_format($product['old_price'], 0, ',', '.') . ' VNĐ';
            }
        }

        // Load banner (tạm thời để trống vì chưa có bảng)
        $banners = array();

        // Load tin tức (tạm thời để trống vì chưa có bảng)
        $news = array();

        // Assign dữ liệu cho template
        $this->smarty->assign('categories', $categories);
        $this->smarty->assign('featured_products', $featured_products);
        $this->smarty->assign('sale_products', $sale_products);
        $this->smarty->assign('flash_sale_products', $flash_sale_products);
        $this->smarty->assign('banners', $banners);
        $this->smarty->assign('news', $news);

        $this->smarty->assign('username', $_SESSION['username']);
        $this->smarty->assign('email', $_SESSION['email']);
        $this->smarty->assign('user_email', $_SESSION['email']);
        $this->smarty->assign('user_name', $_SESSION['username']);

        // Assign cart items for navbar
        $this->smarty->assign('cart_items', getCartItemsForNavbar());
        $this->smarty->display('user/index.tpl');
        $this->clearSessionMessages();
    }

    public function welcome()
    {
        // Trang chào mừng sau khi đăng nhập
        $this->smarty->assign('username', $_SESSION['username']);
        $this->smarty->assign('email', $_SESSION['email']);
        $this->smarty->assign('user_email', $_SESSION['email']);
        $this->smarty->assign('user_name', $_SESSION['username']);

        // Assign cart items for navbar
        $this->smarty->assign('cart_items', getCartItemsForNavbar());
        $this->smarty->display('user/welcome.tpl');
        $this->clearSessionMessages();
    }

    public function profile()
    {
        // Trang thông tin cá nhân
        $user_data = $this->userModel->record_get_by_id($_SESSION['user_id']);
        $this->smarty->assign('user', $user_data);
        $this->smarty->assign('user_email', $_SESSION['email']);
        $this->smarty->assign('user_name', $_SESSION['username']);

        // Assign cart items for navbar
        $this->smarty->assign('cart_items', getCartItemsForNavbar());
        $this->smarty->display('user/profile.tpl');
        $this->clearSessionMessages();
    }

    public function update_profile()
    {
        // Cập nhật thông tin cá nhân
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $username = trim($_POST['username']);
            $phone = trim($_POST['phone']);
            $address = trim($_POST['address'] ?? '');
            $gender = $_POST['gender'] ?? '';

            if (empty($username) || empty($phone)) {
                $_SESSION['error'] = 'Vui lòng nhập đầy đủ thông tin!';
            } else {
                $this->userModel->set('id', $_SESSION['user_id']);
                $this->userModel->set('username', $username);
                $this->userModel->set('phone', $phone);
                $this->userModel->set('address', $address);
                $this->userModel->set('gender', $gender);

                if (
                    $this->userModel->update_field('username') &&
                    $this->userModel->update_field('phone') &&
                    $this->userModel->update_field('address') &&
                    $this->userModel->update_field('gender')
                ) {
                    $_SESSION['username'] = $username;
                    $_SESSION['success'] = 'Cập nhật thông tin thành công!';
                } else {
                    $_SESSION['error'] = 'Có lỗi xảy ra. Vui lòng thử lại!';
                }
            }

            header('Location: /?c=user&v=profile');
            exit;
        }

        // Hiển thị form cập nhật
        $this->profile();
    }

    public function change_password()
    {
        // Đổi mật khẩu
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $current_password = $_POST['current_password'];
            $new_password = $_POST['new_password'];
            $confirm_password = $_POST['confirm_password'];

            if (empty($current_password) || empty($new_password) || empty($confirm_password)) {
                $_SESSION['error'] = 'Vui lòng nhập đầy đủ thông tin!';
            } elseif ($new_password != $confirm_password) {
                $_SESSION['error'] = 'Mật khẩu mới không khớp!';
            } elseif (strlen($new_password) < 6) {
                $_SESSION['error'] = 'Mật khẩu mới phải có ít nhất 6 ký tự!';
            } else {
                // Kiểm tra mật khẩu hiện tại
                $user_data = $this->userModel->record_get_by_id($_SESSION['user_id']);

                if ($user_data['password'] != md5($current_password)) {
                    $_SESSION['error'] = 'Mật khẩu hiện tại không đúng!';
                } else {
                    // Cập nhật mật khẩu mới
                    $this->userModel->set('id', $_SESSION['user_id']);
                    $this->userModel->set('password', md5($new_password));

                    if ($this->userModel->update_field('password')) {
                        $_SESSION['success'] = 'Đổi mật khẩu thành công!';
                    } else {
                        $_SESSION['error'] = 'Có lỗi xảy ra. Vui lòng thử lại!';
                    }
                }
            }

            header('Location: /?c=user&v=profile');
            exit;
        }

        // Hiển thị form đổi mật khẩu
        $this->smarty->assign('user_email', $_SESSION['email']);
        $this->smarty->assign('user_name', $_SESSION['username']);
        $this->smarty->display('user/change_password.tpl');
        $this->clearSessionMessages();
    }

    public function orders()
    {
        // Danh sách đơn hàng của user
        global $db;
        $page = $_GET['page'] ?? 1;
        $limit = 10;
        $offset = ($page - 1) * $limit;
        $user_id = $_SESSION['user_id'];

        $orders = $db->executeQuery_list("
            SELECT o.*, COALESCE(COUNT(oi.id), 0) as item_count 
            FROM orders o 
            LEFT JOIN order_items oi ON o.id = oi.order_id 
            WHERE o.user_id = '$user_id' 
            GROUP BY o.id 
            ORDER BY o.created_at DESC 
            LIMIT $limit OFFSET $offset
        ");

        $totalOrdersResult = $db->executeQuery_list("SELECT COUNT(*) as total FROM orders WHERE user_id = '$user_id'");
        $totalOrders = $totalOrdersResult[0]['total'];
        $totalPages = ceil($totalOrders / $limit);

        $this->smarty->assign('orders', $orders);
        $this->smarty->assign('current_page', $page);
        $this->smarty->assign('total_pages', $totalPages);
        $this->smarty->assign('user_email', $_SESSION['email']);
        $this->smarty->assign('user_name', $_SESSION['username']);
        $this->smarty->display('user/orders.tpl');
        $this->clearSessionMessages();
    }

    public function order_detail()
    {
        // Chi tiết đơn hàng
        $order_id = $_GET['id'] ?? 0;
        $user_id = $_SESSION['user_id'];

        global $db;
        $orderResult = $db->executeQuery_list("
            SELECT * FROM orders 
            WHERE id = '$order_id' AND user_id = '$user_id'
        ");

        if (empty($orderResult)) {
            $_SESSION['error'] = 'Không tìm thấy đơn hàng!';
            header('Location: /?c=user&v=orders');
            exit;
        }

        $order = $orderResult[0];

        $orderItems = $db->executeQuery_list("
            SELECT oi.*, p.name, p.file_url as image 
            FROM order_items oi 
            LEFT JOIN products p ON oi.product_id = p.id 
            WHERE oi.order_id = '$order_id'
        ");

        // Kiểm tra xem đơn hàng đã được đánh giá chưa
        $hasReview = $this->orderReviewModel->hasReview($order_id, $user_id);

        $this->smarty->assign('order', $order);
        $this->smarty->assign('order_items', $orderItems);
        $this->smarty->assign('has_review', $hasReview);
        $this->smarty->assign('user_email', $_SESSION['email']);
        $this->smarty->assign('user_name', $_SESSION['username']);
        $this->smarty->display('user/order_detail.tpl');
        $this->clearSessionMessages();
    }

    public function cart()
    {
        // Giỏ hàng
        $this->smarty->assign('user_email', $_SESSION['email']);
        $this->smarty->assign('user_name', $_SESSION['username']);
        $this->smarty->display('user/cart.tpl');
        $this->clearSessionMessages();
    }

    public function checkout()
    {
        // Thanh toán
        $this->smarty->assign('user_email', $_SESSION['email']);
        $this->smarty->assign('user_name', $_SESSION['username']);
        $this->smarty->display('user/checkout.tpl');
        $this->clearSessionMessages();
    }

    public function gioithieu()
    {
        // Trang giới thiệu
        $this->smarty->assign('user_email', $_SESSION['email'] ?? null);
        $this->smarty->assign('user_name', $_SESSION['username'] ?? null);
        $this->smarty->display('user/gioithieu.tpl');
        $this->clearSessionMessages();
    }

    public function logout()
    {
        // Đăng xuất
        session_destroy();
        header('Location: /?c=auth&v=login');
        exit;
    }

    // === CHỨC NĂNG KHIẾU NẠI ===
    public function complaints()
    {
        // Danh sách khiếu nại của user
        $page = $_GET['page'] ?? 1;
        $limit = 10;
        $offset = ($page - 1) * $limit;
        $user_id = $_SESSION['user_id'];

        $complaints = $this->complaintModel->getUserComplaints($user_id, $limit, $offset);
        $totalComplaints = $this->complaintModel->countComplaints(null, $user_id);
        $totalPages = ceil($totalComplaints / $limit);

        $this->smarty->assign('complaints', $complaints);
        $this->smarty->assign('current_page', $page);
        $this->smarty->assign('total_pages', $totalPages);
        $this->smarty->assign('user_email', $_SESSION['email']);
        $this->smarty->assign('user_name', $_SESSION['username']);
        $this->smarty->display('user/complaints.tpl');
        $this->clearSessionMessages();
    }

    public function create_complaint()
    {
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $order_id = $_POST['order_id'];
            $type = $_POST['type'];
            $subject = trim($_POST['subject']);
            $description = isset($_POST['description']) ? trim($_POST['description']) : '';
            $user_id = $_SESSION['user_id'];

            if (empty($subject) || empty($description)) {
                $_SESSION['error'] = 'Vui lòng nhập đầy đủ thông tin khiếu nại!';
            } else {
                // Kiểm tra xem đã có khiếu nại cho đơn hàng này chưa
                if ($this->complaintModel->hasComplaint($order_id, $user_id)) {
                    $_SESSION['error'] = 'Bạn đã tạo khiếu nại cho đơn hàng này rồi!';
                } else {
                    $data = [
                        'order_id' => $order_id,
                        'user_id' => $user_id,
                        'type' => $type,
                        'subject' => $subject,
                        'description' => $description
                    ];

                    if ($this->complaintModel->createComplaint($data)) {
                        $_SESSION['success'] = 'Tạo khiếu nại thành công! Chúng tôi sẽ xử lý trong thời gian sớm nhất.';
                        header('Location: /?c=user&v=complaints');
                        exit;
                    } else {
                        $_SESSION['error'] = 'Có lỗi xảy ra. Vui lòng thử lại!';
                    }
                }
            }
        }

        // Hiển thị form tạo khiếu nại
        $order_id = $_GET['order_id'] ?? 0;
        if ($order_id) {
            global $db;
            $order = $db->executeQuery("SELECT * FROM orders WHERE id = '$order_id' AND user_id = '{$_SESSION['user_id']}'", 1);
            $this->smarty->assign('order', $order);
        }

        $this->smarty->assign('user_email', $_SESSION['email']);
        $this->smarty->assign('user_name', $_SESSION['username']);
        $this->smarty->display('user/create_complaint.tpl');
        $this->clearSessionMessages();
    }

    public function complaint_detail()
    {
        $complaint_id = $_GET['id'] ?? 0;
        $user_id = $_SESSION['user_id'];

        $complaint = $this->complaintModel->getComplaintById($complaint_id, $user_id);

        if (!$complaint) {
            $_SESSION['error'] = 'Không tìm thấy khiếu nại!';
            header('Location: /?c=user&v=complaints');
            exit;
        }

        $this->smarty->assign('complaint', $complaint);
        $this->smarty->assign('user_email', $_SESSION['email']);
        $this->smarty->assign('user_name', $_SESSION['username']);
        $this->smarty->display('user/complaint_detail.tpl');
        $this->clearSessionMessages();
    }

    // === CHỨC NĂNG ĐÁNH GIÁ ===
    public function reviews()
    {
        // Danh sách đánh giá của user
        $page = $_GET['page'] ?? 1;
        $limit = 10;
        $offset = ($page - 1) * $limit;
        $user_id = $_SESSION['user_id'];

        $reviews = $this->orderReviewModel->getUserReviews($user_id, $limit, $offset);
        $totalReviews = $this->orderReviewModel->countReviews(null, $user_id);
        $totalPages = ceil($totalReviews / $limit);

        $this->smarty->assign('reviews', $reviews);
        $this->smarty->assign('current_page', $page);
        $this->smarty->assign('total_pages', $totalPages);
        $this->smarty->assign('user_email', $_SESSION['email']);
        $this->smarty->assign('user_name', $_SESSION['username']);
        $this->smarty->display('user/reviews.tpl');
        $this->clearSessionMessages();
    }

    public function create_review()
    {
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $order_id = $_POST['order_id'];
            $rating = $_POST['rating'];
            $delivery_rating = $_POST['delivery_rating'];
            $service_rating = $_POST['service_rating'];
            $comment = trim($_POST['comment']);
            $user_id = $_SESSION['user_id'];

            if (empty($rating) || empty($delivery_rating) || empty($service_rating)) {
                $_SESSION['error'] = 'Vui lòng đánh giá đầy đủ các tiêu chí!';
            } else {
                // Kiểm tra xem đã có đánh giá cho đơn hàng này chưa
                if ($this->orderReviewModel->hasReview($order_id, $user_id)) {
                    $_SESSION['error'] = 'Bạn đã đánh giá đơn hàng này rồi!';
                } else {
                    $data = [
                        'order_id' => $order_id,
                        'user_id' => $user_id,
                        'rating' => $rating,
                        'delivery_rating' => $delivery_rating,
                        'service_rating' => $service_rating,
                        'comment' => $comment,
                        'images' => '' // Tạm thời để trống
                    ];

                    if ($this->orderReviewModel->createReview($data)) {
                        $_SESSION['success'] = 'Đánh giá thành công! Cảm ơn bạn đã chia sẻ.';
                        header('Location: /?c=user&v=reviews');
                        exit;
                    } else {
                        $_SESSION['error'] = 'Có lỗi xảy ra. Vui lòng thử lại!';
                    }
                }
            }
        }

        // Hiển thị form đánh giá
        $order_id = $_GET['order_id'] ?? 0;
        if ($order_id) {
            global $db;
            $order = $db->executeQuery("SELECT * FROM orders WHERE id = '$order_id' AND user_id = '{$_SESSION['user_id']}' AND status = 'delivered'", 1);
            if (!$order) {
                $_SESSION['error'] = 'Chỉ có thể đánh giá đơn hàng đã hoàn thành!';
                header('Location: /?c=user&v=orders');
                exit;
            }
            $this->smarty->assign('order', $order);
        }

        $this->smarty->assign('user_email', $_SESSION['email']);
        $this->smarty->assign('user_name', $_SESSION['username']);
        $this->smarty->display('user/create_review.tpl');
        $this->clearSessionMessages();
    }

    // === CHỨC NĂNG HỦY ĐƠN HÀNG ===
    public function cancel_order()
    {
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $order_id = $_POST['order_id'];
            $reason = $_POST['reason'];
            $custom_reason = isset($_POST['custom_reason']) ? trim($_POST['custom_reason']) : '';
            $additional_notes = isset($_POST['additional_notes']) ? trim($_POST['additional_notes']) : '';
            
            // Tạo description từ custom_reason và additional_notes
            $description = '';
            if ($reason === 'Khác' && !empty($custom_reason)) {
                $description = $custom_reason;
            }
            if (!empty($additional_notes)) {
                $description .= (!empty($description) ? "\n\nGhi chú thêm: " : '') . $additional_notes;
            }
            
            $user_id = $_SESSION['user_id'];

            if (empty($reason)) {
                $_SESSION['error'] = 'Vui lòng chọn lý do hủy đơn hàng!';
            } else {
                // Kiểm tra trạng thái đơn hàng
                global $db;
                $order = $db->executeQuery("SELECT * FROM orders WHERE id = '$order_id' AND user_id = '$user_id'", 1);

                if (!$order) {
                    $_SESSION['error'] = 'Không tìm thấy đơn hàng!';
                } elseif ($order['status'] != 'pending') {
                    $_SESSION['error'] = 'Chỉ có thể hủy đơn hàng đang chờ xử lý!';
                } elseif ($this->cancellationModel->hasCancellation($order_id, $user_id)) {
                    $_SESSION['error'] = 'Bạn đã gửi yêu cầu hủy đơn hàng này rồi!';
                } else {
                    $data = [
                        'order_id' => $order_id,
                        'user_id' => $user_id,
                        'reason' => $reason,
                        'description' => $description
                    ];

                    if ($this->cancellationModel->createCancellation($data)) {
                        $_SESSION['success'] = 'Gửi yêu cầu hủy đơn hàng thành công! Chúng tôi sẽ xử lý trong thời gian sớm nhất.';
                        header('Location: /?c=user&v=order_detail&id=' . $order_id);
                        exit;
                    } else {
                        $_SESSION['error'] = 'Có lỗi xảy ra. Vui lòng thử lại!';
                    }
                }
            }
        }

        // Hiển thị form hủy đơn hàng
        $order_id = $_GET['order_id'] ?? 0;
        if ($order_id) {
            global $db;
            $order = $db->executeQuery("SELECT * FROM orders WHERE id = '$order_id' AND user_id = '{$_SESSION['user_id']}'", 1);
            if ($order) {
                $this->smarty->assign('order', $order);
            }
        }

        $this->smarty->assign('user_email', $_SESSION['email']);
        $this->smarty->assign('user_name', $_SESSION['username']);
        $this->smarty->display('user/cancel_order.tpl');
        $this->clearSessionMessages();
    }

    public function cancellations()
    {
        // Danh sách yêu cầu hủy đơn hàng
        $page = $_GET['page'] ?? 1;
        $limit = 10;
        $offset = ($page - 1) * $limit;
        $user_id = $_SESSION['user_id'];

        $cancellations = $this->cancellationModel->getUserCancellations($user_id, $limit, $offset);
        $totalCancellations = $this->cancellationModel->countCancellations(null, $user_id);
        $totalPages = ceil($totalCancellations / $limit);

        $this->smarty->assign('cancellations', $cancellations);
        $this->smarty->assign('current_page', $page);
        $this->smarty->assign('total_pages', $totalPages);
        $this->smarty->assign('user_email', $_SESSION['email']);
        $this->smarty->assign('user_name', $_SESSION['username']);
        $this->smarty->display('user/cancellations.tpl');
        $this->clearSessionMessages();
    }

    // === TRANG LIÊN HỆ - THÔNG BÁO PHẢN HỒI ===
    public function lienhe()
    {
        $user_id = $_SESSION['user_id'];

        // Lấy các khiếu nại đã có phản hồi từ admin
        $resolvedComplaints = $this->complaintModel->getUserComplaints($user_id, 50, 0);

        // Lọc chỉ những khiếu nại có admin_response
        $notifications = [];
        foreach ($resolvedComplaints as $complaint) {
            if (!empty($complaint['admin_response'])) {
                $notifications[] = $complaint;
            }
        }

        $this->smarty->assign('notifications', $notifications);
        $this->smarty->assign('user_email', $_SESSION['email']);
        $this->smarty->assign('user_name', $_SESSION['username']);
        $this->smarty->display('user/lienhe.tpl');
        $this->clearSessionMessages();
    }
}