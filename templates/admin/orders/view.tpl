{assign var="page_title" value="Chi tiết đơn hàng"}
{include file="include/admin/header.tpl"}

<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Chi tiết đơn hàng #{$order.id}</h5>
                    <a href="/?c=admin&a=orders" class="btn btn-secondary">
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
                    
                    <div class="row">
                        <div class="col-md-6">
                            <h6>Thông tin đơn hàng</h6>
                            <table class="table table-borderless">
                                <tr>
                                    <td><strong>Mã đơn hàng:</strong></td>
                                    <td>#{$order.id}</td>
                                </tr>
                                <tr>
                                    <td><strong>Ngày đặt:</strong></td>
                                    <td>{$order.created_at}</td>
                                </tr>
                                <tr>
                                    <td><strong>Trạng thái:</strong></td>
                                    <td>
                                        {if $order.status == 'pending'}
                                            <span class="badge bg-warning">Chờ xử lý</span>
                                        {elseif $order.status == 'processing'}
                                            <span class="badge bg-info">Đang xử lý</span>
                                        {elseif $order.status == 'shipped'}
                                            <span class="badge bg-primary">Đã gửi</span>
                                        {elseif $order.status == 'delivered'}
                                            <span class="badge bg-success">Đã giao</span>
                                        {elseif $order.status == 'cancelled'}
                                            <span class="badge bg-danger">Đã hủy</span>
                                        {/if}
                                    </td>
                                </tr>
                                <tr>
                                    <td><strong>Tổng tiền:</strong></td>
                                    <td><strong class="text-primary">{number_format($order.total)} VNĐ</strong></td>
                                </tr>
                            </table>
                        </div>
                        
                        <div class="col-md-6">
                            <h6>Thông tin khách hàng</h6>
                            <table class="table table-borderless">
                                <tr>
                                    <td><strong>Tên:</strong></td>
                                    <td>{$order.username}</td>
                                </tr>
                                <tr>
                                    <td><strong>Email:</strong></td>
                                    <td>{$order.email}</td>
                                </tr>
                                <tr>
                                    <td><strong>Số điện thoại:</strong></td>
                                    <td>{$order.phone}</td>
                                </tr>
                                <tr>
                                    <td><strong>Địa chỉ giao hàng:</strong></td>
                                    <td>{$order.shipping_address}</td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    
                    <hr>
                    
                    <h6>Chi tiết sản phẩm</h6>
                    <div class="table-responsive">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Sản phẩm</th>
                                    <th>Hình ảnh</th>
                                    <th>Giá</th>
                                    <th>Số lượng</th>
                                    <th>Thành tiền</th>
                                </tr>
                            </thead>
                            <tbody>
                                {if $order_items}
                                    {foreach $order_items as $item}
                                        <tr>
                                            <td>{$item.product_name}</td>
                                            <td>
                                                {if $item.product_file_url}
                                                    <img src="/public/img/products/{$item.product_file_url}?t={$smarty.now}" alt="{$item.product_name}" style="width: 50px; height: 50px; object-fit: cover;" class="rounded">
                                                {else}
                                                    <div class="bg-light d-flex align-items-center justify-content-center" style="width: 50px; height: 50px; border-radius: 4px;">
                                                        <i class="bi bi-image text-muted"></i>
                                                    </div>
                                                {/if}
                                            </td>
                                            <td>{number_format($item.price)} VNĐ</td>
                                            <td>{$item.quantity}</td>
                                            <td><strong>{number_format($item.price * $item.quantity)} VNĐ</strong></td>
                                        </tr>
                                    {/foreach}
                                {else}
                                    <tr>
                                        <td colspan="5" class="text-center text-muted">Không có sản phẩm nào</td>
                                    </tr>
                                {/if}
                            </tbody>
                        </table>
                    </div>
                    
                    <hr>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <h6>Cập nhật trạng thái</h6>
                            <form method="POST" action="/?c=admin&a=updateOrderStatus">
                                <input type="hidden" name="order_id" value="{$order.id}">
                                <div class="mb-3">
                                    <select class="form-select" name="status">
                                        <option value="pending" {if $order.status == 'pending'}selected{/if}>Chờ xử lý</option>
                                        <option value="processing" {if $order.status == 'processing'}selected{/if}>Đang xử lý</option>
                                        <option value="shipped" {if $order.status == 'shipped'}selected{/if}>Đã gửi</option>
                                        <option value="delivered" {if $order.status == 'delivered'}selected{/if}>Đã giao</option>
                                        <option value="cancelled" {if $order.status == 'cancelled'}selected{/if}>Đã hủy</option>
                                    </select>
                                </div>
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-check-circle"></i> Cập nhật trạng thái
                                </button>
                            </form>
                        </div>
                        
                        <div class="col-md-6 text-end">
                            <div class="d-flex justify-content-end gap-2">
                                <button class="btn btn-outline-primary" onclick="window.print()">
                                    <i class="bi bi-printer"></i> In đơn hàng
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

{include file="include/admin/footer.tpl"}