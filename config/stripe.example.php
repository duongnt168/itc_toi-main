<?php
/**
 * Stripe Payment Configuration Example
 * Cấu hình thanh toán Stripe - File mẫu
 * 
 * Hướng dẫn:
 * 1. Copy file này thành stripe.php
 * 2. Thay thế các giá trị YOUR_XXX_KEY bằng API keys thực từ Stripe Dashboard
 */

return [
    'secret_key' => 'YOUR_STRIPE_SECRET_KEY', // sk_test_... hoặc sk_live_...
    'publishable_key' => 'YOUR_STRIPE_PUBLISHABLE_KEY', // pk_test_... hoặc pk_live_...
    'currency' => 'vnd',
    'webhook_secret' => 'YOUR_WEBHOOK_SECRET', // Thêm webhook secret nếu cần
];