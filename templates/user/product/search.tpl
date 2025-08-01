{include file="include/user/header.tpl"}
<link rel="stylesheet" href="/public/user/sp.css">
{include file="include/user/navbar.tpl"}

<div class="container text-center mt-5 pt-5 my-4">
    <h2 class="fw-bold">Kết quả tìm kiếm</h2>
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb justify-content-center">
            <li class="breadcrumb-item">
                <a href="/?c=user&v=index" class="text-dark fw-bold text-decoration-none">Trang chủ</a>
            </li>
            <li class="breadcrumb-item">
                <a href="/?c=product&v=index" class="text-dark fw-bold text-decoration-none">Sản phẩm</a>
            </li>
            <li class="breadcrumb-item active" aria-current="page">Tìm kiếm: "{$search_query}"</li>
        </ol>
    </nav>
    
    <p class="text-muted">Tìm thấy {if $products}{count($products)}{else}0{/if} sản phẩm cho từ khóa "{$search_query}"</p>
</div>

<div class="container my-5">
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
    {/if}
    
    {if isset($success)}
        <div class="alert alert-success">{$success}</div>
    {/if}
    
    {if $products && count($products) > 0}
        <div class="row">
            {foreach from=$products item=product}
                <div class="col-xl-3 col-lg-3 col-md-4 col-sm-6 mb-4">
                    <div class="card h-100 shadow-sm">
                        <div class="position-relative">
                            <img src="{if $product.file_url}/public/img/products/{$product.file_url}{else}/public/img/no-image.png{/if}" 
                                 class="card-img-top" alt="{$product.name}" style="height: 200px; object-fit: cover;">
                            {if $product.discount > 0}
                                <span class="badge bg-danger position-absolute top-0 end-0 m-2">-{$product.discount}%</span>
                            {/if}
                        </div>
                        <div class="card-body d-flex flex-column">
                            <h6 class="card-title">{$product.name}</h6>
                            <p class="card-text text-muted small flex-grow-1">{$product.description|truncate:80}</p>
                            <div class="mt-auto">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    {if $product.discount > 0}
                                        <div>
                                            <span class="text-decoration-line-through text-muted small">{$product.price|number_format:0:",":"."} đ</span><br>
                                            <span class="fw-bold text-danger">{($product.price * (100 - $product.discount) / 100)|number_format:0:",":"."} đ</span>
                                        </div>
                                    {else}
                                        <span class="fw-bold text-success">{$product.price|number_format:0:",":"."} đ</span>
                                    {/if}
                                    <small class="text-muted">Kho: {$product.stock}</small>
                                </div>
                                <div class="d-grid gap-2">
                                    <a href="/?c=product&v=detail&id={$product.id}" class="btn btn-outline-primary btn-sm">Xem chi tiết</a>
                                    {if $product.stock > 0}
                                        <button class="btn btn-success btn-sm" onclick="addToCart({$product.id})">Thêm vào giỏ</button>
                                    {else}
                                        <button class="btn btn-secondary btn-sm" disabled>Hết hàng</button>
                                    {/if}
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            {/foreach}
        </div>
        
        {* Pagination *}
        {if $total_pages > 1}
            <nav aria-label="Search pagination" class="mt-4">
                <ul class="pagination justify-content-center">
                    {if $current_page > 1}
                        <li class="page-item">
                            <a class="page-link" href="/?c=product&v=search&q={$search_query|urlencode}&page={$current_page-1}">Trước</a>
                        </li>
                    {/if}
                    
                    {for $i=1 to $total_pages}
                        {if $i == $current_page}
                            <li class="page-item active">
                                <span class="page-link">{$i}</span>
                            </li>
                        {else}
                            <li class="page-item">
                                <a class="page-link" href="/?c=product&v=search&q={$search_query|urlencode}&page={$i}">{$i}</a>
                            </li>
                        {/if}
                    {/for}
                    
                    {if $current_page < $total_pages}
                        <li class="page-item">
                            <a class="page-link" href="/?c=product&v=search&q={$search_query|urlencode}&page={$current_page+1}">Sau</a>
                        </li>
                    {/if}
                </ul>
            </nav>
        {/if}
    {else}
        <div class="text-center py-5">
            <h4>Không tìm thấy sản phẩm nào</h4>
            <p class="text-muted">Không có sản phẩm nào phù hợp với từ khóa "{$search_query}". Vui lòng thử lại với từ khóa khác.</p>
            <a href="/?c=product&v=index" class="btn btn-primary">Xem tất cả sản phẩm</a>
        </div>
    {/if}
</div>

{include file="include/user/footer.tpl"}

<script>
function addToCart(productId) {
    // Tạo form ẩn để gửi request
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = '/?c=cart&v=add';
    
    const productIdInput = document.createElement('input');
    productIdInput.type = 'hidden';
    productIdInput.name = 'product_id';
    productIdInput.value = productId;
    
    const quantityInput = document.createElement('input');
    quantityInput.type = 'hidden';
    quantityInput.name = 'quantity';
    quantityInput.value = '1';
    
    form.appendChild(productIdInput);
    form.appendChild(quantityInput);
    document.body.appendChild(form);
    form.submit();
}
</script>