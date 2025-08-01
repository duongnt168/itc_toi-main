{include file="include/user/header.tpl"}
{include file="include/user/navbar.tpl"}

<div class="container my-5" style="padding-top: 100px;">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card shadow">
                <div class="card-header bg-success text-white">
                    <h4 class="mb-0">
                        <i class="fas fa-star"></i> Đánh giá đơn hàng
                    </h4>
                </div>
                <div class="card-body">
                    {if isset($smarty.session.error)}
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle"></i> {$smarty.session.error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    {/if}

                    {if isset($order)}
                        <div class="alert alert-info mb-4">
                            <h6><i class="fas fa-info-circle"></i> Thông tin đơn hàng</h6>
                            <p class="mb-1"><strong>Mã đơn hàng:</strong> #{$order.id}</p>
                            <p class="mb-1"><strong>Ngày đặt:</strong> {$order.created_at|date_format:"%d/%m/%Y %H:%M"}</p>
                            <p class="mb-0"><strong>Tổng tiền:</strong> {$order.total_amount|number_format:0:",":"."} VNĐ</p>
                        </div>
                    {/if}

                    <form method="POST" action="/?c=user&v=create_review" id="reviewForm">
                        {if isset($order)}
                            <input type="hidden" name="order_id" value="{$order.id}">
                        {else}
                            <div class="mb-3">
                                <label for="order_id" class="form-label">Mã đơn hàng <span class="text-danger">*</span></label>
                                <input type="number" class="form-control" id="order_id" name="order_id" required 
                                       placeholder="Nhập mã đơn hàng đã hoàn thành">
                                <div class="form-text">Chỉ có thể đánh giá đơn hàng đã hoàn thành</div>
                            </div>
                        {/if}

                        <div class="row mb-4">
                            <div class="col-md-4">
                                <div class="card border-warning">
                                    <div class="card-body text-center">
                                        <h6 class="card-title">Đánh giá tổng thể</h6>
                                        <div class="rating-stars mb-2" data-rating="rating">
                                            {for $i=1 to 5}
                                                <i class="far fa-star" data-value="{$i}"></i>
                                            {/for}
                                        </div>
                                        <input type="hidden" name="rating" id="rating" required>
                                        <div class="rating-text text-muted" id="rating-text">Chọn số sao</div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card border-info">
                                    <div class="card-body text-center">
                                        <h6 class="card-title">Đánh giá giao hàng</h6>
                                        <div class="rating-stars mb-2" data-rating="delivery_rating">
                                            {for $i=1 to 5}
                                                <i class="far fa-star" data-value="{$i}"></i>
                                            {/for}
                                        </div>
                                        <input type="hidden" name="delivery_rating" id="delivery_rating" required>
                                        <div class="rating-text text-muted" id="delivery_rating-text">Chọn số sao</div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card border-primary">
                                    <div class="card-body text-center">
                                        <h6 class="card-title">Đánh giá dịch vụ</h6>
                                        <div class="rating-stars mb-2" data-rating="service_rating">
                                            {for $i=1 to 5}
                                                <i class="far fa-star" data-value="{$i}"></i>
                                            {/for}
                                        </div>
                                        <input type="hidden" name="service_rating" id="service_rating" required>
                                        <div class="rating-text text-muted" id="service_rating-text">Chọn số sao</div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label for="comment" class="form-label">Nhận xét của bạn</label>
                            <textarea class="form-control" id="comment" name="comment" rows="5" 
                                      placeholder="Chia sẻ trải nghiệm của bạn về đơn hàng này..."></textarea>
                            <div class="form-text">Nhận xét của bạn sẽ giúp cải thiện chất lượng dịch vụ</div>
                        </div>

                        <div class="alert alert-success">
                            <h6><i class="fas fa-gift"></i> Ưu đãi cho đánh giá:</h6>
                            <ul class="mb-0">
                                <li>Nhận 10 điểm tích lũy khi đánh giá đơn hàng</li>
                                <li>Đánh giá 5 sao sẽ nhận thêm voucher giảm giá 5%</li>
                                <li>Đánh giá có nhận xét chi tiết sẽ được ưu tiên hiển thị</li>
                            </ul>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-success" id="submitBtn" disabled>
                                <i class="fas fa-star"></i> Gửi đánh giá
                            </button>
                            <a href="/?c=user&v=orders" class="btn btn-secondary">
                                <i class="fas fa-times"></i> Hủy bỏ
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
.rating-stars {
    font-size: 1.5rem;
    cursor: pointer;
}

.rating-stars i {
    color: #ddd;
    transition: color 0.2s;
}

.rating-stars i:hover,
.rating-stars i.active {
    color: #ffc107;
}

.rating-stars i.fas {
    color: #ffc107;
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const ratingTexts = {
        1: 'Rất không hài lòng',
        2: 'Không hài lòng', 
        3: 'Bình thường',
        4: 'Hài lòng',
        5: 'Rất hài lòng'
    };

    // Xử lý rating stars
    document.querySelectorAll('.rating-stars').forEach(function(ratingContainer) {
        const ratingName = ratingContainer.getAttribute('data-rating');
        const hiddenInput = document.getElementById(ratingName);
        const textElement = document.getElementById(ratingName + '-text');
        const stars = ratingContainer.querySelectorAll('i');

        stars.forEach(function(star, index) {
            star.addEventListener('click', function() {
                const value = parseInt(this.getAttribute('data-value'));
                hiddenInput.value = value;
                textElement.textContent = ratingTexts[value];

                // Update star display
                stars.forEach(function(s, i) {
                    if (i < value) {
                        s.className = 'fas fa-star';
                    } else {
                        s.className = 'far fa-star';
                    }
                });

                checkFormValid();
            });

            star.addEventListener('mouseenter', function() {
                const value = parseInt(this.getAttribute('data-value'));
                stars.forEach(function(s, i) {
                    if (i < value) {
                        s.style.color = '#ffc107';
                    } else {
                        s.style.color = '#ddd';
                    }
                });
            });
        });

        ratingContainer.addEventListener('mouseleave', function() {
            const currentValue = parseInt(hiddenInput.value) || 0;
            stars.forEach(function(s, i) {
                if (i < currentValue) {
                    s.style.color = '#ffc107';
                } else {
                    s.style.color = '#ddd';
                }
            });
        });
    });

    // Kiểm tra form hợp lệ
    function checkFormValid() {
        const rating = document.getElementById('rating').value;
        const deliveryRating = document.getElementById('delivery_rating').value;
        const serviceRating = document.getElementById('service_rating').value;
        const submitBtn = document.getElementById('submitBtn');

        if (rating && deliveryRating && serviceRating) {
            submitBtn.disabled = false;
            submitBtn.classList.remove('btn-secondary');
            submitBtn.classList.add('btn-success');
        } else {
            submitBtn.disabled = true;
            submitBtn.classList.remove('btn-success');
            submitBtn.classList.add('btn-secondary');
        }
    }
});
</script>

{include file="include/user/footer.tpl"}