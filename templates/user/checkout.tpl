{include file="include/user/header.tpl"}
{include file="include/user/navbar.tpl"}

<div class="container my-4" style="padding-top: 100px;">
    <div class="row">
        <div class="col-12">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="/?c=user&v=index">Trang chủ</a></li>
                    <li class="breadcrumb-item"><a href="/?c=cart&v=index">Giỏ hàng</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Thanh toán</li>
                </ol>
            </nav>
        </div>
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
    
    <div class="row">
        <div class="col-md-8">
            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0"><i class="fas fa-shipping-fast me-2"></i>Thông tin giao hàng</h5>
                </div>
                <div class="card-body">
                    <form method="post" action="/?c=order&v=checkout" id="checkoutForm">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="province" class="form-label"><i class="fas fa-map-marker-alt me-2"></i>Tỉnh/Thành phố *</label>
                                <select class="form-select" id="province" name="province" required>
                                    <option value="">Chọn tỉnh/thành phố</option>
                                    <option value="ho-chi-minh" data-fee="0">TP. Hồ Chí Minh</option>
                                    <option value="ha-noi" data-fee="30000">Hà Nội</option>
                                    <option value="da-nang" data-fee="25000">Đà Nẵng</option>
                                    <option value="can-tho" data-fee="20000">Cần Thơ</option>
                                    <option value="hai-phong" data-fee="35000">Hải Phòng</option>
                                    <option value="bien-hoa" data-fee="15000">Biên Hòa</option>
                                    <option value="nha-trang" data-fee="40000">Nha Trang</option>
                                    <option value="hue" data-fee="45000">Huế</option>
                                    <option value="long-xuyen" data-fee="25000">Long Xuyên</option>
                                    <option value="thai-nguyen" data-fee="50000">Thái Nguyên</option>
                                    <option value="other" data-fee="60000">Tỉnh khác</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="district" class="form-label">Quận/Huyện *</label>
                                <select class="form-select" id="district" name="district" required disabled>
                                    <option value="">Chọn quận/huyện</option>
                                </select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="ward" class="form-label">Phường/Xã *</label>
                                <select class="form-select" id="ward" name="ward" required disabled>
                                    <option value="">Chọn phường/xã</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="street" class="form-label">Số nhà, tên đường *</label>
                                <input type="text" class="form-control" id="street" name="street" required placeholder="Ví dụ: 123 Nguyễn Văn A">
                            </div>
                        </div>
                        <input type="hidden" id="full_address" name="address" value="">
                        <div class="mb-3">
                            <label for="phone" class="form-label"><i class="fas fa-phone me-2"></i>Số điện thoại *</label>
                            <input type="tel" class="form-control" id="phone" name="phone" required value="{$user_phone|default:''}" placeholder="Nhập số điện thoại liên hệ">
                        </div>
                        <div class="mb-3">
                            <label for="note" class="form-label"><i class="fas fa-sticky-note me-2"></i>Ghi chú (tuỳ chọn)</label>
                            <textarea class="form-control" id="note" name="note" rows="3" placeholder="Ghi chú thêm cho đơn hàng (nếu có)"></textarea>
                        </div>
                        
                        <!-- Phương thức thanh toán -->
                        <div class="mb-4">
                            <label class="form-label"><i class="fas fa-credit-card me-2"></i>Phương thức thanh toán *</label>
                            <div class="payment-methods">
                                <div class="form-check mb-3 p-3 border rounded">
                                    <input class="form-check-input" type="radio" name="payment_method" id="cod" value="cod" checked>
                                    <label class="form-check-label w-100" for="cod">
                                        <div class="d-flex align-items-center">
                                            <i class="fas fa-money-bill-wave text-success me-3 fa-2x"></i>
                                            <div>
                                                <h6 class="mb-1">Thanh toán khi nhận hàng (COD)</h6>
                                                <small class="text-muted">Thanh toán bằng tiền mặt khi nhận hàng</small>
                                            </div>
                                        </div>
                                    </label>
                                </div>
                                
                                <div class="form-check mb-3 p-3 border rounded">
                                    <input class="form-check-input" type="radio" name="payment_method" id="stripe" value="stripe">
                                    <label class="form-check-label w-100" for="stripe">
                                        <div class="d-flex align-items-center">
                                            <i class="fab fa-cc-stripe text-primary me-3 fa-2x"></i>
                                            <div>
                                                <h6 class="mb-1">Thanh toán qua thẻ (Stripe)</h6>
                                                <small class="text-muted">Thanh toán an toàn qua thẻ tín dụng/ghi nợ</small>
                                            </div>
                                        </div>
                                    </label>
                                </div>
                                
                                <div class="form-check mb-3 p-3 border rounded">
                                    <input class="form-check-input" type="radio" name="payment_method" id="qr" value="qr">
                                    <label class="form-check-label w-100" for="qr">
                                        <div class="d-flex align-items-center">
                                            <i class="fas fa-qrcode text-info me-3 fa-2x"></i>
                                            <div>
                                                <h6 class="mb-1">Thanh toán qua mã QR</h6>
                                                <small class="text-muted">Quét mã QR để thanh toán qua ví điện tử</small>
                                            </div>
                                        </div>
                                    </label>
                                </div>
                            </div>
                            
                            <!-- Stripe Payment Section -->
                            <div id="stripe-section" style="display: none;" class="mt-3 p-3 border rounded bg-light">
                                <h6 class="mb-3"><i class="fab fa-cc-stripe me-2"></i>Thông tin thẻ</h6>
                                <div class="mb-3">
                                    <label class="form-label">Thông tin thẻ tín dụng/ghi nợ</label>
                                    <div id="card-element" class="form-control" style="padding: 10px;">
                                        <!-- Stripe Elements sẽ tạo form input ở đây -->
                                    </div>
                                    <div id="card-errors" role="alert" class="text-danger mt-2"></div>
                                </div>
                                <div class="alert alert-info small">
                                    <i class="fas fa-info-circle me-2"></i>
                                    Thông tin thẻ của bạn được bảo mật bởi Stripe. Chúng tôi không lưu trữ thông tin thẻ.
                                </div>
                            </div>
                            
                            <!-- QR Payment Section -->
                            <div id="qr-section" style="display: none;" class="mt-3 p-3 border rounded bg-light">
                                <h6 class="mb-3"><i class="fas fa-qrcode me-2"></i>Thanh toán QR</h6>
                                <div class="text-center">
                                    <img id="qr-image" src="" alt="QR Code" class="img-fluid mb-3" style="max-width: 200px;">
                                    <p class="small text-muted">Quét mã QR bằng ứng dụng ngân hàng để thanh toán</p>
                                    <div class="alert alert-warning small">
                                        <i class="fas fa-exclamation-triangle me-2"></i>
                                        Vui lòng hoàn tất thanh toán trước khi xác nhận đặt hàng.
                                    </div>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
        <div class="col-md-4">
            <div class="card shadow-sm">
                <div class="card-header bg-success text-white">
                    <h5 class="mb-0"><i class="fas fa-receipt me-2"></i>Đơn hàng của bạn</h5>
                </div>
                <div class="card-body">
                    {if isset($cart_items) && $cart_items|@count > 0}
                        <div class="order-summary">
                            {foreach $cart_items as $item}
                            <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom">
                                <div class="d-flex align-items-center">
                                    <img src="{if $item.file_url}/public/img/products/{$item.file_url}{else}/public/img/no-image.png{/if}" 
                                         alt="{$item.name}" 
                                         class="img-thumbnail me-2" 
                                         style="width:50px;height:50px;object-fit:cover;">
                                    <div>
                                        <h6 class="mb-0 small">{$item.name}</h6>
                                        <small class="text-muted">SL: {$item.quantity}</small>
                                    </div>
                                </div>
                                <span class="fw-bold text-primary">{$item.total_price|number_format:0:",":"."} đ</span>
                            </div>
                            {/foreach}
                            
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <span class="fw-bold">Tạm tính:</span>
                                <span class="fw-bold">{if isset($subtotal_after_discount)}{$subtotal_after_discount|number_format:0:",":"."}{else}{$cart_total|number_format:0:",":"."}{/if} đ</span>
                            </div>
                            
                            {if isset($voucher_info) && $voucher_info}
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <span class="text-success">Mã giảm giá ({$voucher_code}):</span>
                                <span class="text-success">-{$voucher_discount|number_format:0:",":"."} đ</span>
                            </div>
                            {/if}
                            
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <span>Phí vận chuyển:</span>
                                <span id="shipping-fee" class="text-success">Miễn phí</span>
                            </div>
                            
                            <hr>
                            
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <span class="h5 mb-0">Tổng cộng:</span>
                                <span id="total-amount" class="h5 mb-0 text-danger">{if isset($subtotal_after_discount)}{$subtotal_after_discount|number_format:0:",":"."}{else}{$cart_total|number_format:0:",":"."}{/if} đ</span>
                            </div>
                            
                            <div class="d-grid gap-2">
                                <button type="submit" form="checkoutForm" class="btn btn-success btn-lg">
                                    <i class="fas fa-credit-card me-2"></i>Xác nhận đặt hàng
                                </button>
                                <a href="/?c=cart&v=index" class="btn btn-outline-secondary">
                                    <i class="fas fa-arrow-left me-2"></i>Quay lại giỏ hàng
                                </a>
                            </div>
                        </div>
                    {else}
                        <div class="text-center py-4">
                            <i class="fas fa-shopping-cart fa-3x text-muted mb-3"></i>
                            <p class="text-muted">Giỏ hàng trống</p>
                            <a href="/?c=user&v=index" class="btn btn-primary">Tiếp tục mua sắm</a>
                        </div>
                    {/if}
                </div>
            </div>
            
            <div class="card shadow-sm mt-3">
                <div class="card-body">
                    <h6 class="card-title"><i class="fas fa-shield-alt me-2"></i>Cam kết của chúng tôi</h6>
                    <ul class="list-unstyled small">
                        <li><i class="fas fa-check text-success me-2"></i>Giao hàng nhanh chóng</li>
                        <li><i class="fas fa-check text-success me-2"></i>Đảm bảo chất lượng</li>
                        <li><i class="fas fa-check text-success me-2"></i>Hỗ trợ 24/7</li>
                        <li><i class="fas fa-check text-success me-2"></i>Đổi trả dễ dàng</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Stripe JS -->
