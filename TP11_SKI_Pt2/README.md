### Description

Ce TP est la suite du TP précédent

### Insersion des données dans la table

```sql
INSERT INTO Clients (noCli, nom, prenom, adresse, cpo, ville)
VALUES
(20, 'Dubosc', 'Frank', '12 avenue des flots bleus', '76140', 'Petit-Quevilly'),
(21, 'Boon', 'Dany', "22 rue des Ch\'tis'", '59280', 'Armentières'),
(22, 'Elmaleh', 'Gad', '45 rue du sentier', '75001', 'Paris'),
(23, 'Dujardin', 'Jean', 'rue Brice', '92500', 'Rueil-Malmaison'),
(24, 'Marceau', 'Sophie', 'Boulevard de la Boom', '75010', 'Paris'),
(25, 'Merad', 'Kad', 'Rue du petit nicolas', '91130', 'Ris-Orangis'),
(26, 'Seigner', 'Mathilde', '357 rue du Camping', '75012', 'Paris'),
(27, 'Reno', 'Jean', '78 Boulevard de Lyon', '51200', 'Montmirail'),
(28, 'Lanvin', 'Gérard', "84 avenue de l\'aile ou la cuisse'", '92100', 'Boulogne-Billancourt'),
(29, 'Tautou', 'Audrey', 'rue de Montmartre', '63110', 'Beaumont'),
(30, 'Cotillard', 'Marion', '45 rue de la Même', '13001', 'Marseille'),
(31, 'Duris', 'Romain', "76 rue de l\'arnaqueur'", '06000', 'Nice'),
(32, 'Depardieu', 'Gérard', '57 rue du conte de Monté-Cristo', '36000', 'Châteauroux'),
(33, 'Youn', 'Michael', 'rue de la beuze', '92150', 'Suresnes'),
(34, 'Poelvoorde', 'Benoït', '22 rue du Boulet', '22500', 'Paimpol'),
(35, 'Paradis', 'Vanessa', '12 rue des arnaqueurs', '94100', 'Saint-Maur-des-Fossés'),
(36, 'Wilson', 'Lambert', '100 rue de Dieu', '92200', 'Neuilly-sur-Seine'),
(37, 'Garcia', 'José', '65 rue de la vérité', '75001', 'Paris'),
(38, 'Luchini', 'Fabrice', '73 rue de Beaumarchais', '75016', 'Paris'),
(39, 'Baye', 'Nathalie', '33 rue de Vénus', '27150', 'Mainneville'),
(40, 'Magimel', 'Benoït', '47 rue des petits mouchoirs', '33950', 'Lège-Cap-Ferret'),
(41, 'Cluzet', 'François', '7 rue des apprentis', '75018', 'Paris'),
(42, 'Frot', 'Catherine', 'rue Odette', '69110', 'Sainte Foy-les-Lyon'),
(43, 'Dupontel', 'Albert', '11 impasse de Bernie', '78100', 'Saint-Germain-en-Laye'),
(44, 'Huppert', 'Isabelle', '8 rue des femmes', '75002', 'Paris'),
(45, 'Deneuve', 'Catherine', '12 rue de Rochefort', '50100', 'Cherbourg-Octeville'),
(46, 'de France', 'Cécile', "17 rue de l\'auberge espagnole'", '08000', 'Charlesville-Mézières');

INSERT INTO Fiches (noFic, noCli, dateCrea, datePaiement, etat)
VALUES
(9909, 20, DATE_SUB(NOW(), INTERVAL 284 DAY), DATE_SUB(NOW(), INTERVAL 282 DAY), 'SO'),
(9910, 21, DATE_SUB(NOW(), INTERVAL 68 DAY), NULL, 'RE');

INSERT INTO LignesFic (noFic, noLig, refart, depart, retour)
VALUES
(9909, 1, 'A10', DATE_SUB(NOW(), INTERVAL 284 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 284 DAY), INTERVAL 6 HOUR)),
(9909, 2, 'S01', DATE_SUB(NOW(), INTERVAL 284 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 282 DAY), INTERVAL 6 HOUR)),
(9910, 1, 'P01', DATE_SUB(NOW(), INTERVAL 68 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 59 DAY), INTERVAL 6 HOUR)),
(9910, 2, 'S01', DATE_SUB(NOW(), INTERVAL 68 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 65 DAY), INTERVAL 6 HOUR)),
(9910, 3, 'A02', DATE_SUB(NOW(), INTERVAL 68 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 66 DAY), INTERVAL 6 HOUR)),
(9910, 4, 'F03', DATE_SUB(NOW(), INTERVAL 68 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 62 DAY), INTERVAL 6 HOUR)),
(9910, 5, 'F22', DATE_SUB(NOW(), INTERVAL 68 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 63 DAY), INTERVAL 6 HOUR));
```

