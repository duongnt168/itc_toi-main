{include file="include/user/header.tpl"}
<link rel="stylesheet" href="/public/user/sp.css">
{include file="include/user/navbar.tpl"}
<div class="container text-center mt-5 pt-5 my-4" style="padding-top: 100px;">
    <h2 class="fw-bold">Danh mục sản phẩm</h2>
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb justify-content-center">
            <li class="breadcrumb-item">
                <a href="/?c=user&v=index" class="text-dark fw-bold text-decoration-none">Trang chủ</a>
            </li>
            <li class="breadcrumb-item active" aria-current="page">Danh mục sản phẩm</li>
        </ol>
    </nav>
</div>
<div class="container mt-6">
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
    
    <div class="row">
        <!-- Sidebar: Danh mục và filter -->
        <div class="col-lg-3 col-md-4 mb-4">
            <div class="card mb-4">
                <div class="card-header fw-bold bg-success text-white">DANH MỤC SẢN PHẨM</div>
                <ul class="list-group list-group-flush">
                    {foreach from=$categories item=cat}
                        <li class="list-group-item d-flex justify-content-between align-items-center">
                            <a href="/?c=product&v=category&id={$cat.id}" class="text-dark text-decoration-none">{$cat.name}</a>
                        </li>
                    {/foreach}
                </ul>
            </div>
            <!-- Filter giữ nguyên, có thể bổ sung sau -->
        </div>
        <!-- Main Content: Product List -->
        <div class="col-lg-9 col-md-8">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="mb-0">Sắp xếp theo:</h5>
                <div>
                    <label>
                        <a href="/?c=product&v=index&sort=name_asc" class="text-dark text-decoration-none">
                            <input type="radio" name="sort" {if $sort=="name_asc"}checked{/if}> Tên A-Z
                        </a>
                    </label>
                    <label>
                        <a href="/?c=product&v=index&sort=name_desc" class="text-dark text-decoration-none">
                            <input type="radio" name="sort" {if $sort=="name_desc"}checked{/if}> Tên Z-A
                        </a>
                    </label>
                    <label>
                        <a href="/?c=product&v=index&sort=price_asc" class="text-dark text-decoration-none">
                            <input type="radio" name="sort" {if $sort=="price_asc"}checked{/if}> Giá thấp đến cao
                        </a>
                    </label>
                    <label>
                        <a href="/?c=product&v=index&sort=price_desc" class="text-dark text-decoration-none">
                            <input type="radio" name="sort" {if $sort=="price_desc"}checked{/if}> Giá cao đến thấp
                        </a>
                    </label>
                </div>
            </div>
            <div class="row g-3">
                {foreach from=$products item=product}
                <div class="col-xl-3 col-lg-3 col-md-4 col-sm-6 col-6">
                    <a href="/?c=product&v=detail&id={$product.id}" class="text-decoration-none">
                        <div class="card h-100 shadow-sm">
                            {if $product.file_url}
                                <img src="/public/img/products/{$product.file_url}?t={$smarty.now}" 
                                     alt="{$product.name}" 
                                     class="card-img-top" 
                                     style="height: 200px; object-fit: cover;">
                            {else}
                                <div class="card-img-top d-flex align-items-center justify-content-center bg-light" 
                                     style="height: 200px;">
                                    <i class="bi bi-image text-muted" style="font-size: 3rem;"></i>
                                </div>
                            {/if}
                            <div class="overlay-buttons">
                                <form method="post" action="/?c=cart&v=add">
                                    <input type="hidden" name="product_id" value="{$product.id}">
                                    <button type="submit" class="btn btn-cart"><i class="fas fa-shopping-cart"></i></button>
                                </form>
                                <button class="btn btn-wishlist"><i class="fas fa-heart"></i></button>
                            </div>
                            <div class="card-body text-center">
                                <h6 class="card-title text-dark">{$product.name}</h6>
                                <p class="card-text text-danger fw-bold">{$product.price|number_format:0:',':'.'}₫</p>
                            </div>
                        </div>
                    </a>
                </div>
                {/foreach}
            </div>
            <!-- Pagination -->
            <div class="mb-5 mt-5">
                <nav aria-label="Page navigation example">
                    <ul class="pagination justify-content-center">
                        {section name=page loop=$total_pages}
                            <li class="page-item {if $page == $smarty.section.page.index+1}active{/if}">
                                <a class="page-link" href="/?c=product&v=index&page={$smarty.section.page.index+1}">{$smarty.section.page.index+1}</a>
                            </li>
                        {/section}
                    </ul>
                </nav>
            </div>
        </div>
    </div>
</div>
{include file="include/user/footer.tpl"}