{include file="include/user/header.tpl"}
{include file="include/user/navbar.tpl"}

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

<!-- Hero Section -->
<section class="hero-section" style="padding-top: 100px;">
    <div class="container">
        <div class="hero-content text-center">
            <h1>AquaGarden - Thiên Nhiên Trong Nhà</h1>
            <p>Hơn 19 năm trong ngành cây cảnh, dẫn đầu trào lưu đem thiên nhiên vào không gian sống</p>
            <a href="#products" class="btn btn-primary">Khám phá ngay</a>
        </div>
    </div>
</section>

<!-- Slide Banner -->
<div class="container-fluid" style="margin-top: 80px;">
    <div class="row">
        <img src="public/img/slide.png" class="img-fluid" alt="AquaGarden Slide Banner">
    </div>
</div>

<!-- Categories Section -->
<section class="categories-section">
    <div class="container mt-4">
        <h3 class="text-center">Danh mục sản phẩm</h3>
        <div class="border-top border-success-emphasis my-2" style="width: 80%; margin: auto;"></div>
        <div class="row justify-content-center">
{foreach from=$categories item=cat}
<div class="col-6 col-lg-2 col-md-3 mb-3">
    <a href="/?c=product&v=category&id={$cat.id}" class="text-decoration-none text-dark">
        <div class="card d-flex flex-column align-items-center justify-content-center text-center border-3 border-top-0 h-100">
            {if $cat.image}
                <img src="/public/img/categories/{$cat.image}?t={$smarty.now}" 
                     class="rounded-circle mx-auto d-block" 
                     style="width: 120px; height: 120px; object-fit: cover;" 
                     alt="{$cat.name}">
            {else}
                <div class="bg-light d-flex align-items-center justify-content-center rounded-circle mx-auto" 
                     style="width: 120px; height: 120px;">
                    <i class="bi bi-image text-muted" style="font-size: 2rem;"></i>
                </div>
            {/if}
            <div class="card-body p-2">
                <p class="card-text">{$cat.name}</p>
            </div>
        </div>
    </a>
</div>
{/foreach}
        </div>
    </div>
</section>

<!-- Featured Products -->
<section id="products" class="products-section">
    <div class="container">
        <h2 class="section-title">Sản Phẩm Nổi Bật</h2>
        <div class="row">
            {if isset($featured_products) && $featured_products}
                {foreach from=$featured_products item=product}
                <div class="col-xl-3 col-lg-3 col-md-4 col-sm-6 mb-4">
                    <div class="card product-card h-100">
                        <div class="position-relative">
                            <a href="/?c=product&v=detail&id={$product.id}">
                                {if $product.file_url}
                                    <img src="/public/img/products/{$product.file_url}?t={$smarty.now}" 
                                         alt="{$product.name}" 
                                         class="card-img-top img-fluid" 
                                         style="height: 200px; object-fit: cover;">
                                {else}
                                    <div class="card-img-top d-flex align-items-center justify-content-center bg-light" 
                                         style="height: 200px;">
                                        <i class="bi bi-image text-muted" style="font-size: 3rem;"></i>
                                    </div>
                                {/if}
                            </a>
                            {if $product.price < 1000000}
                            <span class="sale-badge position-absolute top-0 end-0 bg-danger text-white p-1 rounded">Sale</span>
                            {/if}
                        </div>
                        <div class="card-body text-center">
                            <a href="/?c=product&v=detail&id={$product.id}" class="text-decoration-none text-dark">
                                <h6 class="card-title">{$product.name}</h6>
                            </a>
                            <p class="text-muted">{$product.description|truncate:100}</p>
                            <div class="text-danger fw-bold">
                                {if $product.formatted_old_price}
                                    <span class="text-muted"><del>{$product.formatted_old_price}</del></span>
                                {/if}
                                {$product.formatted_price}
                            </div>
                            <form action="/?c=cart&v=add" method="post" class="mt-2">
                                <input type="hidden" name="product_id" value="{$product.id}">
                                <input type="hidden" name="quantity" value="1">
                                <button type="submit" class="btn btn-sm btn-success w-100">Thêm vào giỏ hàng</button>
                            </form>
                        </div>
                    </div>
                </div>
                {/foreach}
            {else}
                <div class="no-products">
                    <p>Chưa có sản phẩm nào</p>
                </div>
            {/if}
        </div>
    </div>
</section>