### 1️⃣ Liste des clients (nom, prénom, adresse, code postal, ville) ayant au moins une fiche de location en cours.

```sql
SELECT DISTINCT
	c.nom,
    c.prenom,
    c.cpo,
    c.adresse,
    c.ville
FROM
	clients c
JOIN
	fiches f ON c.noCli = f.noCli
JOIN
	lignesfic l ON f.noFic = l.noFic
WHERE
	l.retour is NULL;
```

| Nom       | Prénom   | Code Postal | Adresse              | Ville           |
| --------- | -------- | ----------- | -------------------- | --------------- |
| Albert    | Anatole  | 61000       | Rue des accacias     | Amiens          |
| Bernard   | Barnabé  | 1000        | Rue du bar           | Bourg en Bresse |
| Dupond    | Camille  | 44000       | Rue Crébillon        | Nantes          |
| Desmoulin | Daniel   | 21000       | Rue descendante      | Dijon           |
| Ferdinand | François | 44100       | Rue de la convention | Nantes          |

### 2️⃣ Détail de la fiche de location de M. Dupond Jean de Paris (avec la désignation des articles loués, la date de départ et de retour).

```sql
SELECT
f.noFic,
c.nom,
c.prenom,
l.refart,
a.designation,
l.depart,
l.retour
FROM
    clients c
JOIN
    fiches f ON c.noCli = f.noCli
JOIN
    lignesfic l ON f.noFic = l.noFic
JOIN
    articles a ON l.refart = a.refart
WHERE
    c.nom = 'Dupond' AND c.prenom = 'Jean' AND c.ville = 'Paris'
```

| noFic | Nom    | Prénom | Refart | Désignation          | Départ     | Retour     |
| ----- | ------ | ------ | ------ | -------------------- | ---------- | ---------- |
| 1006  | Dupond | Jean   | S01    | Décathlon Apparition | 2025-01-20 | 2025-01-21 |
| 1006  | Dupond | Jean   | S02    | Décathlon Apparition | 2025-01-20 | 2025-01-21 |
| 1006  | Dupond | Jean   | S03    | Décathlon Apparition | 2025-01-20 | 2025-01-21 |

### 3️⃣ Liste de tous les articles (référence, désignation et libellé de la catégorie) dont le libellé de la catégorie contient ski.

```sql
SELECT
    a.refart,
    a.designation,
    c.libelle
FROM
    articles a
JOIN
    categories c ON a.codeCate = c.codeCate
WHERE
    c.libelle LIKE '%ski%';
```

| Refart | Désignation                   | Libellé                |
| ------ | ----------------------------- | ---------------------- |
| F01    | Fischer Cruiser               | Ski de fond alternatif |
| F02    | Fischer Cruiser               | Ski de fond alternatif |
| F03    | Fischer Cruiser               | Ski de fond alternatif |
| F04    | Fischer Cruiser               | Ski de fond alternatif |
| F05    | Fischer Cruiser               | Ski de fond alternatif |
| F10    | Fischer Sporty Crown          | Ski de fond alternatif |
| F20    | Fischer RCS Classic GOLD      | Ski de fond alternatif |
| F21    | Fischer RCS Classic GOLD      | Ski de fond alternatif |
| F22    | Fischer RCS Classic GOLD      | Ski de fond alternatif |
| F23    | Fischer RCS Classic GOLD      | Ski de fond alternatif |
| F50    | Fischer SOSSkating VASA       | Ski de fond patineur   |
| F60    | Fischer RCS CARBOLITE Skating | Ski de fond patineur   |
| F61    | Fischer RCS CARBOLITE Skating | Ski de fond patineur   |
| F62    | Fischer RCS CARBOLITE Skating | Ski de fond patineur   |
| F63    | Fischer RCS CARBOLITE Skating | Ski de fond patineur   |
| F64    | Fischer RCS CARBOLITE Skating | Ski de fond patineur   |
| A01    | Salomon 24X+Z12               | Ski alpin              |
| A02    | Salomon 24X+Z12               | Ski alpin              |
| A03    | Salomon 24X+Z12               | Ski alpin              |
| A04    | Salomon 24X+Z12               | Ski alpin              |
| A05    | Salomon 24X+Z12               | Ski alpin              |
| A10    | Salomon Pro Link Equipe 4S    | Ski alpin              |
| A11    | Salomon Pro Link Equipe 4S    | Ski alpin              |
| A21    | Salomon 3V RACE JR+L10        | Ski alpin              |

