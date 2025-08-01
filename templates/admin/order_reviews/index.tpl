{include file="include/admin/header.tpl"}
{include file="include/admin/sidebar.tpl"}

<div class="main-content">
    <div class="page-content">
        <div class="container-fluid">
            <!-- start page title -->
            <div class="row">
                <div class="col-12">
                    <div class="page-title-box d-sm-flex align-items-center justify-content-between">
                        <h4 class="mb-sm-0">Quản lý đánh giá đơn hàng</h4>
                        <div class="page-title-right">
                            <ol class="breadcrumb m-0">
                                <li class="breadcrumb-item"><a href="/?c=admin&a=dashboard">Dashboard</a></li>
                                <li class="breadcrumb-item active">Đánh giá đơn hàng</li>
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
                                    <h4 class="card-title mb-0">Danh sách đánh giá đơn hàng</h4>
                                </div>
                                <div class="col-auto">
                                    <div class="d-flex gap-2">
                                        <select class="form-select" id="statusFilter" onchange="filterByStatus()">
                                            <option value="">Tất cả trạng thái</option>
                                            <option value="pending" {if $filter_status == 'pending'}selected{/if}>Chờ duyệt</option>
                                            <option value="approved" {if $filter_status == 'approved'}selected{/if}>Đã duyệt</option>
                                            <option value="rejected" {if $filter_status == 'rejected'}selected{/if}>Từ chối</option>
                                        </select>
                                        <button type="button" class="btn btn-success" onclick="exportReviews()">
                                            <i class="mdi mdi-download"></i> Xuất Excel
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="card-body">
                            {if isset($order_reviews) && count($order_reviews) > 0}
                                <div class="table-responsive">
                                    <table class="table table-hover table-nowrap mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th>ID</th>
                                                <th>Đơn hàng</th>
                                                <th>Khách hàng</th>
                                                <th>Đánh giá</th>
                                                <th>Nhận xét</th>
                                                <th>Ngày tạo</th>
                                                <th>Trạng thái</th>
                                                <th>Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            {foreach from=$order_reviews item=review}
                                                <tr>
                                                    <td>
                                                        <strong>#{$review.id}</strong>
                                                    </td>
                                                    <td>
                                                        <a href="/?c=admin&a=viewOrder&id={$review.order_id}" 
                                                           class="text-decoration-none">
                                                            #{$review.order_id}
                                                        </a>
                                                        <br>
                                                        <small class="text-muted">
                                                            {$review.order_total|number_format:0:",":"."} VNĐ
                                                        </small>
                                                    </td>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <div class="avatar-xs me-3">
                                                                <span class="avatar-title rounded-circle bg-primary text-white font-size-16">
                                                                    {$review.username|substr:0:1|upper}
                                                                </span>
                                                            </div>
                                                            <div>
                                                                <h6 class="mb-0">{$review.username}</h6>
                                                                <small class="text-muted">{$review.email}</small>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div class="mb-1">
                                                            <span class="text-warning">
                                                                {for $i=1 to 5}
                                                                    {if $i <= $review.rating}
                                                                        <i class="mdi mdi-star"></i>
                                                                    {else}
                                                                        <i class="mdi mdi-star-outline"></i>
                                                                    {/if}
                                                                {/for}
                                                            </span>
                                                            <span class="ms-1">({$review.rating}/5)</span>
                                                        </div>
                                                        <div class="small">
                                                            <div>Giao hàng: 
                                                                <span class="text-warning">
                                                                    {for $i=1 to $review.delivery_rating}
                                                                        <i class="mdi mdi-star"></i>
                                                                    {/for}
                                                                </span>
                                                            </div>
                                                            <div>Dịch vụ: 
                                                                <span class="text-warning">
                                                                    {for $i=1 to $review.service_rating}
                                                                        <i class="mdi mdi-star"></i>
                                                                    {/for}
                                                                </span>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        {if $review.comment}
                                                            <div class="text-truncate" style="max-width: 200px;" 
                                                                 title="{$review.comment}">
                                                                {$review.comment}
                                                            </div>
                                                        {else}
                                                            <span class="text-muted">Không có nhận xét</span>
                                                        {/if}
                                                    </td>
                                                    <td>
                                                        {$review.created_at|date_format:"%d/%m/%Y"}
                                                        <br>
                                                        <small class="text-muted">
                                                            {$review.created_at|date_format:"%H:%M"}
                                                        </small>
                                                    </td>
                                                    <td>
                                                        {if $review.status == 'pending'}
                                                            <span class="badge bg-warning">Chờ duyệt</span>
                                                        {elseif $review.status == 'approved'}
                                                            <span class="badge bg-success">Đã duyệt</span>
                                                        {elseif $review.status == 'rejected'}
                                                            <span class="badge bg-danger">Từ chối</span>
                                                        {/if}
                                                    </td>
                                                    <td>
                                                        <div class="d-flex gap-2">
                                                            <a href="/?c=admin&a=order_review_detail&id={$review.id}" 
                                                               class="btn btn-sm btn-outline-primary" 
                                                               title="Xem chi tiết">
                                                                <i class="mdi mdi-eye"></i>
                                                            </a>
                                                            {if $review.status == 'pending'}
                                                                <button type="button" 
                                                                        class="btn btn-sm btn-outline-success" 
                                                                        onclick="quickApprove({$review.id})"
                                                                        title="Duyệt nhanh">
                                                                    <i class="mdi mdi-check"></i>
                                                                </button>
                                                                <button type="button" 
                                                                        class="btn btn-sm btn-outline-danger" 
                                                                        onclick="quickReject({$review.id})"
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
                                                                <a class="page-link" href="/?c=admin&a=order_reviews&page={$current_page-1}{if $filter_status}&status={$filter_status}{/if}">
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
                                                                    <a class="page-link" href="/?c=admin&a=order_reviews&page={$i}{if $filter_status}&status={$filter_status}{/if}">{$i}</a>
                                                                </li>
                                                            {/if}
                                                        {/for}

                                                        {if $current_page < $total_pages}
                                                            <li class="page-item">
                                                                <a class="page-link" href="/?c=admin&a=order_reviews&page={$current_page+1}{if $filter_status}&status={$filter_status}{/if}">
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
                                            <i class="mdi mdi-star-outline"></i>
                                        </div>
                                    </div>
                                    <h5>Không có đánh giá nào</h5>
                                    <p class="text-muted">Chưa có đánh giá đơn hàng nào được gửi đến hệ thống.</p>
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

function quickApprove(reviewId) {
    if (confirm('Bạn có chắc chắn muốn duyệt đánh giá này?')) {
        fetch('/?c=admin&a=order_review_detail&id=' + reviewId, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'status=approved&admin_notes=Đã duyệt tự động'
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

function quickReject(reviewId) {
    const reason = prompt('Nhập lý do từ chối:');
    if (reason) {
        fetch('/?c=admin&a=order_review_detail&id=' + reviewId, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'status=rejected&admin_notes=' + encodeURIComponent(reason)
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

function exportReviews() {
    const status = document.getElementById('statusFilter').value;
    let url = '/?c=admin&a=export_order_reviews';
    
    if (status) {
        url += '&status=' + status;
    }
    
    window.open(url, '_blank');
}
</script>

{include file="include/admin/footer.tpl"}