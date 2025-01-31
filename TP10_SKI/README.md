### Description

Ce TP consiste à gérer la base de données des clients d'une station de ski, et effectuer des requêtes pour ene extraire des informations

## PARTIE 1 : Création de la base de données et insertion des données

### Création de la BDD

```sql
CREATE DATABASE ski;
USE ski;

CREATE TABLE `clients` (
    `noCli` int NOT NULL,
    `nom` varchar(30) NOT NULL,
    `prenom` varchar(30) NOT NULL,
    `adresse` varchar(120) NOT NULL,
    `cpo` varchar(5) NOT NULL,
    `ville` varchar(80) NOT NULL,
    PRIMARY KEY (`noCli`)
);

CREATE TABLE `fiches` (
    `noFic` int NOT NULL,
    `noCli` int NOT NULL,
    `dateCrea` date NOT NULL,
    `datePaiement` date NOT NULL,
    `etat` ENUM('EC', 'RE', 'SO') NOT NULL,
    PRIMARY KEY (`noFic`)
);

CREATE TABLE `lignesFic` (
    `noLig` int NOT NULL,
    `noFic` int NOT NULL,
    `refart` char(8) NOT NULL,
    `depart` date NOT NULL,
    `retour` date,
    PRIMARY KEY (`noLig`, `noFic`)
);

CREATE TABLE `articles` (
    `refart` char(8) NOT NULL,
    `designation` varchar(80) NOT NULL,
    `codeGam` char(5) NOT NULL,
    `codeCate` char(5) NOT NULL,
    PRIMARY KEY (`refart`)
);

CREATE TABLE `categories` (
    `codeCate` char(5) NOT NULL,
    `libelle` varchar(30) NOT NULL,
    PRIMARY KEY (`codeCate`)
);

CREATE TABLE `gammes` (
    `codeGam` char(5) NOT NULL,
    `libelle` varchar(30) NOT NULL,
    PRIMARY KEY (`codeGam`)
);

CREATE TABLE `grilleTarifs` (
    `codeGam` char(5) NOT NULL,
    `codeCate` char(5) NOT NULL,
    `codeTarif` char(5) NOT NULL
);

CREATE TABLE `tarifs` (
    `codeTarif` char(5) NOT NULL,
    `libelle` varchar(30) NOT NULL,
    `prixJour` decimal(5,2) NOT NULL,
    PRIMARY KEY (`codeTarif`)
);

-- Ajout des contraintes FOREIGN KEY
ALTER TABLE `fiches` ADD CONSTRAINT `fk_fiches_noCli` FOREIGN KEY (`noCli`)
REFERENCES `clients` (`noCli`);

ALTER TABLE `lignesFic` ADD CONSTRAINT `fk_lignesFic_noFic` FOREIGN KEY (`noFic`)
REFERENCES `fiches` (`noFic`);

ALTER TABLE `lignesFic` ADD CONSTRAINT `fk_lignesFic_refart` FOREIGN KEY (`refart`)
REFERENCES `articles` (`refart`);

ALTER TABLE `articles` ADD CONSTRAINT `fk_articles_codeGam` FOREIGN KEY (`codeGam`)
REFERENCES `gammes` (`codeGam`);

ALTER TABLE `articles` ADD CONSTRAINT `fk_articles_codeCate` FOREIGN KEY (`codeCate`)
REFERENCES `categories` (`codeCate`);

ALTER TABLE `grilleTarifs` ADD CONSTRAINT `fk_grilleTarifs_codeGam` FOREIGN KEY (`codeGam`)
REFERENCES `gammes` (`codeGam`);

ALTER TABLE `grilleTarifs` ADD CONSTRAINT `fk_grilleTarifs_codeCate` FOREIGN KEY (`codeCate`)
REFERENCES `categories` (`codeCate`);

ALTER TABLE `grilleTarifs` ADD CONSTRAINT `fk_grilleTarifs_codeTarif` FOREIGN KEY (`codeTarif`)
REFERENCES `tarifs` (`codeTarif`);
```

### Insertion des données

