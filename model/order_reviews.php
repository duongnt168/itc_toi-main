<?php
// Model xử lý đánh giá đơn hàng

class OrderReviewModel extends model
{
    public function __construct()
    {
        parent::__construct();
        $this->class_name = 'order_reviews';
    }

    // Tạo đánh giá mới
    public function createReview($data)
    {
        $sql = "INSERT INTO order_reviews (order_id, user_id, rating, delivery_rating, service_rating, comment, images) 
                VALUES ('{$data['order_id']}', '{$data['user_id']}', '{$data['rating']}', 
                        '{$data['delivery_rating']}', '{$data['service_rating']}', 
                        '{$data['comment']}', '{$data['images']}')";

        return $this->db->executeQuery($sql);
    }

    // Lấy danh sách đánh giá của user
    public function getUserReviews($user_id, $limit = 10, $offset = 0)
    {
        $sql = "SELECT orv.*, o.total_amount as order_total, o.created_at as order_date
                FROM order_reviews orv
                LEFT JOIN orders o ON orv.order_id = o.id
                WHERE orv.user_id = '$user_id'
                ORDER BY orv.created_at DESC
                LIMIT $limit OFFSET $offset";

        return $this->db->executeQuery_list($sql);
    }

    // Lấy chi tiết đánh giá
    public function getReviewById($id, $user_id = null)
    {
        $sql = "SELECT orv.*, o.total_amount as order_total, o.created_at as order_date, u.username
                FROM order_reviews orv
                LEFT JOIN orders o ON orv.order_id = o.id
                LEFT JOIN users u ON orv.user_id = u.id
                WHERE orv.id = '$id'";

        if ($user_id) {
            $sql .= " AND orv.user_id = '$user_id'";
        }

        return $this->db->executeQuery($sql, 1);
    }

    // Lấy đánh giá theo order_id
    public function getReviewByOrderId($order_id, $user_id)
    {
        $sql = "SELECT * FROM order_reviews 
                WHERE order_id = '$order_id' AND user_id = '$user_id'";

        return $this->db->executeQuery($sql, 1);
    }

    // Cập nhật trạng thái đánh giá (admin)
    public function updateReviewStatus($id, $status)
    {
        $sql = "UPDATE order_reviews 
                SET status = '$status', updated_at = NOW()
                WHERE id = '$id'";

        return $this->db->executeQuery($sql);
    }

    // Lấy danh sách đánh giá cho admin
    public function getAllReviews($status = null, $limit = 20, $offset = 0)
    {
        $sql = "SELECT orv.*, o.total_amount as order_total, o.created_at as order_date, u.username, u.email
                FROM order_reviews orv
                LEFT JOIN orders o ON orv.order_id = o.id
                LEFT JOIN users u ON orv.user_id = u.id";

        if ($status) {
            $sql .= " WHERE orv.status = '$status'";
        }

        $sql .= " ORDER BY orv.created_at DESC LIMIT $limit OFFSET $offset";

        return $this->db->executeQuery_list($sql);
    }

    // Đếm số lượng đánh giá
    public function countReviews($status = null, $user_id = null)
    {
        $sql = "SELECT COUNT(*) as total FROM order_reviews WHERE 1=1";

        if ($status) {
            $sql .= " AND status = '$status'";
        }

        if ($user_id) {
            $sql .= " AND user_id = '$user_id'";
        }

        $result = $this->db->executeQuery($sql, 1);
        return $result['total'] ?? 0;
    }

    // Kiểm tra xem đơn hàng đã có đánh giá chưa
    public function hasReview($order_id, $user_id)
    {
        $sql = "SELECT COUNT(*) as total FROM order_reviews 
                WHERE order_id = '$order_id' AND user_id = '$user_id'";

        $result = $this->db->executeQuery($sql, 1);
        return ($result['total'] ?? 0) > 0;
    }

    // Lấy thống kê đánh giá
    public function getReviewStats()
    {
        $sql = "SELECT 
                    AVG(rating) as avg_rating,
                    AVG(delivery_rating) as avg_delivery_rating,
                    AVG(service_rating) as avg_service_rating,
                    COUNT(*) as total_reviews,
                    status,
                    COUNT(*) as status_count
                FROM order_reviews 
                GROUP BY status";

        return $this->db->executeQuery_list($sql);
    }

