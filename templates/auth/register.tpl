{include file="templates/include/auth/header.tpl"}
<div class="login-container">
    <div class="login-logo">
        <img src="public/img/LOGOMINI.svg" alt="AquaGarden Logo">
    </div>
    <h2>Đăng Ký Tài Khoản</h2>
    
    {if isset($error)}
        <div class="login-error">{$error}</div>
    {/if}
    
    {if isset($success)}
        <div class="login-success">{$success}</div>
    {/if}
    
    <form action="/?c=auth&v=xu_ly_dang_ky" method="POST">
        <div class="form-group">
            <label for="username">Họ và Tên:</label>
            <input type="text" id="username" name="username" required value="{if isset($username)}{$username}{/if}">
        </div>

        <div class="form-group">
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required value="{if isset($email)}{$email}{/if}">
        </div>

        <div class="form-group">
            <label for="phone">Số điện thoại:</label>
            <input type="tel" id="phone" name="phone" pattern="[0-9]{literal}{10,11}{/literal}" title="Số điện thoại phải có 10 hoặc 11 chữ số" required value="{if isset($phone)}{$phone}{/if}">
        </div>

        <div class="form-group">
            <label for="password">Mật khẩu:</label>
            <input type="password" id="password" name="password" minlength="6" required>
        </div>
        
        <div class="form-group">
            <label for="confirm_password">Xác nhận mật khẩu:</label>
            <input type="password" id="confirm_password" name="confirm_password" minlength="6" required>
        </div>

        <div class="form-group">
            <button type="submit">Đăng Ký</button>
        </div>
    </form>
    
    <div class="register-link">
        Đã có tài khoản? <a href="/?c=auth&v=login">Đăng nhập ngay</a>
    </div>
</div>

{include file="templates/include/auth/footer.tpl"}