<?php

// Hàm gửi email OTP
function sendOTPEmail($email, $otp_code, $type = 'register')
{
    require_once 'vendor/autoload.php'; // Nếu sử dụng PHPMailer qua Composer

    $mail = new PHPMailer\PHPMailer\PHPMailer(true);

    try {
        // Cấu hình SMTP
        $mail->isSMTP();
        $mail->Host = EMAIL_HOST;
        $mail->SMTPAuth = true;
        $mail->Username = EMAIL_USER;
        $mail->Password = EMAIL_PASS;
        $mail->SMTPSecure = PHPMailer\PHPMailer\PHPMailer::ENCRYPTION_STARTTLS;
        $mail->Port = EMAIL_PORT;
        $mail->CharSet = 'UTF-8';

        // Người gửi
        $mail->setFrom(EMAIL_USER, 'ITC System');
        $mail->addAddress($email);

        // Nội dung email
        $mail->isHTML(true);
        if ($type == 'register') {
            $mail->Subject = 'Mã OTP xác thực đăng ký';
            $mail->Body = "<h3>Mã OTP của bạn là: <strong>$otp_code</strong></h3><p>Mã này có hiệu lực trong 5 phút.</p>";
        } else {
            $mail->Subject = 'Mã OTP đặt lại mật khẩu';
            $mail->Body = "<h3>Mã OTP đặt lại mật khẩu: <strong>$otp_code</strong></h3><p>Mã này có hiệu lực trong 5 phút.</p>";
        }

        $mail->send();
        return true;
    } catch (Exception $e) {
        return false;
    }
}

// Hàm tạo OTP
function generateOTP($length = 6)
{
    return str_pad(rand(0, pow(10, $length) - 1), $length, '0', STR_PAD_LEFT);
}

// Hàm lưu OTP vào database
function saveOTP($email, $otp_code, $type = 'register')
{
    global $db;
    
    // Xóa OTP cũ
    $db->record_delete('otp', "email = '$email' AND type = '$type'");
    
    // Lưu OTP mới
    $data = [
        'email' => $email,
        'otp_code' => $otp_code,
        'type' => $type,
        'expires_at' => date('Y-m-d H:i:s', strtotime('+5 minutes')),
        'is_used' => 0
    ];
    
    return $db->record_insert('otp', $data);
}

// Hàm xác thực OTP
function verifyOTP($email, $otp_code, $type = 'register')
{
    global $db;
    
    $sql = "SELECT * FROM otp WHERE email = '$email' AND otp_code = '$otp_code' AND type = '$type' AND expires_at > NOW() AND is_used = 0";
    $result = $db->executeQuery_list($sql);
    
    if (!empty($result)) {
        // Đánh dấu OTP đã sử dụng
        $db->record_update('otp', ['is_used' => 1], "id = '{$result[0]['id']}'");
        return true;
    }
    
    return false;
}

class AuthController {
    private $smarty;
    
    public function __construct($smarty) {
        $this->smarty = $smarty;
    }
    
    public function login() {
        // Hiển thị form đăng nhập
        $this->smarty->display('auth/login.tpl');
    }
    
    public function xu_ly_dang_nhap() {
        // Xử lý đăng nhập
        $email = trim($_POST['email']);
        $password = $_POST['password'];

        if (empty($email) || empty($password)) {
            $this->smarty->assign('error', 'Vui lòng nhập đầy đủ thông tin!');
            $this->smarty->assign('email', $email);
            $this->smarty->display('auth/login.tpl');
        } else {
            $users = new users();
            $user = $users->user($email);

            if (empty($user)) {
                $this->smarty->assign('error', 'Email không tồn tại trong hệ thống!');
                $this->smarty->assign('email', $email);
                $this->smarty->display('auth/login.tpl');
            } elseif ($user[0]['password'] != md5($password)) {
                $this->smarty->assign('error', 'Mật khẩu không đúng!');
                $this->smarty->assign('email', $email);
                $this->smarty->display('auth/login.tpl');
            } else {
                // Đăng nhập thành công
                $_SESSION['user_id'] = $user[0]['id'];
                $_SESSION['email'] = $user[0]['email'];
                $_SESSION['username'] = $user[0]['username'];
                $_SESSION['role'] = $user[0]['role'];

                // Cập nhật last_login
                $users->set('id', $user[0]['id']);
                $users->set('last_login', date('Y-m-d H:i:s'));
                $users->update_field('last_login');

                // Chuyển hướng
                if ($user[0]['role'] == 'admin') {
                    header("Location: /?c=admin&a=dashboard");
                } else {
                    header("Location: /?c=user&v=index");
                }
                exit();
            }
        }
    }
    
