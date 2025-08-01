{include file="include/user/header.tpl"}
{include file="include/user/navbar.tpl"}

<div class="container my-5" style="padding-top: 100px;">
    <h2 class="mb-4">Chi tiết đơn hàng #{$order.id}</h2>
    <div class="row mb-4">
        <div class="col-md-6">
            <ul class="list-group">
                <li class="list-group-item"><b>Ngày đặt:</b> {$order.created_at|date_format:"%d/%m/%Y %H:%M"}</li>
                <li class="list-group-item"><b>Trạng thái:</b> 
                    {if $order.status == 'pending'}
                        <span class="badge bg-warning text-dark">Chờ xử lý</span>
                    {elseif $order.status == 'confirmed'}
                        <span class="badge bg-info text-white">Đã xác nhận</span>
                    {elseif $order.status == 'shipping'}
                        <span class="badge bg-primary">Đang giao hàng</span>
                    {elseif $order.status == 'delivered'}
                        <span class="badge bg-success">Đã giao</span>
                    {elseif $order.status == 'completed'}
                        <span class="badge bg-success">Hoàn thành</span>
                    {elseif $order.status == 'cancelled'}
                        <span class="badge bg-danger">Đã hủy</span>
                    {else}
                        <span class="badge bg-secondary">{$order.status}</span>
                    {/if}
                </li>
                <li class="list-group-item"><b>Địa chỉ giao hàng:</b> {$order.shipping_address|escape}</li>
                <li class="list-group-item"><b>Số điện thoại:</b> {$order.phone|escape}</li>
                <li class="list-group-item"><b>Ghi chú:</b> {$order.note|escape}</li>
                {if isset($order.voucher_code) && $order.voucher_code}
                <li class="list-group-item"><b>Mã giảm giá:</b> <span class="badge bg-success">{$order.voucher_code}</span> (-{$order.voucher_discount|number_format:0:",":"."} đ)</li>
                {/if}
                <li class="list-group-item"><b>Phí vận chuyển:</b> <span class="text-muted">{$order.shipping_fee|number_format:0:",":"."}</span></li>
                <li class="list-group-item"><b>Tổng tiền:</b> <span class="text-danger fw-bold fs-5">{$order.total_amount|number_format:0:",":"."}</span></li>
            </ul>
        </div>
    </div>
    <h4>Sản phẩm trong đơn hàng</h4>
    <div class="alert alert-light">
        <i class="fas fa-info-circle"></i> Đơn hàng này có <strong>{$order_items|@count}</strong> sản phẩm
    </div>
    <table class="table table-bordered align-middle">
        <thead>
            <tr>
                <th>Ảnh</th>
                <th>Tên sản phẩm</th>
                <th>Giá</th>
                <th>Số lượng</th>
                <th>Thành tiền</th>
            </tr>
        </thead>
        <tbody>
            {foreach $order_items as $item}
            <tr>
                <td style="width:80px">
                    {if $item.image}
                        <img src="/public/img/products/{$item.image}" alt="{$item.name}" style="width:64px;height:64px;object-fit:cover;" class="rounded">
                    {else}
                        <div style="width:64px;height:64px;background:#f8f9fa;display:flex;align-items:center;justify-content:center;" class="rounded">
                            <i class="fas fa-image text-muted"></i>
                        </div>
                    {/if}
                </td>
                <td>{$item.name}</td>
                <td>{$item.price|number_format:0:",":"."}₫</td>
                <td>{$item.quantity}</td>
                <td>{($item.price * $item.quantity)|number_format:0:",":"."}₫</td>
            </tr>
            {/foreach}
        </tbody>
        <tfoot>
            <tr class="table-light">
                <td colspan="4" class="text-end fw-bold">Tổng tiền hàng:</td>
                <td class="fw-bold">
                    {assign var="subtotal" value=0}
                    {foreach $order_items as $item}
                        {assign var="subtotal" value=$subtotal + ($item.price * $item.quantity)}
                    {/foreach}
                    {$subtotal|number_format:0:",":"."}
                </td>
            </tr>
            {if isset($order.voucher_code) && $order.voucher_code}
            <tr class="table-light">
                <td colspan="4" class="text-end text-success">Giảm giá ({$order.voucher_code}):</td>
                <td class="text-success">-{$order.voucher_discount|number_format:0:",":"."}</td>
            </tr>
            {/if}
            <tr class="table-light">
                <td colspan="4" class="text-end">Phí vận chuyển:</td>
                <td>{$order.shipping_fee|number_format:0:",":"."}</td>
            </tr>
            <tr class="table-warning">
                <td colspan="4" class="text-end fw-bold fs-6">Tổng thanh toán:</td>
                <td class="fw-bold text-danger fs-6">{$order.total_amount|number_format:0:",":"."}</td>
            </tr>
        </tfoot>
    </table>
    
    <div class="d-flex gap-2 mt-3 flex-wrap">
        <a href="/?c=user&v=orders" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i> Quay lại danh sách đơn hàng
        </a>
        
        {* Nút hủy đơn hàng - chỉ hiện với đơn hàng pending *}
        {if $order.status == 'pending'}
            <a href="/?c=user&v=cancel_order&order_id={$order.id}" class="btn btn-outline-danger">
                <i class="fas fa-times"></i> Yêu cầu hủy đơn hàng
            </a>
        {/if}
        
        {* Nút đánh giá - chỉ hiện với đơn hàng delivered và chưa đánh giá *}
        {if $order.status == 'delivered'}
            {if !$has_review}
                <a href="/?c=user&v=create_review&order_id={$order.id}" class="btn btn-outline-success">
                    <i class="fas fa-star"></i> Đánh giá đơn hàng
                </a>
            {else}
                <span class="btn btn-success disabled">
                    <i class="fas fa-check"></i> Đã đánh giá
                </span>
            {/if}
            <button class="btn btn-outline-primary" onclick="alert('Chức năng mua lại sẽ được phát triển sau!')">
                <i class="fas fa-redo"></i> Mua lại
            </button>
        {/if}
        
        {* Nút khiếu nại - hiện với tất cả đơn hàng trừ cancelled *}
        {if $order.status != 'cancelled'}
            <a href="/?c=user&v=create_complaint&order_id={$order.id}" class="btn btn-outline-warning">
                <i class="fas fa-exclamation-triangle"></i> Khiếu nại
            </a>
        {/if}
    </div>
</div>

{include file="include/user/footer.tpl"}