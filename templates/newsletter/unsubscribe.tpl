<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hủy đăng ký nhận tin - AquaGarden</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #28a745, #20c997);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .unsubscribe-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            max-width: 500px;
            width: 100%;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="unsubscribe-card p-5 text-center">
            <div class="mb-4">
                <img src="/public/img/logo1.webp" alt="AquaGarden" class="img-fluid" style="max-width: 150px;">
            </div>
            
            <h2 class="mb-4">Hủy đăng ký nhận tin</h2>
            
            {if isset($success)}
                <div class="alert alert-success">
                    <i class="fas fa-check-circle me-2"></i>
                    {$success}
                </div>
                <p class="text-muted mb-4">Chúng tôi rất tiếc khi bạn rời đi. Hy vọng sẽ gặp lại bạn trong tương lai!</p>
                <a href="/" class="btn btn-success btn-lg">Về trang chủ</a>
            {/if}
            
            {if isset($error)}
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    {$error}
                </div>
                <a href="/" class="btn btn-secondary btn-lg">Về trang chủ</a>
            {/if}
            
            <div class="mt-4 pt-4 border-top">
                <p class="text-muted small mb-0">
                    Nếu bạn có bất kỳ câu hỏi nào, vui lòng liên hệ với chúng tôi qua email: 
                    <a href="mailto:support@aquagarden.vn">support@aquagarden.vn</a>
                </p>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
</body>
</html>