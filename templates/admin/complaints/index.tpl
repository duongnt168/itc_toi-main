{include file="include/admin/header.tpl"}
{include file="include/admin/sidebar.tpl"}

<div class="main-content">
    <div class="page-content">
        <div class="container-fluid">
            <!-- start page title -->
            <div class="row">
                <div class="col-12">
                    <div class="page-title-box d-sm-flex align-items-center justify-content-between">
                        <h4 class="mb-sm-0">Quản lý khiếu nại</h4>
                        <div class="page-title-right">
                            <ol class="breadcrumb m-0">
                                <li class="breadcrumb-item"><a href="/?c=admin&a=dashboard">Dashboard</a></li>
                                <li class="breadcrumb-item active">Khiếu nại</li>
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
                <div class="col-12">
                    <div class="card">
                        <div class="card-header">
                            <div class="row align-items-center">
                                <div class="col">
                                    <h4 class="card-title mb-0">Danh sách khiếu nại</h4>
                                </div>
                                <div class="col-auto">
                                    <div class="d-flex gap-2">
                                        <select class="form-select" id="statusFilter" onchange="filterByStatus()">
                                            <option value="">Tất cả trạng thái</option>
                                            <option value="pending" {if $filter_status == 'pending'}selected{/if}>Chờ xử lý</option>
                                            <option value="in_progress" {if $filter_status == 'in_progress'}selected{/if}>Đang xử lý</option>
                                            <option value="resolved" {if $filter_status == 'resolved'}selected{/if}>Đã giải quyết</option>
                                            <option value="closed" {if $filter_status == 'closed'}selected{/if}>Đã đóng</option>
                                        </select>
                                        <button type="button" class="btn btn-success" onclick="exportComplaints()">
                                            <i class="mdi mdi-download"></i> Xuất Excel
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="card-body">
                            {if isset($complaints) && count($complaints) > 0}
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0">
                                        <thead class="table-dark">
                                            <tr>
                                                <th>ID</th>
                                                <th>Đơn hàng</th>
                                                <th>Khách hàng</th>
                                                <th>Loại khiếu nại</th>
                                                <th>Tiêu đề</th>
                                                <th>Ngày tạo</th>
                                                <th>Trạng thái</th>
                                                <th>Chi tiết loại</th>
                                                <th>Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            {foreach from=$complaints item=complaint}
                                                <tr>
                                                    <td>
                                                        <strong>#{$complaint.id}</strong>
                                                    </td>
                                                    <td>
                                                        {if $complaint.order_id}
                                                            <a href="/?c=admin&a=viewOrder&id={$complaint.order_id}" 
                                                               class="text-decoration-none">
                                                                #{$complaint.order_id}
                                                            </a>
                                                            <br>
                                                            <small class="text-muted">
                                                                {$complaint.order_total|number_format:0:",":"."} VNĐ
                                                            </small>
                                                        {else}
                                                            <span class="text-muted">Không có</span>
                                                        {/if}
                                                    </td>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <div class="avatar-xs me-3">
                                                                <span class="avatar-title rounded-circle bg-primary text-white font-size-16">
                                                                    {$complaint.username|substr:0:1|upper}
                                                                </span>
                                                            </div>
                                                            <div>
                                                                <h6 class="mb-0">{$complaint.username|default:'Khách hàng'}</h6>
                                                                <small class="text-muted">{$complaint.email|default:'Chưa cập nhật'}</small>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-info" style="font-size: 10px;">{$complaint.type|default:'Chưa phân loại'}</span>
                                                    </td>
                                                    <td>
                                                        <div class="text-truncate" style="max-width: 180px;" 
                                                             title="{$complaint.title}">
                                                            {$complaint.title}
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <small>
                                                            {$complaint.created_at|date_format:"%d/%m/%Y"}
                                                            <br>
                                                            {$complaint.created_at|date_format:"%H:%M"}
                                                        </small>
                                                    </td>
                                                    <td>
                                                        {if $complaint.status == 'pending'}
                                                            <span class="badge bg-warning">Chờ xử lý</span>
                                                        {elseif $complaint.status == 'in_progress'}
                                                            <span class="badge bg-info">Đang xử lý</span>
                                                        {elseif $complaint.status == 'resolved'}
                                                            <span class="badge bg-success">Đã giải quyết</span>
                                                        {elseif $complaint.status == 'closed'}
                                                            <span class="badge bg-secondary">Đã đóng</span>
                                                        {/if}
                                                    </td>
                                                    <td>
                                                        {if isset($complaint.type) && $complaint.type == 'product_quality'}
                                                            <span class="badge bg-danger">Chất lượng SP</span>
                                                        {elseif isset($complaint.type) && $complaint.type == 'delivery_issue'}
                                                            <span class="badge bg-warning">Giao hàng</span>
                                                        {elseif isset($complaint.type) && $complaint.type == 'wrong_item'}
                                                            <span class="badge bg-info">Sai sản phẩm</span>
                                                        {elseif isset($complaint.type) && $complaint.type == 'damaged_item'}
                                                            <span class="badge bg-danger">Hàng hỏng</span>
                                                        {else}
                                                            <span class="badge bg-secondary">Khác</span>
                                                        {/if}
                                                    </td>
                                                    <td>
                                                        <div class="d-flex gap-1">
                                                            <a href="/?c=admin&a=complaint_detail&id={$complaint.id}" 
                                                               class="btn btn-sm btn-outline-primary">
                                                                <i class="mdi mdi-eye"></i> Xem chi tiết
                                                            </a>
                                                            <a href="/?c=admin&a=edit_complaint&id={$complaint.id}" 
                                                               class="btn btn-sm btn-outline-warning">
                                                                <i class="mdi mdi-pencil"></i> Sửa
                                                            </a>
                                                            <button type="button" 
                                                                    class="btn btn-sm btn-outline-danger" 
                                                                    onclick="deleteComplaint({$complaint.id})">
                                                                <i class="mdi mdi-delete"></i> Xóa
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            {/foreach}
                                        </tbody>
                                    </table>
                                </div>

                                {* Phân trang *}
                                {if isset($total_pages) && $total_pages > 1}
                                    <div class="row mt-4">
                                        <div class="col-sm-6">
                                            <div>
                                                <p class="mb-sm-0">
                                                    Hiển thị trang {$current_page} / {$total_pages}
                                                </p>
                                            </div>
                                        </div>
                                        <div class="col-sm-6">
                                            <div class="float-sm-end">
                                                <nav aria-label="Phân trang">
                                                    <ul class="pagination pagination-rounded mb-0">
                                                        {if $current_page > 1}
                                                            <li class="page-item">
                                                                <a class="page-link" href="/?c=admin&a=complaints&page={$current_page-1}{if $filter_status}&status={$filter_status}{/if}">
                                                                    <i class="mdi mdi-chevron-left"></i>
                                                                </a>
                                                            </li>
                                                        {/if}

                                                        {for $i=1 to $total_pages}
                                                            {if $i == $current_page}
                                                                <li class="page-item active">
                                                                    <span class="page-link">{$i}</span>
                                                                </li>
                                                            {else}
                                                                <li class="page-item">
                                                                    <a class="page-link" href="/?c=admin&a=complaints&page={$i}{if $filter_status}&status={$filter_status}{/if}">{$i}</a>
                                                                </li>
                                                            {/if}
                                                        {/for}

                                                        {if $current_page < $total_pages}
                                                            <li class="page-item">
                                                                <a class="page-link" href="/?c=admin&a=complaints&page={$current_page+1}{if $filter_status}&status={$filter_status}{/if}">
                                                                    <i class="mdi mdi-chevron-right"></i>
                                                                </a>
                                                            </li>
                                                        {/if}
                                                    </ul>
                                                </nav>
                                            </div>
                                        </div>
                                    </div>
                                {/if}
                            {else}
                                <div class="text-center py-4">
                                    <div class="avatar-md mx-auto mb-4">
                                        <div class="avatar-title bg-light text-primary rounded-circle font-size-24">
                                            <i class="mdi mdi-comment-alert"></i>
                                        </div>
                                    </div>
                                    <h5>Không có khiếu nại nào</h5>
                                    <p class="text-muted">Chưa có khiếu nại nào được gửi đến hệ thống.</p>
                                </div>
                            {/if}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function filterByStatus() {
    const status = document.getElementById('statusFilter').value;
    const url = new URL(window.location);
    
    if (status) {
        url.searchParams.set('status', status);
    } else {
        url.searchParams.delete('status');
    }
    
    url.searchParams.delete('page');
    window.location.href = url.toString();
}