<script src="https://js.stripe.com/v3/"></script>
<script>
// Xử lý thông báo tự động ẩn
document.addEventListener('DOMContentLoaded', function() {
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
});

// Khởi tạo Stripe
const stripe = Stripe('{$stripe_publishable_key}');
let elements = null;
let cardElement = null;

// Khởi tạo Stripe Elements khi cần
function initStripeElements() {
    if (!elements) {
        elements = stripe.elements();
        cardElement = elements.create('card');
        cardElement.mount('#card-element');
        
        // Xử lý lỗi thẻ
        cardElement.on('change', function(event) {
            const displayError = document.getElementById('card-errors');
            if (event.error) {
                displayError.textContent = event.error.message;
            } else {
                displayError.textContent = '';
            }
        });
    }
}

// Xử lý chuyển đổi phương thức thanh toán
function togglePaymentMethod() {
    const paymentMethod = document.querySelector('input[name="payment_method"]:checked').value;
    const stripeSection = document.getElementById('stripe-section');
    const qrSection = document.getElementById('qr-section');
    
    // Ẩn tất cả sections
    if (stripeSection) stripeSection.style.display = 'none';
    if (qrSection) qrSection.style.display = 'none';
    
    // Hiển thị section tương ứng
    if (paymentMethod === 'stripe' && stripeSection) {
        stripeSection.style.display = 'block';
        // Khởi tạo Stripe Elements khi hiển thị
        setTimeout(initStripeElements, 100);
    } else if (paymentMethod === 'qr' && qrSection) {
        qrSection.style.display = 'block';
        generateQRCode();
    }
}

