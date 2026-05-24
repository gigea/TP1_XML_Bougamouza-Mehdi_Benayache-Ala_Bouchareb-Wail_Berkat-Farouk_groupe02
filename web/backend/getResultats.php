<?php
require_once 'basex.php';

$concoursId = $_GET['concoursId'];

$query = '
let $doc := collection("' . $DATABASE_NAME . '")/club
for $c in $doc//concours[@id="' . $concoursId . '"]
let $coef := xs:decimal($c/@coefficient)
for $p in $c/participants/participant
let $m := $doc//membre[@id=$p/@membreRef]
let $score := (xs:integer($p/complexite) + xs:integer($p/tempsExecution)) * $coef
order by $score descending
return
<resultat>
    <nom>{data($m/nom)}</nom>
    <prenom>{data($m/prenom)}</prenom>
    <score>{round-half-to-even($score, 2)}</score>
</resultat>
';

header('Content-Type: application/xml; charset=utf-8');
echo executeXQuery($query, $DATABASE_NAME);
?>