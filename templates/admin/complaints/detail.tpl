{include file="include/admin/header.tpl"}
{include file="include/admin/sidebar.tpl"}

<div class="main-content">
    <div class="page-content">
        <div class="container-fluid">
            <!-- start page title -->
            <div class="row">
                <div class="col-12">
                    <div class="page-title-box d-sm-flex align-items-center justify-content-between">
                        <h4 class="mb-sm-0">Chi tiết khiếu nại #{$complaint.id}</h4>
                        <div class="page-title-right">
                            <ol class="breadcrumb m-0">
                                <li class="breadcrumb-item"><a href="/?c=admin&a=dashboard">Dashboard</a></li>
                                <li class="breadcrumb-item"><a href="/?c=admin&a=complaints">Khiếu nại</a></li>
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
                            <div class="d-flex align-items-center">
                                <div class="flex-shrink-0 me-3">
                                    <div class="avatar-sm">
                                        <div class="avatar-title rounded-circle bg-primary text-white font-size-16">
                                            <i class="mdi mdi-comment-alert"></i>
                                        </div>
                                    </div>
                                </div>
                                <div class="flex-grow-1">
                                    <h5 class="card-title mb-1">{$complaint.title}</h5>
                                    <p class="text-muted mb-0">
                                        Khiếu nại #{$complaint.id} • 
                                        <span class="badge bg-info">{$complaint.complaint_type|default:'Chưa phân loại'}</span> • 
                                        {if isset($complaint.priority) && $complaint.priority == 'high'}
                                            <span class="badge bg-danger">Ưu tiên cao</span>
                                        {elseif isset($complaint.priority) && $complaint.priority == 'medium'}
                                            <span class="badge bg-warning">Ưu tiên trung bình</span>
                                        {else}
                                            <span class="badge bg-success">Ưu tiên thấp</span>
                                        {/if}
                                    </p>
                                </div>
                                <div class="flex-shrink-0">
                                    {if $complaint.status == 'pending'}
                                        <span class="badge bg-warning font-size-12">Chờ xử lý</span>
                                    {elseif $complaint.status == 'in_progress'}
                                        <span class="badge bg-info font-size-12">Đang xử lý</span>
                                    {elseif $complaint.status == 'resolved'}
                                        <span class="badge bg-success font-size-12">Đã giải quyết</span>
                                    {elseif $complaint.status == 'closed'}
                                        <span class="badge bg-secondary font-size-12">Đã đóng</span>
                                    {/if}
                                </div>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="mb-4">
                                <h6 class="mb-2">Mô tả vấn đề:</h6>
                                <div class="bg-light p-3 rounded">
                                    {$complaint.description|nl2br}
                                </div>
                            </div>

                            {if $complaint.admin_response}
                                <div class="mb-4">
                                    <h6 class="mb-2">Phản hồi từ Admin:</h6>
                                    <div class="bg-success bg-soft p-3 rounded">
                                        {$complaint.admin_response|nl2br}
                                        <hr class="my-2">
                                        <small class="text-muted">
                                            Phản hồi bởi: <strong>{$complaint.admin_name}</strong> • 
                                            {$complaint.updated_at|date_format:"%d/%m/%Y %H:%M"}
                                        </small>
                                    </div>
                                </div>
                            {/if}

                            <!-- Form phản hồi -->
                            <div class="border-top pt-4">
                                <h6 class="mb-3">Cập nhật khiếu nại</h6>
                                <form method="POST" action="/?c=admin&a=complaint_detail&id={$complaint.id}">
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="status" class="form-label">Trạng thái</label>
                                            <select class="form-select" id="status" name="status" required>
                                                <option value="pending" {if $complaint.status == 'pending'}selected{/if}>Chờ xử lý</option>
                                                <option value="in_progress" {if $complaint.status == 'in_progress'}selected{/if}>Đang xử lý</option>
                                                <option value="resolved" {if $complaint.status == 'resolved'}selected{/if}>Đã giải quyết</option>
                                                <option value="closed" {if $complaint.status == 'closed'}selected{/if}>Đã đóng</option>
                                            </select>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="priority" class="form-label">Ưu tiên</label>
                                            <select class="form-select" id="priority" name="priority">
                                                <option value="low" {if isset($complaint.priority) && $complaint.priority == 'low'}selected{/if}>Thấp</option>
                                                <option value="medium" {if isset($complaint.priority) && $complaint.priority == 'medium'}selected{/if}>Trung bình</option>
                                                <option value="high" {if isset($complaint.priority) && $complaint.priority == 'high'}selected{/if}>Cao</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label for="admin_response" class="form-label">Phản hồi của bạn</label>
                                        <textarea class="form-control" id="admin_response" name="admin_response" rows="4" 
                                                  placeholder="Nhập phản hồi cho khách hàng..." required>{$complaint.admin_response}</textarea>
                                    </div>
                                    <div class="d-flex gap-2">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="mdi mdi-content-save"></i> Cập nhật
                                        </button>
                                        <a href="/?c=admin&a=complaints" class="btn btn-secondary">
                                            <i class="mdi mdi-arrow-left"></i> Quay lại
                                        </a>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <!-- Thông tin khách hàng -->
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">
                                <i class="mdi mdi-account"></i> Thông tin khách hàng
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="d-flex align-items-center mb-3">
                                <div class="avatar-sm me-3">
                                    <span class="avatar-title rounded-circle bg-primary text-white font-size-16">
                                        {$complaint.username|substr:0:1|upper}
                                    </span>
                                </div>
                                <div>
                                    <h6 class="mb-1">{$complaint.username|default:'Khách hàng'}</h6>
                                    <p class="text-muted mb-0">{$complaint.user_email|default:'Chưa cập nhật'}</p>
                                </div>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-borderless table-sm mb-0">
                                    <tbody>
                                        <tr>
                                            <td class="ps-0">Điện thoại:</td>
                                            <td class="text-end">{$complaint.user_phone|default:'Chưa cập nhật'}</td>
                                        </tr>
                                        <tr>
                                            <td class="ps-0">Ngày tham gia:</td>
                                            <td class="text-end">{$complaint.user_created_at|date_format:"%d/%m/%Y"}</td>
                                        </tr>
                                        <tr>
                                            <td class="ps-0">Tổng đơn hàng:</td>
                                            <td class="text-end">{$complaint.user_total_orders|default:0}</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="mt-3">
                                <a href="/?c=admin&a=viewUser&id={$complaint.user_id}" class="btn btn-sm btn-outline-primary w-100">
                                    <i class="mdi mdi-eye"></i> Xem hồ sơ khách hàng
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Thông tin đơn hàng -->
                    {if $complaint.order_id}
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">
                                    <i class="mdi mdi-package-variant"></i> Thông tin đơn hàng
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-borderless table-sm mb-0">
                                        <tbody>
                                            <tr>
                                                <td class="ps-0">Mã đơn hàng:</td>
                                                <td class="text-end">
                                                    <a href="/?c=admin&a=viewOrder&id={$complaint.order_id}" class="text-primary">
                                                        #{$complaint.order_id}
                                                    </a>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="ps-0">Ngày đặt:</td>
                                                <td class="text-end">{$complaint.order_created_at|date_format:"%d/%m/%Y"}</td>
                                            </tr>
                                            <tr>
                                                <td class="ps-0">Tổng tiền:</td>
                                                <td class="text-end">{$complaint.order_total|number_format:0:",":"."} VNĐ</td>
                                            </tr>
                                            <tr>
                                                <td class="ps-0">Trạng thái:</td>
                                                <td class="text-end">
                                                    {if $complaint.order_status == 'pending'}
                                                        <span class="badge bg-warning">Chờ xử lý</span>
                                                    {elseif $complaint.order_status == 'processing'}
                                                        <span class="badge bg-info">Đang xử lý</span>
                                                    {elseif $complaint.order_status == 'shipped'}
                                                        <span class="badge bg-primary">Đã giao</span>
                                                    {elseif $complaint.order_status == 'completed'}
                                                        <span class="badge bg-success">Hoàn thành</span>
                                                    {elseif $complaint.order_status == 'cancelled'}
                                                        <span class="badge bg-danger">Đã hủy</span>
                                                    {/if}
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="mt-3">
                                    <a href="/?c=admin&a=viewOrder&id={$complaint.order_id}" class="btn btn-sm btn-outline-primary w-100">
                                        <i class="mdi mdi-eye"></i> Xem chi tiết đơn hàng
                                    </a>
                                </div>
                            </div>
                        </div>
                    {/if}

                    <!-- Thông tin khiếu nại -->
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">
                                <i class="mdi mdi-information"></i> Thông tin khiếu nại
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-borderless table-sm mb-0">
                                    <tbody>
                                        <tr>
                                            <td class="ps-0">Ngày tạo:</td>
                                            <td class="text-end">{$complaint.created_at|date_format:"%d/%m/%Y %H:%M"}</td>
                                        </tr>
                                        <tr>
                                            <td class="ps-0">Cập nhật cuối:</td>
                                            <td class="text-end">{$complaint.updated_at|date_format:"%d/%m/%Y %H:%M"}</td>
                                        </tr>
                                        {if $complaint.admin_name}
                                            <tr>
                                                <td class="ps-0">Xử lý bởi:</td>
                                                <td class="text-end">{$complaint.admin_name}</td>
                                            </tr>
                                        {/if}
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

{include file="include/admin/footer.tpl"}