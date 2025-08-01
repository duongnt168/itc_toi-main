<?php
class model
{

	protected $class_name = 'model';
	protected $paramater;
	protected $db;

	public function __construct()
	{
		global $db;
		$this->db = $db;
	}

	// set value with paramater
	public function set($parameter, $val)
	{
		$this->$parameter = $val;
		return true;
	}
	// get value with paramater
	public function get($parameter)
	{
		return $this->$parameter;
	}

	// get value with paramater
	public function get_detail()
	{
		global $db;

		$sql = "SELECT * FROM $db->tbl_fix`" . $this->class_name . "` WHERE `id` = '" . $this->get('id') . "'";
		$result = $db->executeQuery($sql, 1);

		return $result;
	}

	//Cập nhất một trường trong bảng đúng theo tên trường (field)
	public function update_field($field)
	{
		global $db;
		$id = $this->get('id');

		$arr[$field] = $this->get($field);

		if (isset($arr[$field]))
			$db->record_update($db->tbl_fix . '`' . $this->class_name . '`', $arr, " `id` = '$id' ");

		return true;
	}

	// Lấy một giá trị của trường trong bảng đúng theo tên trường (field)
	public function get_by_field($field)
	{
		global $db;

		$d = $this->get_detail();
		if (isset($d[$field]))
			return $d[$field];

		return 'Undefined';
	}

	//lấy tất cả danh sách bản ghi trong bảng và sắp xếp theo trường id
	public function list_all_sort_by_id($ofset = 0, $limit = '', $orderBy = '')
	{
		global $db;

		if ($limit != '')
			$limit = " LIMIT $ofset, $limit ";

		if ($orderBy != 'DESC' && $orderBy != 'ASC')
			$orderBy = 'DESC';

		$sql = "SELECT * FROM $db->tbl_fix`$this->class_name` ORDER BY `id` $orderBy $limit ";

		$result = $db->executeQuery_list($sql);

		return $result;
	}

	//Liệt kế tất cả bản ghi trong bảng
	public function list_all($ofset = 0, $limit = '')
	{
		global $db;

		if ($limit != '')
			$limit = " LIMIT $ofset, $limit ";

		$sql = "SELECT * FROM $db->tbl_fix`" . $this->class_name . "` $limit ";

		$result = $db->executeQuery_list($sql);

		return $result;
	}

	//đếm số lượng bản ghi trong bảng
	public function list_all_count()
	{
		global $db;

		$sql = "SELECT COUNT(*) total FROM $db->tbl_fix`" . $this->class_name . "` ";

		$result = $db->executeQuery($sql, 1);

		return $result['total'] + 0;
	}

	//xóa bản ghi trong bảng
	public function delete()
	{
		global $db;

		$result = $db->record_delete($db->tbl_fix . $this->class_name, " `id` = '" . $this->get('id') . "'");

		return $result;
	}

}