{assign var="page_title" value="Chi tiết đánh giá"}
{include file="include/admin/header.tpl"}

<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Chi tiết đánh giá #{$review.id}</h5>
                    <div>
                        {if $review.status == 'pending'}
                            <a href="/?c=admin&a=approveReview&id={$review.id}" class="btn btn-success me-2">
                                <i class="bi bi-check-circle"></i> Duyệt
                            </a>
                            <a href="/?c=admin&a=rejectReview&id={$review.id}" class="btn btn-warning me-2">
                                <i class="bi bi-x-circle"></i> Từ chối
                            </a>
                        {/if}
                        <a href="/?c=admin&a=reviews" class="btn btn-secondary">
                            <i class="bi bi-arrow-left"></i> Quay lại
                        </a>
                    </div>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header">
                                    <h6>Thông tin đánh giá</h6>
                                </div>
                                <div class="card-body">
                                    <table class="table table-borderless">
                                        <tr>
                                            <td><strong>Đánh giá:</strong></td>
                                            <td>
                                                <div class="text-warning">
                                                    {for $i=1 to 5}
                                                        {if $i <= $review.rating}
                                                            <i class="bi bi-star-fill"></i>
                                                        {else}
                                                            <i class="bi bi-star"></i>
                                                        {/if}
                                                    {/for}
                                                    <span class="ms-2">({$review.rating}/5 sao)</span>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><strong>Trạng thái:</strong></td>
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
                                        </tr>
                                        <tr>
                                            <td><strong>Ngày tạo:</strong></td>
                                            <td>{$review.created_at|date_format:'%d/%m/%Y %H:%M'}</td>
                                        </tr>
                                        <tr>
                                            <td><strong>Ngày cập nhật:</strong></td>
                                            <td>{$review.updated_at|date_format:'%d/%m/%Y %H:%M'}</td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header">
                                    <h6>Thông tin khách hàng</h6>
                                </div>
                                <div class="card-body">
                                    <div class="d-flex align-items-center mb-3">
                                        <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-3" 
                                             style="width: 60px; height: 60px; font-size: 1.5rem;">
                                            {$review.username|substr:0:1|upper}
                                        </div>
                                        <div>
                                            <h6 class="mb-1">{$review.username}</h6>
                                            <p class="text-muted mb-0">{$review.email}</p>
                                        </div>
                                    </div>
                                    <div class="mt-3">
                                        <a href="/?c=admin&a=viewUser&id={$review.user_id}" class="btn btn-outline-primary btn-sm">
                                            <i class="bi bi-person"></i> Xem thông tin khách hàng
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row mt-4">
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header">
                                    <h6>Thông tin sản phẩm</h6>
                                </div>
                                <div class="card-body">
                                    <div class="d-flex align-items-center">
                                        <div class="me-3">
                                            {if $review.product_file_url}
                                                <img src="/public/img/products/{$review.product_file_url}" 
                                                     alt="{$review.product_name}" 
                                                     class="rounded" 
                                                     style="width: 80px; height: 80px; object-fit: cover;">
                                            {else}
                                                <div class="bg-light d-flex align-items-center justify-content-center" 
                                                     style="width: 80px; height: 80px; border-radius: 8px;">
                                                    <i class="bi bi-image text-muted" style="font-size: 2rem;"></i>
                                                </div>
                                            {/if}
                                        </div>
                                        <div class="flex-grow-1">
                                            <h6 class="mb-1">{$review.product_name}</h6>
                                            <p class="text-muted mb-2">Danh mục: {$review.category_name|default:'Chưa phân loại'}</p>
                                            <p class="text-primary mb-0">{$review.product_price|number_format:0:',':'.'} VNĐ</p>
                                        </div>
                                    </div>
                                    <div class="mt-3">
                                        <a href="/?c=admin&a=viewProduct&id={$review.product_id}" class="btn btn-outline-primary btn-sm">
                                            <i class="bi bi-box"></i> Xem thông tin sản phẩm
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header">
                                    <h6>Thống kê sản phẩm</h6>
                                </div>
                                <div class="card-body">
                                    <div class="row text-center">
                                        <div class="col-6 mb-3">
                                            <div class="card bg-info text-white">
                                                <div class="card-body">
                                                    <h4>{$product_stats.total_reviews|default:0}</h4>
                                                    <small>Tổng đánh giá</small>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-6 mb-3">
                                            <div class="card bg-warning text-white">
                                                <div class="card-body">
                                                    <h4>{$product_stats.avg_rating|string_format:"%.1f"|default:'0.0'}</h4>
                                                    <small>Đánh giá TB</small>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-6 mb-3">
                                            <div class="card bg-success text-white">
                                                <div class="card-body">
                                                    <h4>{$product_stats.approved_reviews|default:0}</h4>
                                                    <small>Đã duyệt</small>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-6 mb-3">
                                            <div class="card bg-secondary text-white">
                                                <div class="card-body">
                                                    <h4>{$product_stats.pending_reviews|default:0}</h4>
                                                    <small>Chờ duyệt</small>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row mt-4">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-header">
                                    <h6>Nội dung đánh giá</h6>
                                </div>
                                <div class="card-body">
                                    <div class="bg-light p-3 rounded">
                                        <p class="mb-0" style="white-space: pre-wrap;">{$review.comment}</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    {if $other_reviews}
                    <div class="row mt-4">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-header">
                                    <h6>Đánh giá khác của khách hàng này</h6>
                                </div>
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table table-striped">
                                            <thead>
                                                <tr>
                                                    <th>Sản phẩm</th>
                                                    <th>Đánh giá</th>
                                                    <th>Nội dung</th>
                                                    <th>Trạng thái</th>
                                                    <th>Ngày tạo</th>
                                                    <th>Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                {foreach $other_reviews as $other_review}
                                                    <tr>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                {if $other_review.product_file_url}
                                                                    <img src="/public/img/products/{$other_review.product_file_url}" 
                                                                         alt="{$other_review.product_name}" 
                                                                         class="rounded me-2" 
                                                                         style="width: 40px; height: 40px; object-fit: cover;">
                                                                {/if}
                                                                <div>
                                                                    <strong>{$other_review.product_name}</strong>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <div class="text-warning">
                                                                {for $i=1 to 5}
                                                                    {if $i <= $other_review.rating}
                                                                        <i class="bi bi-star-fill"></i>
                                                                    {else}
                                                                        <i class="bi bi-star"></i>
                                                                    {/if}
                                                                {/for}
                                                                <br>
                                                                <small>({$other_review.rating}/5)</small>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <div style="max-width: 200px;">
                                                                {$other_review.comment|truncate:80}
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <span class="badge 
                                                                {if $other_review.status == 'approved'}bg-success
                                                                {elseif $other_review.status == 'pending'}bg-warning
                                                                {elseif $other_review.status == 'rejected'}bg-danger
                                                                {else}bg-secondary{/if}">
                                                                {if $other_review.status == 'approved'}Đã duyệt
                                                                {elseif $other_review.status == 'pending'}Chờ duyệt
                                                                {elseif $other_review.status == 'rejected'}Từ chối
                                                                {else}{$other_review.status|capitalize}{/if}
                                                            </span>
                                                        </td>
                                                        <td>{$other_review.created_at|date_format:'%d/%m/%Y'}</td>
                                                        <td>
                                                            <a href="/?c=admin&a=viewReview&id={$other_review.id}" class="btn btn-sm btn-outline-info">
                                                                <i class="bi bi-eye"></i>
                                                            </a>
                                                        </td>
                                                    </tr>
                                                {/foreach}
                                            </tbody>
                                        </table>
                                    </div>
                                    <div class="text-center">
                                        <a href="/?c=admin&a=reviews&user={$review.user_id}" class="btn btn-outline-primary btn-sm">
                                            Xem tất cả đánh giá của khách hàng
                                        </a>
                                    </div>
                                </div>
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