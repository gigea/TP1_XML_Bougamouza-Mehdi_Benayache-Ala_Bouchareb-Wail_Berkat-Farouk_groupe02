xquery version "3.1";

declare variable $doc := doc("club.xml");
declare variable $categorie := "Intelligence Artificielle";

(: ====================================================== :)
(: Q1 — Liste complète des membres :)
(: Affiche ID, nom complet, email et catégorie :)
(: ====================================================== :)
let $q1 :=
<membres>
{
  for $m in $doc//membre
    let $cat := $doc//categorie[@id = $m/@categorieRef]

  return
    <membre id="{data($m/@id)}">
      <nomComplet>
        {concat(data($m/prenom), " ", data($m/nom))}
      </nomComplet>
      <email>{data($m/email)}</email>
      <categorie>{data($cat/@libelle)}</categorie>
    </membre>
}
</membres>

(: ====================================================== :)
(: Q2 — Liste des concours triés par date :)
(: ====================================================== :)
let $q2 :=
<concours>
{
  for $c in $doc/club/concours/concours
    let $cat := $doc//categorie[@id = $c/@categorieRef]
    order by xs:date($c/@date)

  return
    <concours id="{data($c/@id)}">
      <titre>{data($c/titre)}</titre>
      <date>{data($c/@date)}</date>
      <coefficient>{data($c/@coefficient)}</coefficient>
      <categorie>{data($cat/@libelle)}</categorie>
    </concours>
}
</concours>

(: ====================================================== :)
(: Q3 — Calcul des scores des participants :)
(: score = (complexite + tempsExecution) × coefficient :)
(: ====================================================== :)
let $q3 :=
<resultats>
{
  for $c in $doc/club/concours/concours
    let $coef := xs:decimal($c/@coefficient)

  return
    <concours titre="{data($c/titre)}">
    {
      for $p in $c/participants/participant
        let $m := $doc//membre[@id = $p/@membreRef]
        let $compl := xs:integer($p/complexite)
        let $temps := xs:integer($p/tempsExecution)
        let $score := round-half-to-even(
          ($compl + $temps) * $coef,
          2
        )
      return
        <participant>
          <nom>{data($m/nom)}</nom>
          <prenom>{data($m/prenom)}</prenom>
          <complexite>{$compl}</complexite>
          <tempsExecution>{$temps}</tempsExecution>
          <score>{$score}</score>
        </participant>
    }
    </concours>
}
</resultats>

(: ====================================================== :)
(: Q4 — Vainqueur de chaque concours :)
(: Affiche tous les ex-aequo si égalité :)
(: ====================================================== :)
let $q4 :=
<vainqueurs>
{
  for $c in $doc/club/concours/concours
    let $coef := xs:decimal($c/@coefficient)
    let $scores :=
      for $p in $c/participants/participant
        return
          (xs:integer($p/complexite)
          + xs:integer($p/tempsExecution))
          * $coef
    let $maxScore := max($scores)
  return
    <concours titre="{data($c/titre)}" date="{data($c/@date)}">
    {
      for $p in $c/participants/participant
        let $m := $doc//membre[@id = $p/@membreRef]
        let $score :=
          (xs:integer($p/complexite)
          + xs:integer($p/tempsExecution))
          * $coef
        where $score = $maxScore
      return
        <vainqueur>
          <nom>{data($m/nom)}</nom>
          <prenom>{data($m/prenom)}</prenom>
          <score>{round-half-to-even($score, 2)}</score>
        </vainqueur>
    }
    </concours>
}
</vainqueurs>

(: ====================================================== :)
(: Q5 — Membres d'une catégorie donnée :)
(: Trier par nom puis prénom :)
(: ====================================================== :)
let $q5 :=
<membresCategorie>
{
  let $cat := $doc//categorie[@libelle = $categorie]
  for $m in $doc//membre[@categorieRef = $cat/@id]
    order by
      lower-case(data($m/nom)),
      lower-case(data($m/prenom))
  return
    <membre id="{data($m/@id)}">
      <nom>{data($m/nom)}</nom>
      <prenom>{data($m/prenom)}</prenom>
      <email>{data($m/email)}</email>
    </membre>
}
</membresCategorie>

return
($q1, $q2, $q3, $q4, $q5)