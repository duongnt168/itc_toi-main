{assign var="page_title" value="Quản lý sản phẩm"}
{include file="include/admin/header.tpl"}

<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Danh sách sản phẩm</h5>
                    <div class="d-flex gap-2">
                        <div class="btn-group" role="group" aria-label="View toggle">
                            <button type="button" class="btn btn-outline-secondary" id="listViewBtn" onclick="toggleView('list')">
                                <i class="bi bi-list"></i>
                            </button>
                            <button type="button" class="btn btn-outline-secondary" id="gridViewBtn" onclick="toggleView('grid')">
                                <i class="bi bi-grid-3x3-gap"></i>
                            </button>
                        </div>
                        <a href="/?c=admin&a=addProduct" class="btn btn-primary">
                            <i class="bi bi-plus-circle"></i> Thêm sản phẩm
                        </a>
                    </div>
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
                        <div class="col-md-4">
                            <select class="form-select" id="categoryFilter" onchange="filterProducts()">
                                <option value="">Tất cả danh mục</option>
                                {if $categories}
                                    {foreach $categories as $cat}
                                        <option value="{$cat.id}" {if isset($smarty.get.category) && $smarty.get.category == $cat.id}selected{/if}>
                                    {$cat.name}
                                </option>
                                    {/foreach}
                                {/if}
                            </select>
                        </div>
                        <div class="col-md-4">
                            <select class="form-select" id="statusFilter" onchange="filterProducts()">
                                <option value="">Tất cả trạng thái</option>
                                <option value="active" {if isset($smarty.get.status) && $smarty.get.status == 'active'}selected{/if}>Hoạt động</option>
                                <option value="inactive" {if isset($smarty.get.status) && $smarty.get.status == 'inactive'}selected{/if}>Không hoạt động</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <div class="input-group">
                                <input type="text" class="form-control" id="searchInput" 
                                       placeholder="Tìm kiếm sản phẩm..." value="{if isset($smarty.get.search)}{$smarty.get.search}{/if}">
                                <button class="btn btn-outline-secondary" type="button" onclick="filterProducts()">
                                    <i class="bi bi-search"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <div id="listView" class="table-responsive" style="display: none;">
                        <table class="table table-striped table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Hình ảnh</th>
                                    <th>Tên sản phẩm</th>
                                    <th>Danh mục</th>
                                    <th>Giá</th>
                                    <th>Tồn kho</th>
                                    <th>Trạng thái</th>
                                    <th>Ngày tạo</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                {if $products}
                                    {foreach $products as $product}
                                        <tr>
                                            <td>{$product.id}</td>
                                            <td>
                                                {if $product.file_url}
                                                    <img src="/public/img/products/{$product.file_url}?t={$smarty.now}" 
                                                         alt="{$product.name}" 
                                                         class="img-thumbnail" 
                                                         style="width: 50px; height: 50px; object-fit: cover;">
                                                {else}
                                                    <div class="bg-light d-flex align-items-center justify-content-center" 
                                                         style="width: 50px; height: 50px;">
                                                        <i class="bi bi-image text-muted"></i>
                                                    </div>
                                                {/if}
                                            </td>
                                            <td>
                                                <strong>{$product.name}</strong>
                                                <br>
                                                <small class="text-muted">{$product.description|truncate:30}</small>
                                            </td>
                                            <td>{$product.category_name}</td>
                                            <td>
                                                <strong>{$product.price|number_format:0:',':'.'} VNĐ</strong>
                                                {if $product.old_price && $product.old_price > 0}
                                                    <br>
                                                    <small class="text-muted text-decoration-line-through">{$product.old_price|number_format:0:',':'.'} VNĐ</small>
                                                {/if}
                                            </td>
                                            <td>
                                                <span class="badge bg-secondary">
                                    {$product.stock}
                                </span>
                                            </td>
                                            <td>
                                                <span class="badge {if $product.status == 'active'}bg-primary{else}bg-secondary{/if}">
                                    {$product.status|capitalize}
                                </span>
                                            </td>
                                            <td>{$product.created_at|date_format:'%d/%m/%Y'}</td>
                                            <td>
                                                <div class="btn-group" role="group">
                                                    <a href="/?c=admin&a=viewProduct&id={$product.id}" class="btn btn-sm btn-outline-info">
                                                        <i class="bi bi-eye"></i>
                                                    </a>
                                                    <a href="/?c=admin&a=editProduct&id={$product.id}" class="btn btn-sm btn-outline-primary">
                                                        <i class="bi bi-pencil"></i>
                                                    </a>
                                                    <a href="/?c=admin&a=deleteProduct&id={$product.id}" 
                                                       class="btn btn-sm btn-outline-danger"
                                                       onclick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này?')">
                                                        <i class="bi bi-trash"></i>
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    {/foreach}
                                {else}
                                    <tr>
                                        <td colspan="9" class="text-center">Không có sản phẩm nào</td>
                                    </tr>
                                {/if}
                            </tbody>
                        </table>
                </div>
                
                <!-- Grid View -->
                 <div id="gridView" class="row">
                     {if $products}
                         {foreach $products as $product}
                         <div class="col-xl-3 col-lg-3 col-md-4 col-sm-6 mb-4">
                            <div class="card h-100">
                                <div class="position-relative">
                                    {if $product.file_url}
                                        <img src="/public/img/products/{$product.file_url}?t={$smarty.now}" class="card-img-top" style="height: 200px; object-fit: cover;" alt="{$product.name}">
                                    {else}
                                        <div class="card-img-top d-flex align-items-center justify-content-center bg-light" style="height: 200px;">
                                            <i class="bi bi-image text-muted" style="font-size: 3rem;"></i>
                                        </div>
                                    {/if}
                                    <div class="position-absolute top-0 end-0 p-2">
                                        {if $product.status == 'active'}
                                            <span class="badge bg-success">Hoạt động</span>
                                        {else}
                                            <span class="badge bg-danger">Không hoạt động</span>
                                        {/if}
                                    </div>
                                </div>
                                <div class="card-body d-flex flex-column">
                                    <h6 class="card-title">{$product.name}</h6>
                                    <p class="card-text text-muted small mb-1">ID: {$product.id}</p>
                                    <p class="card-text text-muted small mb-1">Danh mục: {$product.category_name}</p>
                                    <p class="card-text text-primary fw-bold">{$product.price|number_format:0:',':'.'} VNĐ</p>
                                    <p class="card-text small mb-2">Tồn kho: {$product.stock}</p>
                                    <div class="mt-auto">
                                        <div class="btn-group w-100" role="group">
                                            <a href="/?c=admin&a=viewProduct&id={$product.id}" class="btn btn-info btn-sm">
                                                <i class="bi bi-eye"></i>
                                            </a>
                                            <a href="/?c=admin&a=editProduct&id={$product.id}" class="btn btn-warning btn-sm">
                                                <i class="bi bi-pencil"></i>
                                            </a>
                                            <a href="/?c=admin&a=deleteProduct&id={$product.id}" class="btn btn-danger btn-sm" onclick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này?')">
                                                <i class="bi bi-trash"></i>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        {/foreach}
                    {else}
                        <div class="col-12">
                            <div class="text-center py-5">
                                <i class="bi bi-box text-muted" style="font-size: 3rem;"></i>
                                <p class="text-muted mt-2">Không có sản phẩm nào</p>
                            </div>
                        </div>
                    {/if}
                </div>
                
                {if $total_pages > 1}
                        <nav aria-label="Phân trang">
                            <ul class="pagination justify-content-center">
                                {if $current_page > 1}
                                    <li class="page-item">
                                        <a class="page-link" href="/?c=admin&a=products&page={$current_page-1}{if isset($smarty.get.category) && $smarty.get.category}&category={$smarty.get.category}{/if}{if isset($smarty.get.status) && $smarty.get.status}&status={$smarty.get.status}{/if}{if isset($smarty.get.search) && $smarty.get.search}&search={$smarty.get.search}{/if}">
                                            <i class="bi bi-chevron-left"></i>
                                        </a>
                                    </li>
                                {/if}
                                
                                {for $i=1 to $total_pages}
                                    <li class="page-item {if $i == $current_page}active{/if}">
                                        <a class="page-link" href="/?c=admin&a=products&page={$i}{if isset($smarty.get.category) && $smarty.get.category}&category={$smarty.get.category}{/if}{if isset($smarty.get.status) && $smarty.get.status}&status={$smarty.get.status}{/if}{if isset($smarty.get.search) && $smarty.get.search}&search={$smarty.get.search}{/if}">{$i}</a>
                                    </li>
                                {/for}
                                
                                {if $current_page < $total_pages}
                                    <li class="page-item">
                                        <a class="page-link" href="/?c=admin&a=products&page={$current_page+1}{if isset($smarty.get.category) && $smarty.get.category}&category={$smarty.get.category}{/if}{if isset($smarty.get.status) && $smarty.get.status}&status={$smarty.get.status}{/if}{if isset($smarty.get.search) && $smarty.get.search}&search={$smarty.get.search}{/if}">
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

