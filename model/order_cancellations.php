<?php
// Model xử lý yêu cầu hủy đơn hàng

class OrderCancellationModel extends model
{
    public function __construct()
    {
        global $db;
        $this->db = $db;
        $this->class_name = 'order_cancellations';
    }

    // Tạo yêu cầu hủy đơn hàng
    public function createCancellation($data)
    {
        $sql = "INSERT INTO order_cancellations (order_id, user_id, reason, description) 
                VALUES ('{$data['order_id']}', '{$data['user_id']}', '{$data['reason']}', '{$data['description']}')";
        
        return $this->db->executeQuery($sql);
    }

    // Lấy yêu cầu hủy theo order_id
    public function getCancellationByOrderId($order_id, $user_id = null)
    {
        $sql = "SELECT oc.*, o.total_amount as order_total, o.status as order_status, u.username
                FROM order_cancellations oc
                LEFT JOIN orders o ON oc.order_id = o.id
                LEFT JOIN users u ON oc.user_id = u.id
                WHERE oc.order_id = '$order_id'";
        
        if ($user_id) {
            $sql .= " AND oc.user_id = '$user_id'";
        }
        
        return $this->db->executeQuery($sql, 1);
    }

    // Lấy danh sách yêu cầu hủy của user
    public function getUserCancellations($user_id, $limit = 10, $offset = 0)
    {
        $sql = "SELECT oc.*, o.total_amount as order_total, o.status as order_status
                FROM order_cancellations oc
                LEFT JOIN orders o ON oc.order_id = o.id
                WHERE oc.user_id = '$user_id'
                ORDER BY oc.created_at DESC
                LIMIT $limit OFFSET $offset";
        
        return $this->db->executeQuery_list($sql);
    }

    // Lấy chi tiết yêu cầu hủy
    public function getCancellationById($id, $user_id = null)
    {
        $sql = "SELECT oc.*, o.total_amount as order_total, o.status as order_status, u.username, u.email
                FROM order_cancellations oc
                LEFT JOIN orders o ON oc.order_id = o.id
                LEFT JOIN users u ON oc.user_id = u.id
                WHERE oc.id = '$id'";
        
        if ($user_id) {
            $sql .= " AND oc.user_id = '$user_id'";
        }
        
        return $this->db->executeQuery($sql, 1);
    }

    // Cập nhật trạng thái yêu cầu hủy (admin)
    public function updateCancellationStatus($id, $status, $admin_response = null)
    {
        $processed_at = ($status != 'pending') ? "NOW()" : "NULL";
        $admin_response = $admin_response ? "'$admin_response'" : "NULL";
        
        $sql = "UPDATE order_cancellations 
                SET status = '$status', admin_response = $admin_response, 
                    processed_at = $processed_at, updated_at = NOW()
                WHERE id = '$id'";
        
        return $this->db->executeQuery($sql);
    }

    // Lấy danh sách yêu cầu hủy cho admin
    public function getAllCancellations($status = null, $limit = 20, $offset = 0)
    {
        $sql = "SELECT oc.*, o.total_amount as order_total, o.status as order_status, u.username, u.email
                FROM order_cancellations oc
                LEFT JOIN orders o ON oc.order_id = o.id
                LEFT JOIN users u ON oc.user_id = u.id";
        
        if ($status) {
            $sql .= " WHERE oc.status = '$status'";
        }
        
        $sql .= " ORDER BY oc.created_at DESC LIMIT $limit OFFSET $offset";
        
        return $this->db->executeQuery_list($sql);
    }

    // Đếm số lượng yêu cầu hủy
    public function countCancellations($status = null, $user_id = null)
    {
        $sql = "SELECT COUNT(*) as total FROM order_cancellations WHERE 1=1";
        
        if ($status) {
            $sql .= " AND status = '$status'";
        }
        
        if ($user_id) {
            $sql .= " AND user_id = '$user_id'";
        }
        
        $result = $this->db->executeQuery($sql, 1);
        return $result['total'] ?? 0;
    }

