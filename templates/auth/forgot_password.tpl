{include file="templates/include/auth/header.tpl"}
<div class="login-container">
    <div class="login-logo">
        <img src="public/img/LOGOMINI.svg" alt="AquaGarden Logo">
    </div>
    <h2>Quên Mật Khẩu</h2>
    
    {if isset($error)}
        <div class="login-error">{$error}</div>
    {/if}
    
    {if isset($success)}
        <div class="login-success">{$success}</div>
    {/if}
    
    <form action="/?c=auth&v=xu_ly_quen_mat_khau" method="POST">
        <div class="form-group">
            <label for="email">Email của bạn:</label>
            <input type="email" id="email" name="email" required value="{if isset($email)}{$email}{/if}" placeholder="Nhập email để nhận mã OTP">
        </div>

        <div class="form-group">
            <button type="submit">Gửi Mã OTP</button>
        </div>
    </form>
    
    <div style="text-align: center; margin-top: 15px;">
        <a href="/?c=auth&v=login" class="forgot-link">Quay lại đăng nhập</a>
    </div>
    
    <div class="register-link">
        Chưa có tài khoản? <a href="/?c=auth&v=register">Đăng ký ngay</a>
    </div>
</div>

{include file="templates/include/auth/footer.tpl"}