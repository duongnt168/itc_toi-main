
-- Tạo database
CREATE DATABASE IF NOT EXISTS `terrariumz` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `terrariumz`;

-- Bảng users (người dùng)
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL UNIQUE,
  `phone` varchar(20) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('user','admin') DEFAULT 'user',
  `avatar` varchar(255) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `gender` enum('male','female','other') DEFAULT NULL,
  `status` enum('active','inactive','banned') DEFAULT 'active',
  `last_login` timestamp NULL DEFAULT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_email` (`email`),
  KEY `idx_username` (`username`),
  KEY `idx_role` (`role`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng categories (danh mục sản phẩm)
CREATE TABLE `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_name` (`name`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng products (sản phẩm)
CREATE TABLE `products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `old_price` decimal(10,2) DEFAULT NULL,
  `category_id` int(11) NOT NULL,
  `file_url` varchar(255) DEFAULT NULL,
  `stock` int(11) DEFAULT 0,
  `is_featured` tinyint(1) DEFAULT 0,
  `is_flash_sale` tinyint(1) DEFAULT 0,
  `is_sale` tinyint(1) DEFAULT 0,
  `discount` decimal(5,2) DEFAULT 0.00,
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_category_id` (`category_id`),
  KEY `idx_name` (`name`),
  KEY `idx_price` (`price`),
  KEY `idx_status` (`status`),
  KEY `idx_featured` (`is_featured`),
  KEY `idx_sale` (`is_sale`),
  FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng orders (đơn hàng)
CREATE TABLE `orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `status` enum('pending','confirmed','shipping','delivered','cancelled') DEFAULT 'pending',
  `shipping_address` text DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_status` (`status`),
  KEY `idx_created_at` (`created_at`),
  FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng order_items (chi tiết đơn hàng)
CREATE TABLE `order_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_order_id` (`order_id`),
  KEY `idx_product_id` (`product_id`),
  FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng reviews (đánh giá sản phẩm)
CREATE TABLE `reviews` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `rating` int(1) NOT NULL CHECK (rating >= 1 AND rating <= 5),
  `comment` text DEFAULT NULL,
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_product_id` (`product_id`),
  KEY `idx_rating` (`rating`),
  KEY `idx_status` (`status`),
  FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng cart (giỏ hàng)
CREATE TABLE `cart` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_product` (`user_id`, `product_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_product_id` (`product_id`),
  FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng images (hình ảnh sản phẩm)
CREATE TABLE `images` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `image_url` varchar(255) NOT NULL,
  `is_primary` tinyint(1) DEFAULT 0,
  `sort_order` int(11) DEFAULT 0,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_product_id` (`product_id`),
  KEY `idx_primary` (`is_primary`),
  KEY `idx_sort_order` (`sort_order`),
  FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng sessions (phiên đăng nhập)
