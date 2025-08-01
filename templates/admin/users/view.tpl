{assign var="page_title" value="Chi tiết người dùng"}
{include file="include/admin/header.tpl"}

<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Chi tiết người dùng #{$user.id}</h5>
                    <div>
                        {if $user.role != 'admin'}
                            <a href="/?c=admin&a=editUser&id={$user.id}" class="btn btn-primary me-2">
                                <i class="bi bi-pencil"></i> Chỉnh sửa
                            </a>
                        {/if}
                        <a href="/?c=admin&a=users" class="btn btn-secondary">
                            <i class="bi bi-arrow-left"></i> Quay lại
                        </a>
                    </div>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header">
                                    <h6>Thông tin cá nhân</h6>
                                </div>
                                <div class="card-body">
                                    <table class="table table-borderless">
                                        <tr>
                                            <td><strong>Tên đăng nhập:</strong></td>
                                            <td>{$user.username}</td>
                                        </tr>
                                        <tr>
                                            <td><strong>Email:</strong></td>
                                            <td>{$user.email}</td>
                                        </tr>
                                        <tr>
                                            <td><strong>Số điện thoại:</strong></td>
                                            <td>{$user.phone|default:'Chưa cập nhật'}</td>
                                        </tr>
                                        <tr>
                                            <td><strong>Địa chỉ:</strong></td>
                                            <td>{$user.address|default:'Chưa cập nhật'}</td>
                                        </tr>
                                        <tr>
                                            <td><strong>Vai trò:</strong></td>
                                            <td>
                                                <span class="badge {if $user.role == 'admin'}bg-danger{else}bg-primary{/if}">
                                                    {$user.role|capitalize}
                                                </span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><strong>Trạng thái:</strong></td>
                                            <td>
                                                <span class="badge {if $user.status == 'active'}bg-success{else}bg-secondary{/if}">
                                                    {$user.status|capitalize}
                                                </span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><strong>Ngày đăng ký:</strong></td>
                                            <td>{$user.created_at|date_format:'%d/%m/%Y %H:%M'}</td>
                                        </tr>
                                        <tr>
                                            <td><strong>Lần cập nhật cuối:</strong></td>
                                            <td>{$user.updated_at|date_format:'%d/%m/%Y %H:%M'}</td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header">
                                    <h6>Thống kê hoạt động</h6>
                                </div>
                                <div class="card-body">
                                    <div class="row text-center">
                                        <div class="col-6 mb-3">
                                            <div class="card bg-primary text-white">
                                                <div class="card-body">
                                                    <h4>{$user_stats.total_orders|default:0}</h4>
                                                    <small>Tổng đơn hàng</small>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-6 mb-3">
                                            <div class="card bg-success text-white">
                                                <div class="card-body">
                                                    <h4>{$user_stats.total_spent|number_format:0:',':'.'|default:0} VNĐ</h4>
                                                    <small>Tổng chi tiêu</small>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-6 mb-3">
                                            <div class="card bg-info text-white">
                                                <div class="card-body">
                                                    <h4>{$user_stats.total_reviews|default:0}</h4>
                                                    <small>Đánh giá đã viết</small>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-6 mb-3">
                                            <div class="card bg-warning text-white">
                                                <div class="card-body">
                                                    <h4>{$user_stats.avg_rating|string_format:"%.1f"|default:'0.0'}</h4>
                                                    <small>Đánh giá trung bình</small>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    {if $recent_orders}
                    <div class="row mt-4">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-header">
                                    <h6>Đơn hàng gần đây</h6>
                                </div>
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table table-striped">
                                            <thead>
                                                <tr>
                                                    <th>Mã đơn hàng</th>
                                                    <th>Tổng tiền</th>
                                                    <th>Trạng thái</th>
                                                    <th>Ngày đặt</th>
                                                    <th>Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                {foreach $recent_orders as $order}
                                                    <tr>
                                                        <td>#{$order.id}</td>
                                                        <td>{$order.total_amount|number_format:0:',':'.'} VNĐ</td>
                                                        <td>
                                                            <span class="badge {if $order.status == 'completed'}bg-success{elseif $order.status == 'pending'}bg-warning{elseif $order.status == 'processing'}bg-info{else}bg-danger{/if}">
                                                                {$order.status|capitalize}
                                                            </span>
                                                        </td>
                                                        <td>{$order.created_at|date_format:'%d/%m/%Y'}</td>
                                                        <td>
                                                            <a href="/?c=admin&a=viewOrder&id={$order.id}" class="btn btn-sm btn-outline-info">
                                                                <i class="bi bi-eye"></i>
                                                            </a>
                                                        </td>
                                                    </tr>
                                                {/foreach}
                                            </tbody>
                                        </table>
                                    </div>
                                    <div class="text-center">
                                        <a href="/?c=admin&a=orders&user_id={$user.id}" class="btn btn-outline-primary btn-sm">
                                            Xem tất cả đơn hàng
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    {/if}
                    
                    {if $recent_reviews}
                    <div class="row mt-4">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-header">
                                    <h6>Đánh giá gần đây</h6>
                                </div>
                                <div class="card-body">
                                    {foreach $recent_reviews as $review}
                                        <div class="border-bottom pb-3 mb-3">
                                            <div class="d-flex justify-content-between align-items-start">
                                                <div>
                                                    <strong>{$review.product_name}</strong>
                                                    <div class="text-warning">
                                                        {for $i=1 to 5}
                                                            {if $i <= $review.rating}
                                                                <i class="bi bi-star-fill"></i>
                                                            {else}
                                                                <i class="bi bi-star"></i>
                                                            {/if}
                                                        {/for}
                                                    </div>
                                                    <p class="mt-2 mb-1">{$review.comment}</p>
                                                </div>
                                                <div class="text-end">
                                                    <small class="text-muted">{$review.created_at|date_format:'%d/%m/%Y'}</small>
                                                    <br>
                                                    <span class="badge {if $review.status == 'approved'}bg-success{elseif $review.status == 'rejected'}bg-danger{else}bg-warning{/if}">
                                                        {$review.status|capitalize}
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                    {/foreach}
                                    <div class="text-center">
                                        <a href="/?c=admin&a=reviews&user_id={$user.id}" class="btn btn-outline-primary btn-sm">
                                            Xem tất cả đánh giá
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    {/if}
                </div>
            </div>
        </div>
    </div>
</div>

{include file="include/admin/footer.tpl"}