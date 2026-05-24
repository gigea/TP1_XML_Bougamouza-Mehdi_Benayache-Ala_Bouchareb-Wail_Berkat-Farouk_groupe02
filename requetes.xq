
(: ─────────────────────────────────────────────
   Q1 — Liste complète des membres
   ───────────────────────────────────────────── :)
let $doc := doc("club.xml")
return
<membres>
{
  for $m in $doc//membre
  let $cat := $doc//categorie[@id = $m/@categorieRef]
  return
    <membre id="{$m/@id}">
      <nomComplet>{ concat($m/prenom, ' ', $m/nom) }</nomComplet>
      <email>{ string($m/email) }</email>
      <categorie>{ string($cat/@libelle) }</categorie>
    </membre>
}
</membres>


(: ─────────────────────────────────────────────
   Q2 — Liste des concours triés par date
   ───────────────────────────────────────────── :)
let $doc := doc("club.xml")
return
<concours>
{
  for $c in $doc//concours
  let $cat := $doc//categorie[@id = $c/@categorieRef]
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


(: ─────────────────────────────────────────────
   Q3 — Calcul des scores
   ───────────────────────────────────────────── :)
let $doc := doc("club.xml")
return
<tousResultats>
{
  for $c in $doc//concours
  let $coef := xs:decimal($c/@coefficient)
  return
    <resultats titre="{string($c/titre)}">
    {
      for $p in $c//participant
      let $m     := $doc//membre[@id = $p/@membreRef][1]
      let $compl := xs:integer($p/complexite)
      let $temps := xs:integer($p/tempsExecution)
      let $score := round(($compl * $coef + $temps) * 100) div 100
      return
        <participant>
          <nom>{ concat($m/prenom, ' ', $m/nom) }</nom>
          <complexite>{ $compl }</complexite>
          <tempsExecution>{ $temps }</tempsExecution>
          <score>{ $score }</score>
        </participant>
    }
    </resultats>
}
</tousResultats>


(: ─────────────────────────────────────────────
   Q4 — Vainqueurs
   ───────────────────────────────────────────── :)
let $doc := doc("club.xml")
return
<tousVainqueurs>
{
  for $c in $doc//concours
  let $coef := xs:decimal($c/@coefficient)

  let $scores :=
    for $p in $c//participant
    let $compl := xs:integer($p/complexite)
    let $temps := xs:integer($p/tempsExecution)
    return round(($compl * $coef + $temps) * 100) div 100

  let $maxScore := max($scores)

  return
    <vainqueurs titre="{string($c/titre)}" date="{string($c/@date)}">
    {
      for $p in $c//participant
      let $m     := $doc//membre[@id = $p/@membreRef][1]
      let $compl := xs:integer($p/complexite)
      let $temps := xs:integer($p/tempsExecution)
      let $score := round(($compl * $coef + $temps) * 100) div 100
      where $score = $maxScore
      return
        <vainqueur>
          <prenom>{ string($m/prenom) }</prenom>
          <nom>{ string($m/nom) }</nom>
          <score>{ $score }</score>
        </vainqueur>
    }
    </vainqueurs>
}
</tousVainqueurs>


(: ─────────────────────────────────────────────
   Q5 — Membres par catégorie
   ───────────────────────────────────────────── :)
let $doc      := doc("club.xml")
let $categorie := "Intelligence Artificielle"
let $catId    := $doc//categorie[@libelle = $categorie]/@id
return
  <membres categorie="{$categorie}">
  {
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
