{include file="include/user/header.tpl"}
{include file="include/user/navbar.tpl"}

<div class="container my-5" style="padding-top: 100px;">
    <div class="row justify-content-center">
        <div class="col-md-10">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Chi tiết khiếu nại #{$complaint.id}</h2>
                <a href="/?c=user&v=complaints" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left"></i> Quay lại danh sách
                </a>
            </div>

            {if isset($smarty.session.error)}
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle"></i> {$smarty.session.error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            {/if}

            <div class="row">
                <div class="col-md-8">
                    <div class="card shadow-sm">
                        <div class="card-header bg-light">
                            <h5 class="mb-0">
                                <i class="fas fa-exclamation-triangle text-warning"></i> 
                                {$complaint.title|escape}
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="mb-4">
                                <h6 class="text-muted">Mô tả vấn đề:</h6>
                                <div class="border-start border-3 border-warning ps-3">
                                    {$complaint.description|escape|nl2br}
                                </div>
                            </div>

                            {if $complaint.admin_response}
                                <div class="alert alert-info">
                                    <h6><i class="fas fa-reply"></i> Phản hồi từ admin:</h6>
                                    <div class="mt-2">
                                        {$complaint.admin_response|escape|nl2br}
                                    </div>
                                    {if $complaint.processed_at}
                                        <small class="text-muted d-block mt-2">
                                            <i class="fas fa-clock"></i> 
                                            Phản hồi lúc: {$complaint.processed_at|date_format:"%d/%m/%Y %H:%M"}
                                        </small>
                                    {/if}
                                </div>
                            {/if}
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card shadow-sm">
                        <div class="card-header bg-light">
                            <h6 class="mb-0"><i class="fas fa-info-circle"></i> Thông tin khiếu nại</h6>
                        </div>
                        <div class="card-body">
                            <div class="mb-3">
                                <label class="form-label text-muted">Mã khiếu nại:</label>
                                <div class="fw-bold">#{$complaint.id}</div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label text-muted">Đơn hàng liên quan:</label>
                                <div>
                                    <a href="/?c=user&v=order_detail&id={$complaint.order_id}" class="text-decoration-none">
                                        #{$complaint.order_id}
                                    </a>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label text-muted">Loại khiếu nại:</label>
                                <div>
                                    {if $complaint.type == 'product'}
                                        <span class="badge bg-info">Sản phẩm</span>
                                    {elseif $complaint.type == 'delivery'}
                                        <span class="badge bg-warning">Giao hàng</span>
                                    {elseif $complaint.type == 'service'}
                                        <span class="badge bg-primary">Dịch vụ</span>
                                    {elseif $complaint.type == 'payment'}
                                        <span class="badge bg-danger">Thanh toán</span>
                                    {else}
                                        <span class="badge bg-secondary">Khác</span>
                                    {/if}
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label text-muted">Trạng thái:</label>
                                <div>
                                    {if $complaint.status == 'pending'}
                                        <span class="badge bg-warning text-dark">Chờ xử lý</span>
                                    {elseif $complaint.status == 'processing'}
                                        <span class="badge bg-info">Đang xử lý</span>
                                    {elseif $complaint.status == 'resolved'}
                                        <span class="badge bg-success">Đã giải quyết</span>
                                    {elseif $complaint.status == 'closed'}
                                        <span class="badge bg-secondary">Đã đóng</span>
                                    {else}
                                        <span class="badge bg-light text-dark">{$complaint.status}</span>
                                    {/if}
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label text-muted">Ngày tạo:</label>
                                <div>{$complaint.created_at|date_format:"%d/%m/%Y %H:%M"}</div>
                            </div>

                            {if $complaint.updated_at && $complaint.updated_at != $complaint.created_at}
                                <div class="mb-3">
                                    <label class="form-label text-muted">Cập nhật lần cuối:</label>
                                    <div>{$complaint.updated_at|date_format:"%d/%m/%Y %H:%M"}</div>
                                </div>
                            {/if}
                        </div>
                    </div>

                    {if $complaint.order_total}
                        <div class="card shadow-sm mt-3">
                            <div class="card-header bg-light">
                                <h6 class="mb-0"><i class="fas fa-shopping-bag"></i> Thông tin đơn hàng</h6>
                            </div>
                            <div class="card-body">
                                <div class="mb-2">
                                    <label class="form-label text-muted">Tổng tiền:</label>
                                    <div class="fw-bold text-danger">
                                        {$complaint.order_total|number_format:0:",":"."} VNĐ
                                    </div>
                                </div>
                                {if $complaint.order_date}
                                    <div class="mb-2">
                                        <label class="form-label text-muted">Ngày đặt:</label>
                                        <div>{$complaint.order_date|date_format:"%d/%m/%Y %H:%M"}</div>
                                    </div>
                                {/if}
                            </div>
                        </div>
                    {/if}
                </div>
            </div>

            <div class="mt-4">
                <div class="alert alert-light">
                    <h6><i class="fas fa-info-circle"></i> Lưu ý:</h6>
                    <ul class="mb-0">
                        <li>Khiếu nại sẽ được xử lý trong vòng 24-48 giờ làm việc</li>
                        <li>Bạn sẽ nhận được thông báo qua email khi có cập nhật</li>
                        <li>Nếu cần hỗ trợ gấp, vui lòng liên hệ hotline: 1900-xxxx</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

{include file="include/user/footer.tpl"}