{include file="include/admin/header.tpl"}
{include file="include/admin/sidebar.tpl"}

<div class="main-content">
    <div class="page-content">
        <div class="container-fluid">
            <!-- start page title -->
            <div class="row">
                <div class="col-12">
                    <div class="page-title-box d-sm-flex align-items-center justify-content-between">
                        <h4 class="mb-sm-0">Chi tiết yêu cầu hủy #{$cancellation.id}</h4>
                        <div class="page-title-right">
                            <ol class="breadcrumb m-0">
                                <li class="breadcrumb-item"><a href="/?c=admin&a=dashboard">Dashboard</a></li>
                                <li class="breadcrumb-item"><a href="/?c=admin&a=cancellations">Yêu cầu hủy đơn</a></li>
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
                            <h4 class="card-title mb-0">Thông tin yêu cầu hủy</h4>
                        </div>
                        <div class="card-body">
                            <div class="row mb-4">
                                <div class="col-sm-3">
                                    <dt>Mã yêu cầu:</dt>
                                </div>
                                <div class="col-sm-9">
                                    <dd><strong>#{$cancellation.id}</strong></dd>
                                </div>
                            </div>

                            <div class="row mb-4">
                                <div class="col-sm-3">
                                    <dt>Đơn hàng liên quan:</dt>
                                </div>
                                <div class="col-sm-9">
                                    <dd>
                                        <a href="/?c=admin&a=viewOrder&id={$cancellation.order_id}" 
                                           class="text-decoration-none">
                                            #{$cancellation.order_id}
                                        </a>
                                    </dd>
                                </div>
                            </div>

                            <div class="row mb-4">
                                <div class="col-sm-3">
                                    <dt>Lý do hủy:</dt>
                                </div>
                                <div class="col-sm-9">
                                    <dd>
                                        <div class="bg-light p-3 rounded">
                                            {$cancellation.reason}
                                        </div>
                                    </dd>
                                </div>
                            </div>

                            {if $cancellation.description}
                                <div class="row mb-4">
                                    <div class="col-sm-3">
                                        <dt>Ghi chú thêm:</dt>
                                    </div>
                                    <div class="col-sm-9">
                                        <dd>
                                    <div class="bg-light p-3 rounded">
                                        {$cancellation.description|nl2br}
                                    </div>
                                </dd>
                                    </div>
                                </div>
                            {/if}

                            <div class="row mb-4">
                                <div class="col-sm-3">
                                    <dt>Ngày yêu cầu:</dt>
                                </div>
                                <div class="col-sm-9">
                                    <dd>{$cancellation.created_at|date_format:"%d/%m/%Y %H:%M"}</dd>
                                </div>
                            </div>

                            <div class="row mb-4">
                                <div class="col-sm-3">
                                    <dt>Trạng thái hiện tại:</dt>
                                </div>
                                <div class="col-sm-9">
                                    <dd>
                                        {if $cancellation.status == 'pending'}
                                            <span class="badge bg-warning">Chờ xử lý</span>
                                        {elseif $cancellation.status == 'approved'}
                                            <span class="badge bg-success">Đã duyệt</span>
                                        {elseif $cancellation.status == 'rejected'}
                                            <span class="badge bg-danger">Từ chối</span>
                                        {/if}
                                    </dd>
                                </div>
                            </div>



                            {if $cancellation.admin_response}
                                <div class="row mb-4">
                                    <div class="col-sm-3">
                                        <dt>Phản hồi admin:</dt>
                                    </div>
                                    <div class="col-sm-9">
                                        <dd>
                                            <div class="bg-info bg-opacity-10 p-3 rounded">
                                                {$cancellation.admin_response|nl2br}
                                            </div>
                                        </dd>
                                    </div>
                                </div>
                            {/if}

                            {if $cancellation.updated_at && $cancellation.updated_at != $cancellation.created_at}
                                <div class="row mb-4">
                                    <div class="col-sm-3">
                                        <dt>Cập nhật cuối:</dt>
                                    </div>
                                    <div class="col-sm-9">
                                        <dd>{$cancellation.updated_at|date_format:"%d/%m/%Y %H:%M"}</dd>
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
                            <h4 class="card-title mb-0">Xử lý yêu cầu hủy</h4>
                        </div>
                        <div class="card-body">
                            <form method="POST" action="/?c=admin&a=cancellation_detail&id={$cancellation.id}">
                                <div class="mb-3">
                                    <label for="status" class="form-label">Trạng thái <span class="text-danger">*</span></label>
                                    <select class="form-select" id="status" name="status" required>
                                        <option value="pending" {if $cancellation.status == 'pending'}selected{/if}>Chờ xử lý</option>
                                        <option value="approved" {if $cancellation.status == 'approved'}selected{/if}>Duyệt (Hủy đơn hàng)</option>
                                        <option value="rejected" {if $cancellation.status == 'rejected'}selected{/if}>Từ chối</option>
                                    </select>
                                </div>



                                <div class="mb-3">
                                    <label for="admin_response" class="form-label">Phản hồi admin</label>
                                    <textarea class="form-control" id="admin_response" name="admin_response" 
                                              rows="4" placeholder="Nhập phản hồi cho khách hàng...">{$cancellation.admin_response}</textarea>
                                    <div class="form-text">Phản hồi này sẽ được gửi đến khách hàng qua email.</div>
                                </div>

                                <div class="alert alert-warning" role="alert">
                                    <i class="mdi mdi-alert-circle-outline me-2"></i>
                                    <strong>Lưu ý:</strong> Nếu duyệt yêu cầu hủy, đơn hàng sẽ được chuyển sang trạng thái "Đã hủy" và tiến hành hoàn tiền cho khách hàng.
                                </div>

                                <div class="d-grid gap-2">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="mdi mdi-content-save"></i> Cập nhật
                                    </button>
                                    <a href="/?c=admin&a=cancellations" class="btn btn-secondary">
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
                                        {$cancellation.username|substr:0:1|upper}
                                    </span>
                                </div>
                                <div>
                                    <h6 class="mb-1">{$cancellation.username}</h6>
                                    <p class="text-muted mb-0">{$cancellation.email}</p>
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
                                        <h5 class="mb-1">{$user_stats.total_cancellations|default:0}</h5>
                                        <p class="text-muted mb-0">Yêu cầu hủy</p>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="mt-3">
                                <a href="/?c=admin&a=viewUser&id={$cancellation.user_id}" 
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
                                
                                <div class="row mb-2">
                                    <div class="col-6">
                                        <strong>Phương thức TT:</strong>
                                    </div>
                                    <div class="col-6">
                                        {if $order_info.payment_method == 'cod'}
                                            Thanh toán khi nhận hàng
                                        {elseif $order_info.payment_method == 'bank_transfer'}
                                            Chuyển khoản ngân hàng
                                        {elseif $order_info.payment_method == 'credit_card'}
                                            Thẻ tín dụng
                                        {else}
                                            {$order_info.payment_method}
                                        {/if}
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