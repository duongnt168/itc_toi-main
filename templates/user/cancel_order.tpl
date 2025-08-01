{include file="include/user/header.tpl"}
{include file="include/user/navbar.tpl"}

<div class="container my-5" style="padding-top: 100px;">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card shadow">
                <div class="card-header bg-warning text-dark">
                    <h4 class="mb-0">
                        <i class="fas fa-ban"></i> Yêu cầu hủy đơn hàng
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
                            <div class="row">
                                <div class="col-md-6">
                                    <p class="mb-1"><strong>Mã đơn hàng:</strong> #{$order.id}</p>
                                    <p class="mb-1"><strong>Ngày đặt:</strong> {$order.created_at|date_format:"%d/%m/%Y %H:%M"}</p>
                                    <p class="mb-0"><strong>Trạng thái:</strong> 
                                        {if $order.status == 'pending'}
                                            <span class="badge bg-warning text-dark">Chờ xử lý</span>
                                        {elseif $order.status == 'processing'}
                                            <span class="badge bg-info">Đang xử lý</span>
                                        {elseif $order.status == 'shipped'}
                                            <span class="badge bg-primary">Đã giao</span>
                                        {elseif $order.status == 'completed'}
                                            <span class="badge bg-success">Hoàn thành</span>
                                        {elseif $order.status == 'cancelled'}
                                            <span class="badge bg-danger">Đã hủy</span>
                                        {/if}
                                    </p>
                                </div>
                                <div class="col-md-6">
                                    <p class="mb-1"><strong>Tổng tiền:</strong> {if isset($order.total_amount)}{$order.total_amount|number_format:0:",":"."}{else}0{/if} VNĐ</p>
                                    <p class="mb-0"><strong>Phương thức thanh toán:</strong> cod</p>
                                </div>
                            </div>
                        </div>

                        {if $order.status != 'pending'}
                            <div class="alert alert-warning">
                                <i class="fas fa-exclamation-triangle"></i> 
                                <strong>Lưu ý:</strong> Đơn hàng này đã được xử lý và có thể không thể hủy. 
                                Vui lòng liên hệ với chúng tôi để được hỗ trợ.
                            </div>
                        {/if}
                    {/if}

                    <form method="POST" action="/?c=user&v=cancel_order" id="cancelForm">
                        {if isset($order)}
                            <input type="hidden" name="order_id" value="{$order.id}">
                        {else}
                            <div class="mb-3">
                                <label for="order_id" class="form-label">Mã đơn hàng <span class="text-danger">*</span></label>
                                <input type="number" class="form-control" id="order_id" name="order_id" required 
                                       placeholder="Nhập mã đơn hàng cần hủy">
                                <div class="form-text">Chỉ có thể hủy đơn hàng đang ở trạng thái "Chờ xử lý"</div>
                            </div>
                        {/if}

                        <div class="mb-4">
                            <label for="reason" class="form-label">Lý do hủy đơn hàng <span class="text-danger">*</span></label>
                            <select class="form-select" id="reason" name="reason" required onchange="toggleCustomReason()">
                                <option value="">-- Chọn lý do hủy --</option>
                                <option value="Thay đổi ý định mua hàng">Thay đổi ý định mua hàng</option>
                                <option value="Tìm được sản phẩm tốt hơn">Tìm được sản phẩm tốt hơn</option>
                                <option value="Không còn nhu cầu sử dụng">Không còn nhu cầu sử dụng</option>
                                <option value="Thời gian giao hàng quá lâu">Thời gian giao hàng quá lâu</option>
                                <option value="Phí vận chuyển quá cao">Phí vận chuyển quá cao</option>
                                <option value="Đặt nhầm sản phẩm">Đặt nhầm sản phẩm</option>
                                <option value="Đặt trùng đơn hàng">Đặt trùng đơn hàng</option>
                                <option value="Vấn đề về thanh toán">Vấn đề về thanh toán</option>
                                <option value="Khác">Lý do khác</option>
                            </select>
                        </div>

                        <div class="mb-4" id="customReasonDiv" style="display: none;">
                            <label for="custom_reason" class="form-label">Lý do cụ thể</label>
                            <textarea class="form-control" id="custom_reason" name="custom_reason" rows="3" 
                                      placeholder="Vui lòng mô tả chi tiết lý do hủy đơn hàng..."></textarea>
                        </div>

                        <div class="mb-4">
                            <label for="additional_notes" class="form-label">Ghi chú thêm (tùy chọn)</label>
                            <textarea class="form-control" id="additional_notes" name="additional_notes" rows="3" 
                                      placeholder="Thêm ghi chú nếu cần..."></textarea>
                        </div>

                        <div class="alert alert-warning">
                            <h6><i class="fas fa-info-circle"></i> Chính sách hủy đơn hàng:</h6>
                            <ul class="mb-0">
                                <li>Đơn hàng chỉ có thể hủy khi đang ở trạng thái "Chờ xử lý"</li>
                                <li>Đơn hàng đã thanh toán sẽ được hoàn tiền trong 3-7 ngày làm việc</li>
                                <li>Đơn hàng đã được xử lý có thể không thể hủy</li>
                                <li>Liên hệ hotline: 1900-xxxx để được hỗ trợ nhanh chóng</li>
                            </ul>
                        </div>

                        <div class="form-check mb-4">
                            <input class="form-check-input" type="checkbox" id="confirmCancel" required>
                            <label class="form-check-label" for="confirmCancel">
                                Tôi xác nhận muốn hủy đơn hàng này và đã đọc hiểu chính sách hủy đơn hàng
                            </label>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-warning">
                                <i class="fas fa-ban"></i> Gửi yêu cầu hủy
                            </button>
                            <a href="{if isset($order)}/?c=user&v=order_detail&id={$order.id}{else}/?c=user&v=orders{/if}" 
                               class="btn btn-secondary">
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
function toggleCustomReason() {
    const reasonSelect = document.getElementById('reason');
    const customReasonDiv = document.getElementById('customReasonDiv');
    const customReasonTextarea = document.getElementById('custom_reason');
    
    if (reasonSelect.value === 'Khác') {
        customReasonDiv.style.display = 'block';
        customReasonTextarea.required = true;
    } else {
        customReasonDiv.style.display = 'none';
        customReasonTextarea.required = false;
        customReasonTextarea.value = '';
    }
}

// Xác nhận trước khi gửi
document.getElementById('cancelForm').addEventListener('submit', function(e) {
    const confirmed = confirm('Bạn có chắc chắn muốn gửi yêu cầu hủy đơn hàng này không?');
    if (!confirmed) {
        e.preventDefault();
    }
});
</script>

{include file="include/user/footer.tpl"}