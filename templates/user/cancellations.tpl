{include file="include/user/header.tpl"}
{include file="include/user/navbar.tpl"}

<div class="container my-5" style="padding-top: 100px;">
    <div class="row">
        <div class="col-12">
            <div class="card shadow">
                <div class="card-header bg-warning text-dark">
                    <h4 class="mb-0">
                        <i class="fas fa-ban"></i> Yêu cầu hủy đơn hàng của tôi
                    </h4>
                </div>
                <div class="card-body">
                    {if isset($smarty.session.success)}
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle"></i> {$smarty.session.success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    {/if}

                    {if isset($smarty.session.error)}
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle"></i> {$smarty.session.error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    {/if}

                    {if isset($cancellations) && count($cancellations) > 0}
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-warning">
                                    <tr>
                                        <th>Mã yêu cầu</th>
                                        <th>Đơn hàng</th>
                                        <th>Lý do hủy</th>
                                        <th>Ngày yêu cầu</th>
                                        <th>Trạng thái</th>
                                        <th>Phản hồi</th>
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
                                                <a href="/?c=user&v=order_detail&id={$cancellation.order_id}" 
                                                   class="text-decoration-none">
                                                    #{$cancellation.order_id}
                                                </a>
                                                <br>
                                                <small class="text-muted">
                                                    {$cancellation.order_total|number_format:0:",":"."} VNĐ
                                                </small>
                                            </td>
                                            <td>
                                                <div class="text-truncate" style="max-width: 200px;" 
                                                     title="{$cancellation.reason}">
                                                    {$cancellation.reason}
                                                </div>
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
                                                    <span class="badge bg-warning text-dark">
                                                        <i class="fas fa-clock"></i> Chờ xử lý
                                                    </span>
                                                {elseif $cancellation.status == 'approved'}
                                                    <span class="badge bg-success">
                                                        <i class="fas fa-check"></i> Đã chấp nhận
                                                    </span>
                                                {elseif $cancellation.status == 'rejected'}
                                                    <span class="badge bg-danger">
                                                        <i class="fas fa-times"></i> Từ chối
                                                    </span>
                                                {/if}
                                            </td>
                                            <td>
                                                {if $cancellation.admin_response}
                                                    <div class="text-truncate" style="max-width: 150px;" 
                                                         title="{$cancellation.admin_response}">
                                                        {$cancellation.admin_response}
                                                    </div>
                                                {else}
                                                    <span class="text-muted">Chưa có phản hồi</span>
                                                {/if}
                                            </td>
                                            <td>
                                                <div class="btn-group" role="group">
                                                    <button type="button" class="btn btn-sm btn-outline-info" 
                                                            onclick="viewCancellationDetail({$cancellation.id})">
                                                        <i class="fas fa-eye"></i>
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
                            <nav aria-label="Phân trang yêu cầu hủy">
                                <ul class="pagination justify-content-center">
                                    {if $current_page > 1}
                                        <li class="page-item">
                                            <a class="page-link" href="/?c=user&v=cancellations&page={$current_page-1}">
                                                <i class="fas fa-chevron-left"></i> Trước
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
                                                <a class="page-link" href="/?c=user&v=cancellations&page={$i}">{$i}</a>
                                            </li>
                                        {/if}
                                    {/for}

                                    {if $current_page < $total_pages}
                                        <li class="page-item">
                                            <a class="page-link" href="/?c=user&v=cancellations&page={$current_page+1}">
                                                Sau <i class="fas fa-chevron-right"></i>
                                            </a>
                                        </li>
                                    {/if}
                                </ul>
                            </nav>
                        {/if}
                    {else}
                        <div class="text-center py-5">
                            <i class="fas fa-ban fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">Bạn chưa có yêu cầu hủy đơn hàng nào</h5>
                            <p class="text-muted">Khi bạn yêu cầu hủy đơn hàng, thông tin sẽ hiển thị tại đây.</p>
                            <a href="/?c=user&v=orders" class="btn btn-primary">
                                <i class="fas fa-shopping-bag"></i> Xem đơn hàng của tôi
                            </a>
                        </div>
                    {/if}
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal chi tiết yêu cầu hủy -->
<div class="modal fade" id="cancellationDetailModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-warning text-dark">
                <h5 class="modal-title">
                    <i class="fas fa-ban"></i> Chi tiết yêu cầu hủy đơn hàng
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="cancellationDetailContent">
                <div class="text-center">
                    <div class="spinner-border text-warning" role="status">
                        <span class="visually-hidden">Đang tải...</span>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    <i class="fas fa-times"></i> Đóng
                </button>
            </div>
        </div>
    </div>
</div>

<script>
function viewCancellationDetail(cancellationId) {
    const modal = new bootstrap.Modal(document.getElementById('cancellationDetailModal'));
    const content = document.getElementById('cancellationDetailContent');
    
    // Hiển thị loading
    content.innerHTML = `
        <div class="text-center">
            <div class="spinner-border text-warning" role="status">
                <span class="visually-hidden">Đang tải...</span>
            </div>
        </div>
    `;
    
    modal.show();
    
    // Gọi AJAX để lấy chi tiết
    fetch(`/?c=user&v=cancellation_detail&id=${cancellationId}&ajax=1`)
        .then(response => response.text())
        .then(data => {
            content.innerHTML = data;
        })
        .catch(error => {
            content.innerHTML = `
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-triangle"></i> 
                    Có lỗi xảy ra khi tải thông tin. Vui lòng thử lại.
                </div>
            `;
        });
}
</script>

{include file="include/user/footer.tpl"}