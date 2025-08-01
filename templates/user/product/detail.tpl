{include file="include/user/header.tpl"}
{include file="include/user/navbar.tpl"}

<div class="container my-5" style="padding-top: 100px;">
    {if isset($smarty.session.error)}
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            {$smarty.session.error}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    {/if}
    {if isset($smarty.session.success)}
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            {$smarty.session.success}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    {/if}
    
    {if isset($error)}
        <div class="alert alert-danger">{$error}</div>
    {else}
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb bg-white px-0">
                <li class="breadcrumb-item"><a href="/?c=user&v=index">Trang chủ</a></li>
                <li class="breadcrumb-item"><a href="/?c=product&v=category&id={$product.category_id}">{$product.category_name|default:'Danh mục'}</a></li>
                <li class="breadcrumb-item active" aria-current="page">{$product.name}</li>
            </ol>
        </nav>
        <div class="row justify-content-center align-items-center">
            <div class="col-lg-5 col-md-6 col-12 mb-4 text-center">
                <div class="bg-white rounded shadow p-3">
                    {if $product.file_url}
                        <img src="/public/img/products/{$product.file_url}?t={$smarty.now}" 
                             alt="{$product.name}" 
                             class="img-fluid rounded" 
                             style="max-width: 400px; max-height: 400px; object-fit: contain;">
                    {else}
                        <div class="d-flex align-items-center justify-content-center bg-light rounded" 
                             style="width: 400px; height: 400px;">
                            <i class="bi bi-image text-muted" style="font-size: 4rem;"></i>
                        </div>
                    {/if}
                </div>
                <div class="mt-3">
                    <span class="badge bg-info text-dark">Mã SP: {$product.id}</span>
                    {if $product.status == 'active'}
                        <span class="badge bg-success ms-2">Còn hàng</span>
                    {else}
                        <span class="badge bg-danger ms-2">Hết hàng</span>
                    {/if}
                    {if isset($product.stock)}
                        <span class="badge bg-secondary ms-2">Kho: {$product.stock}</span>
                    {/if}
                </div>
            </div>
            <div class="col-lg-7 col-md-6 col-12">
                <h2 class="fw-bold mb-3">{$product.name}</h2>
                <div class="mb-2">
                    {if $product.old_price}
                        <span class="text-muted" style="font-size:1.2rem;"><del>{$product.old_price}</del></span>
                    {/if}
                    {if $product.price}
                        <span class="text-danger fw-bold" style="font-size:2rem;">{number_format($product.price,0,',','.')}₫</span>
                    {/if}
                </div>
                <div class="mb-3 text-muted">
                    <i class="fa fa-calendar me-1"></i> Ngày đăng: {$product.created_at|date_format:"%d/%m/%Y"}
                    {if $product.category_name}
                        <span class="ms-3"><i class="fa fa-folder-open me-1"></i> {$product.category_name}</span>
                    {/if}
                </div>
                <div class="mb-4" style="min-height:60px; font-size:1.1rem;">{$product.description}</div>
                <form action="/?c=cart&v=add" method="post" class="mt-3">
                    <input type="hidden" name="product_id" value="{$product.id}">
                    <div class="mb-3 d-flex align-items-center">
                        <label for="quantity" class="form-label me-2 mb-0">Số lượng</label>
                        <input type="number" name="quantity" id="quantity" value="1" min="1" max="{$product.stock|default:99}" class="form-control" style="width:100px;display:inline-block;">
                    </div>
                    <button type="submit" class="btn btn-success px-4"><i class="fa fa-cart-plus me-1"></i> Thêm vào giỏ hàng</button>
                </form>
            </div>
        </div>
    {/if}
</div>

<!-- Đánh giá sản phẩm -->
<div class="container my-5">
    <h4 class="mb-3">Đánh giá sản phẩm</h4>
    {if isset($reviews) && $reviews|@count > 0}
        <div class="list-group">
            {foreach from=$reviews item=review}
            <div class="list-group-item mb-2">
                <div class="d-flex align-items-center mb-2">
                    <img src="public/img/user.png" alt="User Avatar" class="rounded-circle me-2" style="width:36px;height:36px;object-fit:cover;">
                    <div class="flex-grow-1">
                        <div class="d-flex align-items-center mb-1">
                            <span class="fw-bold me-2">{$review.username|default:'Khách hàng'}</span>
                            <span class="text-warning me-2">
                                {for $i=1 to 5}
                                    {if $i <= $review.rating}<i class="fa fa-star"></i>{else}<i class="fa fa-star-o"></i>{/if}
                                {/for}
                            </span>
                            <span class="badge bg-success me-2">Đã mua hàng</span>
                            <span class="text-muted" style="font-size:0.9em;">{$review.created_at|date_format:"%d/%m/%Y"}</span>
                        </div>
                        <div class="small text-muted mb-2">
                            <span class="me-3">Giao hàng: 
                                <span class="text-warning">
                                    {for $i=1 to $review.delivery_rating}<i class="fa fa-star"></i>{/for}
                                </span>
                            </span>
                            <span>Dịch vụ: 
                                <span class="text-warning">
                                    {for $i=1 to $review.service_rating}<i class="fa fa-star"></i>{/for}
                                </span>
                            </span>
                        </div>
                    </div>
                </div>
                {if $review.comment}
                    <div class="ps-5">{$review.comment}</div>
                {/if}
            </div>
            {/foreach}
        </div>
    {else}
        <div class="text-muted">Chưa có đánh giá nào cho sản phẩm này.</div>
    {/if}
</div>
<!-- Sản phẩm liên quan -->
<div class="container my-5">
    <h4 class="mb-3">Sản phẩm liên quan</h4>
    <div class="row">
        {foreach from=$related_products item=rel}
        <div class="col-xl-3 col-lg-3 col-md-4 col-sm-6 mb-4">
            <div class="card h-100">
                <a href="/?c=product&v=detail&id={$rel.id}">
                    {if $rel.file_url}
                        <img src="/public/img/products/{$rel.file_url}?t={$smarty.now}" 
                             alt="{$rel.name}" 
                             class="card-img-top" 
                             style="height:180px;object-fit:cover;">
                    {else}
                        <div class="card-img-top d-flex align-items-center justify-content-center bg-light" 
                             style="height:180px;">
                            <i class="bi bi-image text-muted" style="font-size: 2rem;"></i>
                        </div>
                    {/if}
                </a>
                <div class="card-body text-center">
                    <a href="/?c=product&v=detail&id={$rel.id}" class="text-decoration-none text-dark">
                        <h6 class="card-title">{$rel.name}</h6>
                    </a>
                    <div class="text-danger fw-bold">{number_format($rel.price,0,',','.')}₫</div>
                </div>
            </div>
        </div>
        {/foreach}
    </div>
</div>

{include file="include/user/footer.tpl"}