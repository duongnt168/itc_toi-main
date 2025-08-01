{assign var="page_title" value="Quản lý người dùng"}
{include file="include/admin/header.tpl"}

<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Danh sách người dùng</h5>
                    <a href="/?c=admin&a=addUser" class="btn btn-primary">
                        <i class="bi bi-plus-circle"></i> Thêm người dùng
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
                                    <th>Tên đăng nhập</th>
                                    <th>Email</th>
                                    <th>Số điện thoại</th>
                                    <th>Vai trò</th>
                                    <th>Trạng thái</th>
                                    <th>Ngày tạo</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                {if $users}
                                    {foreach $users as $user}
                                        <tr>
                                            <td>{$user.id}</td>
                                            <td>{$user.username}</td>
                                            <td>{$user.email}</td>
                                            <td>{$user.phone|default:'N/A'}</td>
                                            <td>
                                                <span class="badge {if $user.role == 'admin'}bg-danger{else}bg-primary{/if}">
                                                    {$user.role|capitalize}
                                                </span>
                                            </td>
                                            <td>
                                                <span class="badge {if $user.status == 'active'}bg-success{else}bg-secondary{/if}">
                                                    {$user.status|capitalize}
                                                </span>
                                            </td>
                                            <td>{$user.created_at|date_format:'%d/%m/%Y %H:%M'}</td>
                                            <td>
                                                <div class="btn-group" role="group">
                                                    <a href="/?c=admin&a=viewUser&id={$user.id}" class="btn btn-sm btn-outline-info">
                                                        <i class="bi bi-eye"></i>
                                                    </a>
                                                    <a href="/?c=admin&a=editUser&id={$user.id}" class="btn btn-sm btn-outline-primary">
                                                        <i class="bi bi-pencil"></i>
                                                    </a>
                                                    {if $user.role != 'admin'}
                                                        <a href="/?c=admin&a=deleteUser&id={$user.id}" 
                                                           class="btn btn-sm btn-outline-danger"
                                                           onclick="return confirm('Bạn có chắc chắn muốn xóa người dùng này?')">
                                                            <i class="bi bi-trash"></i>
                                                        </a>
                                                    {/if}
                                                </div>
                                            </td>
                                        </tr>
                                    {/foreach}
                                {else}
                                    <tr>
                                        <td colspan="8" class="text-center">Không có người dùng nào</td>
                                    </tr>
                                {/if}
                            </tbody>
                        </table>
                    </div>
                    
                    {if $total_pages > 1}
                        <nav aria-label="Phân trang">
                            <ul class="pagination justify-content-center">
                                {if $current_page > 1}
                                    <li class="page-item">
                                        <a class="page-link" href="/?c=admin&a=users&page={$current_page-1}">
                                            <i class="bi bi-chevron-left"></i>
                                        </a>
                                    </li>
                                {/if}
                                
                                {for $i=1 to $total_pages}
                                    <li class="page-item {if $i == $current_page}active{/if}">
                                        <a class="page-link" href="/?c=admin&a=users&page={$i}">{$i}</a>
                                    </li>
                                {/for}
                                
                                {if $current_page < $total_pages}
                                    <li class="page-item">
                                        <a class="page-link" href="/?c=admin&a=users&page={$current_page+1}">
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

{include file="include/admin/footer.tpl"}