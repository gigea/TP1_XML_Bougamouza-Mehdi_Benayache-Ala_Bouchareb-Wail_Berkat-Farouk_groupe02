<?php
require_once 'basex.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    $query = $_POST['query'];

    $result = executeXQuery($query, $DATABASE_NAME);

    echo $result;
}
?>