    public function register() {
        // Hiển thị form đăng ký
        $this->smarty->display('auth/register.tpl');
    }
    
    public function xu_ly_dang_ky() {
        // Xử lý đăng ký
        $username = trim($_POST['username']);
        $email = trim($_POST['email']);
        $phone = trim($_POST['phone']);
        $password = $_POST['password'];
        $confirm_password = $_POST['confirm_password'];

        // Validate
        if (empty($username) || empty($email) || empty($phone) || empty($password)) {
            $this->smarty->assign('error', 'Vui lòng nhập đầy đủ thông tin!');
            $this->smarty->assign('username', $username);
            $this->smarty->assign('email', $email);
            $this->smarty->assign('phone', $phone);
            $this->smarty->display('auth/register.tpl');
        } elseif ($password != $confirm_password) {
            $this->smarty->assign('error', 'Mật khẩu xác nhận không khớp!');
            $this->smarty->assign('username', $username);
            $this->smarty->assign('email', $email);
            $this->smarty->assign('phone', $phone);
            $this->smarty->display('auth/register.tpl');
        } elseif (strlen($password) < 6) {
            $this->smarty->assign('error', 'Mật khẩu phải có ít nhất 6 ký tự!');
            $this->smarty->assign('username', $username);
            $this->smarty->assign('email', $email);
            $this->smarty->assign('phone', $phone);
            $this->smarty->display('auth/register.tpl');
        } else {
            // Kiểm tra email đã tồn tại
            $users = new users();
            $existing_user = $users->user($email);

            if (!empty($existing_user)) {
                $this->smarty->assign('error', 'Email đã được sử dụng!');
                $this->smarty->assign('username', $username);
                $this->smarty->assign('email', $email);
                $this->smarty->assign('phone', $phone);
                $this->smarty->display('auth/register.tpl');
            } else {
                // Tạo và gửi OTP
                $otp_code = generateOTP();

                if (saveOTP($email, $otp_code, 'register') && sendOTPEmail($email, $otp_code, 'register')) {
                    // Lưu thông tin tạm thời vào session
                    $_SESSION['temp_register'] = [
                        'username' => $username,
                        'email' => $email,
                        'phone' => $phone,
                        'password' => md5($password)
                    ];

                    header("Location: /?c=auth&v=verify_otp&email=$email&type=register");
                    exit();
                } else {
                    $this->smarty->assign('error', 'Không thể gửi mã OTP. Vui lòng thử lại!');
                    $this->smarty->assign('username', $username);
                    $this->smarty->assign('email', $email);
                    $this->smarty->assign('phone', $phone);
                    $this->smarty->display('auth/register.tpl');
                }
            }
        }
    }
    
    public function forgot_password() {
        // Hiển thị form quên mật khẩu
        $this->smarty->display('auth/forgot_password.tpl');
    }
    
    public function xu_ly_quen_mat_khau() {
        // Xử lý quên mật khẩu
        $email = trim($_POST['email']);

        if (empty($email)) {
            $this->smarty->assign('error', 'Vui lòng nhập email!');
            $this->smarty->display('auth/forgot_password.tpl');
        } else {
            // Kiểm tra email có tồn tại
            $users = new users();
            $user = $users->user($email);

            if (empty($user)) {
                $this->smarty->assign('error', 'Email không tồn tại trong hệ thống!');
                $this->smarty->assign('email', $email);
                $this->smarty->display('auth/forgot_password.tpl');
            } else {
                // Tạo và gửi OTP
                $otp_code = generateOTP();

                if (saveOTP($email, $otp_code, 'forgot_password') && sendOTPEmail($email, $otp_code, 'forgot_password')) {
                    header("Location: /?c=auth&v=verify_otp&email=$email&type=forgot_password");
                    exit();
                } else {
                    $this->smarty->assign('error', 'Không thể gửi mã OTP. Vui lòng thử lại!');
                    $this->smarty->assign('email', $email);
                    $this->smarty->display('auth/forgot_password.tpl');
                }
            }
        }
    }
    
    public function verify_otp() {
        // Hiển thị form xác thực OTP
        $email = $_GET['email'] ?? '';
        $type = $_GET['type'] ?? 'register';

        $this->smarty->assign('email', $email);
        $this->smarty->assign('type', $type);
        $this->smarty->display('auth/verify_otp.tpl');
    }
    