    // Lấy đánh giá theo rating
    public function getReviewsByRating($rating, $limit = 10)
    {
        $sql = "SELECT orv.*, o.total_amount as order_total, u.username
                FROM order_reviews orv
                LEFT JOIN orders o ON orv.order_id = o.id
                LEFT JOIN users u ON orv.user_id = u.id
                WHERE orv.rating = '$rating' AND orv.status = 'approved'
                ORDER BY orv.created_at DESC
                LIMIT $limit";

        return $this->db->executeQuery_list($sql);
    }

    // Cập nhật đánh giá
    public function updateReview($id, $data, $user_id)
    {
        $sql = "UPDATE order_reviews 
                SET rating = '{$data['rating']}', 
                    delivery_rating = '{$data['delivery_rating']}', 
                    service_rating = '{$data['service_rating']}', 
                    comment = '{$data['comment']}', 
                    images = '{$data['images']}',
                    updated_at = NOW()
                WHERE id = '$id' AND user_id = '$user_id'";

        return $this->db->executeQuery($sql);
    }

    // Lấy danh sách đánh giá cho admin với phân trang
    public function getReviewsForAdmin($page = 1, $limit = 20, $status = '')
    {
        $offset = ($page - 1) * $limit;
        $sql = "SELECT orv.*, o.total_amount as order_total, o.created_at as order_date, 
                       u.username, u.email
                FROM order_reviews orv
                LEFT JOIN orders o ON orv.order_id = o.id
                LEFT JOIN users u ON orv.user_id = u.id";

        if ($status) {
            $sql .= " WHERE orv.status = '$status'";
        }

        $sql .= " ORDER BY orv.created_at DESC LIMIT $limit OFFSET $offset";

        return $this->db->executeQuery_list($sql);
    }

    // Lấy chi tiết đánh giá cho admin
    public function getReviewDetail($id)
    {
        $sql = "SELECT orv.*, o.total_amount as order_total, o.created_at as order_date, 
                       o.status as order_status, u.username, u.email as user_email, 
                       u.phone as user_phone
                FROM order_reviews orv
                LEFT JOIN orders o ON orv.order_id = o.id
                LEFT JOIN users u ON orv.user_id = u.id
                WHERE orv.id = '$id'";

        return $this->db->executeQuery($sql, 1);
    }

    // Lấy đánh giá đã được phê duyệt cho sản phẩm
    public function getApprovedReviewsForProduct($product_id, $limit = 10, $offset = 0)
    {
        $sql = "SELECT orv.*, u.username, o.created_at as order_date
                FROM order_reviews orv
                LEFT JOIN orders o ON orv.order_id = o.id
                LEFT JOIN order_items oi ON o.id = oi.order_id
                LEFT JOIN users u ON orv.user_id = u.id
                WHERE oi.product_id = '$product_id' AND orv.status = 'approved'
                ORDER BY orv.created_at DESC
                LIMIT $limit OFFSET $offset";

        return $this->db->executeQuery_list($sql);
    }

    // Đếm số đánh giá đã được phê duyệt cho sản phẩm
    public function countApprovedReviewsForProduct($product_id)
    {
        $sql = "SELECT COUNT(*) as total
                FROM order_reviews orv
                LEFT JOIN orders o ON orv.order_id = o.id
                LEFT JOIN order_items oi ON o.id = oi.order_id
                WHERE oi.product_id = '$product_id' AND orv.status = 'approved'";

        $result = $this->db->executeQuery($sql, 1);
        return $result['total'] ?? 0;
    }

    // Lấy điểm đánh giá trung bình cho sản phẩm
    public function getAverageRatingForProduct($product_id)
    {
        $sql = "SELECT AVG(orv.rating) as avg_rating, COUNT(*) as total_reviews
                FROM order_reviews orv
                LEFT JOIN orders o ON orv.order_id = o.id
                LEFT JOIN order_items oi ON o.id = oi.order_id
                WHERE oi.product_id = '$product_id' AND orv.status = 'approved'";

        return $this->db->executeQuery($sql, 1);
    }
}
?>