CREATE TABLE `sessions` (
  `id` varchar(128) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` text NOT NULL,
  `last_activity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_last_activity` (`last_activity`),
  FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng password_resets (đặt lại mật khẩu)
CREATE TABLE `password_resets` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`email`),
  KEY `idx_token` (`token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng otp (mã OTP)
CREATE TABLE `otp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `otp_code` varchar(6) NOT NULL,
  `type` enum('register','forgot_password','verify') DEFAULT 'register',
  `expires_at` timestamp NOT NULL,
  `is_used` tinyint(1) DEFAULT 0,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_email` (`email`),
  KEY `idx_otp_code` (`otp_code`),
  KEY `idx_type` (`type`),
  KEY `idx_expires_at` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng remember_tokens (remember me tokens)
CREATE TABLE `remember_tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `token` varchar(255) NOT NULL,
  `expires_at` timestamp NOT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_token` (`token`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_expires_at` (`expires_at`),
  FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng activity_logs (log hoạt động)
CREATE TABLE `activity_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `details` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_action` (`action`),
  KEY `idx_created_at` (`created_at`),
  FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Thêm dữ liệu mẫu

-- Thêm admin user mặc định (password: admin123)
INSERT INTO `users` (`username`, `email`, `phone`, `password`, `role`, `status`) VALUES
('admin', 'admin@gmail.com', '0123456789', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 'active');  


INSERT INTO `categories` (`name`, `description`, `image`) VALUES
('Terrarium', 'Terrarium trang trí không gian sống, sáng tạo và xanh mát', 'terrarium.jpg'),
('NVL Trồng Terrarium', 'Nguyên vật liệu dùng để trồng và trang trí Terrarium', 'nvl-terrarium.jpg'),
('Terrarium Tường Rêu Signature', 'Terrarium dạng tranh tường kết hợp rêu sống độc đáo', 'tuong-reu.jpg'),
('Moss Art', 'Tranh nghệ thuật làm từ rêu sống và sen đá', 'moss-art.jpg'),
('Cây Trồng Trong Nước', 'Các loại cây thuỷ sinh trồng trực tiếp trong nước', 'cay-trong-nuoc.jpg'),
('Hồ Bán Cạn', 'Thiết kế hồ thuỷ sinh bán cạn, kết hợp cây và nước', 'ho-ban-can.jpg');

-- Category 1: Terrarium
INSERT INTO `products` (`name`, `description`, `price`, `old_price`, `category_id`, `file_url`, `stock`, `is_featured`, `is_sale`, `discount`)
VALUES
('AquaGarden Mini Pond Kit', 'Bể mini có thác nước tích hợp, dễ setup trong nhà hoặc sân vườn.', 2599900, 2999900, 1, 'mini-pond-kit.jpg', 15, 1, 1, 13.33),
('Tabletop Fountain Kit', 'Bộ đài phun bàn mini AquaGarden màu xám, trang trí nội thất.', 1699000, 1999000, 1, 'tabletop-fountain.jpg', 20, 1, 1, 15.01),
('Awesome Pond Pods (6-pack)', 'Viên xử lý bùn và pH nước hồ cá, làm sạch tự nhiên.', 450000, 550000, 1, 'pond-pods.jpg', 50, 0, 1, 18.18),
('Universal All‑in‑One Pond Pump 1200', 'Máy bơm lọc 5‑in‑1 công suất lớn cho hồ mini và thác.', 1200000, 1400000, 1, 'pump-1200.jpg', 10, 1, 0, 14.29),
('InPond 5‑in‑1 Pump 600 GPH', 'Bơm hồ tích hợp lọc, UV, cho hồ cá đến 600 GPH.', 1599000, 1899000, 1, 'inpump-600.jpg', 8, 0, 1, 15.65);

-- Category 2: NVL Trồng Terrarium
INSERT INTO `products` (`name`, `description`, `price`, `old_price`, `category_id`, `file_url`, `stock`, `is_featured`, `is_sale`, `discount`)
VALUES
('Clay Grow Media Set', 'Bộ nguyên liệu đất sét mở rộng cho trồng thuỷ sinh.', 299000, 350000, 2, 'clay-grow-media.jpg', 40, 0, 1, 14.57),
('Decorative Gravel Kit', 'Kit sỏi trang trí đáy bể và terrarium.', 199000, 250000, 2, 'gravel-kit.jpg', 50, 0, 1, 20.4),
('Filter Media Cartridge', 'Lõi lọc sinh học dùng cho hệ terrarium mini.', 550000, 650000, 2, 'filter-cartridge.jpg', 30, 1, 1, 15.38),
('LED Growth Light', 'Đèn LED chuyên dụng cho cây thủy sinh terrarium.', 850000, 950000, 2, 'led-light.jpg', 25, 1, 1, 10.53),
('Substrate Tray Set', 'Khay nền để dễ dàng setup ban đầu cho terrarium.', 400000, 470000, 2, 'substrate-tray.jpg', 35, 0, 1, 14.89);

-- Category 3: Terrarium Tường Rêu Signature
INSERT INTO `products` (`name`, `description`, `price`, `old_price`, `category_id`, `file_url`, `stock`, `is_featured`, `is_sale`, `discount`)
VALUES
('Terrarium Wall Signature Frame', 'Khung rêu sống signature, treo tường độc đáo.', 1290000, 1490000, 3, 'wall-signature.jpg', 12, 1, 1, 13.42),
('Replacement Moss Patch', 'Miếng rêu thay thế cho khung tường signature.', 350000, 420000, 3, 'moss-patch.jpg', 40, 0, 1, 16.67),
('Mounting Kit Wall', 'Bộ giá treo và ke góc chuyên dụng cho setup rêu tường.', 250000, 300000, 3, 'mount-kit.jpg', 20, 0, 1, 16.67),
('Water Mist System', 'Hệ thống phun sương giúp giữ độ ẩm cho rêu sống.', 790000, 900000, 3, 'mist-system.jpg', 15, 1, 1, 12.22),
('LED Wall Light', 'Đèn LED chiếu sáng khung rêu tường, tăng sinh trưởng.', 600000, 700000, 3, 'wall-led-light.jpg', 18, 0, 1, 14.29);

-- Category 4: Moss Art
INSERT INTO `products` (`name`, `description`, `price`, `old_price`, `category_id`, `file_url`, `stock`, `is_featured`, `is_sale`, `discount`)
VALUES
('Moss Art Panel Small', 'Tranh rêu nghệ thuật nhỏ, phù hợp phòng khách.', 899000, 1099000, 4, 'moss-panel-small.jpg', 10, 1, 1, 18.19),
('Moss Art Panel Medium', 'Tranh rêu trung kích thước trung bình.', 1299000, 1499000, 4, 'moss-panel-medium.jpg', 8, 1, 1, 13.34),
('Moss Art Panel Large', 'Tranh rêu lớn phù hợp văn phòng hoặc sảnh.', 1799000, 1999000, 4, 'moss-panel-large.jpg', 5, 1, 1, 10.01),
('Moss Art Maintenance Kit', 'Kit chăm sóc và tưới cho tranh rêu sống.', 350000, 400000, 4, 'moss-maintenance.jpg', 25, 0, 1, 12.5),
('Moss Art LED Spotlight', 'Đèn spotlight cho tranh rêu, ánh sáng tự nhiên.', 550000, 600000, 4, 'moss-spotlight.jpg', 17, 1, 1, 8.33);

-- Category 5: Cây Trồng Trong Nước
INSERT INTO `products` (`name`, `description`, `price`, `old_price`, `category_id`, `file_url`, `stock`, `is_featured`, `is_sale`, `discount`)
VALUES
('Aquatic Plant Bundle 5pcs', 'Combo 5 loại cây thủy sinh phổ biến trong nước.', 299000, 350000, 5, 'plant-bundle.jpg', 60, 0, 1, 14.57),
('Single Anubias Barteri', 'Cây Anubias Barteri, dễ trồng trong nước.', 75000, 90000, 5, 'anubias-barteri.jpg', 120, 0, 1, 16.67),
('Java Fern Rhizome Piece', 'Củ cây dương xỉ Java sống tốt dưới nước.', 85000, 100000, 5, 'java-fern.jpg', 110, 0, 1, 15.00),
('Water Wisteria Stem', 'Thân cây Wisteria thủy sinh tốc độ phát triển nhanh.', 65000, 80000, 5, 'water-wisteria.jpg', 130, 0, 1, 18.75),
('Cryptocoryne Mix Pack', 'Gói hỗn hợp các loại Cryptocoryne thủy sinh.', 250000, 290000, 5, 'crypto-mix.jpg', 90, 0, 1, 13.79);

-- Category 6: Hồ Bán Cạn
INSERT INTO `products` (`name`, `description`, `price`, `old_price`, `category_id`, `file_url`, `stock`, `is_featured`, `is_sale`, `discount`)
VALUES
('Semi‑Aquatic Bowl Pond', 'Hồ bán cạn dạng bát, kết hợp cây và nước.', 1599000, 1999000, 6, 'bowl-pond.jpg', 10, 1, 1, 19.97),
('Terrarium Pond Hybrid', 'Thiết kế kết hợp hồ và terrarium cây.', 2299000, 2599000, 6, 'hybrid-pond.jpg', 7, 1, 1, 11.54),
('Mini Waterfall Pond Planter', 'Chậu bán cạn có thác nước nhỏ.', 1899000, 2199000, 6, 'waterfall-planter.jpg', 8, 0, 1, 13.67),
('Live Plant Water Shelf', 'Kệ trồng cây trên mặt nước cho hồ bán cạn.', 499000, 600000, 6, 'water-shelf.jpg', 20, 0, 1, 16.83),
('Glass Lid Aquatic Pond', 'Hồ bán cạn có nắp kính, trang trí hiện đại.', 1999000, 2299000, 6, 'glass-lid-pond.jpg', 5, 1, 1, 12.84);



-- Thêm reviews mẫu
INSERT INTO `reviews` (`user_id`, `product_id`, `rating`, `comment`, `status`) VALUES
(1, 1, 5, 'Sản phẩm rất tốt, giao hàng nhanh!', 'approved'),
(1, 2, 4, 'Chất lượng tốt, pin trâu', 'approved'),
(1, 3, 5, 'MacBook Pro rất mượt, xử lý nhanh', 'approved');

-- Tạo indexes để tối ưu hiệu suất
CREATE INDEX `idx_products_category_status` ON `products` (`category_id`, `status`);
CREATE INDEX `idx_orders_user_status` ON `orders` (`user_id`, `status`);
CREATE INDEX `idx_reviews_product_status` ON `reviews` (`product_id`, `status`);
CREATE INDEX `idx_cart_user_product` ON `cart` (`user_id`, `product_id`);

-- Tạo view để thống kê
CREATE VIEW `product_stats` AS
SELECT 
    p.id,
    p.name,
    p.price,
    p.stock,
    c.name as category_name,
    COUNT(oi.id) as total_sold,
    AVG(r.rating) as avg_rating,
    COUNT(r.id) as total_reviews
FROM products p
LEFT JOIN categories c ON p.category_id = c.id
LEFT JOIN order_items oi ON p.id = oi.product_id
LEFT JOIN reviews r ON p.id = r.product_id AND r.status = 'approved'
GROUP BY p.id;

-- Tạo view để thống kê đơn hàng
CREATE VIEW `order_stats` AS
SELECT 
    o.id,
    o.total_amount,
    o.status,
    o.created_at,
    u.username,
    u.email,
    COUNT(oi.id) as total_items
FROM orders o
LEFT JOIN users u ON o.user_id = u.id
LEFT JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id;