### 4️⃣ Calcul du montant de chaque fiche soldée et du montant total des fiches.

```sql
SELECT
    f.noFic AS numeroFiche,
    SUM(DATEDIFF(l.retour, l.depart) * t.prixJour) AS montantFiche
FROM
    fiches f
JOIN
    lignesFic l ON f.noFic = l.noFic
JOIN
    articles a ON l.refart = a.refart
JOIN
    grilleTarifs g ON a.codeGam = g.codeGam AND a.codeCate = g.codeCate
JOIN
    tarifs t ON g.codeTarif = t.codeTarif
WHERE
    f.etat = 'SO' -- Seules les fiches soldées
GROUP BY
    f.noFic;

-- Calcul du montant total
SELECT
    SUM(montantFiche) AS montantTotal
FROM
    (SELECT
        f.noFic AS numeroFiche,
        SUM(DATEDIFF(l.retour, l.depart) * t.prixJour) AS montantFiche
     FROM
        fiches f
     JOIN
        lignesFic l ON f.noFic = l.noFic
     JOIN
        articles a ON l.refart = a.refart
     JOIN
        grilleTarifs g ON a.codeGam = g.codeGam AND a.codeCate = g.codeCate
     JOIN
        tarifs t ON g.codeTarif = t.codeTarif
     WHERE
        f.etat = 'SO'
     GROUP BY
        f.noFic) AS ficheMontants;
```

| Numéro de Fiche | Montant de la Fiche |
| --------------- | ------------------- |
| 1001            | 50.00               |
| 1003            | 80.00               |
| 9909            | 20.00               |

| Montant Total |
| ------------- |
| 150.00        |

### 5️⃣ Calcul du nombre d’articles actuellement en cours de location.

```sql
SELECT COUNT(*) AS nb_articles_loues
FROM
	articles a
JOIN
	lignesFic lf ON a.refart = lf.refart
WHERE
	lf.depart IS NOT NULL AND lf.retour IS NULL;
```

| Nb d'articles loués |
| ------------------- |
| 7                   |

### 6️⃣ Calcul du nombre d’articles loués, par client.

```sql
SELECT
    c.nom AS nom,
    COUNT(a.refart) AS nb_articles_loués
FROM
    clients c
JOIN
    fiches f ON c.noCli = f.noCli
JOIN
    lignesFic lf ON f.noFic = lf.noFic
JOIN
    articles a ON lf.refart = a.refart
;GROUP BY
    c.nom
```

| Nom       | Nb d'articles loués |
| --------- | ------------------- |
| Albert    | 6                   |
| Bernard   | 1                   |
| Boon      | 5                   |
| Boutaud   | 3                   |
| Desmoulin | 3                   |
| Dubosc    | 2                   |
| Dupond    | 5                   |
| Ferdinand | 1                   |

### 7️⃣ Liste des clients qui ont effectué (ou sont en train d’effectuer) plus de 200€ de location.

```sql
SELECT
    c.prenom,
    c.nom,
    SUM(DATEDIFF(IFNULL(lf.retour, CURDATE()), lf.depart) * t.prixJour) AS montantFiche
FROM
    clients c
JOIN
    fiches f ON c.noCli = f.noCli
JOIN
    lignesFic lf ON f.noFic = lf.noFic
JOIN
    articles a ON lf.refart = a.refart
JOIN
    grilleTarifs gt ON a.codeGam = gt.codeGam AND a.codeCate = gt.codeCate
JOIN
    tarifs t ON gt.codeTarif = t.codeTarif
WHERE
    f.etat IN ('EC', 'RE')
GROUP BY
    c.prenom,
    c.nom
HAVING
    SUM(DATEDIFF(IFNULL(lf.retour, CURDATE()), lf.depart) * t.prixJour) > 200;
```

