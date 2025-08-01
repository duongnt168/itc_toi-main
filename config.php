<?php
include_once 'model/db.php';

// Load database configuration
$db_config = require_once 'config/database.php';

$db = new db();
$db->setUsername($db_config['username']);
$db->setPassword($db_config['password']);
$db->setServer($db_config['host']);
$db->setDatabase($db_config['database']);
$db->tbl_fix = $db_config['database'] . '.';

date_default_timezone_set('Asia/Ho_Chi_Minh');
// Email configuration
define('EMAIL_HOST', 'smtp.gmail.com');
define('EMAIL_PORT', 587);
define('EMAIL_USER', 'text07470@gmail.com');
define('EMAIL_PASS', 'jerk hnsi mngl wxyg');
define('EMAIL_FROM', 'text07470@gmail.com');
define('EMAIL_FROM_NAME', 'AquaGarden Shop');

// OTP Configuration
define('OTP_EXPIRE_TIME', 300); // 5 minutes
define('OTP_LENGTH', 6);

// Helper function to get cart items for navbar
function getCartItemsForNavbar()
{
    if (!isset($_SESSION['user_id']) || empty($_SESSION['user_id'])) {
        return array();
    }

    global $db;
    $user_id = $_SESSION['user_id'];

    $cartItems = $db->executeQuery_list("
        SELECT c.*, p.name, p.price, p.file_url, p.stock
        FROM cart c 
        LEFT JOIN products p ON c.product_id = p.id 
        WHERE c.user_id = '$user_id' AND p.status = 'active'
        ORDER BY c.created_at DESC
    ");

    return $cartItems;
}
?>