```sql
USE ski;
INSERT INTO clients (noCli, nom, prenom, adresse, cpo, ville) VALUES
    (1, 'Albert', 'Anatole', 'Rue des accacias', '61000', 'Amiens'),
    (2, 'Bernard', 'Barnabé', 'Rue du bar', '1000', 'Bourg en Bresse'),
    (3, 'Dupond', 'Camille', 'Rue Crébillon', '44000', 'Nantes'),
    (4, 'Desmoulin', 'Daniel', 'Rue descendante', '21000', 'Dijon'),
     (5, 'Ernest', 'Etienne', 'Rue de l’échaffaud', '42000', 'Saint Étienne'),
    (6, 'Ferdinand', 'François', 'Rue de la convention', '44100', 'Nantes'),
    (9, 'Dupond', 'Jean', 'Rue des mimosas', '75018', 'Paris'),
    (14, 'Boutaud', 'Sabine', 'Rue des platanes', '75002', 'Paris');

INSERT INTO fiches (noFic, noCli, dateCrea, datePaiement, etat) VALUES
    (1001, 14,  DATE_SUB(NOW(),INTERVAL  15 DAY), DATE_SUB(NOW(),INTERVAL  13 DAY),'SO' ),
    (1002, 4,  DATE_SUB(NOW(),INTERVAL  13 DAY), NULL, 'EC'),
    (1003, 1,  DATE_SUB(NOW(),INTERVAL  12 DAY), DATE_SUB(NOW(),INTERVAL  10 DAY),'SO'),
    (1004, 6,  DATE_SUB(NOW(),INTERVAL  11 DAY), NULL, 'EC'),
    (1005, 3,  DATE_SUB(NOW(),INTERVAL  10 DAY), NULL, 'EC'),
    (1006, 9,  DATE_SUB(NOW(),INTERVAL  10 DAY),NULL ,'RE'),
    (1007, 1,  DATE_SUB(NOW(),INTERVAL  3 DAY), NULL, 'EC'),
    (1008, 2,  DATE_SUB(NOW(),INTERVAL  0 DAY), NULL, 'EC');

INSERT INTO tarifs (codeTarif, libelle, prixJour) VALUES
    ('T1', 'Base', 10),
    ('T2', 'Chocolat', 15),
    ('T3', 'Bronze', 20),
    ('T4', 'Argent', 30),
    ('T5', 'Or', 50),
    ('T6', 'Platine', 90);

INSERT INTO gammes (codeGam, libelle) VALUES
    ('PR', 'Matériel Professionnel'),
    ('HG', 'Haut de gamme'),
    ('MG', 'Moyenne gamme'),
    ('EG', 'Entrée de gamme');

INSERT INTO categories (codeCate, libelle) VALUES
    ('MONO', 'Monoski'),
    ('SURF', 'Surf'),
    ('PA', 'Patinette'),
    ('FOA', 'Ski de fond alternatif'),
    ('FOP', 'Ski de fond patineur'),
    ('SA', 'Ski alpin');

INSERT INTO grilleTarifs (codeGam, codeCate, codeTarif) VALUES
    ('EG', 'MONO', 'T1'),
    ('MG', 'MONO', 'T2'),
    ('EG', 'SURF', 'T1'),
    ('MG', 'SURF', 'T2'),
    ('HG', 'SURF', 'T3'),
    ('PR', 'SURF', 'T5'),
    ('EG', 'PA', 'T1'),
    ('MG', 'PA', 'T2'),
    ('EG', 'FOA', 'T1'),
    ('MG', 'FOA', 'T2'),
    ('HG', 'FOA', 'T4'),
    ('PR', 'FOA', 'T6'),
    ('EG', 'FOP', 'T2'),
    ('MG', 'FOP', 'T3'),
    ('HG', 'FOP', 'T4'),
    ('PR', 'FOP', 'T6'),
    ('EG', 'SA', 'T1'),
    ('MG', 'SA', 'T2'),
    ('HG', 'SA', 'T4'),
    ('PR', 'SA', 'T6');

INSERT INTO articles (refart, designation, codeGam, codeCate) VALUES
    ('F01', 'Fischer Cruiser', 'EG', 'FOA'),
    ('F02', 'Fischer Cruiser', 'EG', 'FOA'),
    ('F03', 'Fischer Cruiser', 'EG', 'FOA'),
    ('F04', 'Fischer Cruiser', 'EG', 'FOA'),
    ('F05', 'Fischer Cruiser', 'EG', 'FOA'),
    ('F10', 'Fischer Sporty Crown', 'MG', 'FOA'),
    ('F20', 'Fischer RCS Classic GOLD', 'PR', 'FOA'),
    ('F21', 'Fischer RCS Classic GOLD', 'PR', 'FOA'),
    ('F22', 'Fischer RCS Classic GOLD', 'PR', 'FOA'),
    ('F23', 'Fischer RCS Classic GOLD', 'PR', 'FOA'),
    ('F50', 'Fischer SOSSkating VASA', 'HG', 'FOP'),
    ('F60', 'Fischer RCS CARBOLITE Skating', 'PR', 'FOP'),
    ('F61', 'Fischer RCS CARBOLITE Skating', 'PR', 'FOP'),
    ('F62', 'Fischer RCS CARBOLITE Skating', 'PR', 'FOP'),
    ('F63', 'Fischer RCS CARBOLITE Skating', 'PR', 'FOP'),
    ('F64', 'Fischer RCS CARBOLITE Skating', 'PR', 'FOP'),
    ('P01', 'Décathlon Allegre junior 150', 'EG', 'PA'),
    ('P10', 'Fischer mini ski patinette', 'MG', 'PA'),
    ('P11', 'Fischer mini ski patinette', 'MG', 'PA'),
    ('S01', 'Décathlon Apparition', 'EG', 'SURF'),
    ('S02', 'Décathlon Apparition', 'EG', 'SURF'),
    ('S03', 'Décathlon Apparition', 'EG', 'SURF'),
    ('A01', 'Salomon 24X+Z12', 'EG', 'SA'),
    ('A02', 'Salomon 24X+Z12', 'EG', 'SA'),
    ('A03', 'Salomon 24X+Z12', 'EG', 'SA'),
    ('A04', 'Salomon 24X+Z12', 'EG', 'SA'),
    ('A05', 'Salomon 24X+Z12', 'EG', 'SA'),
    ('A10', 'Salomon Pro Link Equipe 4S', 'PR', 'SA'),
    ('A11', 'Salomon Pro Link Equipe 4S', 'PR', 'SA'),
    ('A21', 'Salomon 3V RACE JR+L10', 'PR', 'SA');

INSERT INTO lignesFic (noFic, noLig,  refart, depart, retour) VALUES
    (1001, 1, 'F05', DATE_SUB(NOW(),INTERVAL  15 DAY), DATE_SUB(NOW(),INTERVAL  13 DAY)),
    (1001, 2, 'F50', DATE_SUB(NOW(),INTERVAL  15 DAY), DATE_SUB(NOW(),INTERVAL  14 DAY)),
    (1001, 3, 'F60', DATE_SUB(NOW(),INTERVAL  13 DAY), DATE_SUB(NOW(),INTERVAL  13 DAY)),
    (1002, 1, 'A03', DATE_SUB(NOW(),INTERVAL  13 DAY), DATE_SUB(NOW(),INTERVAL  9 DAY)),
    (1002, 2, 'A04', DATE_SUB(NOW(),INTERVAL  12 DAY), DATE_SUB(NOW(),INTERVAL  7 DAY)),
    (1002, 3, 'S03', DATE_SUB(NOW(),INTERVAL  8 DAY), NULL),
    (1003, 1, 'F50', DATE_SUB(NOW(),INTERVAL  12 DAY), DATE_SUB(NOW(),INTERVAL  10 DAY)),
    (1003, 2, 'F05', DATE_SUB(NOW(),INTERVAL  12 DAY), DATE_SUB(NOW(),INTERVAL  10 DAY)),
    (1004, 1, 'P01', DATE_SUB(NOW(),INTERVAL  6 DAY), NULL),
    (1005, 1, 'F05', DATE_SUB(NOW(),INTERVAL  9 DAY), DATE_SUB(NOW(),INTERVAL  5 DAY)),
    (1005, 2, 'F10', DATE_SUB(NOW(),INTERVAL  4 DAY), NULL),
    (1006, 1, 'S01', DATE_SUB(NOW(),INTERVAL  10 DAY), DATE_SUB(NOW(),INTERVAL  9 DAY)),
    (1006, 2, 'S02', DATE_SUB(NOW(),INTERVAL  10 DAY), DATE_SUB(NOW(),INTERVAL  9 DAY)),
    (1006, 3, 'S03', DATE_SUB(NOW(),INTERVAL  10 DAY), DATE_SUB(NOW(),INTERVAL  9 DAY)),
    (1007, 1, 'F50', DATE_SUB(NOW(),INTERVAL  3 DAY), DATE_SUB(NOW(),INTERVAL  2 DAY)),
    (1007, 3, 'F60', DATE_SUB(NOW(),INTERVAL  1 DAY), NULL),
    (1007, 2, 'F05', DATE_SUB(NOW(),INTERVAL  3 DAY), NULL),
    (1007, 4, 'S02', DATE_SUB(NOW(),INTERVAL  0 DAY), NULL),
    (1008, 1, 'S01', DATE_SUB(NOW(),INTERVAL  0 DAY), NULL);
```

