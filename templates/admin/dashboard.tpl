{assign var="page_title" value="Dashboard"}
{include file="include/admin/header.tpl"}

<div class="container-fluid p-4">
                <div class="row">
                    <div class="col-12">
                        <h1 class="h3 mb-4">Dashboard</h1>
                    </div>
                </div>
                
                <!-- Statistics Cards -->
                <div class="row mb-4">
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card border-left-primary shadow h-100 py-2">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                                            Tổng người dùng
                                        </div>
                                        <div class="h5 mb-0 font-weight-bold text-gray-800">{$stats.total_users}</div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-users fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card border-left-success shadow h-100 py-2">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                                            Tổng sản phẩm
                                        </div>
                                        <div class="h5 mb-0 font-weight-bold text-gray-800">{$stats.total_products}</div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-box fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card border-left-info shadow h-100 py-2">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-info text-uppercase mb-1">
                                            Tổng đơn hàng
                                        </div>
                                        <div class="h5 mb-0 font-weight-bold text-gray-800">{$stats.total_orders}</div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-shopping-cart fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card border-left-warning shadow h-100 py-2">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">
                                            Doanh thu
                                        </div>
                                        <div class="h5 mb-0 font-weight-bold text-gray-800">{$stats.total_revenue|number_format:0:",":"."}đ</div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-dollar-sign fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Recent Orders and Low Stock -->
                <div class="row">
                    <!-- Recent Orders -->
                    <div class="col-lg-6 mb-4">
                        <div class="card shadow">
                            <div class="card-header py-3">
                                <h6 class="m-0 font-weight-bold text-primary">Đơn hàng gần đây</h6>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-bordered">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Khách hàng</th>
                                                <th>Tổng tiền</th>
                                                <th>Trạng thái</th>
                                                <th>Ngày tạo</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            {foreach from=$stats.recent_orders item=order}
                                            <tr>
                                                <td>#{$order.id}</td>
                                                <td>{$order.username}</td>
                                                <td>{$order.total|number_format:0:",":"."}đ</td>
                                                <td>
                                                    {if $order.status == 'pending'}
                                                        <span class="badge bg-warning">Chờ xử lý</span>
                                                    {elseif $order.status == 'confirmed'}
                                                        <span class="badge bg-info">Đã xác nhận</span>
                                                    {elseif $order.status == 'shipping'}
                                                        <span class="badge bg-primary">Đang giao</span>
                                                    {elseif $order.status == 'delivered'}
                                                        <span class="badge bg-success">Đã giao</span>
                                                    {else}
                                                        <span class="badge bg-danger">Đã hủy</span>
                                                    {/if}
                                                </td>
                                                <td>{$order.created_at|date_format:"%d/%m/%Y"}</td>
                                            </tr>
                                            {/foreach}
                                        </tbody>
                                    </table>
                                </div>
                                <div class="text-center">
                                    <a href="/?c=admin&a=orders" class="btn btn-primary btn-sm">Xem tất cả đơn hàng</a>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Low Stock Products -->
                    <div class="col-lg-6 mb-4">
                        <div class="card shadow">
                            <div class="card-header py-3">
                                <h6 class="m-0 font-weight-bold text-danger">Sản phẩm sắp hết hàng</h6>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-bordered">
                                        <thead>
                                            <tr>
                                                <th>Tên sản phẩm</th>
                                                <th>Tồn kho</th>
                                                <th>Giá</th>
                                                <th>Trạng thái</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            {foreach from=$stats.low_stock_products item=product}
                                            <tr>
                                                <td>{$product.name}</td>
                                                <td>
                                                    <span class="badge bg-danger">{$product.stock}</span>
                                                </td>
                                                <td>{$product.price|number_format:0:",":"."}đ</td>
                                                <td>
                                                    {if $product.status == 'active'}
                                                        <span class="badge bg-success">Hoạt động</span>
                                                    {else}
                                                        <span class="badge bg-secondary">Không hoạt động</span>
                                                    {/if}
                                                </td>
                                            </tr>
                                            {/foreach}
                                        </tbody>
                                    </table>
                                </div>
                                <div class="text-center">
                                    <a href="/?c=admin&a=products" class="btn btn-primary btn-sm">Xem tất cả sản phẩm</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Success/Error Messages -->
{if isset($smarty.session.success)}
<div class="alert alert-success alert-dismissible fade show position-fixed" style="top: 20px; right: 20px; z-index: 9999;" role="alert">
    {$smarty.session.success}
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
</div>
{/if}

{if isset($smarty.session.error)}
<div class="alert alert-danger alert-dismissible fade show position-fixed" style="top: 20px; right: 20px; z-index: 9999;" role="alert">
    {$smarty.session.error}
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
</div>
{/if}

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(document).ready(function () {
        // Auto hide alerts after 5 seconds
        setTimeout(function() {
            $('.alert').fadeOut();
        }, 5000);
    });
</script>

{include file="include/admin/footer.tpl"}