// Tạo QR code
function generateQRCode() {
    const total = {$cart_total|default:0};
    const qrImage = document.getElementById('qr-image');
    if (qrImage) {
        const bankCode = '970436'; // Vietcombank
        const accountNumber = '1234567890';
        const template = 'compact2';
        const description = encodeURIComponent('Thanh toan don hang');
        
        const qrUrl = 'https://img.vietqr.io/image/' + bankCode + '-' + accountNumber + '-' + template + '.png?amount=' + total + '&addInfo=' + description;
        qrImage.src = qrUrl;
    }
}

// Xử lý submit form
document.getElementById('checkoutForm').addEventListener('submit', function(event) {
    const paymentMethod = document.querySelector('input[name="payment_method"]:checked').value;
    
    if (paymentMethod === 'stripe') {
        event.preventDefault();
        handleStripePayment();
    } else if (paymentMethod === 'qr') {
        event.preventDefault();
        handleQRPayment();
    }
    // COD sẽ submit form bình thường
});

// Xử lý thanh toán Stripe
async function handleStripePayment() {
    const result = await stripe.createPaymentMethod({
        type: 'card',
        card: cardElement,
    });
    const error = result.error;
    const paymentMethod = result.paymentMethod;
    
    if (error) {
        document.getElementById('card-errors').textContent = error.message;
    } else {
        // Submit form với payment method
        const form = document.getElementById('checkoutForm');
        const hiddenInput = document.createElement('input');
        hiddenInput.type = 'hidden';
        hiddenInput.name = 'stripe_payment_method_id';
        hiddenInput.value = paymentMethod.id;
        form.appendChild(hiddenInput);
        form.submit();
    }
}