<!-- Sale Products (nếu có) -->
{if isset($sale_products) && $sale_products}
<section class="products-section">
    <div class="container">
        <h2 class="section-title">Sản Phẩm Khuyến Mãi</h2>
        <div class="row">
            {foreach from=$sale_products item=product}
            <div class="col-xl-3 col-lg-3 col-md-4 col-sm-6 mb-4">
                <div class="card product-card h-100">
                    <div class="position-relative">
                        <a href="/?c=product&v=detail&id={$product.id}">
                            {if $product.file_url}
                                <img src="/public/img/products/{$product.file_url}?t={$smarty.now}" 
                                     alt="{$product.name}" 
                                     class="card-img-top img-fluid" 
                                     style="height: 200px; object-fit: cover;">
                            {else}
                                <div class="card-img-top d-flex align-items-center justify-content-center bg-light" 
                                     style="height: 200px;">
                                    <i class="bi bi-image text-muted" style="font-size: 3rem;"></i>
                                </div>
                            {/if}
                        </a>
                        {if $product.price < 1000000}
                        <span class="sale-badge position-absolute top-0 end-0 bg-danger text-white p-1 rounded">Sale</span>
                        {/if}
                    </div>
                    <div class="card-body text-center">
                        <a href="/?c=product&v=detail&id={$product.id}" class="text-decoration-none text-dark">
                            <h6 class="card-title">{$product.name}</h6>
                        </a>
                        <p class="text-muted">{$product.description|truncate:100}</p>
                        <div class="text-danger fw-bold">
                            {if $product.formatted_old_price}
                                <span class="text-muted"><del>{$product.formatted_old_price}</del></span>
                            {/if}
                            {$product.formatted_price}
                        </div>
                        <form action="/?c=cart&v=add" method="post" class="mt-2">
                                 <input type="hidden" name="product_id" value="{$product.id}">
                                 <input type="hidden" name="quantity" value="1">
                                 <button type="submit" class="btn btn-success btn-sm w-100">Thêm vào giỏ hàng</button>
                             </form>
                    </div>
                </div>
            </div>
            {/foreach}
        </div>
    </div>
</section>
{/if}

<!-- Flash Sale/Carousel -->
<div class="container mt-4" style="border: 2px solid #e40d0d; padding: 10px; border-radius: 8px;">
    <div class="d-flex justify-content-center align-items-center mb-3">
        <h4 class="m-0 text-danger"> GIÁ HOT TRONG NGÀY</h4>
        <div class="text-danger d-flex align-items-center">
            <div class="bg-danger text-white px-2 py-1 mx-1 rounded" id="hours">00</div>
            <div class="mx-1">:</div>
            <div class="bg-danger text-white px-2 py-1 mx-1 rounded" id="minutes">00</div>
            <div class="mx-1">:</div>
            <div class="bg-danger text-white px-2 py-1 mx-1 rounded" id="seconds">00</div>
        </div>
    </div>
    <div class="owl-carousel owl-carousel-products">
        {foreach from=$flash_sale_products item=product}
        <div class="item">
            <div class="card product-card">
                <div class="position-absolute top-0 end-0 bg-danger text-white p-1 rounded">-{$product.discount}% OFF</div>
                <div class="position-relative">
                    {if isset($product.id)}
                    <a href="/?c=product&v=detail&id={$product.id}">
                        {if $product.file_url}
                            <img src="/public/img/products/{$product.file_url}?t={$smarty.now}" 
                                 class="card-img-top" 
                                 alt="{$product.name}" 
                                 style="height: 200px; object-fit: cover;">
                        {else}
                            <div class="card-img-top d-flex align-items-center justify-content-center bg-light" 
                                 style="height: 200px;">
                                <i class="bi bi-image text-muted" style="font-size: 3rem;"></i>
                            </div>
                        {/if}
                    </a>
                    {else}
                        {if $product.file_url}
                            <img src="/public/img/products/{$product.file_url}?t={$smarty.now}" 
                                 class="card-img-top" 
                                 alt="{$product.name}" 
                                 style="height: 200px; object-fit: cover;">
                        {else}
                            <div class="card-img-top d-flex align-items-center justify-content-center bg-light" 
                                 style="height: 200px;">
                                <i class="bi bi-image text-muted" style="font-size: 3rem;"></i>
                            </div>
                        {/if}
                    {/if}
                </div>
                <div class="card-body text-center">
                    {if isset($product.id)}
                    <a href="/?c=product&v=detail&id={$product.id}" class="text-decoration-none text-dark">
                        <p class="card-text">{$product.name}</p>
                    </a>
                    {else}
                        <p class="card-text">{$product.name}</p>
                    {/if}
                    <div class="text-muted">
                        {if $product.formatted_old_price}
                            <del>{$product.formatted_old_price}</del>
                        {/if}
                        <span class="fw-bold text-danger">{$product.formatted_price}</span>
                    </div>
                    <form action="/?c=cart&v=add" method="post" class="mt-2">
                        <input type="hidden" name="product_id" value="{$product.id}">
                        <input type="hidden" name="quantity" value="1">
                        <button type="submit" class="btn btn-sm btn-success w-100">Thêm vào giỏ hàng</button>
                    </form>
                </div>
            </div>
        </div>
        {/foreach}
    </div>
</div>

<!-- Banner nhỏ -->
<div class="container my-5">
    <div class="row justify-content-center">
        {foreach from=$banners item=banner}
        <div class="col-lg-6 col-md-6 col-6 mb-6">
            <a href="{$banner.link}" target="_blank">
                <div class="card">
                    <img src="{$banner.image}" class="img-fluid banner-img rounded" alt="{$banner.alt}">
                </div>
            </a>
        </div>
        {/foreach}
    </div>
</div>

<!-- News Section -->
<div class="container my-5">
    <h2 class="news-title text-center">Tin tức mới nhất</h2>
    <div class="row row-cols-1 row-cols-md-4 g-4">
        {foreach from=$news item=item}
        <div class="col">
            <div class="card news-card">
                <img src="{$item.image}" class="card-img-top" alt="{$item.title}">
                <div class="news-card-body">
                    <h5 class="news-card-title">{$item.title}</h5>
                    <p class="news-author">Tác giả: {$item.author} | {$item.date}</p>
                </div>
            </div>
        </div>
        {/foreach}
    </div>
</div>

{include file="include/user/footer.tpl"}
