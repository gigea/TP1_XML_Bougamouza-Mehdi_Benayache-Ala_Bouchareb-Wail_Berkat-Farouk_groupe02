xquery version "3.1";

(: ═══════════════════════════════════════════════════════════
   Fichier : updates.xq
   Projet  : Club Info_Tech — TP XML / XSD / XQuery
   Moteur  : BaseX 10+ (XQuery Update Facility)
   
   IMPORTANT : Dans BaseX, les requêtes de mise à jour modifient
   le document en base de données. Charger d'abord club.xml :
     CREATE DB clubdb club.xml
   Puis exécuter chaque update séparément.
   ═══════════════════════════════════════════════════════════ :)


(: ──────────────────────────────────────────────────────────
   UPDATE 1 — INSERTION d'un nouveau membre (1.5 pt)
   Ajout du membre M012 dans la catégorie C2 (Développement Web).
   L'identifiant M012 ne conflicte avec aucun ID existant.
   
   État avant :
     <membres> contient M001 … M011
   État après :
     <membres> contient M001 … M011, M012
   ────────────────────────────────────────────────────────── :)

(: UPDATE 1 — Insertion :)
(
insert node
  <membre id="M012" categorieRef="C2">
    <nom>Ferhat</nom>
    <prenom>Imane</prenom>
    <email>i.ferhat@club.dz</email>
  </membre>
into doc("club.xml")//membres,


(: ──────────────────────────────────────────────────────────
   UPDATE 2 — MODIFICATION du coefficient de CO2 (1.5 pt)
   Le concours CO2 (Hackathon Web) passe de coefficient 1.2 à 2.0.
   
   État avant :
     <concours id="CO2" ... coefficient="1.2">
   État après :
     <concours id="CO2" ... coefficient="2.0">
   ────────────────────────────────────────────────────────── :)

(: UPDATE 2 — Modification du coefficient de CO2 :)
replace value of node
  doc("club.xml")//concours[@id = "CO2"]/@coefficient
with "2.0",


(: ──────────────────────────────────────────────────────────
   UPDATE 3 — SUPPRESSION d'un participant (1 pt)
   Suppression du participant M007 dans le concours CO3.
   Le concours CO3 subsiste avec les participants M008 et M009.
   
   État avant CO3 :
     <participants>
       <participant membreRef="M007"> ... </participant>
       <participant membreRef="M008"> ... </participant>
       <participant membreRef="M009"> ... </participant>
     </participants>
   État après CO3 :
     <participants>
       <participant membreRef="M008"> ... </participant>
       <participant membreRef="M009"> ... </participant>
     </participants>
   ────────────────────────────────────────────────────────── :)

(: UPDATE 3 — Suppression du participant M007 dans CO3 :)
delete node
  doc("club.xml")//concours[@id = "CO3"]
    //participant[@membreRef = "M007"]
)


(: ──────────────────────────────────────────────────────────
   VÉRIFICATIONS — Requêtes de contrôle après les updates
   (À exécuter séparément en mode lecture seule)
   ────────────────────────────────────────────────────────── :)

(: Vérification 1 : Afficher tous les membres pour confirmer l'ajout de M012 :)
(: doc("club.xml")//membre[@id = "M012"] :)

(: Vérification 2 : Afficher le coefficient de CO2 pour confirmer la modification :)
(: doc("club.xml")//concours[@id = "CO2"]/@coefficient :)

(: Vérification 3 : Afficher les participants de CO3 pour confirmer la suppression :)
(: doc("club.xml")//concours[@id = "CO3"]//participant :)
