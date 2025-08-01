{include file="include/admin/header.tpl"}
{include file="include/admin/sidebar.tpl"}

<div class="main-content">
    <div class="page-content">
        <div class="container-fluid">
            <!-- start page title -->
            <div class="row">
                <div class="col-12">
                    <div class="page-title-box d-sm-flex align-items-center justify-content-between">
                        <h4 class="mb-sm-0">Quản lý yêu cầu hủy đơn hàng</h4>
                        <div class="page-title-right">
                            <ol class="breadcrumb m-0">
                                <li class="breadcrumb-item"><a href="/?c=admin&a=dashboard">Dashboard</a></li>
                                <li class="breadcrumb-item active">Yêu cầu hủy đơn</li>
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
                                    <h4 class="card-title mb-0">Danh sách yêu cầu hủy đơn hàng</h4>
                                </div>
                                <div class="col-auto">
                                    <div class="d-flex gap-2">
                                        <select class="form-select" id="statusFilter" onchange="filterByStatus()">
                                            <option value="">Tất cả trạng thái</option>
                                            <option value="pending" {if $filter_status == 'pending'}selected{/if}>Chờ xử lý</option>
                                            <option value="approved" {if $filter_status == 'approved'}selected{/if}>Đã duyệt</option>
                                            <option value="rejected" {if $filter_status == 'rejected'}selected{/if}>Từ chối</option>
                                        </select>
                                        <button type="button" class="btn btn-success" onclick="exportCancellations()">
                                            <i class="mdi mdi-download"></i> Xuất Excel
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="card-body">
                            {if isset($cancellations) && count($cancellations) > 0}
                                <div class="table-responsive">
                                    <table class="table table-hover table-nowrap mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th>ID</th>
                                                <th>Đơn hàng</th>
                                                <th>Khách hàng</th>
                                                <th>Lý do hủy</th>
                                                <th>Ngày yêu cầu</th>
                                                <th>Trạng thái</th>
                                                <th>Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            {foreach from=$cancellations item=cancellation}
                                                <tr>
                                                    <td>
                                                        <strong>#{$cancellation.id}</strong>
                                                    </td>
                                                    <td>
                                                        <a href="/?c=admin&a=viewOrder&id={$cancellation.order_id}" 
                                                           class="text-decoration-none">
                                                            #{$cancellation.order_id}
                                                        </a>
                                                        <br>
                                                        <small class="text-muted">
                                                            {$cancellation.order_total|number_format:0:",":"."} VNĐ
                                                        </small>
                                                    </td>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <div class="avatar-xs me-3">
                                                                <span class="avatar-title rounded-circle bg-primary text-white font-size-16">
                                                                    {$cancellation.username|substr:0:1|upper}
                                                                </span>
                                                            </div>
                                                            <div>
                                                                <h6 class="mb-0">{$cancellation.username}</h6>
                                                                <small class="text-muted">{$cancellation.email}</small>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div class="text-truncate" style="max-width: 200px;" 
                                                             title="{$cancellation.reason}">
                                                            {$cancellation.reason}
                                                        </div>
                                                        {if $cancellation.description}
                                                            <small class="text-muted d-block">
                                                                Ghi chú: {$cancellation.description|truncate:50}
                                                            </small>
                                                        {/if}
                                                    </td>
                                                    <td>
                                                        {$cancellation.created_at|date_format:"%d/%m/%Y"}
                                                        <br>
                                                        <small class="text-muted">
                                                            {$cancellation.created_at|date_format:"%H:%M"}
                                                        </small>
                                                    </td>
                                                    <td>
                                                        {if $cancellation.status == 'pending'}
                                                            <span class="badge bg-warning">Chờ xử lý</span>
                                                        {elseif $cancellation.status == 'approved'}
                                                            <span class="badge bg-success">Đã duyệt</span>
                                                        {elseif $cancellation.status == 'rejected'}
                                                            <span class="badge bg-danger">Từ chối</span>
                                                        {/if}
                                                    </td>

                                                    <td>
                                                        <div class="d-flex gap-2">
                                                            <a href="/?c=admin&a=cancellation_detail&id={$cancellation.id}" 
                                                               class="btn btn-sm btn-outline-primary" 
                                                               title="Xem chi tiết">
                                                                <i class="mdi mdi-eye"></i>
                                                            </a>
                                                            <a href="/?c=admin&a=cancellation_detail&id={$cancellation.id}" 
                                                               class="btn btn-sm btn-outline-warning" 
                                                               title="Sửa">
                                                                <i class="mdi mdi-pencil"></i>
                                                            </a>
                                                            <button type="button" 
                                                                    class="btn btn-sm btn-outline-danger" 
                                                                    onclick="deleteCancellation({$cancellation.id})"
                                                                    title="Xóa">
                                                                <i class="mdi mdi-delete"></i>
                                                            </button>
                                                            {if $cancellation.status == 'pending'}
                                                                <button type="button" 
                                                                        class="btn btn-sm btn-outline-success" 
                                                                        onclick="quickApprove({$cancellation.id})"
                                                                        title="Duyệt nhanh">
                                                                    <i class="mdi mdi-check"></i>
                                                                </button>
                                                                <button type="button" 
                                                                        class="btn btn-sm btn-outline-danger" 
                                                                        onclick="quickReject({$cancellation.id})"
                                                                        title="Từ chối">
                                                                    <i class="mdi mdi-close"></i>
                                                                </button>
                                                            {/if}
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
                                                                <a class="page-link" href="/?c=admin&a=cancellations&page={$current_page-1}{if $filter_status}&status={$filter_status}{/if}">
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
                                                                    <a class="page-link" href="/?c=admin&a=cancellations&page={$i}{if $filter_status}&status={$filter_status}{/if}">{$i}</a>
                                                                </li>
                                                            {/if}
                                                        {/for}

                                                        {if $current_page < $total_pages}
                                                            <li class="page-item">
                                                                <a class="page-link" href="/?c=admin&a=cancellations&page={$current_page+1}{if $filter_status}&status={$filter_status}{/if}">
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
                                            <i class="mdi mdi-cancel"></i>
                                        </div>
                                    </div>
                                    <h5>Không có yêu cầu hủy nào</h5>
                                    <p class="text-muted">Chưa có yêu cầu hủy đơn hàng nào được gửi đến hệ thống.</p>
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

