<?php

require_once 'config.php';
require_once 'basex.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('HTTP/1.1 405 Method Not Allowed');
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode(["success" => false, "message" => "Méthode non autorisée"]);
    exit;
}

$concoursId = $_POST['concoursId'] ?? '';
$membreRef = $_POST['membreRef'] ?? '';
$complexite = $_POST['complexite'] ?? '';
$tempsExecution = $_POST['tempsExecution'] ?? '';

$query = '
insert node

<participant membreRef="' . $membreRef . '">

    <complexite>' . $complexite . '</complexite>

    <tempsExecution>' . $tempsExecution . '</tempsExecution>

</participant>

into
collection("' . $DATABASE_NAME . '")//concours[@id="' . $concoursId . '"]/participants
';

$result = executeXQuery($query, $DATABASE_NAME);

header('Content-Type: application/json; charset=utf-8');
echo json_encode([
    "success" => true,
    "message" => "Participant ajouté",
    "result" => $result
]);

?>