    // Kiểm tra xem đơn hàng đã có yêu cầu hủy chưa
    public function hasCancellation($order_id, $user_id)
    {
        $sql = "SELECT COUNT(*) as total FROM order_cancellations 
                WHERE order_id = '$order_id' AND user_id = '$user_id'";
        
        $result = $this->db->executeQuery($sql, 1);
        return ($result['total'] ?? 0) > 0;
    }

    // Lấy thống kê yêu cầu hủy
    public function getCancellationStats()
    {
        $sql = "SELECT 
                    status,
                    COUNT(*) as count,
                    reason,
                    COUNT(*) as reason_count
                FROM order_cancellations 
                GROUP BY status, reason
                ORDER BY status, reason";
        
        return $this->db->executeQuery_list($sql);
    }

    // Xử lý hủy đơn hàng (cập nhật cả order và cancellation)
    public function processCancellation($cancellation_id, $approve = true, $admin_response = null)
    {
        // Lấy thông tin yêu cầu hủy
        $cancellation = $this->getCancellationById($cancellation_id);
        
        if (!$cancellation) {
            return false;
        }
        
        // Bắt đầu transaction
        $this->db->executeQuery("START TRANSACTION");
        
        try {
            if ($approve) {
                // Cập nhật trạng thái đơn hàng thành cancelled
                $sql_order = "UPDATE orders SET status = 'cancelled', updated_at = NOW() 
                             WHERE id = '{$cancellation['order_id']}'";
                $this->db->executeQuery($sql_order);
                
                // Cập nhật trạng thái yêu cầu hủy thành approved
                $this->updateCancellationStatus($cancellation_id, 'approved', $admin_response);
            } else {
                // Từ chối yêu cầu hủy
                $this->updateCancellationStatus($cancellation_id, 'rejected', $admin_response);
            }
            
            // Commit transaction
            $this->db->executeQuery("COMMIT");
            return true;
            
        } catch (Exception $e) {
            // Rollback nếu có lỗi
            $this->db->executeQuery("ROLLBACK");
            return false;
        }
    }

    // Phê duyệt yêu cầu hủy đơn hàng
    public function approveCancellation($cancellation_id, $admin_response = null, $admin_id = null)
    {
        return $this->processCancellation($cancellation_id, true, $admin_response);
    }

    // Từ chối yêu cầu hủy đơn hàng
    public function rejectCancellation($cancellation_id, $admin_response = null, $admin_id = null)
    {
        return $this->processCancellation($cancellation_id, false, $admin_response);
    }

    // Lấy danh sách yêu cầu hủy cho admin với phân trang
    public function getCancellationsForAdmin($page = 1, $limit = 20, $status = '')
    {
        $offset = ($page - 1) * $limit;
        return $this->getAllCancellations($status, $limit, $offset);
    }

    // Lấy chi tiết yêu cầu hủy cho admin
    public function getCancellationDetail($id)
    {
        return $this->getCancellationById($id);
    }

    // Cập nhật chi tiết yêu cầu hủy
    public function updateCancellationDetails($id, $reason, $description, $status, $admin_response = null)
    {
        $processed_at = ($status != 'pending') ? "NOW()" : "NULL";
        $admin_response = $admin_response ? "'$admin_response'" : "NULL";
        
        $sql = "UPDATE order_cancellations 
                SET reason = '$reason', description = '$description', status = '$status', 
                    admin_response = $admin_response, processed_at = $processed_at, updated_at = NOW()
                WHERE id = '$id'";
        
        return $this->db->executeQuery($sql);
    }

    // Xóa yêu cầu hủy
    public function deleteCancellation($id)
    {
        $sql = "DELETE FROM order_cancellations WHERE id = '$id'";
        return $this->db->executeQuery($sql);
    }
}
?>