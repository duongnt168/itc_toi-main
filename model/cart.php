<?php

class Cart extends model
{
    protected $class_name = 'cart';
    protected $id;
    protected $user_id;
    protected $product_id;
    protected $quantity;
    protected $created_at;
    
    public function __construct()
    {
        // Constructor for Cart model
    }
    
    public function getCartByUserId($user_id)
    {
        $sql = "SELECT c.*, p.name, p.price, p.file_url, p.stock 
                FROM cart c 
                LEFT JOIN products p ON c.product_id = p.id 
                WHERE c.user_id = '$user_id' AND p.status = 'active'
                ORDER BY c.created_at DESC";
        return $this->db->executeQuery_list($sql);
    }
    
    public function addToCart($user_id, $product_id, $quantity)
    {
        // Kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
        $existing = $this->getCartItem($user_id, $product_id);
        
        if ($existing) {
            // Cập nhật số lượng
            $new_quantity = $existing['quantity'] + $quantity;
            return $this->updateQuantity($user_id, $product_id, $new_quantity);
        } else {
            // Thêm mới
            $data = [
                'user_id' => $user_id,
                'product_id' => $product_id,
                'quantity' => $quantity,
                'created_at' => date('Y-m-d H:i:s')
            ];
            return $this->db->record_insert('cart', $data);
        }
    }
    
    public function getCartItem($user_id, $product_id)
    {
        $sql = "SELECT * FROM cart WHERE user_id = '$user_id' AND product_id = '$product_id'";
        $result = $this->db->executeQuery_list($sql);
        return !empty($result) ? $result[0] : null;
    }
    
    public function updateQuantity($user_id, $product_id, $quantity)
    {
        if ($quantity <= 0) {
            return $this->removeFromCart($user_id, $product_id);
        }
        
        $data = ['quantity' => $quantity];
        $where = "user_id = '$user_id' AND product_id = '$product_id'";
        return $this->db->record_update('cart', $data, $where);
    }
    
    public function removeFromCart($user_id, $product_id)
    {
        $where = "user_id = '$user_id' AND product_id = '$product_id'";
        return $this->db->record_delete('cart', $where);
    }
    
    public function clearCart($user_id)
    {
        $where = "user_id = '$user_id'";
        return $this->db->record_delete('cart', $where);
    }
    
    public function getCartTotal($user_id)
    {
        $sql = "SELECT SUM(c.quantity * p.price) as total 
                FROM cart c 
                LEFT JOIN products p ON c.product_id = p.id 
                WHERE c.user_id = '$user_id' AND p.status = 'active'";
        $result = $this->db->executeQuery($sql, 1);
        return $result ? $result['total'] : 0;
    }
    
    public function getCartCount($user_id)
    {
        $sql = "SELECT SUM(quantity) as count FROM cart WHERE user_id = '$user_id'";
        $result = $this->db->executeQuery($sql, 1);
        return $result ? $result['count'] : 0;
    }
}