| Prénom | Nom  | Montant Fiche |
| ------ | ---- | ------------- |
| Dany   | Boon | 650.00        |

### 8️⃣ Liste de tous les articles (loués au moins une fois) et le nombre de fois où ils ont été loués, triés du plus loué au moins loué.

```sql
SELECT
    a.designation,
    COUNT(lf.noLig) AS nbLocation
FROM
    articles a
JOIN
    lignesFic lf ON a.refart = lf.refart
GROUP BY
    a.refart
HAVING
    nbLocation > 0
ORDER BY
    nbLocation DESC;
```

| Désignation                   | Nb Location |
| ----------------------------- | ----------- |
| Décathlon Apparition          | 4           |
| Fischer Cruiser               | 4           |
| Fischer SOSSkating VASA       | 3           |
| Décathlon Apparition          | 2           |
| Fischer RCS CARBOLITE Skating | 2           |
| Décathlon Apparition          | 2           |
| Décathlon Allegre junior 150  | 2           |
| Fischer Sporty Crown          | 1           |
| Fischer Cruiser               | 1           |
| Salomon 24X+Z12               | 1           |
| Salomon 24X+Z12               | 1           |
| Fischer RCS Classic GOLD      | 1           |
| Salomon Pro Link Equipe 4S    | 1           |
| Salomon 24X+Z12               | 1           |

### 9️⃣ Liste des fiches (n°, nom, prénom) de moins de 150€.

```sql
SELECT
    f.noFic,
    c.nom,
    c.prenom,
    SUM(DATEDIFF(IFNULL(lf.retour, CURDATE()), lf.depart) * t.prixJour) AS montantFiche
FROM
    fiches f
JOIN
    clients c ON f.noCli = c.noCli
JOIN
    lignesFic lf ON f.noFic = lf.noFic
JOIN
    articles a ON lf.refart = a.refart
JOIN
    grilleTarifs gt ON a.codeGam = gt.codeGam AND a.codeCate = gt.codeCate
JOIN
    tarifs t ON gt.codeTarif = t.codeTarif
WHERE
    f.etat IN ('EC', 'RE')
GROUP BY
    f.noFic, c.nom, c.prenom
HAVING
    SUM(DATEDIFF(IFNULL(lf.retour, CURDATE()), lf.depart) * t.prixJour) < 150;
```

| noFic | Nom       | Prénom   | Montant Fiche |
| ----- | --------- | -------- | ------------- |
| 1004  | Ferdinand | François | 60.00         |
| 1005  | Dupond    | Camille  | 100.00        |
| 1006  | Dupond    | Jean     | 30.00         |
| 1008  | Bernard   | Barnabé  | 0.00          |

### 1️⃣0️⃣ Calcul de la moyenne des recettes de location de surf (combien peut-on espérer gagner pour une location d'un surf ?)

```sql
SELECT
    AVG(DATEDIFF(IFNULL(lf.retour, CURDATE()), lf.depart) * t.prixJour) AS moyenneRecette
FROM
    lignesFic lf
JOIN
    articles a ON lf.refart = a.refart
JOIN
    grilleTarifs gt ON a.codeGam = gt.codeGam AND a.codeCate = gt.codeCate
JOIN
    tarifs t ON gt.codeTarif = t.codeTarif
WHERE
    a.codeCate = 'SURF'
    AND lf.retour IS NOT NULL;
```

| Moyenne Recette |
| --------------- |
| 16.00           |

### 1️⃣1️⃣ Calcul de la durée moyenne d'une location d'une paire de skis (en journées entières).

```sql
SELECT
   AVG(DATEDIFF(IFNULL(lf.retour, CURDATE()), lf.depart)) AS dureeMoyenne
FROM
   lignesFic lf
JOIN
   articles a ON lf.refart = a.refart
WHERE
   a.codeCate = 'FOA' OR 'FOP' OR 'SA'
   AND lf.retour IS NOT NULL;
```

| Durée Moyenne (en jours) |
| ------------------------ |
| 3.7143                   |
