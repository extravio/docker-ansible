<?php
echo "Test</BR>";

$db = new PDO('mysql:host=mariadb;dbname=SS_metrology;port=3306', 'docker', 'docker');
$sql = "select * from user";
foreach ($db->query($sql) as $row) {
        print $row['User'] . "</BR>";
}
