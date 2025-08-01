<?php
// Cart Controller - Quản lý giỏ hàng
require_once 'model/vouchers.php';

class CartController
{
    private $smarty;
    private $cartModel;
    private $productModel;
    private $voucherModel;

    public function __construct($smarty)
    {
        $this->smarty = $smarty;
        $this->cartModel = new Cart();
        $this->productModel = new Products();
        $this->voucherModel = new Vouchers();
    }

    private function checkLogin()
    {
        if (!isset($_SESSION['user_id'])) {
            $_SESSION['error'] = 'Vui lòng đăng nhập để sử dụng giỏ hàng!';
            header('Location: /?c=auth&v=login');
            exit;
        }
    }

    public function login()
    {
        // Redirect đến trang đăng nhập
        $_SESSION['error'] = 'Vui lòng đăng nhập để sử dụng giỏ hàng!';
        header('Location: /?c=auth&v=login');
        exit;
    }

    public function add()
    {
        $this->checkLogin();
        
        // Thêm sản phẩm vào giỏ hàng
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $product_id = $_POST['product_id'] ?? 0;
            $quantity = $_POST['quantity'] ?? 1;
            $user_id = $_SESSION['user_id'];

            if (empty($product_id) || $quantity <= 0) {
                $_SESSION['error'] = 'Thông tin sản phẩm không hợp lệ!';
                header('Location: ' . ($_SERVER['HTTP_REFERER'] ?? '/?c=user&v=index'));
                exit;
            }

            // Kiểm tra sản phẩm có tồn tại không
            global $db;
            $productResult = $db->executeQuery_list("SELECT * FROM products WHERE id = '$product_id' AND status = 'active'");
            
            if (empty($productResult)) {
                $_SESSION['error'] = 'Sản phẩm không tồn tại!';
                header('Location: ' . ($_SERVER['HTTP_REFERER'] ?? '/?c=user&v=index'));
                exit;
            }

            $product = $productResult[0];

            // Kiểm tra số lượng tồn kho
            if ($quantity > $product['stock']) {
                $_SESSION['error'] = 'Số lượng vượt quá tồn kho!';
                header('Location: ' . ($_SERVER['HTTP_REFERER'] ?? '/?c=user&v=index'));
                exit;
            }

            // Kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
            $existingCartResult = $db->executeQuery_list("SELECT * FROM cart WHERE user_id = '$user_id' AND product_id = '$product_id'");
            
            if (!empty($existingCartResult)) {
                // Cập nhật số lượng
                $existingCart = $existingCartResult[0];
                $newQuantity = $existingCart['quantity'] + $quantity;
                
                if ($newQuantity > $product['stock']) {
                    $_SESSION['error'] = 'Tổng số lượng vượt quá tồn kho!';
                    header('Location: ' . ($_SERVER['HTTP_REFERER'] ?? '/?c=user&v=index'));
                    exit;
                }
                
                $updateResult = $db->executeQuery("UPDATE cart SET quantity = '$newQuantity' WHERE id = '{$existingCart['id']}'");
                
                if ($updateResult) {
                    $_SESSION['success'] = 'Đã cập nhật số lượng sản phẩm trong giỏ hàng!';
                } else {
                    $_SESSION['error'] = 'Có lỗi xảy ra khi cập nhật giỏ hàng!';
                }
            } else {
                // Thêm mới vào giỏ hàng
                $insertResult = $db->executeQuery("INSERT INTO cart (user_id, product_id, quantity, created_at) VALUES ('$user_id', '$product_id', '$quantity', NOW())");
                
                if ($insertResult) {
                    $_SESSION['success'] = 'Đã thêm sản phẩm vào giỏ hàng!';
                } else {
                    $_SESSION['error'] = 'Có lỗi xảy ra khi thêm vào giỏ hàng!';
                }
            }
        }

