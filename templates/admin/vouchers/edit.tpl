<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa Voucher - Admin Panel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="/public/admin/style.css" rel="stylesheet">
</head>
<body>
    {include file="include/admin/header.tpl"}
    
    <div class="container-fluid">
        <div class="row">
            {include file="include/admin/sidebar.tpl"}
            
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2"><i class="fas fa-edit me-2"></i>Chỉnh sửa Voucher</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="/?c=admin&a=vouchers" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left me-1"></i>Quay lại
                        </a>
                    </div>
                </div>

                {if isset($smarty.session.success)}
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>{$smarty.session.success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                {/if}

                {if isset($smarty.session.error)}
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>{$smarty.session.error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                {/if}

                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">Thông tin Voucher</h5>
                    </div>
                    <div class="card-body">
                        <form method="POST" id="voucherForm">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="code" class="form-label">Mã Voucher <span class="text-danger">*</span></label>
                                        <div class="input-group">
                                            <input type="text" class="form-control" id="code" name="code" required 
                                                   placeholder="Nhập mã voucher" value="{$voucher.code}">
                                            <button type="button" class="btn btn-outline-secondary" onclick="generateCode()">
                                                <i class="fas fa-random"></i> Tạo mã
                                            </button>
                                        </div>
                                        <div class="form-text">Mã voucher phải là duy nhất</div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="type" class="form-label">Loại giảm giá <span class="text-danger">*</span></label>
                                        <select class="form-select" id="type" name="type" required onchange="updateValueLabel()">
                                            <option value="">Chọn loại giảm giá</option>
                                            <option value="percentage" {if $voucher.type == 'percentage'}selected{/if}>Phần trăm (%)</option>
                                            <option value="fixed" {if $voucher.type == 'fixed'}selected{/if}>Số tiền cố định (VNĐ)</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="value" class="form-label" id="valueLabel">Giá trị <span class="text-danger">*</span></label>
                                        <input type="number" class="form-control" id="value" name="value" required 
                                               min="0" step="0.01" placeholder="Nhập giá trị" value="{$voucher.value}">
                                        <div class="form-text" id="valueHelp">Nhập giá trị giảm giá</div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="min_order_amount" class="form-label">Giá trị đơn hàng tối thiểu</label>
                                        <input type="number" class="form-control" id="min_order_amount" name="min_order_amount" 
                                               min="0" step="0.01" placeholder="0" value="{$voucher.min_order_amount}">
                                        <div class="form-text">Để trống hoặc 0 nếu không giới hạn</div>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="max_uses" class="form-label">Số lần sử dụng tối đa</label>
                                        <input type="number" class="form-control" id="max_uses" name="max_uses" 
                                               min="1" placeholder="Không giới hạn" value="{$voucher.max_uses}">
                                        <div class="form-text">Để trống nếu không giới hạn số lần sử dụng</div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="status" class="form-label">Trạng thái</label>
                                        <select class="form-select" id="status" name="status">
                                            <option value="active" {if $voucher.status == 'active'}selected{/if}>Hoạt động</option>
                                            <option value="inactive" {if $voucher.status == 'inactive'}selected{/if}>Không hoạt động</option>
                                            <option value="expired" {if $voucher.status == 'expired'}selected{/if}>Hết hạn</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="start_date" class="form-label">Ngày bắt đầu</label>
                                        <input type="datetime-local" class="form-control" id="start_date" name="start_date" 
                                               value="{if $voucher.start_date}{$voucher.start_date|date_format:'%Y-%m-%dT%H:%M'}{/if}">
                                        <div class="form-text">Để trống nếu có hiệu lực ngay</div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="end_date" class="form-label">Ngày kết thúc</label>
                                        <input type="datetime-local" class="form-control" id="end_date" name="end_date" 
                                               value="{if $voucher.end_date}{$voucher.end_date|date_format:'%Y-%m-%dT%H:%M'}{/if}">
                                        <div class="form-text">Để trống nếu không có ngày hết hạn</div>
                                    </div>
                                </div>
                            </div>

                            <!-- Thống kê sử dụng -->
                            <div class="row">
                                <div class="col-12">
                                    <div class="card bg-light mb-3">
                                        <div class="card-header">
                                            <h6 class="card-title mb-0"><i class="fas fa-chart-bar me-2"></i>Thống kê sử dụng</h6>
                                        </div>
                                        <div class="card-body">
                                            <div class="row">
                                                <div class="col-md-3">
                                                    <div class="text-center">
                                                        <h5 class="text-primary">{$voucher.used_count}</h5>
                                                        <small class="text-muted">Đã sử dụng</small>
                                                    </div>
                                                </div>
                                                <div class="col-md-3">
                                                    <div class="text-center">
                                                        <h5 class="text-info">
                                                            {if $voucher.max_uses}
                                                                {$voucher.max_uses - $voucher.used_count}
                                                            {else}
                                                                ∞
                                                            {/if}
                                                        </h5>
                                                        <small class="text-muted">Còn lại</small>
                                                    </div>
                                                </div>
                                                <div class="col-md-3">
                                                    <div class="text-center">
                                                        <h5 class="text-success">{$voucher.created_at|date_format:"%d/%m/%Y"}</h5>
                                                        <small class="text-muted">Ngày tạo</small>
                                                    </div>
                                                </div>
                                                <div class="col-md-3">
                                                    <div class="text-center">
                                                        <h5 class="text-warning">{$voucher.updated_at|date_format:"%d/%m/%Y"}</h5>
                                                        <small class="text-muted">Cập nhật cuối</small>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-12">
                                    <div class="d-flex justify-content-end gap-2">
                                        <a href="/?c=admin&a=vouchers" class="btn btn-secondary">
                                            <i class="fas fa-times me-1"></i>Hủy
                                        </a>
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save me-1"></i>Cập nhật Voucher
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function updateValueLabel() {
            const type = document.getElementById('type').value;
            const valueLabel = document.getElementById('valueLabel');
            const valueHelp = document.getElementById('valueHelp');
            const valueInput = document.getElementById('value');
            
            if (type === 'percentage') {
                valueLabel.innerHTML = 'Phần trăm giảm (%) <span class="text-danger">*</span>';
                valueHelp.textContent = 'Nhập phần trăm giảm (0-100)';
                valueInput.setAttribute('max', '100');
                valueInput.setAttribute('placeholder', 'Ví dụ: 10 (giảm 10%)');
            } else if (type === 'fixed') {
                valueLabel.innerHTML = 'Số tiền giảm (VNĐ) <span class="text-danger">*</span>';
                valueHelp.textContent = 'Nhập số tiền giảm cố định';
                valueInput.removeAttribute('max');
                valueInput.setAttribute('placeholder', 'Ví dụ: 50000 (giảm 50,000 VNĐ)');
            } else {
                valueLabel.innerHTML = 'Giá trị <span class="text-danger">*</span>';
                valueHelp.textContent = 'Nhập giá trị giảm giá';
                valueInput.removeAttribute('max');
                valueInput.setAttribute('placeholder', 'Nhập giá trị');
            }
        }
        
        function generateCode() {
            const prefixes = ['SAVE', 'DISCOUNT', 'VOUCHER', 'PROMO', 'DEAL'];
            const prefix = prefixes[Math.floor(Math.random() * prefixes.length)];
            const randomNum = Math.floor(Math.random() * 9000) + 1000;
            const code = prefix + randomNum;
            
            document.getElementById('code').value = code;
        }
        
        // Validate form
        document.getElementById('voucherForm').addEventListener('submit', function(e) {
            const type = document.getElementById('type').value;
            const value = parseFloat(document.getElementById('value').value);
            
            if (type === 'percentage' && (value < 0 || value > 100)) {
                e.preventDefault();
                alert('Phần trăm giảm phải từ 0 đến 100');
                return;
            }
            
            if (type === 'fixed' && value < 0) {
                e.preventDefault();
                alert('Số tiền giảm phải lớn hơn 0');
                return;
            }
            
            const startDate = document.getElementById('start_date').value;
            const endDate = document.getElementById('end_date').value;
            
            if (startDate && endDate && new Date(startDate) >= new Date(endDate)) {
                e.preventDefault();
                alert('Ngày kết thúc phải sau ngày bắt đầu');
                return;
            }
        });
        
        // Initialize
        updateValueLabel();
    </script>
</body>
</html>