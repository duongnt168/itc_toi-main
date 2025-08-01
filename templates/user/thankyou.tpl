{include file="include/user/header.tpl"}
{include file="include/user/navbar.tpl"}

<div class="container my-4" style="padding-top: 100px;">
    <div class="row">
        <div class="col-12">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="/?c=user&v=index">Trang chủ</a></li>
                    <li class="breadcrumb-item"><a href="/?c=cart&v=index">Giỏ hàng</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Đặt hàng thành công</li>
                </ol>
            </nav>
        </div>
    </div>
    
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card shadow-sm">
                <div class="card-body text-center py-5">
                    <div class="mb-4">
                        <i class="fas fa-check-circle fa-5x text-success"></i>
                    </div>
                    <h2 class="text-success mb-3">Đặt hàng thành công!</h2>
                    <p class="lead mb-4">Cảm ơn bạn đã mua hàng tại AquaGarden.</p>
                    
                    {if isset($order)}
                    <div class="alert alert-info">
                        <h5><i class="fas fa-info-circle me-2"></i>Thông tin đơn hàng</h5>
                        <p class="mb-1"><strong>Mã đơn hàng:</strong> {$order.order_code}</p>
                        {if isset($order.voucher_code) && $order.voucher_code}
                        <p class="mb-1"><strong>Mã giảm giá:</strong> <span class="text-success">{$order.voucher_code}</span> (-{$order.voucher_discount|number_format:0:",":"."} đ)</p>
                        {/if}
                        <p class="mb-1"><strong>Tổng tiền:</strong> <span class="text-danger">{$order.total_amount|number_format:0:",":"."} đ</span></p>
                        <p class="mb-1"><strong>Địa chỉ giao hàng:</strong> {$order.shipping_address}</p>
                        <p class="mb-0"><strong>Số điện thoại:</strong> {$order.phone}</p>
                    </div>
                    {/if}
                    
                    <p class="mb-4">Chúng tôi sẽ liên hệ với bạn sớm nhất để xác nhận đơn hàng và thông báo thời gian giao hàng.</p>
                    
                    <div class="d-flex gap-3 justify-content-center flex-wrap">
                        <a href="/?c=user&v=index" class="btn btn-primary">
                            <i class="fas fa-home me-2"></i>Về trang chủ
                        </a>
                        <a href="/?c=order&v=history" class="btn btn-outline-secondary">
                            <i class="fas fa-history me-2"></i>Xem đơn hàng
                        </a>
                        <a href="/?c=user&v=index" class="btn btn-outline-success">
                            <i class="fas fa-shopping-bag me-2"></i>Tiếp tục mua sắm
                        </a>
                    </div>
                </div>
            </div>
            
            {if isset($order_items) && $order_items|@count > 0}
            <div class="card shadow-sm mt-4">
                <div class="card-header bg-success text-white">
                    <h5 class="mb-0"><i class="fas fa-list me-2"></i>Chi tiết đơn hàng</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th style="width: 80px;">Ảnh</th>
                                    <th>Tên sản phẩm</th>
                                    <th style="width: 100px;">Đơn giá</th>
                                    <th style="width: 80px;">Số lượng</th>
                                    <th style="width: 120px;">Thành tiền</th>
                                </tr>
                            </thead>
                            <tbody>
                                {foreach $order_items as $item}
                                <tr>
                                    <td>
                                        <img src="{if $item.file_url}/public/img/products/{$item.file_url}{else}/public/img/no-image.png{/if}" 
                                             alt="{$item.name}" 
                                             class="img-thumbnail" 
                                             style="width:60px;height:60px;object-fit:cover;">
                                    </td>
                                    <td>
                                        <h6 class="mb-0">{$item.name}</h6>
                                    </td>
                                    <td>
                                        <span class="fw-bold text-primary">{$item.price|number_format:0:",":"."} đ</span>
                                    </td>
                                    <td>
                                        <span class="badge bg-secondary">{$item.quantity}</span>
                                    </td>
                                    <td>
                                        <span class="fw-bold text-success">{($item.price * $item.quantity)|number_format:0:",":"."} đ</span>
                                    </td>
                                </tr>
                                {/foreach}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            {/if}
            
            <div class="card shadow-sm mt-4">
                <div class="card-body">
                    <h6 class="card-title"><i class="fas fa-info-circle me-2"></i>Thông tin quan trọng</h6>
                    <ul class="list-unstyled mb-0">
                        <li><i class="fas fa-clock text-primary me-2"></i>Thời gian giao hàng: 2-3 ngày làm việc</li>
                        <li><i class="fas fa-phone text-success me-2"></i>Hotline hỗ trợ: 058.8888.729</li>
                        <li><i class="fas fa-envelope text-info me-2"></i>Email: support@aquagarden.vn</li>
                        <li><i class="fas fa-shield-alt text-warning me-2"></i>Chính sách đổi trả trong vòng 7 ngày</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

{include file="include/user/footer.tpl"}