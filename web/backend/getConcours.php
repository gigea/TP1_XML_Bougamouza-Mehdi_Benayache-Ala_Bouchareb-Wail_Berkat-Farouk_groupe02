<?php

require_once 'config.php';
require_once 'basex.php';

$query = '
let $doc := collection("' . $DATABASE_NAME . '")/club
return
<concours>
{
for $c in $doc/concours/concours

let $cat :=
    $doc//categorie[@id=$c/@categorieRef]

order by xs:date($c/@date)

return

<concours>

    <id>{data($c/@id)}</id>

    <titre>{data($c/titre)}</titre>

    <date>{data($c/@date)}</date>

    <coefficient>{data($c/@coefficient)}</coefficient>

    <categorie>{data($cat/@libelle)}</categorie>

</concours>
}
</concours>
';

$result = executeXQuery($query, $DATABASE_NAME);

header("Content-Type: application/xml; charset=utf-8");

echo $result;


?>