<style>
.view-transition {
    transition: all 0.3s ease-in-out;
}

#gridView .card {
    transition: transform 0.2s ease-in-out;
}

#gridView .card:hover {
    transform: translateY(-5px);
    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
}

.btn-group .btn.active {
    background-color: #0d6efd;
    border-color: #0d6efd;
    color: white;
}
</style>

<script>
function filterProducts() {
    const category = document.getElementById('categoryFilter').value;
    const status = document.getElementById('statusFilter').value;
    const search = document.getElementById('searchInput').value;
    
    let url = '/?c=admin&a=products';
    const params = [];
    
    if (category) params.push('category=' + category);
    if (status) params.push('status=' + status);
    if (search) params.push('search=' + encodeURIComponent(search));
    
    if (params.length > 0) {
        url += '&' + params.join('&');
    }
    
    window.location.href = url;
}

function toggleView(viewType) {
    const listView = document.getElementById('listView');
    const gridView = document.getElementById('gridView');
    const listBtn = document.getElementById('listViewBtn');
    const gridBtn = document.getElementById('gridViewBtn');
    
    // Remove active class from both buttons
    listBtn.classList.remove('active');
    gridBtn.classList.remove('active');
    
    if (viewType === 'list') {
        listView.style.display = 'block';
        gridView.style.display = 'none';
        listBtn.classList.add('active');
        localStorage.setItem('productViewType', 'list');
    } else {
        listView.style.display = 'none';
        gridView.style.display = 'block';
        gridBtn.classList.add('active');
        localStorage.setItem('productViewType', 'grid');
    }
}

// Enter key support for search
document.getElementById('searchInput').addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
        filterProducts();
    }
});

// Initialize view based on saved preference or default to grid
document.addEventListener('DOMContentLoaded', function() {
    const savedView = localStorage.getItem('productViewType') || 'grid';
    toggleView(savedView);
});
</script>

{include file="include/admin/footer.tpl"}