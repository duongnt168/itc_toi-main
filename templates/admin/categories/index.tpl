{assign var="page_title" value="Quản lý danh mục"}
{include file="include/admin/header.tpl"}

<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Danh sách danh mục</h5>
                    <a href="/?c=admin&a=addCategory" class="btn btn-primary">
                        <i class="bi bi-plus-circle"></i> Thêm danh mục
                    </a>
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
                    
                    <div class="table-responsive">
                        <table class="table table-striped table-hover">
                            <thead class="table-dark">
                                <tr>
                                    <th>ID</th>
                                    <th>Hình ảnh</th>
                                    <th>Tên danh mục</th>
                                    <th>Mô tả</th>
                                    <th>Trạng thái</th>
                                    <th>Ngày tạo</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                {if $categories}
                                    {foreach $categories as $category}
                                        <tr>
                                            <td>{$category.id}</td>
                                            <td>
                                                {if $category.image}
                                                    <img src="/public/img/categories/{$category.image}?t={$smarty.now}" 
                                                         alt="{$category.name}" 
                                                         class="img-thumbnail" 
                                                         style="width: 50px; height: 50px; object-fit: cover;">
                                                {else}
                                                    <div class="bg-light d-flex align-items-center justify-content-center" 
                                                         style="width: 50px; height: 50px;">
                                                        <i class="bi bi-image text-muted"></i>
                                                    </div>
                                                {/if}
                                            </td>
                                            <td><strong>{$category.name}</strong></td>
                                            <td>{$category.description|truncate:50}</td>
                                            <td>
                                                <span class="badge {if $category.status == 'active'}bg-success{else}bg-secondary{/if}">
                                                    {$category.status|capitalize}
                                                </span>
                                            </td>
                                            <td>{$category.created_at|date_format:'%d/%m/%Y %H:%M'}</td>
                                            <td>
                                                <div class="btn-group" role="group">
                                                    <a href="/?c=admin&a=viewCategory&id={$category.id}" class="btn btn-sm btn-outline-info">
                                                        <i class="bi bi-eye"></i>
                                                    </a>
                                                    <a href="/?c=admin&a=editCategory&id={$category.id}" class="btn btn-sm btn-outline-primary">
                                                        <i class="bi bi-pencil"></i>
                                                    </a>
                                                    <a href="/?c=admin&a=deleteCategory&id={$category.id}" 
                                                       class="btn btn-sm btn-outline-danger"
                                                       onclick="return confirm('Bạn có chắc chắn muốn xóa danh mục này?')">
                                                        <i class="bi bi-trash"></i>
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    {/foreach}
                                {else}
                                    <tr>
                                        <td colspan="7" class="text-center">Không có danh mục nào</td>
                                    </tr>
                                {/if}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

{include file="include/admin/footer.tpl"}