    public function xu_ly_xac_thuc_otp() {
        // Xử lý xác thực OTP
        $email = $_POST['email'];
        $type = $_POST['type'];
        $otp_code = $_POST['otp_code'];

        if (empty($otp_code)) {
            $this->smarty->assign('error', 'Vui lòng nhập mã OTP!');
            $this->smarty->assign('email', $email);
            $this->smarty->assign('type', $type);
            $this->smarty->display('auth/verify_otp.tpl');
        } elseif (verifyOTP($email, $otp_code, $type)) {
            if ($type == 'register') {
                // Hoàn tất đăng ký
                if (isset($_SESSION['temp_register'])) {
                    $temp_data = $_SESSION['temp_register'];

                    $data = [
                        'username' => $temp_data['username'],
                        'email' => $temp_data['email'],
                        'phone' => $temp_data['phone'],
                        'password' => $temp_data['password'],
                        'role' => 'user',
                        'status' => 'active'
                    ];

                    global $db;
                    if ($db->record_insert('users', $data)) {
                        unset($_SESSION['temp_register']);
                        header("Location: /?c=auth&v=login&success=1");
                        exit();
                    } else {
                        $this->smarty->assign('error', 'Có lỗi xảy ra. Vui lòng thử lại!');
                        $this->smarty->assign('email', $email);
                        $this->smarty->assign('type', $type);
                        $this->smarty->display('auth/verify_otp.tpl');
                    }
                } else {
                    $this->smarty->assign('error', 'Phiên đăng ký đã hết hạn. Vui lòng đăng ký lại!');
                    $this->smarty->assign('email', $email);
                    $this->smarty->assign('type', $type);
                    $this->smarty->display('auth/verify_otp.tpl');
                }
            } else {
                // Chuyển đến trang đặt lại mật khẩu
                header("Location: /?c=auth&v=reset_password&email=$email");
                exit();
            }
        } else {
            $this->smarty->assign('error', 'Mã OTP không đúng hoặc đã hết hạn!');
            $this->smarty->assign('email', $email);
            $this->smarty->assign('type', $type);
            $this->smarty->display('auth/verify_otp.tpl');
        }
    }
    
    public function reset_password() {
        // Hiển thị form đặt lại mật khẩu
        $email = $_GET['email'] ?? '';
        $this->smarty->assign('email', $email);
        $this->smarty->display('auth/reset_password.tpl');
    }
    
    public function xu_ly_dat_lai_mat_khau() {
        // Xử lý đặt lại mật khẩu
        $email = $_POST['email'];
        $new_password = $_POST['new_password'];
        $confirm_password = $_POST['confirm_password'];

        if (empty($new_password) || empty($confirm_password)) {
            $this->smarty->assign('error', 'Vui lòng nhập đầy đủ thông tin!');
            $this->smarty->assign('email', $email);
            $this->smarty->display('auth/reset_password.tpl');
        } elseif ($new_password != $confirm_password) {
            $this->smarty->assign('error', 'Mật khẩu xác nhận không khớp!');
            $this->smarty->assign('email', $email);
            $this->smarty->display('auth/reset_password.tpl');
        } elseif (strlen($new_password) < 6) {
            $this->smarty->assign('error', 'Mật khẩu phải có ít nhất 6 ký tự!');
            $this->smarty->assign('email', $email);
            $this->smarty->display('auth/reset_password.tpl');
        } else {
            // Cập nhật mật khẩu
            global $db;
            $hashed_password = md5($new_password);

            $data = ['password' => $hashed_password];
            if ($db->record_update('users', $data, "email = '$email'")) {
                header("Location: /?c=auth&v=login&success=2");
                exit();
            } else {
                $this->smarty->assign('error', 'Có lỗi xảy ra. Vui lòng thử lại!');
                $this->smarty->assign('email', $email);
                $this->smarty->display('auth/reset_password.tpl');
            }
        }
    }
    
    public function resend_otp() {
        // Gửi lại OTP
        $email = $_POST['email'];
        $type = $_POST['type'];

        $otp_code = generateOTP();

        if (saveOTP($email, $otp_code, $type) && sendOTPEmail($email, $otp_code, $type)) {
            echo json_encode(['success' => true, 'message' => 'OTP đã được gửi lại thành công!']);
        } else {
            echo json_encode(['success' => false, 'message' => 'Có lỗi xảy ra khi gửi OTP!']);
        }
        exit();
    }
    
    public function welcome() {
        // Trang chào mừng sau khi đăng nhập
        if (!isset($_SESSION['user_id']) || empty($_SESSION['user_id'])) {
            header("Location: /?c=auth&v=login");
            exit();
        }

        $this->smarty->assign('username', $_SESSION['username']);
        $this->smarty->assign('email', $_SESSION['email']);
        $this->smarty->display('auth/welcome.tpl');
    }
    
    public function logout() {
        // Đăng xuất
        session_destroy();
        header("Location: /?c=auth&v=login");
        exit();
    }
}