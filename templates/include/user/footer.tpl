<!-- Footer -->
<footer class="bg-success text-white py-5 mt-5">
    <div class="container">
        <div class="row gy-4">
            <div class="col-md-4 col-12 text-center">
                <h5 class="text-uppercase mb-4">Đăng ký nhận thông tin</h5>
                <p>Đăng ký để nhận ưu đãi đặc biệt các chương trình Khuyến Mãi AquaGarden</p>
                <form id="newsletter-form" action="/?c=newsletter&v=subscribe" method="POST">
                    <div class="input-group mb-4">
                        <input type="email" name="email" class="form-control rounded-pill" placeholder="Nhập email của bạn" required>
                        <button class="btn btn-warning rounded-pill ms-2" type="submit">Đăng ký</button>
                    </div>
                </form>
                <div id="newsletter-message" style="margin-top: 10px;"></div>
                <h5 class="text-uppercase mb-3">Chính sách</h5>
                <ul class="list-unstyled">
                    <li><a href="#" class="text-white text-decoration-none">Chính sách thanh toán</a></li>
                    <li><a href="#" class="text-white text-decoration-none">Chính sách vận chuyển</a></li>
                    <li><a href="#" class="text-white text-decoration-none">Chính sách kiểm hàng</a></li>
                    <li><a href="#" class="text-white text-decoration-none">Chính sách đổi trả</a></li>
                    <li><a href="#" class="text-white text-decoration-none">Chính sách bảo mật</a></li>
                </ul>
            </div>
            <div class="col-md-4 col-12 text-center">
                <img src="public/img/logo1.webp" alt="Logo AquaGarden" class="img-fluid mb-3" style="max-width: 200px;">
                <p>Hơn 10 năm trong ngành Cây cảnh, Aquagarden dẫn đầu trào lưu đem thiên nhiên vào không gian sống một cách hoàn hảo nhất!</p>
                <img src="public/img/ws3.jpg" alt="Nhân viên AquaGarden" class="img-fluid" style="max-width: 250px;">
            </div>
            <div class="col-md-4 col-12 text-center">
                <h5 class="text-uppercase mb-4">Liên hệ với chúng tôi</h5>
                <p class="mb-1">Hộ kinh doanh AquaGarden</p>
                <p class="mb-1">Giấy đăng ký kinh doanh số 41A8048483</p>
                <p class="mb-1">Địa chỉ: 12 Trịnh Đình Thảo</p>
                <p class="mb-1">Điện thoại: 058.8888.729</p>
                <h6 class="text-uppercase mt-4">Địa chỉ trên bản đồ</h6>
                <div class="ratio ratio-16x9" style="max-width: 300px; margin: 0 auto; border: 1px solid white; border-radius: 10px;">
                    <iframe src="https://www.google.com/maps/embed?pb=..." style="border:0;" allowfullscreen="" loading="lazy"></iframe>
                </div>
            </div>
        </div>
    </div>
</footer>

<!-- Copyright and Social -->
<div class="bg-dark text-light py-2">
    <div class="container">
        <div class="row gy-2 align-items-center">
            <div class="col-md-6 col-12 text-center text-md-start">
                <p class="mb-0">&copy; Bản quyền thuộc về Aquagarden | Cung cấp bởi Dương</p>
            </div>
            <div class="col-md-6 col-12 text-center text-md-end">
                <a href="#" class="text-light me-3"><i class="fab fa-facebook-f"></i></a>
                <a href="#" class="text-light me-3"><i class="fab fa-twitter"></i></a>
                <a href="#" class="text-light"><i class="fab fa-google"></i></a>
            </div>
        </div>
    </div>
</div>

<!-- JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/owl.carousel.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Owl Carousel
    $(".owl-carousel-products").owlCarousel({
        loop: true,
        margin: 15,
        nav: true,
        dots: true,
        autoplay: true,
        autoplayTimeout: 3000,
        autoplayHoverPause: true,
        responsive: {
            0: { items: 1 },
            576: { items: 2 },
            768: { items: 3 },
            1200: { items: 4 }
        }
    });

    // Countdown - chỉ chạy khi có elements countdown
    if (document.getElementById("hours") && document.getElementById("minutes") && document.getElementById("seconds")) {
        var countDownDate = new Date().getTime() + (1 * 60 * 60 * 1000);
        var x = setInterval(function () {
            var now = new Date().getTime();
            var distance = countDownDate - now;
            var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
            var seconds = Math.floor((distance % (1000 * 60)) / 1000);
            var hoursEl = document.getElementById("hours");
            var minutesEl = document.getElementById("minutes");
            var secondsEl = document.getElementById("seconds");
            if (hoursEl) hoursEl.innerHTML = ("0" + hours).slice(-2);
            if (minutesEl) minutesEl.innerHTML = ("0" + minutes).slice(-2);
            if (secondsEl) secondsEl.innerHTML = ("0" + seconds).slice(-2);
            if (distance < 0) {
                clearInterval(x);
                var hoursEl = document.getElementById("hours");
                var minutesEl = document.getElementById("minutes");
                var secondsEl = document.getElementById("seconds");
                if (hoursEl) hoursEl.innerHTML = "00";
                if (minutesEl) minutesEl.innerHTML = "00";
                if (secondsEl) secondsEl.innerHTML = "00";
            }
        }, 1000);
    }

    // Newsletter form submission
    $(document).ready(function() {
        $('#newsletter-form').on('submit', function(e) {
            e.preventDefault();
            
            var email = $('input[name="email"]').val();
            var messageDiv = $('#newsletter-message');
            
            // Reset message
            messageDiv.html('');
            
            // Show loading
            messageDiv.html('<div class="alert alert-info">Đang xử lý...</div>');
            
            $.ajax({
                url: '/?c=newsletter&v=subscribe',
                type: 'POST',
                data: { email: email },
                dataType: 'json',
                success: function(response) {
                    if (response.success) {
                        messageDiv.html('<div class="alert alert-success">' + response.message + '</div>');
                        $('#newsletter-form')[0].reset();
                    } else {
                        messageDiv.html('<div class="alert alert-danger">' + response.message + '</div>');
                    }
                },
                error: function() {
                    messageDiv.html('<div class="alert alert-danger">Có lỗi xảy ra. Vui lòng thử lại!</div>');
                }
            });
        });
    });
</script>
</body>
</html>
