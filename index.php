<?php
session_start();

error_reporting(E_ALL);
ini_set('display_errors', true);
ini_set('display_startup_errors', true);

include_once 'config.php';
include_once 'model/model.php';

include_once 'model/cart.php';
include_once 'model/categories.php';
include_once 'model/images.php';
include_once 'model/order_items.php';
include_once 'model/orders.php';
include_once 'model/products.php';
include_once 'model/reviews.php';
include_once 'model/users.php';
include_once 'model/order_complaints.php';
include_once 'model/order_reviews.php';
include_once 'model/order_cancellations.php';


//Gọi template engine Smarty
// Thư viện Smarty được tải từ thư mục library/smarty/libs/Smarty.class.php
// Đảm bảo rằng thư mục này tồn tại và chứa file Smarty.class.php
// Nếu không có, bạn cần tải Smarty từ trang chính thức và đặt nó vào thư mục này.
include_once 'library/smarty/libs/Smarty.class.php';
$smarty = new \Smarty\Smarty;
$smarty->debugging = false;
$smarty->caching = false; // Tắt cache để thay đổi hiển thị ngay lập tức
$smarty->cache_lifetime = 0;

//Xác định controller và action
$controller_name = $_GET['c'] ?? 'product';
$action = $_GET['v'] ?? $_GET['a'] ?? 'index'; // Prioritize 'v' over 'a' for consistency

// Kiểm tra file controller có tồn tại không
$controller_file = 'controller/' . $controller_name . '.php';
if (file_exists($controller_file)) {
    include_once $controller_file;

    // Tạo instance của controller class
    $controller_class = ucfirst($controller_name) . 'Controller';
    if (class_exists($controller_class)) {
        $controller_instance = new $controller_class($smarty);

        // Gọi method tương ứng với action
        if (method_exists($controller_instance, $action)) {
            $controller_instance->$action();
        } else {
            // Nếu method không tồn tại, thử hiển thị template trực tiếp
            $template = 'templates/' . $controller_name . '/' . $action . '.tpl';
            if (file_exists($template)) {
                $smarty->display($template);
            } else {
                echo "<h1>404 - Trang không tồn tại</h1>";
                echo "<p>Action '$action' không tồn tại trong controller '$controller_name'.</p>";
                echo "<a href='/?c=product&a=index'>Quay về trang shop</a>";
            }
        }
    } else {
        echo "<h1>500 - Lỗi hệ thống</h1>";
        echo "<p>Controller class '$controller_class' không tồn tại.</p>";
    }
} else {
    // Nếu controller không tồn tại, chuyển về trang shop
    header("Location: /?c=product&v=index");
    exit();
}