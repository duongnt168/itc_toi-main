{include file="include/user/header.tpl"}
{include file="include/user/navbar.tpl"}

<div class="container my-5" style="padding-top: 100px;">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2><i class="fas fa-bell"></i> Thông báo & Liên hệ</h2>
        <a href="/?c=user&v=complaints" class="btn btn-outline-primary">
            <i class="fas fa-exclamation-triangle"></i> Xem khiếu nại
        </a>
    </div>

    {if isset($smarty.session.success)}
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle"></i> {$smarty.session.success}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    {/if}

    {if isset($smarty.session.error)}
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-circle"></i> {$smarty.session.error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    {/if}

    <div class="row">
        <div class="col-md-8">
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0"><i class="fas fa-comments"></i> Phản hồi từ Admin</h5>
                </div>
                <div class="card-body">
                    {if $notifications && count($notifications) > 0}
                        {foreach $notifications as $notification}
                        <div class="notification-item border-bottom pb-3 mb-3">
                            <div class="d-flex justify-content-between align-items-start">
                                <div class="flex-grow-1">
                                    <h6 class="text-primary mb-1">
                                        <i class="fas fa-exclamation-triangle"></i> 
                                        Khiếu nại #{$notification.id}: {$notification.title|escape}
                                    </h6>
                                    <div class="mb-2">
                                        <span class="badge bg-info">Đơn hàng #{$notification.order_id}</span>
                                        {if $notification.type == 'product'}
                                            <span class="badge bg-secondary">Sản phẩm</span>
                                        {elseif $notification.type == 'delivery'}
                                            <span class="badge bg-warning">Giao hàng</span>
                                        {elseif $notification.type == 'service'}
                                            <span class="badge bg-primary">Dịch vụ</span>
                                        {elseif $notification.type == 'payment'}
                                            <span class="badge bg-danger">Thanh toán</span>
                                        {else}
                                            <span class="badge bg-secondary">Khác</span>
                                        {/if}
                                        {if $notification.status == 'resolved'}
                                            <span class="badge bg-success">Đã giải quyết</span>
                                        {elseif $notification.status == 'processing'}
                                            <span class="badge bg-info">Đang xử lý</span>
                                        {else}
                                            <span class="badge bg-warning">Chờ xử lý</span>
                                        {/if}
                                    </div>
                                    <div class="admin-response bg-light p-3 rounded">
                                        <h6 class="text-success mb-2">
                                            <i class="fas fa-user-shield"></i> Phản hồi từ Admin:
                                        </h6>
                                        <p class="mb-0">{$notification.admin_response|nl2br|escape}</p>
                                    </div>
                                </div>
                                <div class="ms-3">
                                    <small class="text-muted">
                                        {$notification.updated_at|date_format:"%d/%m/%Y %H:%M"}
                                    </small>
                                </div>
                            </div>
                            <div class="mt-2">
                                <a href="/?c=user&v=complaint_detail&id={$notification.id}" class="btn btn-sm btn-outline-primary">
                                    <i class="fas fa-eye"></i> Xem chi tiết
                                </a>
                            </div>
                        </div>
                        {/foreach}
                    {else}
                        <div class="text-center py-4">
                            <div class="mb-3">
                                <i class="fas fa-inbox fa-3x text-muted"></i>
                            </div>
                            <h5 class="text-muted">Chưa có thông báo nào</h5>
                            <p class="text-muted">Khi admin phản hồi khiếu nại của bạn, thông báo sẽ hiển thị ở đây.</p>
                            <a href="/?c=user&v=complaints" class="btn btn-primary">
                                <i class="fas fa-plus"></i> Tạo khiếu nại mới
                            </a>
                        </div>
                    {/if}
                </div>
            </div>
        </div>
        
        <div class="col-md-4">
            <div class="card">
                <div class="card-header bg-info text-white">
                    <h6 class="mb-0"><i class="fas fa-info-circle"></i> Thông tin liên hệ</h6>
                </div>
                <div class="card-body">
                    <div class="contact-info">
                        <div class="mb-3">
                            <i class="fas fa-phone text-primary"></i>
                            <strong>Hotline:</strong><br>
                            <span>1900-1234</span>
                        </div>
                        <div class="mb-3">
                            <i class="fas fa-envelope text-primary"></i>
                            <strong>Email:</strong><br>
                            <span>support@aquagarden.com</span>
                        </div>
                        <div class="mb-3">
                            <i class="fas fa-clock text-primary"></i>
                            <strong>Giờ làm việc:</strong><br>
                            <span>8:00 - 17:00 (T2-T6)</span><br>
                            <span>8:00 - 12:00 (T7)</span>
                        </div>
                        <div class="mb-3">
                            <i class="fas fa-map-marker-alt text-primary"></i>
                            <strong>Địa chỉ:</strong><br>
                            <span>123 Đường ABC, Quận XYZ, TP.HCM</span>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="card mt-3">
                <div class="card-header bg-warning text-dark">
                    <h6 class="mb-0"><i class="fas fa-question-circle"></i> Hướng dẫn</h6>
                </div>
                <div class="card-body">
                    <ul class="list-unstyled">
                        <li class="mb-2">
                            <i class="fas fa-check text-success"></i>
                            Tạo khiếu nại từ trang đơn hàng
                        </li>
                        <li class="mb-2">
                            <i class="fas fa-check text-success"></i>
                            Theo dõi trạng thái xử lý
                        </li>
                        <li class="mb-2">
                            <i class="fas fa-check text-success"></i>
                            Nhận thông báo phản hồi tại đây
                        </li>
                        <li class="mb-2">
                            <i class="fas fa-check text-success"></i>
                            Liên hệ trực tiếp qua hotline
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

{include file="include/user/footer.tpl"}