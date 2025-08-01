<?php
// Unsubscribe Controller - Xử lý hủy đăng ký nhận tin

require_once 'config.php';
require_once 'model/db.php';

class UnsubscribeController
{
    private $smarty;
    private $db;

    public function __construct($smarty)
    {
        $this->smarty = $smarty;
        global $db;
        $this->db = $db;
    }

    public function index()
    {
        $email = isset($_GET['email']) ? trim($_GET['email']) : '';
        $token = isset($_GET['token']) ? trim($_GET['token']) : '';
        
        if (empty($email) || empty($token)) {
            $this->smarty->assign('error', 'Liên kết không hợp lệ!');
            $this->smarty->display('newsletter/unsubscribe.tpl');
            return;
        }
        
        // Verify token
        $expectedToken = md5($email . 'unsubscribe_salt');
        if ($token !== $expectedToken) {
            $this->smarty->assign('error', 'Liên kết không hợp lệ!');
            $this->smarty->display('newsletter/unsubscribe.tpl');
            return;
        }
        
        // Update subscriber status
        $email_escaped = $this->db->escape($email);
        $result = $this->db->executeQuery(
            "UPDATE newsletter_subscribers SET status = 'unsubscribed', updated_at = NOW() WHERE email = '$email_escaped'"
        );
        
        if ($result) {
            $this->smarty->assign('success', 'Bạn đã hủy đăng ký thành công!');
        } else {
            $this->smarty->assign('error', 'Có lỗi xảy ra. Vui lòng thử lại!');
        }
        
        $this->smarty->display('newsletter/unsubscribe.tpl');
    }
}

// Handle request
if (isset($_GET['c']) && $_GET['c'] === 'unsubscribe') {
    include_once 'library/smarty/Smarty.class.php';
    $smarty = new Smarty();
    $smarty->setTemplateDir('templates/');
    $smarty->setCompileDir('templates_c/');
    $smarty->setCacheDir('cache/');
    $smarty->setConfigDir('configs/');
    
    $controller = new UnsubscribeController($smarty);
    $controller->index();
}
?>