        // Redirect về trang trước đó hoặc trang chủ
        header('Location: ' . ($_SERVER['HTTP_REFERER'] ?? '/?c=user&v=index'));
        exit;
    }

    public function view()
    {
        $this->index();
    }

    public function index()
    {
        $this->checkLogin();
        
        // Hiển thị giỏ hàng
        $user_id = $_SESSION['user_id'];
        
        global $db;
        $cartItems = $db->executeQuery_list("
            SELECT c.*, p.name, p.price, p.file_url, p.stock
            FROM cart c 
            LEFT JOIN products p ON c.product_id = p.id 
            WHERE c.user_id = '$user_id' AND p.status = 'active'
            ORDER BY c.created_at DESC
        ");

        $total = 0;
        foreach ($cartItems as &$item) {
            $item['total_price'] = $item['price'] * $item['quantity'];
            $total += $item['total_price'];
        }

        // Xử lý voucher nếu có
        $voucher_discount = 0;
        $voucher_code = $_SESSION['voucher_code'] ?? '';
        $voucher_info = null;
        
        if (!empty($voucher_code)) {
            $voucher_info = $this->voucherModel->getByCode($voucher_code);
            if ($voucher_info && $this->voucherModel->isValid($voucher_info['id'], $total)) {
                $voucher_discount = $this->voucherModel->calculateDiscount($voucher_info['id'], $total);
            } else {
                // Voucher không hợp lệ, xóa khỏi session
                unset($_SESSION['voucher_code']);
                $voucher_code = '';
            }
        }
        
        $final_total = $total - $voucher_discount;
        
        $this->smarty->assign('cart_items', $cartItems);
        $this->smarty->assign('cart_total', $total);
        $this->smarty->assign('voucher_code', $voucher_code);
        $this->smarty->assign('voucher_discount', $voucher_discount);
        $this->smarty->assign('voucher_info', $voucher_info);
        $this->smarty->assign('final_total', $final_total);
        $this->smarty->assign('user_email', $_SESSION['email']);
        $this->smarty->assign('user_name', $_SESSION['username']);
        $this->smarty->display('user/cart.tpl');
        $this->clearSessionMessages();
    }

    public function remove()
    {
        $this->checkLogin();
        
        // Xóa sản phẩm khỏi giỏ hàng
        $product_id = $_GET['product_id'] ?? 0;
        $user_id = $_SESSION['user_id'];

        if ($product_id > 0) {
            global $db;
            $deleteResult = $db->executeQuery("DELETE FROM cart WHERE user_id = '$user_id' AND product_id = '$product_id'");
            
            if ($deleteResult) {
                $_SESSION['success'] = 'Đã xóa sản phẩm khỏi giỏ hàng!';
            } else {
                $_SESSION['error'] = 'Có lỗi xảy ra khi xóa sản phẩm!';
            }
        }

        header('Location: /?c=cart&v=index');
        exit;
    }

    public function update()
    {
        $this->checkLogin();
        
        // Cập nhật số lượng sản phẩm trong giỏ hàng
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $quantities = $_POST['quantities'] ?? [];
            $user_id = $_SESSION['user_id'];

            global $db;
            foreach ($quantities as $product_id => $quantity) {
                if ($quantity > 0) {
                    // Kiểm tra tồn kho
                    $productResult = $db->executeQuery_list("SELECT stock FROM products WHERE id = '$product_id'");
                    if (!empty($productResult) && $quantity <= $productResult[0]['stock']) {
                        $db->executeQuery("UPDATE cart SET quantity = '$quantity' WHERE user_id = '$user_id' AND product_id = '$product_id'");
                    }
                } else {
                    // Xóa nếu số lượng = 0
                    $db->executeQuery("DELETE FROM cart WHERE user_id = '$user_id' AND product_id = '$product_id'");
                }
            }
            
            $_SESSION['success'] = 'Đã cập nhật giỏ hàng!';
        }

        header('Location: /?c=cart&v=index');
        exit;
    }

    public function clear()
    {
        $this->checkLogin();
        
        // Xóa toàn bộ giỏ hàng
        $user_id = $_SESSION['user_id'];
        
        global $db;
        $deleteResult = $db->executeQuery("DELETE FROM cart WHERE user_id = '$user_id'");
        
        if ($deleteResult) {
            $_SESSION['success'] = 'Đã xóa toàn bộ giỏ hàng!';
        } else {
            $_SESSION['error'] = 'Có lỗi xảy ra khi xóa giỏ hàng!';
        }
        
        header('Location: /?c=cart&v=index');
        exit;
    }

    public function apply_voucher()
    {
        $this->checkLogin();
        
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $voucher_code = trim($_POST['voucher_code'] ?? '');
            
            if (empty($voucher_code)) {
                $_SESSION['error'] = 'Vui lòng nhập mã voucher!';
                header('Location: /?c=cart&v=index');
                exit;
            }
            
            // Kiểm tra voucher
            $voucher = $this->voucherModel->getByCode($voucher_code);
            
            if (!$voucher) {
                $_SESSION['error'] = 'Mã voucher không tồn tại!';
                header('Location: /?c=cart&v=index');
                exit;
            }
            
            // Tính tổng giỏ hàng
            $user_id = $_SESSION['user_id'];
            global $db;
            $cartItems = $db->executeQuery_list("
                SELECT c.*, p.price
                FROM cart c 
                LEFT JOIN products p ON c.product_id = p.id 
                WHERE c.user_id = '$user_id' AND p.status = 'active'
            ");
            
            $total = 0;
            foreach ($cartItems as $item) {
                $total += $item['price'] * $item['quantity'];
            }
            
            // Kiểm tra tính hợp lệ của voucher
            if (!$this->voucherModel->isValid($voucher['id'], $total)) {
                $error_msg = 'Mã voucher không hợp lệ!';
                
                if ($voucher['status'] !== 'active') {
                    $error_msg = 'Mã voucher đã hết hiệu lực!';
                } elseif ($voucher['min_order_amount'] > 0 && $total < $voucher['min_order_amount']) {
                    $error_msg = 'Đơn hàng chưa đạt giá trị tối thiểu ' . number_format($voucher['min_order_amount']) . ' VNĐ!';
                } elseif ($voucher['max_uses'] > 0 && $voucher['used_count'] >= $voucher['max_uses']) {
                    $error_msg = 'Mã voucher đã hết lượt sử dụng!';
                } elseif ($voucher['start_date'] && $voucher['start_date'] !== '0000-00-00 00:00:00' && strtotime($voucher['start_date']) > time()) {
                    $error_msg = 'Mã voucher chưa có hiệu lực!';
                } elseif ($voucher['end_date'] && $voucher['end_date'] !== '0000-00-00 00:00:00' && strtotime($voucher['end_date']) < time()) {
                    $error_msg = 'Mã voucher đã hết hạn!';
                }
                
                $_SESSION['error'] = $error_msg;
                header('Location: /?c=cart&v=index');
                exit;
            }
            
            // Lưu voucher vào session
            $_SESSION['voucher_code'] = $voucher_code;
            $discount = $this->voucherModel->calculateDiscount($voucher['id'], $total);
            $_SESSION['success'] = 'Áp dụng mã voucher thành công! Giảm ' . number_format($discount) . ' VNĐ';
        }
        
        header('Location: /?c=cart&v=index');
        exit;
    }
    
    public function remove_voucher()
    {
        $this->checkLogin();
        
        unset($_SESSION['voucher_code']);
        $_SESSION['success'] = 'Đã hủy mã voucher!';
        
        header('Location: /?c=cart&v=index');
        exit;
    }

    private function clearSessionMessages()
    {
        unset($_SESSION['success']);
        unset($_SESSION['error']);
        unset($_SESSION['info']);
    }
}
?>