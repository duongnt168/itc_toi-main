{assign var="page_title" value="Báo cáo thống kê"}
{include file="include/admin/header.tpl"}

<div class="container-fluid">
    <!-- Summary Cards -->
    <div class="row mb-4">
        <div class="col-md-3">
            <div class="card bg-primary text-white">
                <div class="card-body">
                    <div class="d-flex justify-content-between">
                        <div>
                            <h6 class="card-title">Doanh thu tháng này</h6>
                            <h4>{$monthly_revenue|number_format:0:',':'.'} VNĐ</h4>
                        </div>
                        <div class="align-self-center">
                            <i class="bi bi-currency-dollar fs-1"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-success text-white">
                <div class="card-body">
                    <div class="d-flex justify-content-between">
                        <div>
                            <h6 class="card-title">Đơn hàng tháng này</h6>
                            <h4>{$monthly_orders}</h4>
                        </div>
                        <div class="align-self-center">
                            <i class="bi bi-cart fs-1"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-info text-white">
                <div class="card-body">
                    <div class="d-flex justify-content-between">
                        <div>
                            <h6 class="card-title">Khách hàng mới</h6>
                            <h4>{$new_customers}</h4>
                        </div>
                        <div class="align-self-center">
                            <i class="bi bi-people fs-1"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-warning text-white">
                <div class="card-body">
                    <div class="d-flex justify-content-between">
                        <div>
                            <h6 class="card-title">Sản phẩm bán chạy</h6>
                            <h4>{$bestseller_count}</h4>
                        </div>
                        <div class="align-self-center">
                            <i class="bi bi-star fs-1"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <!-- Revenue Chart -->
        <div class="col-md-8">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Biểu đồ doanh thu 12 tháng gần đây</h5>
                </div>
                <div class="card-body">
                    <canvas id="revenueChart" height="100"></canvas>
                </div>
            </div>
        </div>
        
        <!-- Top Products -->
        <div class="col-md-4">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Sản phẩm bán chạy nhất</h5>
                </div>
                <div class="card-body">
                    {if $top_products}
                        {foreach $top_products as $product}
                            <div class="d-flex align-items-center mb-3">
                                {if $product.file_url}
                                    <img src="/public/img/products/{$product.file_url}" 
                                         alt="{$product.name}" 
                                         class="img-thumbnail me-3" 
                                         style="width: 50px; height: 50px; object-fit: cover;">
                                {else}
                                    <div class="bg-light d-flex align-items-center justify-content-center me-3" 
                                         style="width: 50px; height: 50px;">
                                        <i class="bi bi-image text-muted"></i>
                                    </div>
                                {/if}
                                <div class="flex-grow-1">
                                    <h6 class="mb-1">{$product.name}</h6>
                                    <small class="text-muted">Đã bán: {$product.total_sold} sản phẩm</small>
                                </div>
                            </div>
                        {/foreach}
                    {else}
                        <p class="text-muted">Chưa có dữ liệu</p>
                    {/if}
                </div>
            </div>
        </div>
    </div>

    <div class="row mt-4">
        <!-- Order Status Chart -->
        <div class="col-md-6">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Thống kê trạng thái đơn hàng</h5>
                </div>
                <div class="card-body">
                    <canvas id="orderStatusChart" height="150"></canvas>
                </div>
            </div>
        </div>
        
        <!-- Category Revenue -->
        <div class="col-md-6">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Doanh thu theo danh mục</h5>
                </div>
                <div class="card-body">
                    <canvas id="categoryRevenueChart" height="150"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- Recent Activity -->
    <div class="row mt-4">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Hoạt động gần đây</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Thời gian</th>
                                    <th>Hoạt động</th>
                                    <th>Người dùng</th>
                                    <th>Chi tiết</th>
                                </tr>
                            </thead>
                            <tbody>
                                {if $recent_activities}
                                    {foreach $recent_activities as $activity}
                                        <tr>
                                            <td>{$activity.created_at|date_format:'%d/%m/%Y %H:%M'}</td>
                                            <td>
                                                <span class="badge 
                                                    {if $activity.action == 'order_created'}bg-success
                                                    {elseif $activity.action == 'product_added'}bg-info
                                                    {elseif $activity.action == 'user_registered'}bg-primary
                                                    {else}bg-secondary{/if}">
                                                    {if $activity.action == 'order_created'}Đơn hàng mới
                                                    {elseif $activity.action == 'product_added'}Thêm sản phẩm
                                                    {elseif $activity.action == 'user_registered'}Đăng ký mới
                                                    {else}{$activity.action}{/if}
                                                </span>
                                            </td>
                                            <td>{$activity.username}</td>
                                            <td>{$activity.details}</td>
                                        </tr>
                                    {/foreach}
                                {else}
                                    <tr>
                                        <td colspan="4" class="text-center">Chưa có hoạt động nào</td>
                                    </tr>
                                {/if}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
// Revenue Chart
const revenueCtx = document.getElementById('revenueChart').getContext('2d');
const revenueChart = new Chart(revenueCtx, {
    type: 'line',
    data: {
        labels: {$revenue_labels|json_encode},
        datasets: [{
            label: 'Doanh thu (VNĐ)',
            data: {$revenue_data|json_encode},
            borderColor: 'rgb(75, 192, 192)',
            backgroundColor: 'rgba(75, 192, 192, 0.2)',
            tension: 0.1
        }]
    },
    options: {
        responsive: true,
        scales: {
            y: {
                beginAtZero: true,
                ticks: {
                    callback: function(value) {
                        return new Intl.NumberFormat('vi-VN').format(value) + ' VNĐ';
                    }
                }
            }
        }
    }
});

// Order Status Chart
const orderStatusCtx = document.getElementById('orderStatusChart').getContext('2d');
const orderStatusChart = new Chart(orderStatusCtx, {
    type: 'doughnut',
    data: {
        labels: {$order_status_labels|json_encode},
        datasets: [{
            data: {$order_status_data|json_encode},
            backgroundColor: [
                '#28a745',
                '#17a2b8',
                '#ffc107',
                '#dc3545',
                '#6c757d'
            ]
        }]
    },
    options: {
        responsive: true,
        plugins: {
            legend: {
                position: 'bottom'
            }
        }
    }
});

// Category Revenue Chart
const categoryRevenueCtx = document.getElementById('categoryRevenueChart').getContext('2d');
const categoryRevenueChart = new Chart(categoryRevenueCtx, {
    type: 'bar',
    data: {
        labels: {$category_labels|json_encode},
        datasets: [{
            label: 'Doanh thu (VNĐ)',
            data: {$category_revenue_data|json_encode},
            backgroundColor: 'rgba(54, 162, 235, 0.8)',
            borderColor: 'rgba(54, 162, 235, 1)',
            borderWidth: 1
        }]
    },
    options: {
        responsive: true,
        scales: {
            y: {
                beginAtZero: true,
                ticks: {
                    callback: function(value) {
                        return new Intl.NumberFormat('vi-VN').format(value) + ' VNĐ';
                    }
                }
            }
        }
    }
});
</script>

{include file="include/admin/footer.tpl"}