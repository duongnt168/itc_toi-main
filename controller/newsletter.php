<?php
// Newsletter Controller - Xử lý đăng ký nhận tin khuyến mãi

require_once 'config.php';
require_once 'model/db.php';
require_once 'vendor/autoload.php';

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;

class NewsletterController
{
    private $smarty;

    public function __construct($smarty)
    {
        $this->smarty = $smarty;
    }

    public function subscribe()
    {
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $email = trim($_POST['email'] ?? '');
            $isAjax = !empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest';
            
            // Validate email
            if (empty($email)) {
                $message = 'Vui lòng nhập địa chỉ email!';
                if ($isAjax) {
                    header('Content-Type: application/json');
                    echo json_encode(['success' => false, 'message' => $message]);
                    return;
                }
                $_SESSION['error'] = $message;
                $this->redirectBack();
                return;
            }
            
            if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
                $message = 'Địa chỉ email không hợp lệ!';
                if ($isAjax) {
                    header('Content-Type: application/json');
                    echo json_encode(['success' => false, 'message' => $message]);
                    return;
                }
                $_SESSION['error'] = $message;
                $this->redirectBack();
                return;
            }
            
            // Check if email already exists
            global $db;
            $existingEmail = $db->executeQuery_list("SELECT id FROM {$db->tbl_fix}newsletter_subscribers WHERE email = '$email'");
            
            if (!empty($existingEmail)) {
                $message = 'Email này đã được đăng ký nhận tin!';
                if ($isAjax) {
                    header('Content-Type: application/json');
                    echo json_encode(['success' => false, 'message' => $message]);
                    return;
                }
                $_SESSION['error'] = $message;
                $this->redirectBack();
                return;
            }
            
            // Generate voucher code
            $voucherCode = $this->generateVoucherCode();
            
            // Save to database
            $result = $db->executeQuery_insert(
                "{$db->tbl_fix}newsletter_subscribers",
                "email, voucher_code, status, created_at",
                "'$email', '$voucherCode', 'active', NOW()"
            );
            
            if ($result) {
                // Send welcome email with voucher
                if ($this->sendWelcomeEmail($email, $voucherCode)) {
                    $message = 'Đăng ký thành công! Vui lòng kiểm tra email để nhận mã giảm giá.';
                } else {
                    $message = 'Đăng ký thành công! Mã giảm giá của bạn: ' . $voucherCode;
                }
                
                if ($isAjax) {
                    header('Content-Type: application/json');
                    echo json_encode(['success' => true, 'message' => $message]);
                    return;
                }
                $_SESSION['success'] = $message;
            } else {
                $message = 'Có lỗi xảy ra. Vui lòng thử lại!';
                if ($isAjax) {
                    header('Content-Type: application/json');
                    echo json_encode(['success' => false, 'message' => $message]);
                    return;
                }
                $_SESSION['error'] = $message;
            }
            
            $this->redirectBack();
        }
    }
    
    private function generateVoucherCode()
    {
        // Generate unique voucher code
        $prefix = 'WELCOME';
        $randomNumber = rand(1000, 9999);
        return $prefix . $randomNumber;
    }
    
    private function sendWelcomeEmail($email, $voucherCode)
    {
        try {
            $mail = new PHPMailer(true);
            
            // Server settings
            $mail->isSMTP();
            $mail->Host       = EMAIL_HOST;
            $mail->SMTPAuth   = true;
            $mail->Username   = EMAIL_USER;
            $mail->Password   = EMAIL_PASS;
            $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
            $mail->Port       = EMAIL_PORT;
            $mail->CharSet    = 'UTF-8';
            
            // Recipients
            $mail->setFrom(EMAIL_FROM, EMAIL_FROM_NAME);
            $mail->addAddress($email);
            
            // Content
            $mail->isHTML(true);
            $mail->Subject = 'Chào mừng bạn đến với AquaGarden - Mã giảm giá đặc biệt!';
            
            // Load email template
            $emailTemplate = file_get_contents('templates/email/voucher.html');
            $emailTemplate = str_replace('{{EMAIL}}', $email, $emailTemplate);
            $emailTemplate = str_replace('{{VOUCHER_CODE}}', $voucherCode, $emailTemplate);
            $emailTemplate = str_replace('{{DISCOUNT_VALUE}}', '10', $emailTemplate);
            $emailTemplate = str_replace('{{EXPIRY_DATE}}', date('d/m/Y', strtotime('+30 days')), $emailTemplate);
            
            // Create unsubscribe URL
            $unsubscribeToken = md5($email . 'unsubscribe_salt');
            $unsubscribeUrl = 'http://localhost/?c=unsubscribe&email=' . urlencode($email) . '&token=' . $unsubscribeToken;
            $emailTemplate = str_replace('{{UNSUBSCRIBE_URL}}', $unsubscribeUrl, $emailTemplate);
            
            $mail->Body = $emailTemplate;
            
            $mail->send();
            return true;
        } catch (Exception $e) {
            error_log("Email sending failed: {$mail->ErrorInfo}");
            return false;
        }
    }
    
    private function redirectBack()
    {
        $referer = $_SERVER['HTTP_REFERER'] ?? '/?c=user&v=index';
        header('Location: ' . $referer);
        exit;
    }
}

// Handle direct access to newsletter controller
if (isset($_GET['c']) && $_GET['c'] === 'newsletter') {
    include_once 'library/smarty/libs/Smarty.class.php';
    $smarty = new \Smarty\Smarty;
    $smarty->debugging = false;
    $smarty->caching = false;
    $smarty->cache_lifetime = 0;
    
    $controller = new NewsletterController($smarty);
    $action = $_GET['v'] ?? 'subscribe';
    
    if (method_exists($controller, $action)) {
        $controller->$action();
    } else {
        echo json_encode(['success' => false, 'message' => 'Action không tồn tại']);
    }
}