<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AquaGarden Admin Panel</title>
    <link rel="stylesheet" href="/public/admin/style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

    <script>
        // Auto-hide success alerts after 3 seconds
        document.addEventListener('DOMContentLoaded', function() {
            const successAlerts = document.querySelectorAll('.alert-success');
            successAlerts.forEach(function(alert) {
                setTimeout(function() {
                    if (alert && alert.parentNode) {
                        alert.style.transition = 'opacity 0.5s ease-out';
                        alert.style.opacity = '0';
                        setTimeout(function() {
                            if (alert && alert.parentNode) {
                                alert.remove();
                            }
                        }, 500);
                    }
                }, 3000);
            });
        });
    </script>
</head>
<body>
<div class="sidebar d-flex flex-column">
    <div class="logo">
        <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
            <path d="M12 2C13.1 2 14 2.9 14 4C14 5.1 13.1 6 12 6C10.9 6 10 5.1 10 4C10 2.9 10.9 2 12 2ZM21 9V7L15 1H5C3.89 1 3 1.89 3 3V21C3 22.11 3.89 23 5 23H19C20.11 23 21 22.11 21 21V9M19 21H5V3H13V9H19Z"/>
        </svg>
        AquaGarden Admin
    </div>
    <nav class="nav-container">
        <a class="nav-link{if $smarty.get.a == 'dashboard'} active{/if}" href="/?c=admin&a=dashboard"><i class="bi bi-speedometer2"></i> <span>Dashboard</span></a>
        <a class="nav-link{if $smarty.get.a == 'products'} active{/if}" href="/?c=admin&a=products"><i class="bi bi-box-seam"></i> <span>Quản lý sản phẩm</span></a>
        <a class="nav-link{if $smarty.get.a == 'orders'} active{/if}" href="/?c=admin&a=orders"><i class="bi bi-cart4"></i> <span>Quản lý đơn hàng</span></a>
        <a class="nav-link{if $smarty.get.a == 'users'} active{/if}" href="/?c=admin&a=users"><i class="bi bi-people"></i> <span>Quản lý người dùng</span></a>
        <a class="nav-link{if $smarty.get.a == 'categories'} active{/if}" href="/?c=admin&a=categories"><i class="bi bi-tags"></i> <span>Quản lý danh mục</span></a>
        <a class="nav-link{if $smarty.get.a == 'vouchers' || $smarty.get.a == 'add_voucher' || $smarty.get.a == 'edit_voucher'} active{/if}" href="/?c=admin&a=vouchers"><i class="bi bi-ticket-perforated"></i> <span>Quản lý voucher</span></a>
        <a class="nav-link{if $smarty.get.a == 'reviews'} active{/if}" href="/?c=admin&a=reviews"><i class="bi bi-chat-dots"></i> <span>Quản lý đánh giá</span></a>
        <a class="nav-link{if $smarty.get.a == 'complaints'} active{/if}" href="/?c=admin&a=complaints"><i class="bi bi-exclamation-triangle"></i> <span>Quản lý khiếu nại</span></a>
        <a class="nav-link{if $smarty.get.a == 'cancellations'} active{/if}" href="/?c=admin&a=cancellations"><i class="bi bi-x-circle"></i> <span>Yêu cầu hủy đơn</span></a>
    </nav>
    <div class="sidebar-bottom">
        <img src="/public/img/avatar_admin.png" class="avatar" alt="Admin">
        <div>Admin</div>
        <a href="/?c=admin&a=logout" class="btn btn-danger logout-btn"><i class="bi bi-box-arrow-right"></i> Đăng xuất</a>
    </div>
</div>
<div class="main-content">
    <div class="admin-header">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item"><a href="/?c=admin&a=dashboard">Admin</a></li>
                <li class="breadcrumb-item active" aria-current="page">{$page_title|default:$smarty.get.a|capitalize}</li>
            </ol>
        </nav>
        <div class="admin-info">
            <span class="fw-bold">Admin</span>
            <img src="/public/img/avatar_admin.png" class="avatar" alt="Admin">
        </div>
    </div>