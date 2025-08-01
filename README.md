# ITC TOI - E-commerce Website

Dự án website thương mại điện tử được xây dựng bằng PHP với Smarty Template Engine.

## Yêu cầu hệ thống

- PHP 7.4 hoặc cao hơn
- MySQL 5.7 hoặc cao hơn
- Apache/Nginx web server
- Composer

## Cài đặt

### 1. Clone repository

```bash
git clone https://github.com/duongnt168/itc_toi-main.git
cd itc_toi-main
```

### 2. Cài đặt dependencies

```bash
composer install
```

### 3. Cấu hình database

1. Copy file cấu hình mẫu:
   ```bash
   cp config/database.example.php config/database.php
   ```

2. Chỉnh sửa `config/database.php` với thông tin database của bạn:
   ```php
   return [
       'host' => 'localhost',
       'username' => 'your_username',
       'password' => 'your_password',
       'database' => 'your_database_name',
       'charset' => 'utf8mb4',
       'port' => 3306
   ];
   ```

3. Import database:
   ```bash
   mysql -u username -p database_name < database.sql
   ```

### 4. Cấu hình Stripe (thanh toán)

1. Copy file cấu hình mẫu:
   ```bash
   cp config/stripe.example.php config/stripe.php
   ```

2. Chỉnh sửa `config/stripe.php` với API keys từ Stripe Dashboard:
   ```php
   return [
       'secret_key' => 'sk_test_your_secret_key',
       'publishable_key' => 'pk_test_your_publishable_key',
       'currency' => 'vnd',
       'webhook_secret' => 'your_webhook_secret'
   ];
   ```

### 5. Cấu hình web server

Đảm bảo document root trỏ đến thư mục gốc của project và mod_rewrite được bật.

### 6. Phân quyền thư mục

```bash
chmod 755 cache/
chmod 755 templates_c/
chmod 755 public/img/
```

## Cấu trúc thư mục

```
├── config/          # File cấu hình
├── controller/      # Controllers
├── model/          # Models
├── templates/      # Smarty templates
├── public/         # Assets (CSS, JS, images)
├── vendor/         # Composer dependencies
├── cache/          # Cache files
└── templates_c/    # Compiled templates
```

## Tính năng chính

- Quản lý sản phẩm và danh mục
- Giỏ hàng và thanh toán
- Quản lý đơn hàng
- Hệ thống đánh giá sản phẩm
- Quản lý khiếu nại
- Tích hợp thanh toán Stripe
- Panel quản trị

## Bảo mật

- Các file cấu hình chứa thông tin nhạy cảm đã được loại trừ khỏi git
- Sử dụng file `.example.php` làm template
- Không commit API keys hoặc thông tin database

## Đóng góp

1. Fork repository
2. Tạo feature branch
3. Commit changes
4. Push to branch
5. Tạo Pull Request

## License

MIT License

## 🏗️ Kiến trúc hệ thống

### Cấu trúc thư mục
```
itc_toi-main/
├── config/                 # Cấu hình hệ thống
│   ├── database.php       # Cấu hình database
│   └── stripe.php         # Cấu hình thanh toán Stripe
├── controller/            # Controllers xử lý logic
│   ├── admin.php         # Quản lý admin panel
│   ├── auth.php          # Xác thực người dùng
│   ├── cart.php          # Quản lý giỏ hàng
│   ├── order.php         # Xử lý đơn hàng
│   ├── product.php       # Quản lý sản phẩm
│   ├── user.php          # Giao diện người dùng
│   ├── newsletter.php    # Quản lý newsletter
│   └── unsubscribe.php   # Hủy đăng ký
├── model/                # Models tương tác database
│   ├── db.php           # Class kết nối database
│   ├── users.php        # Quản lý người dùng
│   ├── products.php     # Quản lý sản phẩm
│   ├── orders.php       # Quản lý đơn hàng
│   ├── cart.php         # Quản lý giỏ hàng
│   └── ...              # Các model khác
├── templates/            # Giao diện Smarty
│   ├── admin/           # Giao diện admin
│   ├── user/            # Giao diện người dùng
│   ├── auth/            # Giao diện đăng nhập/đăng ký
│   └── include/         # Các template chung
├── public/              # Tài nguyên tĩnh
│   ├── css/            # Stylesheets
│   ├── img/            # Hình ảnh
│   └── admin/          # Tài nguyên admin
├── library/            # Thư viện Smarty
├── vendor/             # Dependencies (Composer)
└── cache/              # Cache Smarty
```

