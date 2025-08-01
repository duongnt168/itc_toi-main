{include file="include/user/header.tpl"}
{include file="include/user/navbar.tpl"}

<div class="container my-5" style="padding-top: 100px;">
    <div class="row">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="mb-0">Giỏ hàng của bạn</h2>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="/?c=user&v=index">Trang chủ</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Giỏ hàng</li>
                    </ol>
                </nav>
            </div>
            
            {if isset($smarty.session.error)}
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    {$smarty.session.error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            {/if}
            {if isset($smarty.session.success)}
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    {$smarty.session.success}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            {/if}
            
            {if !isset($cart_items) || $cart_items|@count == 0}
                <div class="text-center py-5">
                    <div class="mb-4">
                        <i class="fas fa-shopping-cart fa-5x text-muted"></i>
                    </div>
                    <h4 class="text-muted mb-3">Giỏ hàng của bạn đang trống</h4>
                    <p class="text-muted mb-4">Hãy thêm một số sản phẩm vào giỏ hàng để tiếp tục mua sắm.</p>
                    <a href="/?c=user&v=index" class="btn btn-primary btn-lg">
                        <i class="fas fa-arrow-left me-2"></i>Tiếp tục mua sắm
                    </a>
                </div>
            {else}
                <div class="card shadow-sm">
                    <div class="card-header bg-success text-white">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="mb-0"><i class="fas fa-shopping-cart me-2"></i>Chi tiết giỏ hàng</h5>
                            <span class="badge bg-light text-dark">{$cart_items|@count} sản phẩm</span>
                        </div>
                    </div>
                    <div class="card-body p-0">
                        <form method="post" action="/?c=cart&v=update" id="cartForm">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th style="width: 100px;">Ảnh</th>
                                            <th>Tên sản phẩm</th>
                                            <th style="width: 120px;">Đơn giá</th>
                                            <th style="width: 150px;">Số lượng</th>
                                            <th style="width: 120px;">Thành tiền</th>
                                            <th style="width: 80px;">Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {foreach $cart_items as $item}
                                        <tr>
                                            <td>
                                                {if $item.file_url}
                                                    <img src="/public/img/products/{$item.file_url}?t={$smarty.now}" 
                                                         alt="{$item.name}" 
                                                         class="img-thumbnail" 
                                                         style="width:80px;height:80px;object-fit:cover;">
                                                {else}
                                                    <div class="img-thumbnail d-flex align-items-center justify-content-center bg-light" 
                                                         style="width:80px;height:80px;">
                                                        <i class="bi bi-image text-muted"></i>
                                                    </div>
                                                {/if}
                                            </td>
                                            <td>
                                                <h6 class="mb-1">{$item.name}</h6>
                                                <small class="text-muted">Còn lại: {$item.stock} sản phẩm</small>
                                            </td>
                                            <td>
                                                <span class="fw-bold text-primary" id="price_{$item.product_id}">{if $item.price}{$item.price|number_format:0:",":"."} đ{/if}</span>
                                            </td>
                                            <td>
                                                <div class="input-group input-group-sm" style="width: 120px;">
                                                    <button type="button" class="btn btn-outline-secondary" onclick="decreaseQuantity({$item.product_id})">
                                                        <i class="fas fa-minus"></i>
                                                    </button>
                                                    <input type="number" 
                                                           name="quantities[{$item.product_id}]" 
                                                           value="{$item.quantity}" 
                                                           min="1" 
                                                           max="{$item.stock}" 
                                                           class="form-control text-center" 
                                                           id="qty_{$item.product_id}"
                                                           onchange="updateTotal()">
                                                    <button type="button" class="btn btn-outline-secondary" onclick="increaseQuantity({$item.product_id}, {$item.stock})">
                                                        <i class="fas fa-plus"></i>
                                                    </button>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="fw-bold text-success" id="total_{$item.product_id}">{$item.total_price|number_format:0:",":"."} đ</span>
                                            </td>
                                            <td>
                                                 <a href="/?c=cart&v=remove&product_id={$item.product_id}" 
                                                    class="btn btn-outline-danger btn-sm" 
                                                    onclick="return confirm('Bạn có chắc muốn xóa sản phẩm này?')" 
                                                    title="Xóa sản phẩm">
                                                     <i class="fas fa-trash"></i>
                                                 </a>
                                             </td>
                                        </tr>
                                        {/foreach}
                                    </tbody>
                                </table>
                            </div>
                        </form>
                    </div>
                    <div class="card-footer bg-light">
                        <!-- Phần Voucher -->
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <div class="card border-primary">
                                    <div class="card-header bg-primary text-white py-2">
                                        <h6 class="mb-0"><i class="fas fa-ticket-alt me-2"></i>Mã giảm giá</h6>
                                    </div>
                                    <div class="card-body p-3">
                                        {if $voucher_code}
                                            <!-- Voucher đã áp dụng -->
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div>
                                                    <span class="badge bg-success fs-6">{$voucher_code}</span>
                                                    <div class="small text-muted mt-1">
                                                        {if $voucher_info.type == 'percentage'}
                                                            Giảm {$voucher_info.value}%
                                                        {else}
                                                            Giảm {$voucher_info.value|number_format:0:",":"."} đ
                                                        {/if}
                                                    </div>
                                                </div>
                                                <a href="/?c=cart&a=remove_voucher" class="btn btn-outline-danger btn-sm">
                                                    <i class="fas fa-times"></i> Hủy
                                                </a>
                                            </div>
                                        {else}
                                            <!-- Form nhập voucher -->
                                            <form method="POST" action="/?c=cart&a=apply_voucher">
                                                <div class="input-group">
                                                    <input type="text" class="form-control" name="voucher_code" 
                                                           placeholder="Nhập mã giảm giá" required>
                                                    <button type="submit" class="btn btn-primary">
                                                        <i class="fas fa-check me-1"></i>Áp dụng
                                                    </button>
                                                </div>
                                            </form>
                                        {/if}
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <!-- Tóm tắt đơn hàng -->
                                <div class="card border-success">
                                    <div class="card-header bg-success text-white py-2">
                                        <h6 class="mb-0"><i class="fas fa-calculator me-2"></i>Tóm tắt đơn hàng</h6>
                                    </div>
                                    <div class="card-body p-3">
                                        <div class="d-flex justify-content-between mb-2">
                                            <span>Tạm tính:</span>
                                            <span>{$cart_total|number_format:0:",":"."} đ</span>
                                        </div>
                                        {if $voucher_discount > 0}
                                            <div class="d-flex justify-content-between mb-2 text-success">
                                                <span>Giảm giá:</span>
                                                <span>-{$voucher_discount|number_format:0:",":"."} đ</span>
                                            </div>
                                        {/if}
                                        <hr class="my-2">
                                        <div class="d-flex justify-content-between">
                                            <strong>Tổng cộng:</strong>
                                            <strong class="text-danger">{$final_total|number_format:0:",":"."} đ</strong>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row align-items-center">
                            <div class="col-md-6">
                                <div class="d-flex gap-2">
                                    <a href="/?c=user&v=index" class="btn btn-outline-secondary">
                                        <i class="fas fa-arrow-left me-2"></i>Tiếp tục mua sắm
                                    </a>
                                    <a href="/?c=cart&v=clear" 
                                        class="btn btn-outline-warning" 
                                        onclick="return confirm('Bạn có chắc muốn xóa toàn bộ giỏ hàng?')">
                                         <i class="fas fa-trash-alt me-2"></i>Xóa tất cả
                                     </a>
                                </div>
                            </div>
                            <div class="col-md-6 text-md-end">
                                <div class="d-flex gap-2 justify-content-md-end">
                                    <button type="submit" form="cartForm" class="btn btn-primary">
                                        <i class="fas fa-sync-alt me-2"></i>Cập nhật giỏ hàng
                                    </button>
                                    <a href="/?c=order&v=checkout" class="btn btn-success btn-lg">
                                        <i class="fas fa-credit-card me-2"></i>Thanh toán ({$final_total|number_format:0:",":"."} đ)
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
    {/if}
        </div>
    </div>
</div>

<script>
// Hàm tăng số lượng
function increaseQuantity(productId, maxStock) {
    const qtyInput = document.getElementById('qty_' + productId);
    let currentQty = parseInt(qtyInput.value);
    if (currentQty < maxStock) {
        qtyInput.value = currentQty + 1;
        updateQuantityAjax(productId, currentQty + 1);
    } else {
        showNotification('Số lượng đã đạt tối đa!', 'warning');
    }
}

// Hàm giảm số lượng
function decreaseQuantity(productId) {
    const qtyInput = document.getElementById('qty_' + productId);
    let currentQty = parseInt(qtyInput.value);
    if (currentQty > 1) {
        qtyInput.value = currentQty - 1;
        updateQuantityAjax(productId, currentQty - 1);
    } else {
        showNotification('Số lượng tối thiểu là 1!', 'warning');
    }
}

// Hàm cập nhật số lượng qua AJAX
function updateQuantityAjax(productId, newQuantity) {
    const formData = new FormData();
    formData.append('quantities[' + productId + ']', newQuantity);
    
    fetch('/?c=cart&v=update', {
        method: 'POST',
        body: formData
    })
    .then(response => {
        if (response.ok) {
            updateItemTotal(productId, newQuantity);
            updateGrandTotal();
            showNotification('Đã cập nhật số lượng!', 'success');
        } else {
            showNotification('Có lỗi xảy ra khi cập nhật!', 'error');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showNotification('Có lỗi xảy ra!', 'error');
    });
}

// Hàm cập nhật tổng tiền của từng sản phẩm
function updateItemTotal(productId, quantity) {
    const priceElement = document.getElementById('price_' + productId);
    const totalElement = document.getElementById('total_' + productId);
    
    if (priceElement && totalElement) {
        const priceText = priceElement.textContent.replace(/[^0-9]/g, '');
        const price = parseInt(priceText);
        const newTotal = price * quantity;
        totalElement.textContent = new Intl.NumberFormat('vi-VN').format(newTotal) + ' đ';
    }
}

// Hàm cập nhật tổng tiền toàn bộ giỏ hàng
function updateGrandTotal() {
    const grandTotalElement = document.getElementById('grandTotal');
    if (!grandTotalElement) {
        return; // Không có element grandTotal (có thể giỏ hàng trống)
    }
    
    let grandTotal = 0;
    const totalElements = document.querySelectorAll('[id^="total_"]');
    
    totalElements.forEach(element => {
        const totalText = element.textContent.replace(/[^0-9]/g, '');
        grandTotal += parseInt(totalText) || 0;
    });
    
    grandTotalElement.innerHTML = 'Tổng tiền: ' + new Intl.NumberFormat('vi-VN').format(grandTotal) + ' đ';
}

// Hàm hiển thị thông báo
function showNotification(message, type = 'info') {
    // Xóa thông báo cũ nếu có
    const existingAlert = document.querySelector('.dynamic-alert');
    if (existingAlert) {
        existingAlert.remove();
    }
    
    // Tạo thông báo mới
    const alertClass = {
        'success': 'alert-success',
        'error': 'alert-danger',
        'warning': 'alert-warning',
        'info': 'alert-info'
    }[type] || 'alert-info';
    
    const alertHtml = `
        <div class="alert ` + alertClass + ` alert-dismissible fade show dynamic-alert" role="alert">
            ` + message + `
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    `;
    
    // Chèn thông báo vào đầu container
    const container = document.querySelector('.container');
    if (container) {
        container.insertAdjacentHTML('afterbegin', alertHtml);
        
        // Tự động ẩn sau 3 giây
        setTimeout(() => {
            const alert = document.querySelector('.dynamic-alert');
            if (alert) {
                alert.style.transition = 'opacity 0.5s';
                alert.style.opacity = '0';
                setTimeout(() => {
                    if (alert.parentNode) {
                        alert.parentNode.removeChild(alert);
                    }
                }, 500);
            }
        }, 3000);
    }
}

// Xử lý thông báo tự động ẩn
document.addEventListener('DOMContentLoaded', function() {
    // Kiểm tra và khởi tạo các element cần thiết
    const grandTotalElement = document.getElementById('grandTotal');
    if (grandTotalElement) {
        // Chỉ thực hiện các thao tác khi có element grandTotal
        console.log('Cart page loaded with grand total element');
    }
    
    // Tự động ẩn thông báo sau 5 giây
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(function(alert) {
        setTimeout(function() {
            if (alert && alert.parentNode) {
                alert.style.transition = 'opacity 0.5s';
                alert.style.opacity = '0';
                setTimeout(function() {
                    if (alert.parentNode) {
                        alert.parentNode.removeChild(alert);
                    }
                }, 500);
            }
        }, 5000);
    });
    
    // Xử lý nút đóng thông báo
    const closeButtons = document.querySelectorAll('.btn-close');
    closeButtons.forEach(function(btn) {
        btn.addEventListener('click', function() {
            const alert = this.closest('.alert');
            if (alert) {
                alert.style.transition = 'opacity 0.3s';
                alert.style.opacity = '0';
                setTimeout(function() {
                    if (alert.parentNode) {
                        alert.parentNode.removeChild(alert);
                    }
                }, 300);
            }
        });
    });
});
</script>

{include file="include/user/footer.tpl"}