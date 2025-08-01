{include file="templates/include/auth/header.tpl"}
<div class="login-container">
    <div class="login-logo">
        <img src="public/img/LOGOMINI.svg" alt="AquaGarden Logo">
    </div>
    <h2>Xác Thực OTP</h2>
    
    <div class="otp-info">
        <p>Chúng tôi đã gửi mã OTP đến email:</p>
        <p><strong>{$email}</strong></p>
        <p>Vui lòng kiểm tra hộp thư và nhập mã OTP bên dưới.</p>
    </div>
    
    {if isset($error)}
        <div class="login-error">{$error}</div>
    {/if}
    
    {if isset($success)}
        <div class="login-success">{$success}</div>
    {/if}
    
    {if isset($smarty.get.resent)}
        <div class="login-success">Mã OTP đã được gửi lại thành công!</div>
    {/if}
    
    {if isset($smarty.get.error)}
        <div class="login-error">Không thể gửi lại mã OTP. Vui lòng thử lại!</div>
    {/if}
    
    <form action="/?c=auth&v=xu_ly_xac_thuc_otp" method="POST">
        <input type="hidden" name="email" value="{$email}">
        <input type="hidden" name="type" value="{$type}">
        
        <div class="form-group">
            <label for="otp_code">Mã OTP (6 chữ số):</label>
            <input type="text" id="otp_code" name="otp_code" required maxlength="6" pattern="[0-9]{literal}{6}{/literal}" placeholder="Nhập mã OTP" style="text-align: center; font-size: 18px; letter-spacing: 3px;">
        </div>

        <div class="form-group">
            <button type="submit">Xác Thực</button>
        </div>
    </form>
    
    <div class="otp-actions">
        <p>Không nhận được mã?</p>
        <a href="/?c=auth&v=resend_otp&email={$email}&type={$type}" class="resend-link">Gửi lại mã OTP</a>
        <br><br>
        <a href="/?c=auth&v=login" class="forgot-link">Quay lại đăng nhập</a>
    </div>
</div>

{include file="templates/include/auth/footer.tpl"}