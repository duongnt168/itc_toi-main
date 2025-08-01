{include file="include/user/header.tpl"}
{include file="include/user/navbar.tpl"}

<div class="container my-5" style="padding-top: 100px;">
    <h2 class="mb-4">Đơn hàng của tôi</h2>
    {if $orders|@count == 0}
        <div class="alert alert-info">Bạn chưa có đơn hàng nào.</div>
    {else}
    <table class="table table-bordered align-middle">
        <thead>
            <tr>
                <th>Mã đơn</th>
                <th>Ngày đặt</th>
                <th>Số sản phẩm</th>
                <th>Voucher</th>
                <th>Tổng tiền</th>
                <th>Trạng thái</th>
                <th>Thao tác</th>
            </tr>
        </thead>
        <tbody>
            {foreach $orders as $order}
            <tr>
                <td><strong>#{$order.id}</strong></td>
                <td>{$order.created_at|date_format:"%d/%m/%Y %H:%M"}</td>
                <td><span class="badge bg-light text-dark">{$order.item_count} sản phẩm</span></td>
                <td>
                    {if isset($order.voucher_code) && $order.voucher_code}
                        <span class="badge bg-success">{$order.voucher_code}</span>
                        <br><small class="text-muted">-{$order.voucher_discount|number_format:0:",":"."} đ</small>
                    {else}
                        <span class="text-muted">Không có</span>
                    {/if}
                </td>
                <td><strong class="text-danger">{$order.total_amount|number_format:0:",":"."}</strong></td>
                <td>
                    {if $order.status == 'pending'}
                        <span class="badge bg-warning text-dark">Chờ xử lý</span>
                    {elseif $order.status == 'confirmed'}
                        <span class="badge bg-info text-white">Đã xác nhận</span>
                    {elseif $order.status == 'shipping'}
                        <span class="badge bg-primary">Đang giao hàng</span>
                    {elseif $order.status == 'completed'}
                        <span class="badge bg-success">Hoàn thành</span>
                    {elseif $order.status == 'cancelled'}
                        <span class="badge bg-danger">Đã hủy</span>
                    {else}
                        <span class="badge bg-secondary">{$order.status}</span>
                    {/if}
                </td>
                <td>
                    <a href="/?c=user&v=order_detail&id={$order.id}" class="btn btn-sm btn-outline-primary">
                        <i class="fas fa-eye"></i> Xem chi tiết
                    </a>
                </td>
            </tr>
            {/foreach}
        </tbody>
    </table>
    {/if}
</div>

{include file="include/user/footer.tpl"}