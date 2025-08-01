{include file="include/admin/header.tpl"}
{include file="include/admin/sidebar.tpl"}

<div class="main-content">
    <div class="page-content">
        <div class="container-fluid">
            <!-- start page title -->
            <div class="row">
                <div class="col-12">
                    <div class="page-title-box d-sm-flex align-items-center justify-content-between">
                        <h4 class="mb-sm-0">Chi tiết đánh giá đơn hàng #{$review.id}</h4>
                        <div class="page-title-right">
                            <ol class="breadcrumb m-0">
                                <li class="breadcrumb-item"><a href="/?c=admin&a=dashboard">Dashboard</a></li>
                                <li class="breadcrumb-item"><a href="/?c=admin&a=order_reviews">Đánh giá đơn hàng</a></li>
                                <li class="breadcrumb-item active">Chi tiết</li>
                            </ol>
                        </div>
                    </div>
                </div>
            </div>
            <!-- end page title -->

            {if isset($smarty.session.success)}
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="mdi mdi-check-all me-2"></i>
                    {$smarty.session.success}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            {/if}

            {if isset($smarty.session.error)}
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="mdi mdi-block-helper me-2"></i>
                    {$smarty.session.error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            {/if}

            <div class="row">
                <div class="col-lg-8">
                    <div class="card">
                        <div class="card-header">
                            <h4 class="card-title mb-0">Thông tin đánh giá</h4>
                        </div>
                        <div class="card-body">
                            <div class="row mb-4">
                                <div class="col-sm-3">
                                    <dt>Mã đánh giá:</dt>
                                </div>
                                <div class="col-sm-9">
                                    <dd><strong>#{$review.id}</strong></dd>
                                </div>
                            </div>

                            <div class="row mb-4">
                                <div class="col-sm-3">
                                    <dt>Đơn hàng liên quan:</dt>
                                </div>
                                <div class="col-sm-9">
                                    <dd>
                                        <a href="/?c=admin&a=viewOrder&id={$review.order_id}" 
                                           class="text-decoration-none">
                                            #{$review.order_id}
                                        </a>
                                    </dd>
                                </div>
                            </div>

                            <div class="row mb-4">
                                <div class="col-sm-3">
                                    <dt>Đánh giá tổng thể:</dt>
                                </div>
                                <div class="col-sm-9">
                                    <dd>
                                        <span class="text-warning me-2">
                                            {for $i=1 to 5}
                                                {if $i <= $review.rating}
                                                    <i class="mdi mdi-star"></i>
                                                {else}
                                                    <i class="mdi mdi-star-outline"></i>
                                                {/if}
                                            {/for}
                                        </span>
                                        <span class="fw-bold">({$review.rating}/5 sao)</span>
                                    </dd>
                                </div>
                            </div>

                            <div class="row mb-4">
                                <div class="col-sm-3">
                                    <dt>Đánh giá giao hàng:</dt>
                                </div>
                                <div class="col-sm-9">
                                    <dd>
                                        <span class="text-warning me-2">
                                            {for $i=1 to 5}
                                                {if $i <= $review.delivery_rating}
                                                    <i class="mdi mdi-star"></i>
                                                {else}
                                                    <i class="mdi mdi-star-outline"></i>
                                                {/if}
                                            {/for}
                                        </span>
                                        <span class="fw-bold">({$review.delivery_rating}/5 sao)</span>
                                    </dd>
                                </div>
                            </div>

                            <div class="row mb-4">
                                <div class="col-sm-3">
                                    <dt>Đánh giá dịch vụ:</dt>
                                </div>
                                <div class="col-sm-9">
                                    <dd>
                                        <span class="text-warning me-2">
                                            {for $i=1 to 5}
                                                {if $i <= $review.service_rating}
                                                    <i class="mdi mdi-star"></i>
                                                {else}
                                                    <i class="mdi mdi-star-outline"></i>
                                                {/if}
                                            {/for}
                                        </span>
                                        <span class="fw-bold">({$review.service_rating}/5 sao)</span>
                                    </dd>
                                </div>
                            </div>

                            <div class="row mb-4">
                                <div class="col-sm-3">
                                    <dt>Nhận xét:</dt>
                                </div>
                                <div class="col-sm-9">
                                    <dd>
                                        {if $review.comment}
                                            <div class="bg-light p-3 rounded">
                                                {$review.comment|nl2br}
                                            </div>
                                        {else}
                                            <span class="text-muted">Không có nhận xét</span>
                                        {/if}
                                    </dd>
                                </div>
                            </div>

                            <div class="row mb-4">
                                <div class="col-sm-3">
                                    <dt>Ngày tạo:</dt>
                                </div>
                                <div class="col-sm-9">
                                    <dd>{$review.created_at|date_format:"%d/%m/%Y %H:%M"}</dd>
                                </div>
                            </div>

                            <div class="row mb-4">
                                <div class="col-sm-3">
                                    <dt>Trạng thái hiện tại:</dt>
                                </div>
                                <div class="col-sm-9">
                                    <dd>
                                        {if $review.status == 'pending'}
                                            <span class="badge bg-warning">Chờ duyệt</span>
                                        {elseif $review.status == 'approved'}
                                            <span class="badge bg-success">Đã duyệt</span>
                                        {elseif $review.status == 'rejected'}
                                            <span class="badge bg-danger">Từ chối</span>
                                        {/if}
                                    </dd>
                                </div>
                            </div>

                            {if $review.admin_notes}
                                <div class="row mb-4">
                                    <div class="col-sm-3">
                                        <dt>Ghi chú admin:</dt>
                                    </div>
                                    <div class="col-sm-9">
                                        <dd>
                                            <div class="bg-info bg-opacity-10 p-3 rounded">
                                                {$review.admin_notes|nl2br}
                                            </div>
                                        </dd>
                                    </div>
                                </div>
                            {/if}

                            {if $review.updated_at && $review.updated_at != $review.created_at}
                                <div class="row mb-4">
                                    <div class="col-sm-3">
                                        <dt>Cập nhật cuối:</dt>
                                    </div>
                                    <div class="col-sm-9">
                                        <dd>{$review.updated_at|date_format:"%d/%m/%Y %H:%M"}</dd>
                                    </div>
                                </div>
                            {/if}
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <!-- Form cập nhật trạng thái -->
                    <div class="card">
                        <div class="card-header">
                            <h4 class="card-title mb-0">Cập nhật đánh giá</h4>
                        </div>
                        <div class="card-body">
                            <form method="POST" action="/?c=admin&a=order_review_detail&id={$review.id}">
                                <div class="mb-3">
                                    <label for="status" class="form-label">Trạng thái <span class="text-danger">*</span></label>
                                    <select class="form-select" id="status" name="status" required>
                                        <option value="pending" {if $review.status == 'pending'}selected{/if}>Chờ duyệt</option>
                                        <option value="approved" {if $review.status == 'approved'}selected{/if}>Duyệt</option>
                                        <option value="rejected" {if $review.status == 'rejected'}selected{/if}>Từ chối</option>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label for="admin_notes" class="form-label">Ghi chú admin</label>
                                    <textarea class="form-control" id="admin_notes" name="admin_notes" 
                                              rows="4" placeholder="Nhập ghi chú về quyết định của bạn...">{$review.admin_notes}</textarea>
                                    <div class="form-text">Ghi chú này sẽ được gửi đến khách hàng qua email.</div>
                                </div>

                                <div class="d-grid gap-2">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="mdi mdi-content-save"></i> Cập nhật
                                    </button>
                                    <a href="/?c=admin&a=order_reviews" class="btn btn-secondary">
                                        <i class="mdi mdi-arrow-left"></i> Quay lại
                                    </a>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Thông tin khách hàng -->
                    <div class="card">
                        <div class="card-header">
                            <h4 class="card-title mb-0">Thông tin khách hàng</h4>
                        </div>
                        <div class="card-body">
                            <div class="d-flex align-items-center mb-3">
                                <div class="avatar-md me-3">
                                    <span class="avatar-title rounded-circle bg-primary text-white font-size-20">
                                        {$review.username|substr:0:1|upper}
                                    </span>
                                </div>
                                <div>
                                    <h6 class="mb-1">{$review.username}</h6>
                                    <p class="text-muted mb-0">{$review.email}</p>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-6">
                                    <div class="text-center">
                                        <h5 class="mb-1">{$user_stats.total_orders|default:0}</h5>
                                        <p class="text-muted mb-0">Tổng đơn hàng</p>
                                    </div>
                                </div>
                                <div class="col-6">
                                    <div class="text-center">
                                        <h5 class="mb-1">{$user_stats.total_reviews|default:0}</h5>
                                        <p class="text-muted mb-0">Tổng đánh giá</p>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="mt-3">
                                <a href="/?c=admin&a=viewUser&id={$review.user_id}" 
                                   class="btn btn-outline-primary btn-sm w-100">
                                    <i class="mdi mdi-account-details"></i> Xem chi tiết khách hàng
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Thông tin đơn hàng -->
                    {if isset($order_info)}
                        <div class="card">
                            <div class="card-header">
                                <h4 class="card-title mb-0">Thông tin đơn hàng</h4>
                            </div>
                            <div class="card-body">
                                <div class="row mb-2">
                                    <div class="col-6">
                                        <strong>Mã đơn hàng:</strong>
                                    </div>
                                    <div class="col-6">
                                        #{$order_info.id}
                                    </div>
                                </div>
                                
                                <div class="row mb-2">
                                    <div class="col-6">
                                        <strong>Tổng tiền:</strong>
                                    </div>
                                    <div class="col-6">
                                        <span class="text-success fw-bold">
                                            {$order_info.total_amount|number_format:0:",":"."} VNĐ
                                        </span>
                                    </div>
                                </div>
                                
                                <div class="row mb-2">
                                    <div class="col-6">
                                        <strong>Ngày đặt:</strong>
                                    </div>
                                    <div class="col-6">
                                        {$order_info.created_at|date_format:"%d/%m/%Y"}
                                    </div>
                                </div>
                                
                                <div class="row mb-3">
                                    <div class="col-6">
                                        <strong>Trạng thái:</strong>
                                    </div>
                                    <div class="col-6">
                                        {if $order_info.status == 'pending'}
                                            <span class="badge bg-warning">Chờ xử lý</span>
                                        {elseif $order_info.status == 'confirmed'}
                                            <span class="badge bg-info">Đã xác nhận</span>
                                        {elseif $order_info.status == 'shipping'}
                                            <span class="badge bg-primary">Đang giao</span>
                                        {elseif $order_info.status == 'delivered'}
                                            <span class="badge bg-success">Đã giao</span>
                                        {elseif $order_info.status == 'cancelled'}
                                            <span class="badge bg-danger">Đã hủy</span>
                                        {/if}
                                    </div>
                                </div>
                                
                                <div class="mt-3">
                                    <a href="/?c=admin&a=viewOrder&id={$order_info.id}" 
                                       class="btn btn-outline-success btn-sm w-100">
                                        <i class="mdi mdi-package-variant"></i> Xem chi tiết đơn hàng
                                    </a>
                                </div>
                            </div>
                        </div>
                    {/if}
                </div>
            </div>
        </div>
    </div>
</div>

{include file="include/admin/footer.tpl"}