{assign var="page_title" value="Quản lý đánh giá"}
{include file="include/admin/header.tpl"}

<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Danh sách đánh giá</h5>
                </div>
                <div class="card-body">
                    {if isset($smarty.session.success)}
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            {$smarty.session.success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>

                    {/if}
                    
                    {if isset($smarty.session.error)}
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            {$smarty.session.error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>

                    {/if}
                    
                    <!-- Filter Form -->
                    <div class="row mb-3">
                        <div class="col-md-3">
                            <select class="form-select" id="ratingFilter" onchange="filterReviews()">
                                <option value="">Tất cả đánh giá</option>
                                <option value="5" {if $smarty.get.rating == '5'}selected{/if}>5 sao</option>
                                <option value="4" {if $smarty.get.rating == '4'}selected{/if}>4 sao</option>
                                <option value="3" {if $smarty.get.rating == '3'}selected{/if}>3 sao</option>
                                <option value="2" {if $smarty.get.rating == '2'}selected{/if}>2 sao</option>
                                <option value="1" {if $smarty.get.rating == '1'}selected{/if}>1 sao</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <select class="form-select" id="statusFilter" onchange="filterReviews()">
                                <option value="">Tất cả trạng thái</option>
                                <option value="approved" {if $smarty.get.status == 'approved'}selected{/if}>Đã duyệt</option>
                                <option value="pending" {if $smarty.get.status == 'pending'}selected{/if}>Chờ duyệt</option>
                                <option value="rejected" {if $smarty.get.status == 'rejected'}selected{/if}>Từ chối</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <input type="date" class="form-control" id="dateFilter" value="{if isset($smarty.get.date)}{$smarty.get.date}{/if}" onchange="filterReviews()">
                        </div>
                        <div class="col-md-3">
                            <div class="input-group">
                                <input type="text" class="form-control" id="searchInput" 
                                       placeholder="Tìm kiếm đánh giá..." value="{if isset($smarty.get.search)}{$smarty.get.search}{/if}">
                                <button class="btn btn-outline-secondary" type="button" onclick="filterReviews()">
                                    <i class="bi bi-search"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <div class="table-responsive">
                        <table class="table table-striped table-hover">
                            <thead class="table-dark">
                                <tr>
                                    <th>ID</th>
                                    <th>Sản phẩm</th>
                                    <th>Khách hàng</th>
                                    <th>Đánh giá</th>
                                    <th>Nội dung</th>
                                    <th>Trạng thái</th>
                                    <th>Ngày tạo</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                {if $reviews}
                                    {foreach $reviews as $review}
                                        <tr>
                                            <td>{$review.id}</td>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    {if $review.product_file_url}
                                                        <img src="/public/img/products/{$review.product_file_url}?t={$smarty.now}" 
                                                             alt="{$review.product_name}" 
                                                             class="img-thumbnail me-2" 
                                                             style="width: 40px; height: 40px; object-fit: cover;">
                                                    {/if}
                                                    <div>
                                                        <strong>{$review.product_name}</strong>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <div>
                                                    <strong>{$review.username}</strong>
                                                    <br>
                                                    <small class="text-muted">{$review.email}</small>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="text-warning">
                                                    {for $i=1 to 5}
                                                        {if $i <= $review.rating}
                                                            <i class="bi bi-star-fill"></i>
                                                        {else}
                                                            <i class="bi bi-star"></i>
                                                        {/if}
                                                    {/for}
                                                    <br>
                                                    <small>({$review.rating}/5)</small>
                                                </div>
                                            </td>
                                            <td>
                                                <div style="max-width: 200px;">
                                                    {$review.comment|truncate:100}
                                                    {if $review.comment|strlen > 100}
                                                        <br>
                                                        <small>
                                                            <a href="#" onclick="showFullComment('{$review.id}')" class="text-primary">
                                                                Xem thêm...
                                                            </a>
                                                        </small>
                                                    {/if}
                                                </div>
                                                <div id="full-comment-{$review.id}" class="d-none">
                                                    {$review.comment}
                                                </div>
                                            </td>
                                            <td>
                                                <span class="badge 
                                                    {if $review.status == 'approved'}bg-success
                                                    {elseif $review.status == 'pending'}bg-warning
                                                    {elseif $review.status == 'rejected'}bg-danger
                                                    {else}bg-secondary{/if}">
                                                    {if $review.status == 'approved'}Đã duyệt
                                                    {elseif $review.status == 'pending'}Chờ duyệt
                                                    {elseif $review.status == 'rejected'}Từ chối
                                                    {else}{$review.status|capitalize}{/if}
                                                </span>
                                            </td>
                                            <td>{$review.created_at|date_format:'%d/%m/%Y %H:%M'}</td>
                                            <td>
                                                <div class="btn-group" role="group">
                                                    <a href="/?c=admin&a=viewReview&id={$review.id}" 
                                                       class="btn btn-sm btn-outline-info"
                                                       title="Xem">
                                                        <i class="bi bi-eye"></i>
                                                    </a>
                                                    {if $review.status == 'pending'}
                                                        <a href="/?c=admin&a=approveReview&id={$review.id}" 
                                                           class="btn btn-sm btn-outline-success"
                                                           title="Duyệt">
                                                            <i class="bi bi-check-circle"></i>
                                                        </a>
                                                        <a href="/?c=admin&a=rejectReview&id={$review.id}" 
                                                           class="btn btn-sm btn-outline-warning"
                                                           title="Từ chối">
                                                            <i class="bi bi-x-circle"></i>
                                                        </a>
                                                    {/if}
                                                    <a href="/?c=admin&a=deleteReview&id={$review.id}" 
                                                       class="btn btn-sm btn-outline-danger"
                                                       onclick="return confirm('Bạn có chắc chắn muốn xóa đánh giá này?')"
                                                       title="Xóa">
                                                        <i class="bi bi-trash"></i>
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    {/foreach}
                                {else}
                                    <tr>
                                        <td colspan="8" class="text-center">Không có đánh giá nào</td>
                                    </tr>
                                {/if}
                            </tbody>
                        </table>
                    </div>
                    
                    {if $total_pages > 1}
                        <nav aria-label="Phân trang">
                            <ul class="pagination justify-content-center">
                                {if $current_page > 1}
                                    <li class="page-item">
                                        <a class="page-link" href="/?c=admin&a=reviews&page={$current_page-1}{if $smarty.get.rating}&rating={$smarty.get.rating}{/if}{if $smarty.get.status}&status={$smarty.get.status}{/if}{if $smarty.get.date}&date={$smarty.get.date}{/if}{if $smarty.get.search}&search={$smarty.get.search}{/if}">
                                            <i class="bi bi-chevron-left"></i>
                                        </a>
                                    </li>
                                {/if}
                                
                                {for $i=1 to $total_pages}
                                    <li class="page-item {if $i == $current_page}active{/if}">
                                        <a class="page-link" href="/?c=admin&a=reviews&page={$i}{if $smarty.get.rating}&rating={$smarty.get.rating}{/if}{if $smarty.get.status}&status={$smarty.get.status}{/if}{if $smarty.get.date}&date={$smarty.get.date}{/if}{if $smarty.get.search}&search={$smarty.get.search}{/if}">{$i}</a>
                                    </li>
                                {/for}
                                
                                {if $current_page < $total_pages}
                                    <li class="page-item">
                                        <a class="page-link" href="/?c=admin&a=reviews&page={$current_page+1}{if $smarty.get.rating}&rating={$smarty.get.rating}{/if}{if $smarty.get.status}&status={$smarty.get.status}{/if}{if $smarty.get.date}&date={$smarty.get.date}{/if}{if $smarty.get.search}&search={$smarty.get.search}{/if}">
                                            <i class="bi bi-chevron-right"></i>
                                        </a>
                                    </li>
                                {/if}
                            </ul>
                        </nav>
                    {/if}
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal for full comment -->
<div class="modal fade" id="commentModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Nội dung đánh giá</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="modalCommentContent">
                <!-- Comment content will be loaded here -->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<script>
function filterReviews() {
    const rating = document.getElementById('ratingFilter').value;
    const status = document.getElementById('statusFilter').value;
    const date = document.getElementById('dateFilter').value;
    const search = document.getElementById('searchInput').value;
    
    let url = '/?c=admin&a=reviews';
    const params = [];
    
    if (rating) params.push('rating=' + rating);
    if (status) params.push('status=' + status);
    if (date) params.push('date=' + date);
    if (search) params.push('search=' + encodeURIComponent(search));
    
    if (params.length > 0) {
        url += '&' + params.join('&');
    }
    
    window.location.href = url;
}

function showFullComment(reviewId) {
    const fullComment = document.getElementById('full-comment-' + reviewId).innerHTML;
    document.getElementById('modalCommentContent').innerHTML = fullComment;
    const modal = new bootstrap.Modal(document.getElementById('commentModal'));
    modal.show();
}

// Enter key support for search
document.getElementById('searchInput').addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
        filterReviews();
    }
});
</script>

{include file="include/admin/footer.tpl"}