function quickUpdate(complaintId, status) {
    if (confirm('Bạn có chắc chắn muốn cập nhật trạng thái khiếu nại này?')) {
        // Gửi AJAX request để cập nhật nhanh
        fetch('/?c=admin&a=complaint_detail&id=' + complaintId, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'status=' + status + '&admin_response=Đã bắt đầu xử lý khiếu nại'
        })
        .then(response => {
            if (response.ok) {
                location.reload();
            } else {
                alert('Có lỗi xảy ra khi cập nhật!');
            }
        })
        .catch(error => {
            alert('Có lỗi xảy ra khi cập nhật!');
        });
    }
}

function exportComplaints() {
    const status = document.getElementById('statusFilter').value;
    let url = '/?c=admin&a=export_complaints';
    
    if (status) {
        url += '&status=' + status;
    }
    
    window.open(url, '_blank');
}

function deleteComplaint(complaintId) {
    if (confirm('Bạn có chắc chắn muốn xóa khiếu nại này?')) {
        fetch('/?c=admin&a=delete_complaint&id=' + complaintId, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            }
        })
        .then(response => {
            if (response.ok) {
                location.reload();
            } else {
                alert('Có lỗi xảy ra khi xóa!');
            }
        })
        .catch(error => {
            alert('Có lỗi xảy ra khi xóa!');
        });
    }
}
</script>

{include file="include/admin/footer.tpl"}