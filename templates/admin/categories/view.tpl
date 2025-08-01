{assign var="page_title" value="Chi tiết danh mục"}
{include file="include/admin/header.tpl"}

<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Chi tiết danh mục #{$category.id}</h5>
                    <div>
                        <a href="/?c=admin&a=editCategory&id={$category.id}" class="btn btn-primary me-2">
                            <i class="bi bi-pencil"></i> Chỉnh sửa
                        </a>
                        <a href="/?c=admin&a=categories" class="btn btn-secondary">
                            <i class="bi bi-arrow-left"></i> Quay lại
                        </a>
                    </div>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-4">
                            <div class="card">
                                <div class="card-header">
                                    <h6>Hình ảnh danh mục</h6>
                                </div>
                                <div class="card-body text-center">
                                    {if $category.image}
                                        <img src="/public/img/categories/{$category.image}?t={$smarty.now}" 
                                             alt="{$category.name}" 
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
                                    <h6>Thông tin danh mục</h6>
                                </div>
                                <div class="card-body">
                                    <table class="table table-borderless">
                                        <tr>
                                            <td><strong>Tên danh mục:</strong></td>
                                            <td>{$category.name}</td>
                                        </tr>
                                        <tr>
                                            <td><strong>Mô tả:</strong></td>
                                            <td>
                                                {if $category.description}
                                                    {$category.description|nl2br}
                                                {else}
                                                    <span class="text-muted">Chưa có mô tả</span>
                                                {/if}
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><strong>Trạng thái:</strong></td>
                                            <td>
                                                <span class="badge {if $category.status == 'active'}bg-success{else}bg-secondary{/if}">
                                                    {$category.status|capitalize}
                                                </span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><strong>Ngày tạo:</strong></td>
                                            <td>{$category.created_at|date_format:'%d/%m/%Y %H:%M'}</td>
                                        </tr>
                                        <tr>
                                            <td><strong>Ngày cập nhật:</strong></td>
                                            <td>{$category.updated_at|date_format:'%d/%m/%Y %H:%M'}</td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row mt-4">
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header">
                                    <h6>Thống kê</h6>
                                </div>
                                <div class="card-body">
                                    <div class="row text-center">
                                        <div class="col-6 mb-3">
                                            <div class="card bg-primary text-white">
                                                <div class="card-body">
                                                    <h4>{$category_stats.total_products|default:0}</h4>
                                                    <small>Tổng sản phẩm</small>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-6 mb-3">
                                            <div class="card bg-success text-white">
                                                <div class="card-body">
                                                    <h4>{$category_stats.active_products|default:0}</h4>
                                                    <small>Sản phẩm hoạt động</small>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-6 mb-3">
                                            <div class="card bg-info text-white">
                                                <div class="card-body">
                                                    <h4>{$category_stats.total_reviews|default:0}</h4>
                                                    <small>Tổng đánh giá</small>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-6 mb-3">
                                            <div class="card bg-warning text-white">
                                                <div class="card-body">
                                                    <h4>{$category_stats.avg_rating|string_format:"%.1f"|default:'0.0'}</h4>
                                                    <small>Đánh giá trung bình</small>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header">
                                    <h6>Sản phẩm bán chạy</h6>
                                </div>
                                <div class="card-body">
                                    {if $top_products}
                                        {foreach $top_products as $product}
                                            <div class="d-flex align-items-center mb-3">
                                                <div class="me-3">
                                                    {if $product.file_url}
                                                        <img src="/public/img/products/{$product.file_url}?t={$smarty.now}" 
                                                             alt="{$product.name}" 
                                                             class="rounded" 
                                                             style="width: 50px; height: 50px; object-fit: cover;">
                                                    {else}
                                                        <div class="bg-light d-flex align-items-center justify-content-center" 
                                                             style="width: 50px; height: 50px; border-radius: 4px;">
                                                            <i class="bi bi-image text-muted"></i>
                                                        </div>
                                                    {/if}
                                                </div>
                                                <div class="flex-grow-1">
                                                    <h6 class="mb-1">{$product.name}</h6>
                                                    <small class="text-muted">Đã bán: {$product.total_sold|default:0} sản phẩm</small>
                                                    <br>
                                                    <small class="text-primary">{$product.price|number_format:0:',':'.'} VNĐ</small>
                                                </div>
                                            </div>
                                        {/foreach}
                                    {else}
                                        <p class="text-muted">Chưa có dữ liệu bán hàng</p>
                                    {/if}
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    {if $recent_products}
                    <div class="row mt-4">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-header">
                                    <h6>Sản phẩm mới nhất</h6>
                                </div>
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table table-striped">
                                            <thead>
                                                <tr>
                                                    <th>Hình ảnh</th>
                                                    <th>Tên sản phẩm</th>
                                                    <th>Giá</th>
                                                    <th>Tồn kho</th>
                                                    <th>Trạng thái</th>
                                                    <th>Ngày tạo</th>
                                                    <th>Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                {foreach $recent_products as $product}
                                                    <tr>
                                                        <td>
                                                            {if $product.file_url}
                                                                <img src="/public/img/products/{$product.file_url}?t={$smarty.now}" 
                                                                     alt="{$product.name}" 
                                                                     class="rounded" 
                                                                     style="width: 40px; height: 40px; object-fit: cover;">
                                                            {else}
                                                                <div class="bg-light d-flex align-items-center justify-content-center" 
                                                                     style="width: 40px; height: 40px; border-radius: 4px;">
                                                                    <i class="bi bi-image text-muted"></i>
                                                                </div>
                                                            {/if}
                                                        </td>
                                                        <td>{$product.name}</td>
                                                        <td>{$product.price|number_format:0:',':'.'} VNĐ</td>
                                                        <td>
                                                            <span class="badge {if $product.stock > 10}bg-success{elseif $product.stock > 0}bg-warning{else}bg-danger{/if}">
                                                                {$product.stock}
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <span class="badge {if $product.status == 'active'}bg-success{else}bg-secondary{/if}">
                                                                {$product.status|capitalize}
                                                            </span>
                                                        </td>
                                                        <td>{$product.created_at|date_format:'%d/%m/%Y'}</td>
                                                        <td>
                                                            <a href="/?c=admin&a=viewProduct&id={$product.id}" class="btn btn-sm btn-outline-info">
                                                                <i class="bi bi-eye"></i>
                                                            </a>
                                                        </td>
                                                    </tr>
                                                {/foreach}
                                            </tbody>
                                        </table>
                                    </div>
                                    <div class="text-center">
                                        <a href="/?c=admin&a=products&category={$category.id}" class="btn btn-outline-primary btn-sm">
                                            Xem tất cả sản phẩm
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