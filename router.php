<?php
// Router for PHP built-in server to handle static files

$uri = urldecode(parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH));

// Handle static files from public directory
if (preg_match('/^\/public\/(.+)$/', $uri, $matches)) {
    $file = __DIR__ . '/public/' . $matches[1];
    
    if (file_exists($file) && is_file($file)) {
        // Get file extension
        $ext = pathinfo($file, PATHINFO_EXTENSION);
        
        // Set appropriate content type
        $contentTypes = [
            'css' => 'text/css',
            'js' => 'application/javascript',
            'png' => 'image/png',
            'jpg' => 'image/jpeg',
            'jpeg' => 'image/jpeg',
            'gif' => 'image/gif',
            'svg' => 'image/svg+xml',
            'webp' => 'image/webp',
            'ico' => 'image/x-icon'
        ];
        
        if (isset($contentTypes[$ext])) {
            header('Content-Type: ' . $contentTypes[$ext]);
        }
        
        // Set no-cache headers for development to see changes immediately
        if (in_array($ext, ['png', 'jpg', 'jpeg', 'gif', 'svg', 'webp', 'ico'])) {
            header('Cache-Control: no-cache, no-store, must-revalidate');
            header('Pragma: no-cache');
            header('Expires: 0');
        }
        
        readfile($file);
        return;
    }
}

// For all other requests, use the main index.php
require_once __DIR__ . '/index.php';
?>