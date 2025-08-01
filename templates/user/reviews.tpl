{include file="include/user/header.tpl"}
{include file="include/user/navbar.tpl"}

<div class="container my-5" style="padding-top: 100px;">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>Đánh giá của tôi</h2>
        <a href="/?c=user&v=orders" class="btn btn-outline-primary">
            <i class="fas fa-arrow-left"></i> Quay lại đơn hàng
        </a>
    </div>

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

    {if $reviews && count($reviews) > 0}
        <div class="row">
            {foreach $reviews as $review}
                <div class="col-md-6 mb-4">
                    <div class="card h-100 shadow-sm">
                        <div class="card-header bg-light d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="mb-0">
                                    <a href="/?c=user&v=order_detail&id={$review.order_id}" class="text-decoration-none">
                                        Đơn hàng #{$review.order_id}
                                    </a>
                                </h6>
                                <small class="text-muted">
                                    {$review.created_at|date_format:"%d/%m/%Y %H:%M"}
                                </small>
                            </div>
                            <div>
                                {if $review.status == 'pending'}
                                    <span class="badge bg-warning text-dark">Chờ duyệt</span>
                                {elseif $review.status == 'approved'}
                                    <span class="badge bg-success">Đã duyệt</span>
                                {elseif $review.status == 'rejected'}
                                    <span class="badge bg-danger">Bị từ chối</span>
                                {else}
                                    <span class="badge bg-secondary">{$review.status}</span>
                                {/if}
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="row mb-3">
                                <div class="col-4">
                                    <div class="text-center">
                                        <div class="text-muted small">Tổng thể</div>
                                        <div class="d-flex justify-content-center align-items-center">
                                            <span class="text-warning me-1">
                                                {for $i=1 to 5}
                                                    {if $i <= $review.rating}
                                                        <i class="fas fa-star"></i>
                                                    {else}
                                                        <i class="far fa-star"></i>
                                                    {/if}
                                                {/for}
                                            </span>
                                            <span class="fw-bold">{$review.rating}/5</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-4">
                                    <div class="text-center">
                                        <div class="text-muted small">Giao hàng</div>
                                        <div class="d-flex justify-content-center align-items-center">
                                            <span class="text-warning me-1">
                                                {for $i=1 to 5}
                                                    {if $i <= $review.delivery_rating}
                                                        <i class="fas fa-star"></i>
                                                    {else}
                                                        <i class="far fa-star"></i>
                                                    {/if}
                                                {/for}
                                            </span>
                                            <span class="fw-bold">{$review.delivery_rating}/5</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-4">
                                    <div class="text-center">
                                        <div class="text-muted small">Dịch vụ</div>
                                        <div class="d-flex justify-content-center align-items-center">
                                            <span class="text-warning me-1">
                                                {for $i=1 to 5}
                                                    {if $i <= $review.service_rating}
                                                        <i class="fas fa-star"></i>
                                                    {else}
                                                        <i class="far fa-star"></i>
                                                    {/if}
                                                {/for}
                                            </span>
                                            <span class="fw-bold">{$review.service_rating}/5</span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            {if $review.comment}
                                <div class="mb-3">
                                    <h6 class="text-muted">Nhận xét:</h6>
                                    <div class="border-start border-3 border-primary ps-3">
                                        {$review.comment|escape|nl2br}
                                    </div>
                                </div>
                            {/if}

                            {if $review.order_total}
                                <div class="text-muted small">
                                    <i class="fas fa-receipt"></i> 
                                    Giá trị đơn hàng: <span class="fw-bold">{$review.order_total|number_format:0:",":"."} VNĐ</span>
                                </div>
                            {/if}
                        </div>
                    </div>
                </div>
            {/foreach}
        </div>

        {* Phân trang *}
        {if $total_pages > 1}
            <nav aria-label="Phân trang đánh giá">
                <ul class="pagination justify-content-center">
                    {if $current_page > 1}
                        <li class="page-item">
                            <a class="page-link" href="/?c=user&v=reviews&page={$current_page-1}">
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
                                <a class="page-link" href="/?c=user&v=reviews&page={$i}">{$i}</a>
                            </li>
                        {/if}
                    {/for}
                    
                    {if $current_page < $total_pages}
                        <li class="page-item">
                            <a class="page-link" href="/?c=user&v=reviews&page={$current_page+1}">
                                Sau <i class="fas fa-chevron-right"></i>
                            </a>
                        </li>
                    {/if}
                </ul>
            </nav>
        {/if}
    {else}
        <div class="text-center py-5">
            <div class="mb-4">
                <i class="fas fa-star fa-4x text-muted"></i>
            </div>
            <h4 class="text-muted">Chưa có đánh giá nào</h4>
            <p class="text-muted">Bạn chưa đánh giá đơn hàng nào. Hãy đánh giá các đơn hàng đã hoàn thành để chia sẻ trải nghiệm của bạn.</p>
            <a href="/?c=user&v=orders" class="btn btn-primary">
                <i class="fas fa-shopping-bag"></i> Xem đơn hàng
            </a>
        </div>
    {/if}
</div>

{include file="include/user/footer.tpl"}