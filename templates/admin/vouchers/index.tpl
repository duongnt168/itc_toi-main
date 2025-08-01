<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Voucher - Admin Panel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="/public/admin/style.css" rel="stylesheet">
</head>
<body>
    {include file="include/admin/header.tpl"}
    
    <div class="container-fluid">
        <div class="row">
            {include file="include/admin/sidebar.tpl"}
            
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2"><i class="fas fa-ticket-alt me-2"></i>Quản lý Voucher</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="/?c=admin&a=add_voucher" class="btn btn-primary">
                            <i class="fas fa-plus me-1"></i>Thêm Voucher
                        </a>
                    </div>
                </div>

                {if isset($smarty.session.success)}
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>{$smarty.session.success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                {/if}

                {if isset($smarty.session.error)}
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>{$smarty.session.error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                {/if}

                <!-- Filter -->
                <div class="card mb-4">
                    <div class="card-body">
                        <form method="GET" class="row g-3">
                            <input type="hidden" name="c" value="admin">
                            <input type="hidden" name="a" value="vouchers">
                            <div class="col-md-3">
                                <label class="form-label">Trạng thái</label>
                                <select name="status" class="form-select">
                                    <option value="">Tất cả</option>
                                    <option value="active" {if $filter_status == 'active'}selected{/if}>Hoạt động</option>
                                    <option value="inactive" {if $filter_status == 'inactive'}selected{/if}>Không hoạt động</option>
                                    <option value="expired" {if $filter_status == 'expired'}selected{/if}>Hết hạn</option>
                                </select>
                            </div>
                            <div class="col-md-3 d-flex align-items-end">
                                <button type="submit" class="btn btn-outline-primary me-2">
                                    <i class="fas fa-filter me-1"></i>Lọc
                                </button>
                                <a href="/?c=admin&a=vouchers" class="btn btn-outline-secondary">
                                    <i class="fas fa-times me-1"></i>Xóa lọc
                                </a>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Voucher List -->
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">Danh sách Voucher</h5>
                    </div>
                    <div class="card-body">
                        {if $vouchers}
                            <div class="table-responsive">
                                <table class="table table-striped table-hover">
                                    <thead class="table-dark">
                                        <tr>
                                            <th>ID</th>
                                            <th>Mã Voucher</th>
                                            <th>Loại</th>
                                            <th>Giá trị</th>
                                            <th>Đơn tối thiểu</th>
                                            <th>Số lần dùng</th>
                                            <th>Ngày bắt đầu</th>
                                            <th>Ngày kết thúc</th>
                                            <th>Trạng thái</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {foreach from=$vouchers item=voucher}
                                            <tr>
                                                <td><strong>#{$voucher.id}</strong></td>
                                                <td>
                                                    <span class="badge bg-primary">{$voucher.code}</span>
                                                </td>
                                                <td>
                                                    {if $voucher.type == 'percentage'}
                                                        <span class="badge bg-info">Phần trăm</span>
                                                    {else}
                                                        <span class="badge bg-warning">Số tiền</span>
                                                    {/if}
                                                </td>
                                                <td>
                                                    {if $voucher.type == 'percentage'}
                                                        {$voucher.value}%
                                                    {else}
                                                        {number_format($voucher.value, 0, ',', '.')} VNĐ
                                                    {/if}
                                                </td>
                                                <td>
                                                    {if $voucher.min_order_amount > 0}
                                                        {number_format($voucher.min_order_amount, 0, ',', '.')} VNĐ
                                                    {else}
                                                        Không
                                                    {/if}
                                                </td>
                                                <td>
                                                    {$voucher.used_count}
                                                    {if $voucher.max_uses}
                                                        / {$voucher.max_uses}
                                                    {else}
                                                        / Không giới hạn
                                                    {/if}
                                                </td>
                                                <td>
                                                    {if $voucher.start_date}
                                                        {$voucher.start_date|date_format:"%d/%m/%Y"}
                                                    {else}
                                                        Không giới hạn
                                                    {/if}
                                                </td>
                                                <td>
                                                    {if $voucher.end_date}
                                                        {$voucher.end_date|date_format:"%d/%m/%Y"}
                                                    {else}
                                                        Không giới hạn
                                                    {/if}
                                                </td>
                                                <td>
                                                    {if $voucher.status == 'active'}
                                                        <span class="badge bg-success">Hoạt động</span>
                                                    {elseif $voucher.status == 'inactive'}
                                                        <span class="badge bg-secondary">Không hoạt động</span>
                                                    {else}
                                                        <span class="badge bg-danger">Hết hạn</span>
                                                    {/if}
                                                </td>
                                                <td>
                                                    <div class="btn-group" role="group">
                                                        <a href="/?c=admin&a=edit_voucher&id={$voucher.id}" 
                                                           class="btn btn-sm btn-outline-primary" title="Sửa">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <button type="button" class="btn btn-sm btn-outline-danger" 
                                                                onclick="deleteVoucher({$voucher.id})" title="Xóa">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        {/foreach}
                                    </tbody>
                                </table>
                            </div>

                            <!-- Pagination -->
                            {if $total_pages > 1}
                                <nav aria-label="Voucher pagination">
                                    <ul class="pagination justify-content-center">
                                        {if $current_page > 1}
                                            <li class="page-item">
                                                <a class="page-link" href="/?c=admin&a=vouchers&page={$current_page-1}{if $filter_status}&status={$filter_status}{/if}">
                                                    <i class="fas fa-chevron-left"></i>
                                                </a>
                                            </li>
                                        {/if}
                                        
                                        {for $i=1 to $total_pages}
                                            <li class="page-item {if $i == $current_page}active{/if}">
                                                <a class="page-link" href="/?c=admin&a=vouchers&page={$i}{if $filter_status}&status={$filter_status}{/if}">{$i}</a>
                                            </li>
                                        {/for}
                                        
                                        {if $current_page < $total_pages}
                                            <li class="page-item">
                                                <a class="page-link" href="/?c=admin&a=vouchers&page={$current_page+1}{if $filter_status}&status={$filter_status}{/if}">
                                                    <i class="fas fa-chevron-right"></i>
                                                </a>
                                            </li>
                                        {/if}
                                    </ul>
                                </nav>
                            {/if}
                        {else}
                            <div class="text-center py-4">
                                <i class="fas fa-ticket-alt fa-3x text-muted mb-3"></i>
                                <h5 class="text-muted">Chưa có voucher nào</h5>
                                <p class="text-muted">Hãy thêm voucher đầu tiên để bắt đầu quản lý.</p>
                                <a href="/?c=admin&a=add_voucher" class="btn btn-primary">
                                    <i class="fas fa-plus me-1"></i>Thêm Voucher
                                </a>
                            </div>
                        {/if}
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Xác nhận xóa</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>Bạn có chắc chắn muốn xóa voucher này không?</p>
                    <p class="text-danger"><small>Hành động này không thể hoàn tác!</small></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <form id="deleteForm" method="POST" style="display: inline;">
                        <input type="hidden" name="id" id="deleteId">
                        <button type="submit" class="btn btn-danger">Xóa</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function deleteVoucher(id) {
            document.getElementById('deleteId').value = id;
            document.getElementById('deleteForm').action = '/?c=admin&a=delete_voucher';
            new bootstrap.Modal(document.getElementById('deleteModal')).show();
        }
    </script>
</body>
</html>