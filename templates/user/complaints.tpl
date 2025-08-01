{include file="include/user/header.tpl"}
{include file="include/user/navbar.tpl"}

<div class="container my-5" style="padding-top: 100px;">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>Khiếu nại của tôi</h2>
        <a href="/?c=user&v=orders" class="btn btn-outline-primary">
            <i class="fas fa-arrow-left"></i> Quay lại đơn hàng
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

    {if $complaints && count($complaints) > 0}
        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>Mã khiếu nại</th>
                        <th>Đơn hàng</th>
                        <th>Loại khiếu nại</th>
                        <th>Tiêu đề</th>
                        <th>Ngày tạo</th>
                        <th>Trạng thái</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach $complaints as $complaint}
                    <tr>
                        <td><strong>#{$complaint.id}</strong></td>
                        <td>
                            <a href="/?c=user&v=order_detail&id={$complaint.order_id}" class="text-decoration-none">
                                #{$complaint.order_id}
                            </a>
                        </td>
                        <td>
                            {if $complaint.type == 'product'}
                                <span class="badge bg-info">Sản phẩm</span>
                            {elseif $complaint.type == 'delivery'}
                                <span class="badge bg-warning">Giao hàng</span>
                            {elseif $complaint.type == 'service'}
                                <span class="badge bg-primary">Dịch vụ</span>
                            {elseif $complaint.type == 'payment'}
                                <span class="badge bg-danger">Thanh toán</span>
                            {else}
                                <span class="badge bg-secondary">Khác</span>
                            {/if}
                        </td>
                        <td>
                            <div class="text-truncate" style="max-width: 200px;" title="{$complaint.title|escape}">
                                {$complaint.title|escape}
                            </div>
                        </td>
                        <td>{$complaint.created_at|date_format:"%d/%m/%Y %H:%M"}</td>
                        <td>
                            {if $complaint.status == 'pending'}
                                <span class="badge bg-warning text-dark">Chờ xử lý</span>
                            {elseif $complaint.status == 'processing'}
                                <span class="badge bg-info">Đang xử lý</span>
                            {elseif $complaint.status == 'resolved'}
                                <span class="badge bg-success">Đã giải quyết</span>
                            {elseif $complaint.status == 'closed'}
                                <span class="badge bg-secondary">Đã đóng</span>
                            {else}
                                <span class="badge bg-light text-dark">{$complaint.status}</span>
                            {/if}
                        </td>
                        <td>
                            <a href="/?c=user&v=complaint_detail&id={$complaint.id}" class="btn btn-sm btn-outline-primary">
                                <i class="fas fa-eye"></i> Xem chi tiết
                            </a>
                        </td>
                    </tr>
                    {/foreach}
                </tbody>
            </table>
        </div>

        {* Phân trang *}
        {if $total_pages > 1}
            <nav aria-label="Phân trang khiếu nại">
                <ul class="pagination justify-content-center">
                    {if $current_page > 1}
                        <li class="page-item">
                            <a class="page-link" href="/?c=user&v=complaints&page={$current_page-1}">
                                <i class="fas fa-chevron-left"></i> Trước
                            </a>
                        </li>
                    {/if}
                    
                    {for $i=1 to $total_pages}
                        {if $i == $current_page}
                            <li class="page-item active">
                                <span class="page-link">{$i}</span>
                            </li>
                        {else}
                            <li class="page-item">
                                <a class="page-link" href="/?c=user&v=complaints&page={$i}">{$i}</a>
                            </li>
                        {/if}
                    {/for}
                    
                    {if $current_page < $total_pages}
                        <li class="page-item">
                            <a class="page-link" href="/?c=user&v=complaints&page={$current_page+1}">
                                Sau <i class="fas fa-chevron-right"></i>
                            </a>
                        </li>
                    {/if}
                </ul>
            </nav>
        {/if}
    {else}
        <div class="text-center py-5">
            <div class="mb-4">
                <i class="fas fa-exclamation-triangle fa-4x text-muted"></i>
            </div>
            <h4 class="text-muted">Chưa có khiếu nại nào</h4>
            <p class="text-muted">Bạn chưa tạo khiếu nại nào. Nếu có vấn đề với đơn hàng, hãy tạo khiếu nại để được hỗ trợ.</p>
            <a href="/?c=user&v=orders" class="btn btn-primary">
                <i class="fas fa-shopping-bag"></i> Xem đơn hàng
            </a>
        </div>
    {/if}
</div>

{include file="include/user/footer.tpl"}