### 1️⃣ Liste des clients (toutes les informations) dont le nom commence par un D

```sql
SELECT * FROM clients WHERE nom LIKE 'D%';
```

### 2️⃣ Nom et prénom de tous les clients

```sql
SELECT nom, prenom FROM clients;
```

### 3️⃣ Liste des fiches (n°, état) pour les clients (nom, prénom) qui habitent en Loire Atlantique (44)

```sql
SELECT c.nom, c.prenom, f.noFic, f.etat
FROM clients c
JOIN fiches f ON c.noCli = f.noCli
JOIN lignesFic l ON f.noFic = l.noFic
WHERE c.cpo LIKE '44%'
GROUP BY c.noCli;
```

### 4️⃣ Détail de la fiche n°1002

```sql
SELECT
    f.noFic,
    c.nom,
    c.prenom,
    l.refart,
    a.designation,
    l.depart,
    l.retour,
    t.prixJour,
    DATEDIFF(IFNULL(l.retour, CURDATE()), l.depart) * t.prixJour AS montant
FROM fiches f
JOIN clients c ON f.noCli = c.noCli
JOIN lignesFic l ON f.noFic = l.noFic
JOIN articles a ON l.refart = a.refart
JOIN grilleTarifs g ON a.codeGam = g.codeGam AND a.codeCate = g.codeCate
JOIN tarifs t ON g.codeTarif = t.codeTarif
WHERE f.noFic = 1002;
```

