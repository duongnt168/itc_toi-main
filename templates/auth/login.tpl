{include file="templates/include/auth/header.tpl"}
<div class="login-container">
    <div class="login-logo">
        <img src="public/img/logo1.webp" alt="AquaGarden Logo">
    </div>
    <h2>Đăng Nhập</h2>
    
    {if isset($error)}
        <div class="login-error">{$error}</div>
    {/if}
    
    {if isset($success)}
        <div class="login-success">{$success}</div>
    {/if}
    
    {if isset($smarty.get.success)}
        {if $smarty.get.success == 1}
            <div class="login-success">Đăng ký thành công! Vui lòng đăng nhập.</div>
        {elseif $smarty.get.success == 2}
            <div class="login-success">Đặt lại mật khẩu thành công! Vui lòng đăng nhập.</div>
        {/if}
    {/if}
    
    <form action="/?c=auth&v=xu_ly_dang_nhap" method="POST">
        <div class="form-group">
            <label for="email">Email đăng nhập:</label>
            <input type="email" id="email" name="email" required value="{if isset($email)}{$email}{/if}">
        </div>
        <div class="form-group">
            <label for="password">Mật khẩu:</label>
            <input type="password" id="password" name="password" required>
        </div>
        <div class="form-group remember-me">
            <label class="checkbox-container">
                <input type="checkbox" id="remember" name="remember" value="1">
                <span class="checkmark"></span>
                Ghi nhớ đăng nhập
            </label>
        </div>
        <div class="form-group">
            <button type="submit">Đăng Nhập</button>
        </div>
    </form>
    
    <div style="text-align: center; margin-top: 15px;">
        <a href="/?c=auth&v=forgot_password" class="forgot-link">Quên mật khẩu?</a>
    </div>
    
    <div class="register-link">
        Chưa có tài khoản? <a href="/?c=auth&v=register">Đăng ký ngay</a>
    </div>
</div>

{include file="templates/include/auth/footer.tpl"}