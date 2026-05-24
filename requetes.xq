(: ──────────────────────────────────────────────────────────
   Q1 — Liste complète des membres (1 pt)
   Affiche : id, nom complet, email et libellé de la catégorie
   ────────────────────────────────────────────────────────── :)

(: Q1 :)
let $doc := doc("club.xml")
return
<membres>
{
  (: Pour chaque membre du document :)
  for $m in $doc//membre
    (: Jointure : retrouver la catégorie correspondant à categorieRef :)
    let $cat := $doc//categorie[@id = $m/@categorieRef]
  return
    <membre id="{$m/@id}">
      (: Concaténation prénom + nom pour le nom complet :)
      <nomComplet>{ concat($m/prenom, ' ', $m/nom) }</nomComplet>
      <email>{ string($m/email) }</email>
      <categorie>{ string($cat/@libelle) }</categorie>
    </membre>
}
</membres>


(: ──────────────────────────────────────────────────────────
   Q2 — Liste des concours (1 pt)
   Affiche : titre, date, coefficient, libellé catégorie
   Triés par date croissante
   ────────────────────────────────────────────────────────── :)

(: Q2 :)
let $doc := doc("club.xml")
return
<concours>
{
  (: FLWOR avec tri par date :)
  for $c in $doc//concours/concours
    (: Jointure : récupérer la catégorie liée au concours :)
    let $cat := $doc//categorie[@id = $c/@categorieRef]
    (: Tri par date croissante (xs:date pour comparer correctement) :)
    order by xs:date($c/@date) ascending
  return
    <concours id="{$c/@id}">
      <titre>{ string($c/titre) }</titre>
      <date>{ string($c/@date) }</date>
      <coefficient>{ string($c/@coefficient) }</coefficient>
      <categorie>{ string($cat/@libelle) }</categorie>
    </concours>
}
</concours>


(: ──────────────────────────────────────────────────────────
   Q3 — Calcul des scores de chaque participant (2 pts)
   Formule : score = (complexite + tempsExecution) × coefficient
   Arrondi à 2 décimales
   ────────────────────────────────────────────────────────── :)

(: Q3 :)
let $doc := doc("club.xml")
return
<resultats>
{
  (: Boucle sur chaque concours :)
  for $c in $doc//concours/concours
    (: Coefficient converti en décimal pour le calcul :)
    let $coef := xs:decimal($c/@coefficient)
  return
    <concours titre="{$c/titre}">
    {
      (: Boucle sur chaque participant du concours :)
      for $p in $c//participant
        (: Récupération du membre via membreRef pour obtenir son nom :)
        let $m      := $doc//membre[@id = $p/@membreRef]
        let $compl  := xs:integer($p/complexite)
        let $temps  := xs:integer($p/tempsExecution)
        (: Calcul du score et arrondi à 2 décimales :)
        let $score  := round(($compl + $temps) * $coef * 100) div 100
      return
        <participant>
          <nom>{ concat($m/prenom, ' ', $m/nom) }</nom>
          <complexite>{ $compl }</complexite>
          <tempsExecution>{ $temps }</tempsExecution>
          <score>{ $score }</score>
        </participant>
    }
    </concours>
}
</resultats>


(: ──────────────────────────────────────────────────────────
   Q4 — Vainqueur de chaque concours (2 pts)
   Participant ayant le score maximum.
   En cas d'égalité, tous les ex-aequo sont affichés.
   ────────────────────────────────────────────────────────── :)

(: Q4 :)
let $doc := doc("club.xml")
return
<vainqueurs>
{
  for $c in $doc//concours/concours
    let $coef := xs:decimal($c/@coefficient)
    (: Calcul du score de chaque participant :)
    let $scores :=
      for $p in $c//participant
        let $compl := xs:integer($p/complexite)
        let $temps := xs:integer($p/tempsExecution)
        let $score := round(($compl + $temps) * $coef * 100) div 100
      return $score
    (: Score maximum du concours :)
    let $maxScore := max($scores)
  return
    <concours titre="{$c/titre}" date="{$c/@date}">
    {
      (: Filtrer les participants dont le score = max (gère les ex-aequo) :)
      for $p in $c//participant
        let $m     := $doc//membre[@id = $p/@membreRef]
        let $compl := xs:integer($p/complexite)
        let $temps := xs:integer($p/tempsExecution)
        let $score := round(($compl + $temps) * $coef * 100) div 100
        where $score = $maxScore
      return
        <vainqueur>
          <prenom>{ string($m/prenom) }</prenom>
          <nom>{ string($m/nom) }</nom>
          <score>{ $score }</score>
        </vainqueur>
    }
    </concours>
}
</vainqueurs>


(: ──────────────────────────────────────────────────────────
   Q5 — Membres d'une catégorie donnée (2 pts)
   Variable $categorie : changer la valeur pour filtrer.
   Tri alphabétique par nom, puis par prénom.
   ────────────────────────────────────────────────────────── :)

(: Q5 :)
let $doc       := doc("club.xml")
(: ← Modifier cette valeur pour filtrer une autre catégorie :)
let $categorie := "Intelligence Artificielle"
(: Retrouver l'id de la catégorie correspondant au libellé :)
let $catId     := $doc//categorie[@libelle = $categorie]/@id
return
<membres categorie="{$categorie}">
{
  (: Filtrer les membres de la catégorie, triés nom puis prénom :)
  for $m in $doc//membre[@categorieRef = $catId]
    order by $m/nom ascending, $m/prenom ascending
  return
    <membre id="{$m/@id}">
      <nom>{ string($m/nom) }</nom>
      <prenom>{ string($m/prenom) }</prenom>
      <email>{ string($m/email) }</email>
    </membre>
}
</membres>
