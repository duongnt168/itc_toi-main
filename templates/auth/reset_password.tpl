{include file="templates/include/auth/header.tpl"}
<div class="login-container">
    <div class="login-logo">
        <img src="public/img/LOGOMINI.svg" alt="AquaGarden Logo">
    </div>
    <h2>Đặt Lại Mật Khẩu</h2>
    
    {if isset($error)}
        <div class="login-error">{$error}</div>
    {/if}
    
    {if isset($success)}
        <div class="login-success">{$success}</div>
    {/if}
    
    <form action="/?c=auth&v=xu_ly_dat_lai_mat_khau" method="POST">
        <input type="hidden" name="email" value="{$email}">
        
        <div class="form-group">
            <label for="new_password">Mật khẩu mới:</label>
            <input type="password" id="new_password" name="new_password" required minlength="6" placeholder="Nhập mật khẩu mới">
        </div>
        
        <div class="form-group">
            <label for="confirm_password">Xác nhận mật khẩu mới:</label>
            <input type="password" id="confirm_password" name="confirm_password" required minlength="6" placeholder="Nhập lại mật khẩu mới">
        </div>

        <div class="form-group">
            <button type="submit">Đặt Lại Mật Khẩu</button>
        </div>
    </form>
    
    <div style="text-align: center; margin-top: 15px;">
        <a href="/?c=auth&v=login" class="forgot-link">Quay lại đăng nhập</a>
    </div>
</div>

{include file="templates/include/auth/footer.tpl"}