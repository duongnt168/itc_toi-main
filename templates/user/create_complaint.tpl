{include file="include/user/header.tpl"}
{include file="include/user/navbar.tpl"}

<div class="container my-5" style="padding-top: 100px;">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card shadow">
                <div class="card-header bg-warning text-dark">
                    <h4 class="mb-0">
                        <i class="fas fa-exclamation-triangle"></i> Tạo khiếu nại
                    </h4>
                </div>
                <div class="card-body">
                    {if isset($smarty.session.error)}
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle"></i> {$smarty.session.error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    {/if}

                    {if isset($order)}
                        <div class="alert alert-info mb-4">
                            <h6><i class="fas fa-info-circle"></i> Thông tin đơn hàng</h6>
                            <p class="mb-1"><strong>Mã đơn hàng:</strong> #{$order.id}</p>
                            <p class="mb-1"><strong>Ngày đặt:</strong> {$order.created_at|date_format:"%d/%m/%Y %H:%M"}</p>
                            <p class="mb-0"><strong>Tổng tiền:</strong> {$order.total_amount|number_format:0:",":"."} VNĐ</p>
                        </div>
                    {/if}

                    <form method="POST" action="/?c=user&v=create_complaint">
                        {if isset($order)}
                            <input type="hidden" name="order_id" value="{$order.id}">
                        {else}
                            <div class="mb-3">
                                <label for="order_id" class="form-label">Mã đơn hàng <span class="text-danger">*</span></label>
                                <input type="number" class="form-control" id="order_id" name="order_id" required 
                                       placeholder="Nhập mã đơn hàng cần khiếu nại">
                                <div class="form-text">Nhập mã đơn hàng mà bạn muốn khiếu nại</div>
                            </div>
                        {/if}

                        <div class="mb-3">
                            <label for="type" class="form-label">Loại khiếu nại <span class="text-danger">*</span></label>
                            <select class="form-select" id="type" name="type" required>
                                <option value="">-- Chọn loại khiếu nại --</option>
                                <option value="product">Vấn đề về sản phẩm</option>
                                <option value="delivery">Vấn đề về giao hàng</option>
                                <option value="service">Vấn đề về dịch vụ</option>
                                <option value="payment">Vấn đề về thanh toán</option>
                                <option value="other">Vấn đề khác</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label for="subject" class="form-label">Tiêu đề khiếu nại <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="subject" name="subject" required 
                                   placeholder="Nhập tiêu đề ngắn gọn cho khiếu nại" maxlength="200">
                            <div class="form-text">Tối đa 200 ký tự</div>
                        </div>

                        <div class="mb-4">
                            <label for="description" class="form-label">Mô tả chi tiết <span class="text-danger">*</span></label>
                            <textarea class="form-control" id="description" name="description" rows="6" required 
                                      placeholder="Mô tả chi tiết vấn đề bạn gặp phải..."></textarea>
                            <div class="form-text">Vui lòng mô tả chi tiết vấn đề để chúng tôi có thể hỗ trợ bạn tốt nhất</div>
                        </div>

                        <div class="alert alert-warning">
                            <h6><i class="fas fa-info-circle"></i> Lưu ý:</h6>
                            <ul class="mb-0">
                                <li>Khiếu nại sẽ được xử lý trong vòng 24-48 giờ làm việc</li>
                                <li>Bạn sẽ nhận được thông báo qua email khi có cập nhật</li>
                                <li>Vui lòng cung cấp thông tin chính xác để được hỗ trợ nhanh chóng</li>
                            </ul>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-warning">
                                <i class="fas fa-paper-plane"></i> Gửi khiếu nại
                            </button>
                            <a href="/?c=user&v=orders" class="btn btn-secondary">
                                <i class="fas fa-times"></i> Hủy bỏ
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
// Tự động điền tiêu đề dựa trên loại khiếu nại
document.getElementById('type').addEventListener('change', function() {
    const subjectInput = document.getElementById('subject');
    const type = this.value;
    
    if (subjectInput.value === '') {
        switch(type) {
            case 'product':
                subjectInput.value = 'Vấn đề về chất lượng sản phẩm';
                break;
            case 'delivery':
                subjectInput.value = 'Vấn đề về giao hàng';
                break;
            case 'service':
                subjectInput.value = 'Vấn đề về dịch vụ khách hàng';
                break;
            case 'payment':
                subjectInput.value = 'Vấn đề về thanh toán';
                break;
            case 'other':
                subjectInput.value = 'Vấn đề khác';
                break;
        }
    }
});
</script>

{include file="include/user/footer.tpl"}