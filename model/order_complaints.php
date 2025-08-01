<?php
// Model xử lý khiếu nại đơn hàng

class OrderComplaintModel extends model
{
    public function __construct()
    {
        parent::__construct();
        $this->class_name = 'order_complaints';
    }

    // Tạo khiếu nại mới
    public function createComplaint($data)
    {
        $sql = "INSERT INTO order_complaints (order_id, user_id, type, title, description, images) 
                VALUES ('{$data['order_id']}', '{$data['user_id']}', '{$data['type']}', 
                        '{$data['title']}', '{$data['description']}', '{$data['images']}')";

        return $this->db->executeQuery($sql);
    }

    // Lấy danh sách khiếu nại của user
    public function getUserComplaints($user_id, $limit = 10, $offset = 0)
    {
        $sql = "SELECT oc.*, o.total_amount as order_total, o.created_at as order_date
                FROM order_complaints oc
                LEFT JOIN orders o ON oc.order_id = o.id
                WHERE oc.user_id = '$user_id'
                ORDER BY oc.created_at DESC
                LIMIT $limit OFFSET $offset";

        return $this->db->executeQuery_list($sql);
    }

    // Lấy chi tiết khiếu nại
    public function getComplaintById($id, $user_id = null)
    {
        $sql = "SELECT oc.*, o.total_amount as order_total, o.created_at as order_date, o.status as order_status,
                       u.username, u.email as user_email, u.phone as user_phone, u.created_at as user_created_at,
                       oc.type as complaint_type, oc.priority,
                       admin.username as admin_name
                FROM order_complaints oc
                LEFT JOIN orders o ON oc.order_id = o.id
                LEFT JOIN users u ON oc.user_id = u.id
                LEFT JOIN users admin ON oc.admin_id = admin.id
                WHERE oc.id = '$id'";

        if ($user_id) {
            $sql .= " AND oc.user_id = '$user_id'";
        }

        return $this->db->executeQuery($sql, 1);
    }

    // Cập nhật trạng thái khiếu nại (admin)
    public function updateComplaintStatus($id, $status, $admin_response = null, $admin_id = null, $priority = null)
    {
        $resolved_at = ($status == 'resolved') ? "NOW()" : "NULL";
        $processed_at = ($admin_response && $status != 'pending') ? "NOW()" : "NULL";
        $admin_response = $admin_response ? "'$admin_response'" : "NULL";
        $admin_id = $admin_id ? "'$admin_id'" : "NULL";
        
        $sql = "UPDATE order_complaints 
                SET status = '$status', admin_response = $admin_response, 
                    admin_id = $admin_id, resolved_at = $resolved_at, 
                    processed_at = $processed_at, updated_at = NOW()";
        
        if ($priority) {
            $sql .= ", priority = '$priority'";
        }
        
        $sql .= " WHERE id = '$id'";

        return $this->db->executeQuery($sql);
    }

    // Lấy danh sách khiếu nại cho admin
    public function getAllComplaints($status = null, $limit = 20, $offset = 0)
    {
        $sql = "SELECT oc.*, o.total_amount as order_total, o.created_at as order_date, o.status as order_status,
                       u.username, u.email, oc.type, oc.type as complaint_type
                FROM order_complaints oc
                LEFT JOIN orders o ON oc.order_id = o.id
                LEFT JOIN users u ON oc.user_id = u.id";

        if ($status) {
            $sql .= " WHERE oc.status = '$status'";
        }

        $sql .= " ORDER BY oc.created_at DESC LIMIT $limit OFFSET $offset";

        return $this->db->executeQuery_list($sql);
    }

    // Đếm số lượng khiếu nại
    public function countComplaints($status = null, $user_id = null)
    {
        $sql = "SELECT COUNT(*) as total FROM order_complaints WHERE 1=1";

        if ($status) {
            $sql .= " AND status = '$status'";
        }

        if ($user_id) {
            $sql .= " AND user_id = '$user_id'";
        }

        $result = $this->db->executeQuery($sql, 1);
        return $result['total'] ?? 0;
    }

    // Kiểm tra xem đơn hàng đã có khiếu nại chưa
    public function hasComplaint($order_id, $user_id)
    {
        $sql = "SELECT COUNT(*) as total FROM order_complaints 
                WHERE order_id = '$order_id' AND user_id = '$user_id'";

        $result = $this->db->executeQuery($sql, 1);
        return ($result['total'] ?? 0) > 0;
    }

    // Lấy thống kê khiếu nại
    public function getComplaintStats()
    {
        $sql = "SELECT 
                    status,
                    COUNT(*) as count,
                    type,
                    COUNT(*) as type_count
                FROM order_complaints 
                GROUP BY status, type
                ORDER BY status, type";

        return $this->db->executeQuery_list($sql);
    }

    // Lấy danh sách khiếu nại cho admin với phân trang
    public function getComplaintsForAdmin($page = 1, $limit = 20, $status = '')
    {
        $offset = ($page - 1) * $limit;
        $sql = "SELECT oc.*, o.total_amount as order_total, o.created_at as order_date, o.status as order_status,
                       u.username, u.email, oc.type, oc.type as complaint_type
                FROM order_complaints oc
                LEFT JOIN orders o ON oc.order_id = o.id
                LEFT JOIN users u ON oc.user_id = u.id";

        if ($status) {
            $sql .= " WHERE oc.status = '$status'";
        }

        $sql .= " ORDER BY oc.created_at DESC LIMIT $limit OFFSET $offset";

        return $this->db->executeQuery_list($sql);
    }

    // Lấy chi tiết khiếu nại cho admin
    public function getComplaintDetail($id)
    {
        $sql = "SELECT oc.*, o.total_amount as order_total, o.created_at as order_date, o.status as order_status,
                       u.username, u.email as user_email, u.phone as user_phone, u.created_at as user_created_at,
                       oc.type as complaint_type, oc.priority,
                       admin.username as admin_name
                FROM order_complaints oc
                LEFT JOIN orders o ON oc.order_id = o.id
                LEFT JOIN users u ON oc.user_id = u.id
                LEFT JOIN users admin ON oc.admin_id = admin.id
                WHERE oc.id = '$id'";

        return $this->db->executeQuery($sql, 1);
    }

    // Xóa khiếu nại
    public function deleteComplaint($id)
    {
        $sql = "DELETE FROM order_complaints WHERE id = '$id'";
        return $this->db->executeQuery($sql);
    }
}
?>