// Xử lý thanh toán QR
function handleQRPayment() {
    // Hiển thị modal xác nhận thanh toán QR
    if (confirm('Bạn đã quét mã QR và hoàn tất thanh toán chưa?')) {
        document.getElementById('checkoutForm').submit();
    }
}

// Đảm bảo jQuery đã được load
function initCheckoutScript() {
    if (typeof jQuery === 'undefined') {
        console.error('jQuery chưa được load!');
        setTimeout(initCheckoutScript, 100); // Thử lại sau 100ms
        return;
    }
    
    $(document).ready(function() {
        // Kiểm tra giới hạn thanh toán khi trang được tải
        setTimeout(function() {
            const currentTotal = subtotal + currentShippingFee;
            checkPaymentLimit(currentTotal);
        }, 1000);
        
        // Xử lý khi chọn phương thức thanh toán
        $('input[name="payment_method"]').on('change', function() {
            const selectedMethod = $(this).val();
            
            if (selectedMethod === 'stripe') {
                initStripeElements();
            } else {
                // Ẩn Stripe elements nếu không chọn Stripe
                $('#stripe-elements').hide();
            }
        });
        
     // Dữ liệu địa danh
    const locationData = {
        'ho-chi-minh': {
            name: 'TP. Hồ Chí Minh',
            districts: {
                'quan-1': { name: 'Quận 1', wards: ['Phường Bến Nghé', 'Phường Bến Thành', 'Phường Cầu Kho', 'Phường Cầu Ông Lãnh'] },
                'quan-3': { name: 'Quận 3', wards: ['Phường 1', 'Phường 2', 'Phường 3', 'Phường 4'] },
                'quan-7': { name: 'Quận 7', wards: ['Phường Tân Thuận Đông', 'Phường Tân Thuận Tây', 'Phường Tân Kiểng', 'Phường Tân Hưng'] },
                'thu-duc': { name: 'TP. Thủ Đức', wards: ['Phường Linh Xuân', 'Phường Linh Trung', 'Phường Linh Chiểu', 'Phường Linh Đông'] }
            }
        },
        'ha-noi': {
            name: 'Hà Nội',
            districts: {
                'hoan-kiem': { name: 'Quận Hoàn Kiếm', wards: ['Phường Chương Dương', 'Phường Cửa Nam', 'Phường Đồng Xuân', 'Phường Hàng Bạc'] },
                'ba-dinh': { name: 'Quận Ba Đình', wards: ['Phường Cống Vị', 'Phường Điện Biên', 'Phường Đội Cấn', 'Phường Giảng Võ'] },
                'cau-giay': { name: 'Quận Cầu Giấy', wards: ['Phường Dịch Vọng', 'Phường Dịch Vọng Hậu', 'Phường Mai Dịch', 'Phường Nghĩa Đô'] }
            }
        },
        'da-nang': {
            name: 'Đà Nẵng',
            districts: {
                'hai-chau': { name: 'Quận Hải Châu', wards: ['Phường Hải Châu I', 'Phường Hải Châu II', 'Phường Phước Ninh', 'Phường Thuận Phước'] },
                'thanh-khe': { name: 'Quận Thanh Khê', wards: ['Phường Thanh Khê Đông', 'Phường Thanh Khê Tây', 'Phường Thạc Gián', 'Phường Tân Chính'] }
            }
        },
        'can-tho': {
            name: 'Cần Thơ',
            districts: {
                'ninh-kieu': { name: 'Quận Ninh Kiều', wards: ['Phường An Hòa', 'Phường An Nghiệp', 'Phường An Cư', 'Phường Tân An'] },
                'binh-thuy': { name: 'Quận Bình Thủy', wards: ['Phường Bình Thủy', 'Phường Trà An', 'Phường Trà Nóc', 'Phường Long Hòa'] }
            }
        },
        'hai-phong': {
            name: 'Hải Phòng',
            districts: {
                'hong-bang': { name: 'Quận Hồng Bàng', wards: ['Phường Quán Toan', 'Phường Hùng Vương', 'Phường Sở Dầu', 'Phường Thượng Lý'] },
                'ngo-quyen': { name: 'Quận Ngô Quyền', wards: ['Phường Máy Chai', 'Phường Máy Tơ', 'Phường Vạn Mỹ', 'Phường Đông Khê'] }
            }
        },
        'bien-hoa': {
            name: 'Biên Hòa',
            districts: {
                'bien-hoa': { name: 'TP. Biên Hòa', wards: ['Phường Tân Tiến', 'Phường Tân Hạnh', 'Phường Quyết Thắng', 'Phường Trảng Dài'] }
            }
        },
        'nha-trang': {
            name: 'Nha Trang',
            districts: {
                'nha-trang': { name: 'TP. Nha Trang', wards: ['Phường Vĩnh Hải', 'Phường Vĩnh Phước', 'Phường Ngọc Hiệp', 'Phường Tân Lập'] }
            }
        },
        'hue': {
            name: 'Huế',
            districts: {
                'hue': { name: 'TP. Huế', wards: ['Phường Phú Hòa', 'Phường Phú Bình', 'Phường Kim Long', 'Phường Vỹ Dạ'] }
            }
        },
        'long-xuyen': {
            name: 'Long Xuyên',
            districts: {
                'long-xuyen': { name: 'TP. Long Xuyên', wards: ['Phường Đông Xuyên', 'Phường Mỹ Bình', 'Phường Mỹ Long', 'Phường Mỹ Phước'] }
            }
        },
        'thai-nguyen': {
            name: 'Thái Nguyên',
            districts: {
                'thai-nguyen': { name: 'TP. Thái Nguyên', wards: ['Phường Hoàng Văn Thụ', 'Phường Trưng Vương', 'Phường Quang Trung', 'Phường Phan Đình Phùng'] }
            }
        },
        'other': {
            name: 'Tỉnh khác',
            districts: {
                'other': { name: 'Quận/Huyện khác', wards: ['Phường/Xã khác'] }
            }
        }
    };

    let currentShippingFee = 0;
     let subtotal = {if isset($subtotal_after_discount)}{$subtotal_after_discount|default:0}{else}{$cart_total|default:0}{/if};
     let originalSubtotal = {$cart_total|default:0};
     let voucherDiscount = {if isset($voucher_discount)}{$voucher_discount|default:0}{else}0{/if};

    // Xử lý chọn tỉnh/thành phố
    $('#province').on('change', function() {
        const provinceValue = $(this).val();
        const districtSelect = $('#district');
        const wardSelect = $('#ward');
        
        // Reset quận/huyện và phường/xã
        districtSelect.html('<option value="">Chọn quận/huyện</option>').prop('disabled', true);
        wardSelect.html('<option value="">Chọn phường/xã</option>').prop('disabled', true);
        
        if (provinceValue && locationData[provinceValue]) {
            // Cập nhật phí vận chuyển
            currentShippingFee = parseInt($(this).find('option:selected').data('fee')) || 0;
            updateShippingFee();
            
            // Thêm các quận/huyện
            const districts = locationData[provinceValue].districts;
            Object.keys(districts).forEach(key => {
                districtSelect.append('<option value="' + key + '">' + districts[key].name + '</option>');
            });
            districtSelect.prop('disabled', false);
        } else {
            currentShippingFee = 0;
            updateShippingFee();
        }
        
        updateFullAddress();
    });

    // Xử lý chọn quận/huyện
    $('#district').on('change', function() {
        const provinceValue = $('#province').val();
        const districtValue = $(this).val();
        const wardSelect = $('#ward');
        
        wardSelect.html('<option value="">Chọn phường/xã</option>').prop('disabled', true);
        
        if (provinceValue && districtValue && locationData[provinceValue] && locationData[provinceValue].districts[districtValue]) {
            const wards = locationData[provinceValue].districts[districtValue].wards;
            wards.forEach(ward => {
                wardSelect.append('<option value="' + ward + '">' + ward + '</option>');
            });
            wardSelect.prop('disabled', false);
        }
        
        updateFullAddress();
    });

    // Xử lý chọn phường/xã
    $('#ward, #street').on('change keyup', function() {
        updateFullAddress();
    });
    


    // Cập nhật phí vận chuyển
     function updateShippingFee() {
         const shippingFeeElement = $('#shipping-fee');
         const totalElement = $('#total-amount');
         
         if (currentShippingFee > 0) {
             shippingFeeElement.html(formatCurrency(currentShippingFee)).removeClass('text-success').addClass('text-warning');
         } else {
             shippingFeeElement.html('Miễn phí').removeClass('text-warning').addClass('text-success');
         }
         
         // Cập nhật tổng cộng
         const newTotal = subtotal + currentShippingFee;
         totalElement.text(formatCurrency(newTotal));
         
         // Kiểm tra giới hạn thanh toán
         checkPaymentLimit(newTotal);
     }
     

     
     // Kiểm tra giới hạn thanh toán
     function checkPaymentLimit(total) {
         const maxAmount = 9999999;
         const submitButton = $('button[type="submit"]');
         const limitWarning = $('#payment-limit-warning');
         
         // Xóa cảnh báo cũ nếu có
         limitWarning.remove();
         
         if (total > maxAmount) {
             // Vô hiệu hóa nút thanh toán
             submitButton.prop('disabled', true).addClass('btn-secondary').removeClass('btn-success');
             
             // Thêm cảnh báo
             const warningHtml = '<div id="payment-limit-warning" class="alert alert-danger mt-3">' +
                 '<i class="fas fa-exclamation-triangle me-2"></i>' +
                 '<strong>Cảnh báo:</strong> Số tiền thanh toán vượt quá giới hạn cho phép (tối đa ' + formatCurrency(maxAmount) + '). ' +
                 'Vui lòng giảm số lượng sản phẩm hoặc liên hệ với chúng tôi để được hỗ trợ.' +
                 '</div>';
             $('.card-body').last().append(warningHtml);
         } else {
             // Kích hoạt lại nút thanh toán
             submitButton.prop('disabled', false).removeClass('btn-secondary').addClass('btn-success');
         }
     }

    // Cập nhật địa chỉ đầy đủ
    function updateFullAddress() {
        const street = $('#street').val();
        const ward = $('#ward option:selected').text();
        const district = $('#district option:selected').text();
        const province = $('#province option:selected').text();
        
        let fullAddress = '';
        if (street) fullAddress += street;
        if (ward && ward !== 'Chọn phường/xã') fullAddress += (fullAddress ? ', ' : '') + ward;
        if (district && district !== 'Chọn quận/huyện') fullAddress += (fullAddress ? ', ' : '') + district;
        if (province && province !== 'Chọn tỉnh/thành phố') fullAddress += (fullAddress ? ', ' : '') + province;
        
        $('#full_address').val(fullAddress);
    }

    // Format tiền tệ
    function formatCurrency(amount) {
        return new Intl.NumberFormat('vi-VN').format(amount) + ' đ';
    }

    // Kiểm tra địa chỉ khi submit (không prevent default ở đây)
    $('#checkoutForm').on('submit', function(e) {
        // Kiểm tra địa chỉ đầy đủ
        if (!$('#full_address').val()) {
            e.preventDefault();
            alert('Vui lòng chọn đầy đủ thông tin địa chỉ!');
            return false;
        }
        
        // Không prevent default ở đây để cho event listener chính xử lý
        return true;
    });
});
}

// Gọi function để khởi tạo script
initCheckoutScript();

// Khởi tạo khi trang load
document.addEventListener('DOMContentLoaded', function() {
    // Thêm event listener cho radio buttons
    document.querySelectorAll('input[name="payment_method"]').forEach(function(radio) {
        radio.addEventListener('change', togglePaymentMethod);
    });
    
    // Khởi tạo trạng thái ban đầu
    togglePaymentMethod();
    
    // Kiểm tra giới hạn thanh toán khi trang được tải
    setTimeout(function() {
        if (typeof subtotal !== 'undefined' && typeof currentShippingFee !== 'undefined') {
            const currentTotal = subtotal + currentShippingFee;
            if (typeof checkPaymentLimit === 'function') {
                checkPaymentLimit(currentTotal);
            }
        }
    }, 1000);
});
</script>

{include file="include/user/footer.tpl"}