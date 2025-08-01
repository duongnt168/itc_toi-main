{assign var="page_title" value="Chỉnh sửa danh mục"}
{include file="include/admin/header.tpl"}

<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Chỉnh sửa danh mục</h5>
                    <a href="/?c=admin&a=categories" class="btn btn-secondary">
                        <i class="bi bi-arrow-left"></i> Quay lại
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
                    
                    <form method="POST" enctype="multipart/form-data">
                        <div class="row">
                            <div class="col-md-8">
                                <div class="mb-3">
                                    <label for="name" class="form-label">Tên danh mục <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="name" name="name" value="{$category.name|default:''}" required>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="description" class="form-label">Mô tả</label>
                                    <textarea class="form-control" id="description" name="description" rows="4">{$category.description|default:''}</textarea>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="image" class="form-label">Hình ảnh danh mục</label>
                                    <input type="file" class="form-control" id="image" name="image" accept="image/*">
                                    {if $category.image}
                                        <div class="mt-2">
                                            <img src="/public/img/categories/{$category.image}" alt="{$category.name}" class="img-thumbnail" style="max-width: 200px;">
                                            <p class="text-muted small mt-1">Hình ảnh hiện tại</p>
                                        </div>
                                    {/if}
                                </div>
                            </div>
                            
                            <div class="col-md-4">
                                <div class="mb-3">
                                    <label for="status" class="form-label">Trạng thái</label>
                                    <select class="form-select" id="status" name="status">
                                        <option value="active" {if $category.status == 'active'}selected{/if}>Hoạt động</option>
                                        <option value="inactive" {if $category.status == 'inactive'}selected{/if}>Không hoạt động</option>
                                    </select>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">Ngày tạo</label>
                                    <input type="text" class="form-control" value="{$category.created_at|default:''}" readonly>
                                </div>
                            </div>
                        </div>
                        
                        <div class="d-flex justify-content-end gap-2">
                            <a href="/?c=admin&a=categories" class="btn btn-secondary">Hủy</a>
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-check-circle"></i> Cập nhật
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

{include file="include/admin/footer.tpl"}