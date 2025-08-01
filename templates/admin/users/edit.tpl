{assign var="page_title" value="Chỉnh sửa người dùng"}
{include file="include/admin/header.tpl"}

<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Chỉnh sửa người dùng</h5>
                    <a href="/?c=admin&a=users" class="btn btn-secondary">
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
                    
                    <form method="POST">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="username" class="form-label">Tên đăng nhập <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="username" name="username" value="{$user.username|default:''}" required>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                                    <input type="email" class="form-control" id="email" name="email" value="{$user.email|default:''}" required>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="phone" class="form-label">Số điện thoại</label>
                                    <input type="text" class="form-control" id="phone" name="phone" value="{$user.phone|default:''}">
                                </div>
                                
                                <div class="mb-3">
                                    <label for="address" class="form-label">Địa chỉ</label>
                                    <textarea class="form-control" id="address" name="address" rows="3">{$user.address|default:''}</textarea>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="role" class="form-label">Vai trò</label>
                                    <select class="form-select" id="role" name="role">
                                        <option value="user" {if $user.role == 'user'}selected{/if}>Người dùng</option>
                                        <option value="admin" {if $user.role == 'admin'}selected{/if}>Quản trị viên</option>
                                    </select>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="status" class="form-label">Trạng thái</label>
                                    <select class="form-select" id="status" name="status">
                                        <option value="active" {if $user.status == 'active'}selected{/if}>Hoạt động</option>
                                        <option value="inactive" {if $user.status == 'inactive'}selected{/if}>Không hoạt động</option>
                                        <option value="banned" {if $user.status == 'banned'}selected{/if}>Bị cấm</option>
                                    </select>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="gender" class="form-label">Giới tính</label>
                                    <select class="form-select" id="gender" name="gender">
                                        <option value="" {if $user.gender == ''}selected{/if}>Không xác định</option>
                                        <option value="male" {if $user.gender == 'male'}selected{/if}>Nam</option>
                                        <option value="female" {if $user.gender == 'female'}selected{/if}>Nữ</option>
                                    </select>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">Ngày tạo</label>
                                    <input type="text" class="form-control" value="{$user.created_at|default:''}" readonly>
                                </div>
                            </div>
                        </div>
                        
                        <div class="d-flex justify-content-end gap-2">
                            <a href="/?c=admin&a=users" class="btn btn-secondary">Hủy</a>
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