function quickApprove(cancellationId) {
    if (confirm('Bạn có chắc chắn muốn duyệt yêu cầu hủy này? Đơn hàng sẽ được hủy và hoàn tiền cho khách hàng.')) {
        fetch('/?c=admin&a=cancellation_detail&id=' + cancellationId, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'status=approved&admin_response=Đã duyệt yêu cầu hủy đơn hàng'
        })
        .then(response => {
            if (response.ok) {
                location.reload();
            } else {
                alert('Có lỗi xảy ra khi duyệt!');
            }
        })
        .catch(error => {
            alert('Có lỗi xảy ra khi duyệt!');
        });
    }
}

function quickReject(cancellationId) {
    const reason = prompt('Nhập lý do từ chối yêu cầu hủy:');
    if (reason) {
        fetch('/?c=admin&a=cancellation_detail&id=' + cancellationId, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'status=rejected&admin_response=' + encodeURIComponent(reason)
        })
        .then(response => {
            if (response.ok) {
                location.reload();
            } else {
                alert('Có lỗi xảy ra khi từ chối!');
            }
        })
        .catch(error => {
            alert('Có lỗi xảy ra khi từ chối!');
        });
    }
}

function exportCancellations() {
    const status = document.getElementById('statusFilter').value;
    let url = '/?c=admin&a=export_cancellations';
    
    if (status) {
        url += '&status=' + status;
    }
    
    window.open(url, '_blank');
}

function deleteCancellation(cancellationId) {
    if (confirm('Bạn có chắc chắn muốn xóa yêu cầu hủy này? Hành động này không thể hoàn tác.')) {
        fetch('/?c=admin&a=delete_cancellation&id=' + cancellationId, {
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