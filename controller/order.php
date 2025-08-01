<?php
// Order Controller - Quản lý đơn hàng và thanh toán
require_once 'model/vouchers.php';

class OrderController
{
    private $smarty;
    private $orderModel;
    private $cartModel;
    private $productModel;
    private $voucherModel;

    public function __construct($smarty)
    {
        $this->smarty = $smarty;
        $this->orderModel = new Orders();
        $this->cartModel = new Cart();
        $this->productModel = new Products();
        $this->voucherModel = new Vouchers();
    }

    private function checkLogin()
    {
        if (!isset($_SESSION['user_id'])) {
            $_SESSION['error'] = 'Vui lòng đăng nhập để thực hiện thanh toán!';
            header('Location: /?c=auth&v=login');
            exit;
        }
    }

    public function checkout()
    {
        $this->checkLogin();

        $user_id = $_SESSION['user_id'];

        // Kiểm tra giỏ hàng có sản phẩm không
        global $db;
        $cartItems = $db->executeQuery_list("
            SELECT c.*, p.name, p.price, p.file_url, p.stock
            FROM cart c 
            LEFT JOIN products p ON c.product_id = p.id 
            WHERE c.user_id = '$user_id' AND p.status = 'active'
            ORDER BY c.created_at DESC
        ");

        if (empty($cartItems)) {
            $_SESSION['error'] = 'Giỏ hàng của bạn đang trống!';
            header('Location: /?c=cart&v=index');
            exit;
        }

        // Xử lý đặt hàng
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $address = $_POST['address'] ?? '';
            $phone = $_POST['phone'] ?? '';
            $note = $_POST['note'] ?? '';
            $province = $_POST['province'] ?? '';
            $district = $_POST['district'] ?? '';
            $ward = $_POST['ward'] ?? '';
            $street = $_POST['street'] ?? '';
            $payment_method = $_POST['payment_method'] ?? 'cod';

            if (empty($address) || empty($phone) || empty($province) || empty($district) || empty($ward) || empty($street)) {
                $_SESSION['error'] = 'Vui lòng nhập đầy đủ thông tin giao hàng!';
            } else {
                // Tính phí vận chuyển theo tỉnh/thành phố
                $shippingFees = [
                    'ho-chi-minh' => 0,
                    'ha-noi' => 30000,
                    'da-nang' => 25000,
                    'can-tho' => 20000,
                    'hai-phong' => 35000,
                    'bien-hoa' => 15000,
                    'nha-trang' => 40000,
                    'hue' => 45000,
                    'long-xuyen' => 25000,
                    'thai-nguyen' => 50000,
                    'other' => 60000
                ];

                $shippingFee = $shippingFees[$province] ?? 60000;

                // Tính tổng tiền sản phẩm
                $subtotal = 0;
                foreach ($cartItems as $item) {
                    $subtotal += $item['price'] * $item['quantity'];
                }

                // Xử lý voucher nếu có
                $voucher_discount = 0;
                $voucher_code = $_SESSION['voucher_code'] ?? '';
                $voucher_id = null;
                
                if (!empty($voucher_code)) {
                    $voucher = $this->voucherModel->getByCode($voucher_code);
                    if ($voucher && $this->voucherModel->isValid($voucher['id'], $subtotal)) {
                        $voucher_discount = $this->voucherModel->calculateDiscount($voucher['id'], $subtotal);
                        $voucher_id = $voucher['id'];
                    } else {
                        // Voucher không hợp lệ, xóa khỏi session
                        unset($_SESSION['voucher_code']);
                    }
                }

                // Tổng tiền sau giảm giá và phí vận chuyển
                $total = $subtotal - $voucher_discount + $shippingFee;

                // Kiểm tra giới hạn số tiền thanh toán (áp dụng cho tất cả phương thức)
                if ($total > 9999999) {
                    $_SESSION['error'] = 'Số tiền thanh toán vượt quá giới hạn cho phép (tối đa 9,999,999 VND). Vui lòng giảm số lượng sản phẩm hoặc liên hệ với chúng tôi để được hỗ trợ.';
                    $this->smarty->assign('cart_items', $cartItems);
                    $this->smarty->assign('cart_total', array_sum(array_column($cartItems, 'total_price')));
                    $this->smarty->display('user/checkout.tpl');
                    return;
                }

                // Xử lý theo phương thức thanh toán
                $payment_status = 'pending';
                $order_status = 'pending';

                if ($payment_method === 'stripe') {
                    // Kiểm tra có stripe_payment_method_id không
                    $stripe_payment_method_id = $_POST['stripe_payment_method_id'] ?? '';
                    if (empty($stripe_payment_method_id)) {
                        $_SESSION['error'] = 'Vui lòng nhập thông tin thẻ để thanh toán!';
                        $this->smarty->assign('cart_items', $cartItems);
                        $this->smarty->assign('cart_total', array_sum(array_column($cartItems, 'total_price')));
                        $this->smarty->display('user/checkout.tpl');
                        return;
                    }
                    
                    // Xử lý thanh toán Stripe
                    $stripe_result = $this->processStripePayment($total, $orderCode ?? 'DH' . date('YmdHis') . rand(100, 999), $stripe_payment_method_id);
                    if ($stripe_result['success']) {
                        $payment_status = 'paid';
                        $order_status = 'confirmed';
                    } else {
                        $_SESSION['error'] = 'Thanh toán Stripe thất bại: ' . $stripe_result['error'];
                        $this->smarty->assign('cart_items', $cartItems);
                        $this->smarty->assign('cart_total', array_sum(array_column($cartItems, 'total_price')));
                        $this->smarty->display('user/checkout.tpl');
                        return;
                    }
                } elseif ($payment_method === 'qr') {
                    // Xử lý thanh toán QR code
                    $qr_result = $this->processQRPayment($total);
                    if ($qr_result['success']) {
                        $payment_status = 'paid';
                        $order_status = 'confirmed';
                    } else {
                        $_SESSION['error'] = 'Thanh toán QR code thất bại: ' . $qr_result['error'];
                        $this->smarty->assign('cart_items', $cartItems);
                        $this->smarty->assign('cart_total', array_sum(array_column($cartItems, 'total_price')));
                        $this->smarty->display('user/checkout.tpl');
                        return;
                    }
                }

                // Tạo đơn hàng
                $orderCode = $orderCode ?? 'DH' . date('YmdHis') . rand(100, 999);
                $voucher_discount_db = $voucher_discount > 0 ? $voucher_discount : 0;
                $voucher_code_db = !empty($voucher_code) ? $voucher_code : '';
                
                $insertOrder = $db->executeQuery("
                    INSERT INTO orders (user_id, order_code, total_amount, shipping_address, phone, note, shipping_fee, voucher_code, voucher_discount, payment_method, payment_status, status, created_at) 
                    VALUES ('$user_id', '$orderCode', '$total', '$address', '$phone', '$note', '$shippingFee', '$voucher_code_db', '$voucher_discount_db', '$payment_method', '$payment_status', '$order_status', NOW())
                ");

                if ($insertOrder) {
                    $order_id = $db->mysqli_insert_id();

                    // Thêm chi tiết đơn hàng
                    $allItemsAdded = true;
                    foreach ($cartItems as $item) {
                        $itemTotal = $item['price'] * $item['quantity'];
                        $insertItem = $db->executeQuery("
                            INSERT INTO order_items (order_id, product_id, quantity, price) 
                            VALUES ('$order_id', '{$item['product_id']}', '{$item['quantity']}', '{$item['price']}')
                        ");

                        if (!$insertItem) {
                            $allItemsAdded = false;
                            break;
                        }

                        // Cập nhật tồn kho
                        $db->executeQuery("
                            UPDATE products 
                            SET stock = stock - {$item['quantity']} 
                            WHERE id = '{$item['product_id']}'
                        ");
                    }

                    if ($allItemsAdded) {
                        // Sử dụng voucher nếu có
                        if ($voucher_id) {
                            $this->voucherModel->useVoucher($voucher_id);
                            unset($_SESSION['voucher_code']); // Xóa voucher khỏi session
                        }
                        
                        // Xóa giỏ hàng
                        $db->executeQuery("DELETE FROM cart WHERE user_id = '$user_id'");

                        $_SESSION['success'] = 'Đặt hàng thành công! Mã đơn hàng: ' . $orderCode;
                        header('Location: /?c=order&v=thankyou&order_code=' . $orderCode);
                        exit;
                    } else {
                        $_SESSION['error'] = 'Có lỗi xảy ra khi tạo đơn hàng!';
                    }
                } else {
                    $_SESSION['error'] = 'Có lỗi xảy ra khi tạo đơn hàng!';
                }
            }
        }

        // Hiển thị trang checkout
        $total = 0;
        foreach ($cartItems as &$item) {
            $item['total_price'] = $item['price'] * $item['quantity'];
            $total += $item['total_price'];
        }

        // Xử lý voucher cho hiển thị
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
        
        $subtotal_after_discount = $total - $voucher_discount;

        // Lấy thông tin user
        $userInfo = $db->executeQuery_list("SELECT * FROM users WHERE id = '$user_id'");
        $user = $userInfo[0] ?? [];

        // Lấy Stripe config
        $stripe_config = require_once __DIR__ . '/../config/stripe.php';

        $this->smarty->assign('cart_items', $cartItems);
        $this->smarty->assign('cart_total', $total);
        $this->smarty->assign('voucher_code', $voucher_code);
        $this->smarty->assign('voucher_discount', $voucher_discount);
        $this->smarty->assign('voucher_info', $voucher_info);
        $this->smarty->assign('subtotal_after_discount', $subtotal_after_discount);
        $this->smarty->assign('user_address', $user['address'] ?? '');
        $this->smarty->assign('user_phone', $user['phone'] ?? '');
        $this->smarty->assign('user_email', $_SESSION['email']);
        $this->smarty->assign('user_name', $_SESSION['username']);
        $this->smarty->assign('stripe_publishable_key', $stripe_config['publishable_key']);
        $this->smarty->display('user/checkout.tpl');
        $this->clearSessionMessages();
    }

    public function thankyou()
    {
        $this->checkLogin();

        $order_code = $_GET['order_code'] ?? '';

        if (empty($order_code)) {
            header('Location: /?c=user&v=index');
            exit;
        }

        // Lấy thông tin đơn hàng
        global $db;
        $orderInfo = $db->executeQuery_list("
            SELECT o.*, u.username, u.email 
            FROM orders o 
            LEFT JOIN users u ON o.user_id = u.id 
            WHERE o.order_code = '$order_code' AND o.user_id = '{$_SESSION['user_id']}'
        ");

        if (empty($orderInfo)) {
            $_SESSION['error'] = 'Không tìm thấy đơn hàng!';
            header('Location: /?c=user&v=index');
            exit;
        }

        $order = $orderInfo[0];

        // Lấy chi tiết đơn hàng
        $orderItems = $db->executeQuery_list("
            SELECT oi.*, p.name, p.file_url 
            FROM order_items oi 
            LEFT JOIN products p ON oi.product_id = p.id 
            WHERE oi.order_id = '{$order['id']}'
        ");

        $this->smarty->assign('order', $order);
        $this->smarty->assign('order_items', $orderItems);
        $this->smarty->assign('user_email', $_SESSION['email']);
        $this->smarty->assign('user_name', $_SESSION['username']);
        $this->smarty->display('user/thankyou.tpl');
        $this->clearSessionMessages();
    }

    public function history()
    {
        $this->checkLogin();

        $user_id = $_SESSION['user_id'];

        // Lấy danh sách đơn hàng
        global $db;
        $orders = $db->executeQuery_list("
            SELECT * FROM orders 
            WHERE user_id = '$user_id' 
            ORDER BY created_at DESC
        ");

        $this->smarty->assign('orders', $orders);
        $this->smarty->assign('user_email', $_SESSION['email']);
        $this->smarty->assign('user_name', $_SESSION['username']);
        $this->smarty->display('user/orders.tpl');
        $this->clearSessionMessages();
    }

    public function detail()
    {
        $this->checkLogin();

        $order_id = $_GET['id'] ?? 0;
        $user_id = $_SESSION['user_id'];

        // Lấy thông tin đơn hàng
        global $db;
        $orderInfo = $db->executeQuery_list("
            SELECT * FROM orders 
            WHERE id = '$order_id' AND user_id = '$user_id'
        ");

        if (empty($orderInfo)) {
            $_SESSION['error'] = 'Không tìm thấy đơn hàng!';
            header('Location: /?c=order&v=history');
            exit;
        }

        $order = $orderInfo[0];

        // Lấy chi tiết đơn hàng
        $orderItems = $db->executeQuery_list("
            SELECT oi.*, p.name, p.file_url 
            FROM order_items oi 
            LEFT JOIN products p ON oi.product_id = p.id 
            WHERE oi.order_id = '$order_id'
        ");

        $this->smarty->assign('order', $order);
        $this->smarty->assign('order_items', $orderItems);
        $this->smarty->assign('user_email', $_SESSION['email']);
        $this->smarty->assign('user_name', $_SESSION['username']);
        $this->smarty->display('user/order_detail.tpl');
        $this->clearSessionMessages();
    }

    private function clearSessionMessages()
    {
        unset($_SESSION['success']);
        unset($_SESSION['error']);
    }

    private function processStripePayment($amount, $orderCode, $paymentMethodId)
    {
        require_once __DIR__ . '/../vendor/autoload.php';

        // Lấy Stripe keys từ config
        $stripe_config = require_once __DIR__ . '/../config/stripe.php';

        \Stripe\Stripe::setApiKey($stripe_config['secret_key']);

        try {
            // Kiểm tra giới hạn amount cho VND (tối đa 9,999,999 VND)
            if ($amount > 9999999) {
                return [
                    'success' => false,
                    'error' => 'Số tiền thanh toán vượt quá giới hạn cho phép (tối đa 9,999,999 VND). Vui lòng giảm số lượng sản phẩm hoặc liên hệ với chúng tôi để được hỗ trợ.'
                ];
            }

            // Tạo Payment Intent với payment method
            $intent = \Stripe\PaymentIntent::create([
                'amount' => $amount * 100, // Stripe tính bằng cents
                'currency' => 'vnd',
                'payment_method' => $paymentMethodId,
                'confirmation_method' => 'manual',
                'confirm' => true,
                'return_url' => 'http://localhost:8000/?c=order&v=thankyou&order_code=' . $orderCode,
                'metadata' => [
                    'order_code' => $orderCode
                ]
            ]);

            // Kiểm tra trạng thái thanh toán
            if ($intent->status === 'succeeded') {
                return [
                    'success' => true,
                    'payment_intent_id' => $intent->id
                ];
            } else {
                return [
                    'success' => false,
                    'error' => 'Thanh toán chưa được xác nhận'
                ];
            }
        } catch (Exception $e) {
            return [
                'success' => false,
                'error' => $e->getMessage()
            ];
        }
    }

    private function processQRPayment($amount)
    {
        // Giả lập xử lý thanh toán QR code
        // Trong thực tế, bạn sẽ tích hợp với các nhà cung cấp như VietQR, MoMo, ZaloPay, etc.

        try {
            // Tạo QR code cho thanh toán
            $qr_data = [
                'bank_code' => 'VCB',
                'account_number' => '1234567890',
                'amount' => $amount,
                'description' => 'Thanh toan don hang ' . date('YmdHis'),
                'qr_code' => $this->generateQRCode($amount)
            ];

            // Trong demo này, chúng ta giả định thanh toán thành công
            // Thực tế cần kiểm tra trạng thái thanh toán từ ngân hàng/ví điện tử

            return [
                'success' => true,
                'qr_data' => $qr_data
            ];
        } catch (Exception $e) {
            return [
                'success' => false,
                'error' => $e->getMessage()
            ];
        }
    }

    private function generateQRCode($amount)
    {
        // Tạo chuỗi QR code theo chuẩn VietQR
        $bank_code = '970436'; // Vietcombank
        $account_number = '1234567890';
        $template = 'compact2';
        $description = urlencode('Thanh toan don hang');

        return "https://img.vietqr.io/image/{$bank_code}-{$account_number}-{$template}.png?amount={$amount}&addInfo={$description}";
    }
}
?>