{assign var="page_title" value="Quản lý đơn hàng"}
{include file="include/admin/header.tpl"}

<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Danh sách đơn hàng</h5>
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
                        <div class="col-md-3">
                            <select class="form-select" id="statusFilter" onchange="filterOrders()">
                                <option value="">Tất cả trạng thái</option>
                                <option value="pending" {if isset($smarty.get.status) && $smarty.get.status == 'pending'}selected{/if}>Chờ xử lý</option>
                                <option value="confirmed" {if isset($smarty.get.status) && $smarty.get.status == 'confirmed'}selected{/if}>Đã xác nhận</option>
                                <option value="shipping" {if isset($smarty.get.status) && $smarty.get.status == 'shipping'}selected{/if}>Đang giao</option>
                                <option value="delivered" {if isset($smarty.get.status) && $smarty.get.status == 'delivered'}selected{/if}>Đã giao</option>
                                <option value="cancelled" {if isset($smarty.get.status) && $smarty.get.status == 'cancelled'}selected{/if}>Đã hủy</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <input type="date" class="form-control" id="dateFrom" value="{if isset($smarty.get.date_from)}{$smarty.get.date_from}{/if}" onchange="filterOrders()">
                        </div>
                        <div class="col-md-3">
                            <input type="date" class="form-control" id="dateTo" value="{if isset($smarty.get.date_to)}{$smarty.get.date_to}{/if}" onchange="filterOrders()">
                        </div>
                        <div class="col-md-3">
                            <div class="input-group">
                                <input type="text" class="form-control" id="searchInput" 
                                       placeholder="Tìm kiếm đơn hàng..." value="{if isset($smarty.get.search)}{$smarty.get.search}{/if}">
                                <button class="btn btn-outline-secondary" type="button" onclick="filterOrders()">
                                    <i class="bi bi-search"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <div class="table-responsive">
                        <table class="table table-striped table-hover">
                            <thead class="table-dark">
                                <tr>
                                    <th>Mã đơn hàng</th>
                                    <th>Khách hàng</th>
                                    <th>Tổng tiền</th>
                                    <th>Trạng thái</th>
                                    <th>Phương thức thanh toán</th>
                                    <th>Ngày đặt</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                {if $orders}
                                    {foreach $orders as $order}
                                        <tr>
                                            <td><strong>#{$order.id}</strong></td>
                                            <td>
                                                <div>
                                                    <strong>{$order.username}</strong>
                                                    <br>
                                                    <small class="text-muted">{$order.email}</small>
                                                </div>
                                            </td>
                                            <td>
                                                <strong class="text-success">{$order.total|number_format:0:',':'.'} VNĐ</strong>
                                            </td>
                                            <td>
                                                <span class="badge 
                                                    {if $order.status == 'pending'}bg-warning
                                                    {elseif $order.status == 'confirmed'}bg-info
                                                    {elseif $order.status == 'shipping'}bg-primary
                                                    {elseif $order.status == 'delivered'}bg-success
                                                    {elseif $order.status == 'cancelled'}bg-danger
                                                    {else}bg-secondary{/if}">
                                                    {if $order.status == 'pending'}Chờ xử lý
                                                    {elseif $order.status == 'confirmed'}Đã xác nhận
                                                    {elseif $order.status == 'shipping'}Đang giao
                                                    {elseif $order.status == 'delivered'}Đã giao
                                                    {elseif $order.status == 'cancelled'}Đã hủy
                                                    {else}{$order.status|capitalize}{/if}
                                                </span>
                                            </td>
                                            <td>
                                                <span class="badge bg-secondary">
                                                    {if $order.payment_method == 'cod'}COD
                                                    {elseif $order.payment_method == 'bank_transfer'}Chuyển khoản
                                                    {elseif $order.payment_method == 'credit_card'}Thẻ tín dụng
                                                    {else}{$order.payment_method|capitalize}{/if}
                                                </span>
                                            </td>
                                            <td>{$order.created_at|date_format:'%d/%m/%Y %H:%M'}</td>
                                            <td>
                                                <div class="btn-group" role="group">
                                                    <a href="/?c=admin&a=viewOrder&id={$order.id}" class="btn btn-sm btn-outline-info">
                                                        <i class="bi bi-eye"></i>
                                                    </a>
                                                    <a href="/?c=admin&a=editOrder&id={$order.id}" class="btn btn-sm btn-outline-primary">
                                                        <i class="bi bi-pencil"></i>
                                                    </a>
                                                    {if $order.status == 'pending'}
                                                        <a href="/?c=admin&a=deleteOrder&id={$order.id}" 
                                                           class="btn btn-sm btn-outline-danger"
                                                           onclick="return confirm('Bạn có chắc chắn muốn xóa đơn hàng này?')">
                                                            <i class="bi bi-trash"></i>
                                                        </a>
                                                    {/if}
                                                </div>
                                            </td>
                                        </tr>
                                    {/foreach}
                                {else}
                                    <tr>
                                        <td colspan="7" class="text-center">Không có đơn hàng nào</td>
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
                                        <a class="page-link" href="/?c=admin&a=orders&page={$current_page-1}{if isset($smarty.get.status) && $smarty.get.status}&status={$smarty.get.status}{/if}{if isset($smarty.get.date_from) && $smarty.get.date_from}&date_from={$smarty.get.date_from}{/if}{if isset($smarty.get.date_to) && $smarty.get.date_to}&date_to={$smarty.get.date_to}{/if}{if isset($smarty.get.search) && $smarty.get.search}&search={$smarty.get.search}{/if}">
                                            <i class="bi bi-chevron-left"></i>
                                        </a>
                                    </li>
                                {/if}
                                
                                {for $i=1 to $total_pages}
                                    <li class="page-item {if $i == $current_page}active{/if}">
                                        <a class="page-link" href="/?c=admin&a=orders&page={$i}{if isset($smarty.get.status) && $smarty.get.status}&status={$smarty.get.status}{/if}{if isset($smarty.get.date_from) && $smarty.get.date_from}&date_from={$smarty.get.date_from}{/if}{if isset($smarty.get.date_to) && $smarty.get.date_to}&date_to={$smarty.get.date_to}{/if}{if isset($smarty.get.search) && $smarty.get.search}&search={$smarty.get.search}{/if}">{$i}</a>
                                    </li>
                                {/for}
                                
                                {if $current_page < $total_pages}
                                    <li class="page-item">
                                        <a class="page-link" href="/?c=admin&a=orders&page={$current_page+1}{if isset($smarty.get.status) && $smarty.get.status}&status={$smarty.get.status}{/if}{if isset($smarty.get.date_from) && $smarty.get.date_from}&date_from={$smarty.get.date_from}{/if}{if isset($smarty.get.date_to) && $smarty.get.date_to}&date_to={$smarty.get.date_to}{/if}{if isset($smarty.get.search) && $smarty.get.search}&search={$smarty.get.search}{/if}">
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

<script>
function filterOrders() {
    const status = document.getElementById('statusFilter').value;
    const dateFrom = document.getElementById('dateFrom').value;
    const dateTo = document.getElementById('dateTo').value;
    const search = document.getElementById('searchInput').value;
    
    let url = '/?c=admin&a=orders';
    const params = [];
    
    if (status) params.push('status=' + status);
    if (dateFrom) params.push('date_from=' + dateFrom);
    if (dateTo) params.push('date_to=' + dateTo);
    if (search) params.push('search=' + encodeURIComponent(search));
    
    if (params.length > 0) {
        url += '&' + params.join('&');
    }
    
    window.location.href = url;
}

// Enter key support for search
document.getElementById('searchInput').addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
        filterOrders();
    }
});
</script>

{include file="include/admin/footer.tpl"}