### 5️⃣ Prix journalier moyen de location par gamme

```sql
SELECT g.libelle, AVG(t.prixJour) AS moyenne_prix
FROM gammes g
INNER JOIN grilletarifs ON g.codeGam = grilletarifs.codeGam
INNER JOIN tarifs t ON grilletarifs.codeTarif = t.codeTarif
GROUP BY g.libelle
ORDER BY moyenne_prix ASC;
```

### 6️⃣ Détail de la fiche n°1002 avec le total

```sql
SELECT
    f.noFic,
    c.nom,
    c.prenom,
    l.refart,
    a.designation,
    l.depart,
    l.retour,
    t.prixJour,
    DATEDIFF(IFNULL(l.retour, CURDATE()), l.depart) * t.prixJour AS montant,
    SUM(DATEDIFF(IFNULL(l.retour, CURDATE()), l.depart) * t.prixJour) OVER () AS total
FROM fiches f
JOIN clients c ON f.noCli = c.noCli
JOIN lignesFic l ON f.noFic = l.noFic
JOIN articles a ON l.refart = a.refart
JOIN grilleTarifs g ON a.codeGam = g.codeGam AND a.codeCate = g.codeCate
JOIN tarifs t ON g.codeTarif = t.codeTarif
WHERE f.noFic = 1002;
```

### 7️⃣ Grille des tarifs

```sql
SELECT c.libelle AS Libelle, g.libelle AS Gamme, t.libelle AS Tarif, t.prixJour
FROM grilletarifs gt
JOIN tarifs t ON gt.codeTarif = t.codeTarif
JOIN gammes g ON gt.codeGam = g.codeGam
JOIN categories c ON gt.codeCate = c.codeCate;
```

### 8️⃣ Liste des locations de la catégorie SURF

```sql
SELECT l.refart, a.designation, COUNT(l.noFic) AS nbLocation
FROM lignesFic l
JOIN articles a ON l.refart = a.refart
WHERE EXISTS (
    SELECT 1
    FROM grilleTarifs g
    JOIN categories c ON g.codeCate = c.codeCate
    WHERE c.libelle = 'SURF' AND a.codeCate = g.codeCate
)
GROUP BY l.refart, a.designation;
```

### 9️⃣ Calcul du nombre moyen d’articles loués par fiche de location

```sql
SELECT AVG(nbArticles) AS moyenne_nb_article_par_fiche
FROM (
    SELECT COUNT(l.noLig) AS nbArticles
    FROM fiches f
    JOIN lignesFic l ON f.noFic = l.noFic
    GROUP BY f.noFic
) AS nbArticlesParFiche;
```

### 1️⃣0️⃣ Calcul du nombre de fiches de location établies pour les catégories de location Ski alpin, Surf et Patinette

```sql
SELECT c.libelle AS categorie, COUNT(f.noFic) AS nbFiches
FROM categories c
JOIN articles a ON c.codeCate = a.codeCate
JOIN lignesFic l ON a.refart = l.refart
JOIN fiches f ON l.noFic = f.noFic
WHERE c.libelle IN ('Ski alpin', 'Surf', 'Patinette')
GROUP BY c.libelle;
```

### 1️⃣1️⃣ Calcul du montant moyen des fiches de location

```sql
--NE FONCTIONNE PAS OU PAS MEME RESULTAT QUE TP
SELECT AVG(montant) AS moyenne_montant_fiche
FROM (
    SELECT DATEDIFF(IFNULL(l.retour, CURDATE()), l.depart) * t.prixJour AS montant,
    FROM fiches f
    JOIN clients c ON f.noCli = c.noCli
    JOIN lignesFic l ON f.noFic = l.noFic
    JOIN articles a ON l.refart = a.refart
    JOIN grilleTarifs g ON a.codeGam = g.codeGam AND a.codeCate = g.codeCate
    JOIN tarifs t ON g.codeTarif = t.codeTarif
) AS montantParFiche;
```
