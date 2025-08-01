<?php
// Product Controller - Quản lý sản phẩm

require_once 'model/db.php';
require_once 'model/products.php';
require_once 'model/categories.php';
require_once 'model/reviews.php';
require_once 'model/cart.php';

class ProductController
{
    private $smarty;
    private $productModel;
    private $categoryModel;
    private $reviewModel;
    private $cartModel;

    public function __construct($smarty)
    {
        $this->smarty = $smarty;
        $this->productModel = new products();
        $this->categoryModel = new categories();
        $this->reviewModel = new reviews();
        $this->cartModel = new cart();

        // Assign user info for navbar if logged in
        $this->assignUserInfo();
    }

    private function assignUserInfo()
    {
        if (isset($_SESSION['user_id']) && !empty($_SESSION['user_id'])) {
            $this->smarty->assign('user_email', $_SESSION['email'] ?? null);
            $this->smarty->assign('user_name', $_SESSION['username'] ?? null);
        }
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

    public function index()
    {
        // Danh sách tất cả sản phẩm
        global $db;
        $page = $_GET['page'] ?? 1;
        $limit = 12;
        $offset = ($page - 1) * $limit;
        $category_id = $_GET['category'] ?? null;
        $search = $_GET['search'] ?? null;

        $whereClause = "WHERE 1=1";
        if ($category_id) {
            $whereClause .= " AND p.category_id = '$category_id'";
        }
        if ($search) {
            $search = $db->escape($search);
            $whereClause .= " AND (p.name LIKE '%$search%' OR p.description LIKE '%$search%')";
        }

        $products = $db->executeQuery_list("
            SELECT p.*, c.name as category_name 
            FROM {$db->tbl_fix}products p 
            LEFT JOIN {$db->tbl_fix}categories c ON p.category_id = c.id 
            $whereClause
            ORDER BY p.created_at DESC 
            LIMIT $limit OFFSET $offset
        ");

        $totalProductsResult = $db->executeQuery_list("SELECT COUNT(*) as total FROM {$db->tbl_fix}products p $whereClause");
        $totalProducts = $totalProductsResult[0]['total'];
        $totalPages = ceil($totalProducts / $limit);

        // Lấy danh sách categories
        $categories = $this->categoryModel->list_all();


        
        $this->smarty->assign('products', $products);
        $this->smarty->assign('categories', $categories);
        $this->smarty->assign('current_page', $page);
        $this->smarty->assign('total_pages', $totalPages);
        $this->smarty->assign('current_category', $category_id);
        $this->smarty->assign('search_query', $search);
        
        // Assign cart items for navbar
        $this->smarty->assign('cart_items', getCartItemsForNavbar());
        $this->smarty->display('user/product/index.tpl');
        $this->clearSessionMessages();
    }

    public function detail()
    {
        // Chi tiết sản phẩm
        $product_id = $_GET['id'] ?? 0;
        
        global $db;
        $productResult = $db->executeQuery_list("
            SELECT p.*, c.name as category_name 
            FROM {$db->tbl_fix}products p 
            LEFT JOIN {$db->tbl_fix}categories c ON p.category_id = c.id 
            WHERE p.id = '$product_id'
        ");
        
        if (empty($productResult)) {
            $this->smarty->assign('error', 'Không tìm thấy sản phẩm!');
            $this->smarty->display('user/product/detail.tpl');
            return;
        }
        
        $product = $productResult[0];
        
        // Lấy reviews của sản phẩm từ order_reviews (chỉ lấy những đánh giá đã được duyệt)
        $reviews = $db->executeQuery_list("
            SELECT rev.*, u.username, o.id as order_id
            FROM {$db->tbl_fix}order_reviews rev 
            LEFT JOIN {$db->tbl_fix}users u ON rev.user_id = u.id 
            LEFT JOIN {$db->tbl_fix}orders o ON rev.order_id = o.id
            LEFT JOIN {$db->tbl_fix}order_items oi ON o.id = oi.order_id
            WHERE oi.product_id = '$product_id' AND rev.status = 'approved'
            GROUP BY rev.id
            ORDER BY rev.created_at DESC
        ");
        
        // Lấy sản phẩm liên quan (cùng category)
        $relatedProducts = $db->executeQuery_list("
            SELECT p.*, c.name as category_name 
            FROM {$db->tbl_fix}products p 
            LEFT JOIN {$db->tbl_fix}categories c ON p.category_id = c.id 
            WHERE p.category_id = '{$product['category_id']}' 
            AND p.id != '$product_id' 
            LIMIT 4
        ");
        
        $this->smarty->assign('product', $product);
        $this->smarty->assign('reviews', $reviews);
        $this->smarty->assign('related_products', $relatedProducts);
        
        // Assign cart items for navbar
        $this->smarty->assign('cart_items', getCartItemsForNavbar());
        $this->smarty->display('user/product/detail.tpl');
        $this->clearSessionMessages();
    }

    public function category()
    {
        // Sản phẩm theo danh mục
        $category_id = $_GET['id'] ?? 0;
        
        global $db;
        $categoryResult = $db->executeQuery_list("SELECT * FROM {$db->tbl_fix}categories WHERE id = '$category_id'");
        
        if (empty($categoryResult)) {
            $_SESSION['error'] = 'Không tìm thấy danh mục!';
            header('Location: /?c=product&v=index');
            exit;
        }
        
        $category = $categoryResult[0];
        
        $page = $_GET['page'] ?? 1;
        $limit = 12;
        $offset = ($page - 1) * $limit;
        
        $products = $db->executeQuery_list("
            SELECT p.*, c.name as category_name 
            FROM {$db->tbl_fix}products p 
            LEFT JOIN {$db->tbl_fix}categories c ON p.category_id = c.id 
            WHERE p.category_id = '$category_id' 
            ORDER BY p.created_at DESC 
            LIMIT $limit OFFSET $offset
        ");
        
        $totalProductsResult = $db->executeQuery_list("SELECT COUNT(*) as total FROM {$db->tbl_fix}products WHERE category_id = '$category_id'");
        $totalProducts = $totalProductsResult[0]['total'];
        $totalPages = ceil($totalProducts / $limit);
        
        $this->smarty->assign('category', $category);
        $this->smarty->assign('products', $products);
        $this->smarty->assign('current_page', $page);
        $this->smarty->assign('total_pages', $totalPages);
        
        // Assign cart items for navbar
        $this->smarty->assign('cart_items', getCartItemsForNavbar());
        $this->smarty->display('user/product/category.tpl');
        $this->clearSessionMessages();
    }

    public function search()
    {
        // Tìm kiếm sản phẩm
        $query = $_GET['q'] ?? '';
        
        if (empty($query)) {
            header('Location: /?c=product&v=index');
            exit;
        }
        
        global $db;
        $query = $db->escape($query);
        
        $page = $_GET['page'] ?? 1;
        $limit = 12;
        $offset = ($page - 1) * $limit;
        
        $products = $db->executeQuery_list("
            SELECT p.*, c.name as category_name 
            FROM {$db->tbl_fix}products p 
            LEFT JOIN {$db->tbl_fix}categories c ON p.category_id = c.id 
            WHERE p.name LIKE '%$query%' OR p.description LIKE '%$query%' 
            ORDER BY p.created_at DESC 
            LIMIT $limit OFFSET $offset
        ");
        
        $totalProductsResult = $db->executeQuery_list("
            SELECT COUNT(*) as total FROM {$db->tbl_fix}products 
            WHERE name LIKE '%$query%' OR description LIKE '%$query%'
        ");
        $totalProducts = $totalProductsResult[0]['total'];
        $totalPages = ceil($totalProducts / $limit);
        
        $this->smarty->assign('products', $products);
        $this->smarty->assign('search_query', $_GET['q']);
        $this->smarty->assign('current_page', $page);
        $this->smarty->assign('total_pages', $totalPages);
        
        // Assign cart items for navbar
        $this->smarty->assign('cart_items', getCartItemsForNavbar());
        $this->smarty->display('user/product/search.tpl');
        $this->clearSessionMessages();
    }
}