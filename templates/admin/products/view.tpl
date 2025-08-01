{assign var="page_title" value="Chi tiết sản phẩm"}
{include file="include/admin/header.tpl"}

<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Chi tiết sản phẩm #{$product.id}</h5>
                    <div>
                        <a href="/?c=admin&a=editProduct&id={$product.id}" class="btn btn-primary me-2">
                            <i class="bi bi-pencil"></i> Chỉnh sửa
                        </a>
                        <a href="/?c=admin&a=products" class="btn btn-secondary">
                            <i class="bi bi-arrow-left"></i> Quay lại
                        </a>
                    </div>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-4">
                            <div class="card">
                                <div class="card-header">
                                    <h6>Hình ảnh sản phẩm</h6>
                                </div>
                                <div class="card-body text-center">
                                    {if $product.file_url}
                                        <img src="/public/img/products/{$product.file_url}?t={$smarty.now}" 
                                             alt="{$product.name}" 
                                             class="img-fluid rounded" 
                                             style="max-height: 300px; object-fit: cover;">
                                    {else}
                                        <div class="bg-light d-flex align-items-center justify-content-center" 
                                             style="height: 300px; border-radius: 8px;">
                                            <i class="bi bi-image text-muted" style="font-size: 3rem;"></i>
                                        </div>
                                        <p class="text-muted mt-2">Không có hình ảnh</p>
                                    {/if}
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-8">
                            <div class="card">
                                <div class="card-header">
                                    <h6>Thông tin sản phẩm</h6>
                                </div>
                                <div class="card-body">
                                    <table class="table table-borderless">
                                        <tr>
                                            <td><strong>Tên sản phẩm:</strong></td>
                                            <td>{$product.name}</td>
                                        </tr>
                                        <tr>
                                            <td><strong>Danh mục:</strong></td>
                                            <td>
                                                <span class="badge bg-secondary">{$product.category_name}</span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><strong>Giá hiện tại:</strong></td>
                                            <td>
                                                <strong class="text-primary">{$product.price|number_format:0:',':'.'} VNĐ</strong>
                                            </td>
                                        </tr>
                                        {if $product.old_price && $product.old_price > 0}
                                        <tr>
                                            <td><strong>Giá cũ:</strong></td>
                                            <td>
                                                <span class="text-muted text-decoration-line-through">{$product.old_price|number_format:0:',':'.'} VNĐ</span>
                                            </td>
                                        </tr>
                                        {/if}
                                        <tr>
                                            <td><strong>Tồn kho:</strong></td>
                                            <td>
                                                <span class="badge {if $product.stock > 10}bg-success{elseif $product.stock > 0}bg-warning{else}bg-danger{/if}">
                                                    {$product.stock} sản phẩm
                                                </span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><strong>Trạng thái:</strong></td>
                                            <td>
                                                <span class="badge {if $product.status == 'active'}bg-success{else}bg-secondary{/if}">
                                                    {$product.status|capitalize}
                                                </span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><strong>Ngày tạo:</strong></td>
                                            <td>{$product.created_at|date_format:'%d/%m/%Y %H:%M'}</td>
                                        </tr>
                                        <tr>
                                            <td><strong>Ngày cập nhật:</strong></td>
                                            <td>{$product.updated_at|date_format:'%d/%m/%Y %H:%M'}</td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row mt-4">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-header">
                                    <h6>Mô tả sản phẩm</h6>
                                </div>
                                <div class="card-body">
                                    {if $product.description}
                                        <p>{$product.description|nl2br}</p>
                                    {else}
                                        <p class="text-muted">Chưa có mô tả cho sản phẩm này.</p>
                                    {/if}
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    {if $reviews}
                    <div class="row mt-4">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-header">
                                    <h6>Đánh giá gần đây</h6>
                                </div>
                                <div class="card-body">
                                    {foreach $reviews as $review}
                                        <div class="border-bottom pb-3 mb-3">
                                            <div class="d-flex justify-content-between align-items-start">
                                                <div>
                                                    <strong>{$review.username}</strong>
                                                    <div class="text-warning">
                                                        {for $i=1 to 5}
                                                            {if $i <= $review.rating}
                                                                <i class="bi bi-star-fill"></i>
                                                            {else}
                                                                <i class="bi bi-star"></i>
                                                            {/if}
                                                        {/for}
                                                    </div>
                                                    <p class="mt-2 mb-1">{$review.comment}</p>
                                                </div>
                                                <div class="text-end">
                                                    <small class="text-muted">{$review.created_at|date_format:'%d/%m/%Y'}</small>
                                                    <br>
                                                    <span class="badge {if $review.status == 'approved'}bg-success{elseif $review.status == 'rejected'}bg-danger{else}bg-warning{/if}">
                                                        {$review.status|capitalize}
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                    {/foreach}
                                    <div class="text-center">
                                        <a href="/?c=admin&a=reviews&product_id={$product.id}" class="btn btn-outline-primary btn-sm">
                                            Xem tất cả đánh giá
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