<nav class="navbar navbar-expand-lg fixed-top bg-success ">
    <div class="container-fluid">
        <!-- Logo Section -->
        <a class="navbar-brand" href="/?c=user&v=index">
            <img src="public/img/logo1.webp" alt="AquaGarden Logo" style="width: 150px; height: auto;">
        </a>
        <!-- Search Bar Section (Centered) -->
        <div class="d-flex flex-grow-1 justify-content-center">
            <form class="d-flex" style="width: 70%; max-width: 500px;">
                <input class="form-control rounded-pill me-1" type="search" placeholder="Bạn cần tìm gì?" aria-label="Search">
                <button class="btn btn-light rounded-pill" type="submit">
                    <i class="bi bi-search"></i>
                </button>
            </form>
        </div>
        <!-- Navbar Toggler for Mobile (Moved to the Right End) -->
        <button class="navbar-toggler pe-0" type="button" data-bs-toggle="offcanvas" data-bs-target="#offcanvasNavbar" aria-controls="offcanvasNavbar" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <!-- Offcanvas Menu -->
        <div class="offcanvas offcanvas-end" tabindex="-1" id="offcanvasNavbar" aria-labelledby="offcanvasNavbarLabel">
            <div class="offcanvas-header">
                <h5 class="offcanvas-title" id="offcanvasNavbarLabel">Menu</h5>
                <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
            </div>
            <div class="offcanvas-body">
                <ul class="navbar-nav justify-content-center flex-grow-1 pe-3">
                    <li class="nav-item">
                        <a class="nav-link mx-lg-2 active" aria-current="page" href="/?c=user&v=index">Trang chủ</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link mx-lg-2" href="/?c=user&v=gioithieu">Giới thiệu</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link mx-lg-2" href="/?c=product&v=index">Sản phẩm</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link mx-lg-2" href="#">Tư vấn</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link mx-lg-2" href="/?c=user&v=orders">Đơn hàng</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link mx-lg-2" href="/?c=user&v=lienhe">Liên hệ</a>
                    </li>
                    <li class="nav-item position-relative">
                        <a href="/?c=cart&v=view" class="nav-link position-relative">
                            <i class="fa fa-shopping-cart fa-lg"></i>
                            {if isset($cart_items) && $cart_items|@count > 0}
                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size:0.8rem;">{$cart_items|@count}</span>
                            {/if}
                        </a>
                    </li>
                </ul>
                <!-- Icons Section (Heart and Cart) -->
                <div class="d-flex align-items-center me-3">
                    <a href="#" class="me-3"><i class="fa fa-heart text-danger"></i> </a>
                    {if isset($user_email) && $user_email}
                        <!-- Đã đăng nhập -->
                        <div class="dropdown d-inline-block user-info">
                            <a href="#" class="dropdown-toggle d-flex align-items-center text-light text-decoration-none" id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                {if isset($user_avatar) && $user_avatar}
                                    <img src="{$user_avatar}" alt="avatar" class="rounded-circle me-2" style="width:32px;height:32px;object-fit:cover;">
                                {else}
                                    <i class="fa fa-user-circle fa-2x me-2"></i>
                                {/if}
                                <span class="fw-bold">{if isset($user_name) && $user_name}{$user_name}{else}{$user_email}{/if}</span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                                <li><a class="dropdown-item" href="/user/profile">Tài khoản của tôi</a></li>
                                <li><a class="dropdown-item" href="/user/orders">Đơn hàng</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-danger" href="/?c=auth&v=logout">Đăng xuất</a></li>
                            </ul>
                        </div>
                    {else}
                        <!-- Chưa đăng nhập -->
                        <a href="/?c=auth&v=login" class="btn btn-light btn-sm me-2">Đăng nhập</a>
                        <a href="/?c=auth&v=register" class="btn btn-warning btn-sm">Đăng ký</a>
                    {/if}
                </div>
            </div>
        </div>
    </div>
</nav>
