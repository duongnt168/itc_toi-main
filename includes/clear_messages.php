<?php
// Clear session messages after displaying them
if (isset($_SESSION['success'])) {
    unset($_SESSION['success']);
}
if (isset($_SESSION['error'])) {
    unset($_SESSION['error']);
}
?>