## 🚀 Tính năng chính

### 👤 Quản lý người dùng
- **Đăng ký/Đăng nhập** với xác thực OTP qua email
- **Quên mật khẩu** với hệ thống reset password
- **Quản lý profile** người dùng
- **Phân quyền** admin/user
- **Bảo mật** với session management

### 🛍️ Quản lý sản phẩm
- **Danh mục sản phẩm** với phân loại
- **Sản phẩm nổi bật** (Featured products)
- **Flash sale** và khuyến mãi
- **Quản lý kho** (Stock management)
- **Upload hình ảnh** sản phẩm
- **Tìm kiếm và lọc** sản phẩm

### 🛒 Giỏ hàng và đơn hàng
- **Giỏ hàng** với session management
- **Thanh toán đa phương thức**:
  - Thanh toán khi nhận hàng (COD)
  - Thanh toán qua Stripe (Credit Card)
  - Thanh toán QR Code
- **Quản lý địa chỉ giao hàng**
- **Tính phí vận chuyển** theo tỉnh/thành phố
- **Theo dõi trạng thái đơn hàng**

### 📊 Quản trị admin
- **Dashboard** với thống kê tổng quan
- **Quản lý người dùng** (CRUD)
- **Quản lý sản phẩm** (CRUD)
- **Quản lý đơn hàng** và cập nhật trạng thái
- **Quản lý đánh giá** sản phẩm
- **Báo cáo** doanh thu và thống kê

### 🔄 Tính năng nâng cao
- **Hệ thống khiếu nại** đơn hàng
- **Đánh giá đơn hàng** (delivery & service rating)
- **Yêu cầu hủy đơn hàng**
- **Newsletter** và email marketing
- **Activity logs** theo dõi hoạt động

## 🛠️ Công nghệ sử dụng

### Backend
- **PHP 7.4+** - Ngôn ngữ lập trình chính
- **MySQL** - Hệ quản trị cơ sở dữ liệu
- **Smarty Template Engine** - Template system
- **PHPMailer** - Gửi email
- **Stripe PHP SDK** - Thanh toán online

### Frontend
- **HTML5/CSS3** - Giao diện người dùng
- **JavaScript** - Tương tác client-side
- **Bootstrap** - Framework CSS (nếu có)
- **Responsive Design** - Tương thích mobile

### Công cụ phát triển
- **Composer** - Quản lý dependencies
- **XAMPP** - Môi trường phát triển
- **Git** - Quản lý version control

## 📊 Cơ sở dữ liệu

### Các bảng chính
1. **users** - Thông tin người dùng
2. **categories** - Danh mục sản phẩm
3. **products** - Sản phẩm
4. **orders** - Đơn hàng
5. **order_items** - Chi tiết đơn hàng
6. **cart** - Giỏ hàng
7. **reviews** - Đánh giá sản phẩm
8. **order_complaints** - Khiếu nại đơn hàng
9. **order_reviews** - Đánh giá đơn hàng
10. **order_cancellations** - Yêu cầu hủy đơn hàng
11. **otp** - Mã OTP xác thực
12. **activity_logs** - Nhật ký hoạt động

### Views và Indexes
- **product_stats** - Thống kê sản phẩm
- **order_stats** - Thống kê đơn hàng
- **complaint_stats** - Thống kê khiếu nại
- **order_review_stats** - Thống kê đánh giá

## ⚙️ Cài đặt và cấu hình

