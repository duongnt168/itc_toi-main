<?php
// Voucher Model - Quản lý voucher

require_once 'model.php';

class vouchers extends model
{
    public function __construct()
    {
        parent::__construct();
    }

    // Lấy tất cả voucher
    public function getAllVouchers()
    {
        $sql = "SELECT * FROM {$this->db->tbl_fix}vouchers ORDER BY created_at DESC";
        return $this->db->executeQuery_list($sql);
    }

    // Lấy voucher theo ID
    public function getVoucherById($id)
    {
        $sql = "SELECT * FROM {$this->db->tbl_fix}vouchers WHERE id = '$id'";
        $result = $this->db->executeQuery($sql, 1);
        return $result;
    }

    // Lấy voucher theo code
    public function getByCode($code)
    {
        $sql = "SELECT * FROM {$this->db->tbl_fix}vouchers WHERE code = '$code' AND status = 'active'";
        $result = $this->db->executeQuery($sql, 1);
        return $result;
    }

    // Alias cho getByCode để tương thích
    public function getVoucherByCode($code)
    {
        return $this->getByCode($code);
    }

    // Thêm voucher mới
    public function addVoucher($data)
    {
        $insertData = array(
            'code' => $data['code'],
            'type' => $data['type'],
            'value' => floatval($data['value']),
            'min_order_amount' => isset($data['min_order_amount']) ? floatval($data['min_order_amount']) : 0,
            'max_uses' => isset($data['max_uses']) ? intval($data['max_uses']) : null,
            'start_date' => isset($data['start_date']) ? $data['start_date'] : null,
            'end_date' => isset($data['end_date']) ? $data['end_date'] : null,
            'status' => isset($data['status']) ? $data['status'] : 'active',
            'created_at' => date('Y-m-d H:i:s')
        );

        return $this->db->record_insert("{$this->db->tbl_fix}vouchers", $insertData);
    }

    // Cập nhật voucher
    public function updateVoucher($id, $data)
    {
        $updateData = array(
            'code' => $data['code'],
            'type' => $data['type'],
            'value' => floatval($data['value']),
            'min_order_amount' => isset($data['min_order_amount']) ? floatval($data['min_order_amount']) : 0,
            'max_uses' => isset($data['max_uses']) ? intval($data['max_uses']) : null,
            'start_date' => isset($data['start_date']) ? $data['start_date'] : null,
            'end_date' => isset($data['end_date']) ? $data['end_date'] : null,
            'status' => isset($data['status']) ? $data['status'] : 'active',
            'updated_at' => date('Y-m-d H:i:s')
        );

        return $this->db->record_update("{$this->db->tbl_fix}vouchers", $updateData, "id = '$id'");
    }

    // Xóa voucher
    public function deleteVoucher($id)
    {
        return $this->db->record_delete("{$this->db->tbl_fix}vouchers", "id = '$id'");
    }

    // Kiểm tra voucher có hợp lệ không
    public function validateVoucher($code, $orderAmount = 0)
    {
        $voucher = $this->getVoucherByCode($code);

        if (!$voucher) {
            return ['valid' => false, 'message' => 'Mã voucher không tồn tại hoặc đã hết hạn'];
        }

        // Kiểm tra trạng thái
        if ($voucher['status'] !== 'active') {
            return ['valid' => false, 'message' => 'Mã voucher không còn hiệu lực'];
        }

        // Kiểm tra ngày bắt đầu
        if ($voucher['start_date'] && $voucher['start_date'] !== '0000-00-00 00:00:00' && strtotime($voucher['start_date']) > time()) {
            return ['valid' => false, 'message' => 'Mã voucher chưa có hiệu lực'];
        }

        // Kiểm tra ngày kết thúc
        if ($voucher['end_date'] && $voucher['end_date'] !== '0000-00-00 00:00:00' && strtotime($voucher['end_date']) < time()) {
            return ['valid' => false, 'message' => 'Mã voucher đã hết hạn'];
        }

        // Kiểm tra số lần sử dụng tối đa
        if ($voucher['max_uses'] && $voucher['used_count'] >= $voucher['max_uses']) {
            return ['valid' => false, 'message' => 'Mã voucher đã hết lượt sử dụng'];
        }

        // Kiểm tra giá trị đơn hàng tối thiểu
        if ($voucher['min_order_amount'] && $orderAmount < $voucher['min_order_amount']) {
            return ['valid' => false, 'message' => 'Đơn hàng chưa đạt giá trị tối thiểu để sử dụng voucher'];
        }

        return ['valid' => true, 'voucher' => $voucher];
    }

