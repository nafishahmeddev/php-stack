<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

echo "=== PhpSpreadsheet Test ===\n\n";

// Check PHP version
echo "PHP Version: " . phpversion() . "\n\n";

// Check if autoload exists
$autoloadPath = '/test/vendor/autoload.php';
echo "Checking autoload at: $autoloadPath\n";

if (!file_exists($autoloadPath)) {
    echo "❌ ERROR: Composer autoload not found!\n";
    echo "Run: docker exec php-test-fpm bash -c 'cd /test && composer require \"phpoffice/phpspreadsheet:~1.14.0\"'\n";
    exit(1);
}

require $autoloadPath;
echo "✓ Autoload loaded successfully\n\n";

// Check if PhpSpreadsheet is available
if (!class_exists('PhpOffice\PhpSpreadsheet\Spreadsheet')) {
    echo "❌ ERROR: PhpSpreadsheet class not found!\n";
    exit(1);
}

echo "✓ PhpSpreadsheet class found\n\n";

try {
    // Create new spreadsheet
    echo "Creating spreadsheet...\n";
    $spreadsheet = new \PhpOffice\PhpSpreadsheet\Spreadsheet();
    $sheet = $spreadsheet->getActiveSheet();
    
    // Add headers
    $sheet->setCellValue('A1', 'Name');
    $sheet->setCellValue('B1', 'Age');
    $sheet->setCellValue('C1', 'Email');
    
    // Add data
    $sheet->setCellValue('A2', 'John Doe');
    $sheet->setCellValue('B2', 30);
    $sheet->setCellValue('C2', 'john@example.com');
    
    $sheet->setCellValue('A3', 'Jane Smith');
    $sheet->setCellValue('B3', 25);
    $sheet->setCellValue('C3', 'jane@example.com');
    
    // Save to file
    $filename = '/tmp/test_' . date('YmdHis') . '.xlsx';
    echo "Saving to: $filename\n";
    
    $writer = new \PhpOffice\PhpSpreadsheet\Writer\Xlsx($spreadsheet);
    $writer->save($filename);
    
    // Verify file was created
    if (file_exists($filename)) {
        $filesize = filesize($filename);
        echo "✓ SUCCESS! File created: $filename (" . round($filesize/1024, 2) . " KB)\n";
    } else {
        echo "❌ ERROR: File was not created\n";
        exit(1);
    }
    
} catch (Exception $e) {
    echo "❌ ERROR: " . $e->getMessage() . "\n";
    echo "Stack trace:\n" . $e->getTraceAsString() . "\n";
    exit(1);
}

echo "\n=== Test completed successfully! ===\n";