### Yêu cầu hệ thống
- PHP >= 7.4
- MySQL >= 5.7
- Apache/Nginx web server
- Composer

### Cài đặt
1. **Clone repository**
   ```bash
   git clone [repository-url]
   cd itc_toi-main
   ```

2. **Cài đặt dependencies**
   ```bash
   composer install
   ```

3. **Cấu hình database**
   - Import file `database.sql` và `order_features.sql`
   - Cập nhật thông tin database trong `config/database.php`

4. **Cấu hình email**
   - Cập nhật thông tin SMTP trong `config.php`
   - Cấu hình Gmail App Password

5. **Cấu hình Stripe** (nếu sử dụng)
   - Cập nhật API keys trong `config/stripe.php`

6. **Phân quyền thư mục**
   ```bash
   chmod 755 cache/
   chmod 755 templates_c/
   ```

### Cấu hình web server
- Document root: `itc_toi-main/`
- URL rewriting: Apache mod_rewrite hoặc Nginx rewrite rules

## 🔐 Bảo mật

### Các biện pháp bảo mật đã triển khai
- **SQL Injection Protection** - Prepared statements
- **XSS Protection** - Input sanitization
- **CSRF Protection** - Token validation
- **Session Security** - Secure session management
- **Password Hashing** - bcrypt encryption
- **OTP Authentication** - Two-factor authentication
- **Input Validation** - Server-side validation

### Cấu hình bảo mật
- HTTPS enforcement (production)
- Secure headers
- File upload restrictions
- Rate limiting (có thể thêm)

## 📈 Hiệu suất

### Tối ưu hóa
- **Database Indexing** - Indexes cho các cột thường query
- **Smarty Caching** - Template caching
- **Image Optimization** - Compressed images
- **Query Optimization** - Efficient SQL queries
- **Session Management** - Optimized session handling

### Monitoring
- **Activity Logs** - Track user activities
- **Error Logging** - PHP error logs
- **Database Logs** - Query performance monitoring

## 🧪 Testing

### Các test case cần thiết
- **Unit Tests** - Test các functions và classes
- **Integration Tests** - Test database interactions
- **User Acceptance Tests** - Test user workflows
- **Security Tests** - Test vulnerabilities

## 📝 API Documentation

### Endpoints chính
- `/?c=auth&a=login` - Đăng nhập
- `/?c=auth&a=register` - Đăng ký
- `/?c=user&a=index` - Trang chủ
- `/?c=cart&a=index` - Giỏ hàng
- `/?c=order&a=checkout` - Thanh toán
- `/?c=admin&a=dashboard` - Admin dashboard

## 🚀 Deployment

### Production Checklist
- [ ] Cấu hình HTTPS
- [ ] Tối ưu hóa database
- [ ] Cấu hình caching
- [ ] Backup strategy
- [ ] Monitoring setup
- [ ] Error handling
- [ ] Log rotation

### Environment Variables
```env
DB_HOST=localhost
DB_NAME=terrariumz
DB_USER=root
DB_PASS=
EMAIL_HOST=smtp.gmail.com
EMAIL_USER=your-email@gmail.com
EMAIL_PASS=your-app-password
STRIPE_SECRET_KEY=your-stripe-secret
STRIPE_PUBLISHABLE_KEY=your-stripe-public
```

## 🤝 Đóng góp

### Quy trình phát triển
1. Fork repository
2. Tạo feature branch
3. Commit changes
4. Push to branch
5. Create Pull Request

### Coding Standards
- PSR-4 Autoloading
- PSR-12 Coding Style
- Meaningful commit messages
- Code documentation

## 📄 License

Dự án này được phát triển cho mục đích học tập và nghiên cứu.

## 👥 Tác giả

**AquaGarden Shop Team**
- Phát triển: [Tên developer]
- Thiết kế: [Tên designer]
- Quản lý dự án: [Tên PM]

## 📞 Liên hệ

- **Email**: support@aquagarden.com
- **Website**: https://aquagarden.com
- **GitHub**: [repository-url]

---

