<?php

require_once 'config.php';
require_once 'BaseXClient.php';

function executeXQuery($query, $dbName = null)
{
    global $BASEX_HOST;
    global $BASEX_PORT;
    global $BASEX_USER;
    global $BASEX_PASSWORD;

    $session = new BaseXSession(
        $BASEX_HOST,
        $BASEX_PORT,
        $BASEX_USER,
        $BASEX_PASSWORD
    );

    if ($dbName !== null && $dbName !== '') {
        try {
            $session->execute('OPEN ' . $dbName);
        } catch (Exception $e) {
            if (strpos($e->getMessage(), "Database '$dbName' was not found") !== false) {
                $xmlPath = realpath(__DIR__ . '/../club.xml');
                if ($xmlPath === false) {
                    $session->close();
                    throw new Exception('club.xml not found in project root.');
                }
                $escapedPath = str_replace('"', '\\"', $xmlPath);
                $session->execute('CREATE DB ' . $dbName . ' "' . $escapedPath . '"');
                $session->execute('OPEN ' . $dbName);
            } else {
                $session->close();
                throw $e;
            }
        }
    }

    $result = $session->query($query)->execute();
    $session->close();

    return $result;
}
?>