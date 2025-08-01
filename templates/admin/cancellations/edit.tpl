{extends file="admin/layout.tpl"}

{block name="title"}Chỉnh sửa yêu cầu hủy đơn hàng{/block}

{block name="content"}
<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">Chỉnh sửa yêu cầu hủy đơn hàng #{$cancellation.id}</h3>
                    <div class="card-tools">
                        <a href="/?c=admin&a=cancellations" class="btn btn-secondary btn-sm">
                            <i class="fas fa-arrow-left"></i> Quay lại
                        </a>
                    </div>
                </div>
                
                <form method="POST" action="/?c=admin&a=edit_cancellation&id={$cancellation.id}">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label>Mã đơn hàng</label>
                                    <input type="text" class="form-control" value="#{$cancellation.order_id}" readonly>
                                </div>
                                
                                <div class="form-group">
                                    <label>Khách hàng</label>
                                    <input type="text" class="form-control" value="{$cancellation.username} ({$cancellation.email})" readonly>
                                </div>
                                
                                <div class="form-group">
                                    <label>Lý do hủy</label>
                                    <select name="reason" class="form-control" required>
                                        <option value="changed_mind" {if $cancellation.reason == 'changed_mind'}selected{/if}>Đổi ý</option>
                                        <option value="found_better_price" {if $cancellation.reason == 'found_better_price'}selected{/if}>Tìm được giá tốt hơn</option>
                                        <option value="delivery_too_slow" {if $cancellation.reason == 'delivery_too_slow'}selected{/if}>Giao hàng quá chậm</option>
                                        <option value="product_not_needed" {if $cancellation.reason == 'product_not_needed'}selected{/if}>Không cần sản phẩm nữa</option>
                                        <option value="other" {if $cancellation.reason == 'other'}selected{/if}>Khác</option>
                                    </select>
                                </div>
                                
                                <div class="form-group">
                                    <label>Trạng thái</label>
                                    <select name="status" class="form-control" required>
                                        <option value="pending" {if $cancellation.status == 'pending'}selected{/if}>Chờ xử lý</option>
                                        <option value="approved" {if $cancellation.status == 'approved'}selected{/if}>Đã duyệt</option>
                                        <option value="rejected" {if $cancellation.status == 'rejected'}selected{/if}>Từ chối</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label>Mô tả chi tiết</label>
                                    <textarea name="description" class="form-control" rows="4" required>{$cancellation.description}</textarea>
                                </div>
                                
                                <div class="form-group">
                                    <label>Phản hồi của admin</label>
                                    <textarea name="admin_response" class="form-control" rows="4" placeholder="Nhập phản hồi...">{$cancellation.admin_response}</textarea>
                                </div>
                                
                                <div class="form-group">
                                    <label>Ngày tạo</label>
                                    <input type="text" class="form-control" value="{$cancellation.created_at}" readonly>
                                </div>
                                
                                {if $cancellation.processed_at}
                                <div class="form-group">
                                    <label>Ngày xử lý</label>
                                    <input type="text" class="form-control" value="{$cancellation.processed_at}" readonly>
                                </div>
                                {/if}
                            </div>
                        </div>
                    </div>
                    
                    <div class="card-footer">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Lưu thay đổi
                        </button>
                        <a href="/?c=admin&a=cancellations" class="btn btn-secondary">
                            <i class="fas fa-times"></i> Hủy
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
{/block}