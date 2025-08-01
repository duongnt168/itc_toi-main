{assign var="page_title" value="Thêm sản phẩm"}
{include file="include/admin/header.tpl"}

<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Thêm sản phẩm mới</h5>
                    <a href="/?c=admin&a=products" class="btn btn-secondary">
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
                                    <label for="name" class="form-label">Tên sản phẩm <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="name" name="name" required>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="description" class="form-label">Mô tả</label>
                                    <textarea class="form-control" id="description" name="description" rows="4"></textarea>
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="price" class="form-label">Giá bán <span class="text-danger">*</span></label>
                                            <input type="number" class="form-control" id="price" name="price" min="0" step="1000" required>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="old_price" class="form-label">Giá gốc</label>
                                            <input type="number" class="form-control" id="old_price" name="old_price" min="0" step="1000">
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="category_id" class="form-label">Danh mục <span class="text-danger">*</span></label>
                                            <select class="form-select" id="category_id" name="category_id" required>
                                                <option value="">Chọn danh mục</option>
                                                {if $categories}
                                                    {foreach $categories as $cat}
                                                        <option value="{$cat.id}">{$cat.name}</option>
                                                    {/foreach}
                                                {/if}
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="stock" class="form-label">Số lượng tồn kho <span class="text-danger">*</span></label>
                                            <input type="number" class="form-control" id="stock" name="stock" min="0" required>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="file_url" class="form-label">Hình ảnh chính</label>
                                    <input type="file" class="form-control" id="file_url" name="file_url" accept="image/*">
                                </div>
                                

                            </div>
                            
                            <div class="col-md-4">
                                <div class="mb-3">
                                    <label for="status" class="form-label">Trạng thái</label>
                                    <select class="form-select" id="status" name="status">
                                        <option value="active">Hoạt động</option>
                                        <option value="inactive">Không hoạt động</option>
                                    </select>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="discount" class="form-label">Giảm giá (%)</label>
                                    <input type="number" class="form-control" id="discount" name="discount" min="0" max="100" value="0">
                                </div>
                                
                                <div class="mb-3">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="is_featured" name="is_featured">
                                        <label class="form-check-label" for="is_featured">
                                            Sản phẩm nổi bật
                                        </label>
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="is_flash_sale" name="is_flash_sale">
                                        <label class="form-check-label" for="is_flash_sale">
                                            Flash Sale
                                        </label>
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="is_sale" name="is_sale">
                                        <label class="form-check-label" for="is_sale">
                                            Đang giảm giá
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="d-flex justify-content-end gap-2">
                            <a href="/?c=admin&a=products" class="btn btn-secondary">Hủy</a>
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-check-circle"></i> Thêm sản phẩm
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

{include file="include/admin/footer.tpl"}