    // Kiểm tra voucher có hợp lệ không (theo ID)
    public function isValid($voucherId, $orderAmount = 0)
    {
        $voucher = $this->getVoucherById($voucherId);
        
        if (!$voucher) {
            return false;
        }
        
        // Kiểm tra trạng thái
        if ($voucher['status'] !== 'active') {
            return false;
        }
        
        // Kiểm tra ngày bắt đầu
        if ($voucher['start_date'] && $voucher['start_date'] !== '0000-00-00 00:00:00' && strtotime($voucher['start_date']) > time()) {
            return false;
        }
        
        // Kiểm tra ngày kết thúc
        if ($voucher['end_date'] && $voucher['end_date'] !== '0000-00-00 00:00:00' && strtotime($voucher['end_date']) < time()) {
            return false;
        }
        
        // Kiểm tra số lần sử dụng tối đa
        if ($voucher['max_uses'] && $voucher['used_count'] >= $voucher['max_uses']) {
            return false;
        }
        
        // Kiểm tra giá trị đơn hàng tối thiểu
        if ($voucher['min_order_amount'] && $orderAmount < $voucher['min_order_amount']) {
            return false;
        }
        
        return true;
    }

    // Tính toán giảm giá (theo ID voucher)
    public function calculateDiscount($voucherId, $orderAmount)
    {
        $voucher = $this->getVoucherById($voucherId);
        
        if (!$voucher) {
            return 0;
        }
        
        if ($voucher['type'] === 'percentage') {
            return ($orderAmount * $voucher['value']) / 100;
        } else {
            return min($voucher['value'], $orderAmount);
        }
    }
    
    // Tính toán giảm giá (theo array voucher) - để tương thích
    public function calculateDiscountByVoucher($voucher, $orderAmount)
    {
        if ($voucher['type'] === 'percentage') {
            return ($orderAmount * $voucher['value']) / 100;
        } else {
            return min($voucher['value'], $orderAmount);
        }
    }

    // Sử dụng voucher (tăng used_count)
    public function useVoucher($code)
    {
        $sql = "UPDATE {$this->db->tbl_fix}vouchers SET used_count = used_count + 1 WHERE code = '$code'";
        return $this->db->executeQuery($sql);
    }

    // Tạo mã voucher ngẫu nhiên
    public function generateVoucherCode($prefix = 'VOUCHER')
    {
        do {
            $randomNumber = rand(1000, 9999);
            $code = $prefix . $randomNumber;
            $existing = $this->getVoucherByCode($code);
        } while ($existing);

        return $code;
    }

    // Lấy voucher theo trạng thái
    public function getVouchersByStatus($status)
    {
        $sql = "SELECT * FROM {$this->db->tbl_fix}vouchers WHERE status = '$status' ORDER BY created_at DESC";
        return $this->db->executeQuery_list($sql);
    }

    // Lấy voucher còn hiệu lực
    public function getActiveVouchers()
    {
        $sql = "SELECT * FROM {$this->db->tbl_fix}vouchers 
                WHERE status = 'active' 
                AND (start_date IS NULL OR start_date <= NOW()) 
                AND (end_date IS NULL OR end_date >= NOW())
                AND (max_uses IS NULL OR used_count < max_uses)
                ORDER BY created_at DESC";
        return $this->db->executeQuery_list($sql);
    }
}
?>