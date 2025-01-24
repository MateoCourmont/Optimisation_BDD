/* CREATION DE LA BASE DE DONNEES 
ET DES TABLES ASSOCIEES */

CREATE DATABASE `gestion_clients`;

USE `gestion_clients`;

CREATE TABLE `client` (
    `client_id` int  NOT NULL ,
    `nom` varchar(255)  NOT NULL ,
    PRIMARY KEY (
        `client_id`
    )
);

CREATE TABLE `projet` (
    `projet_id` int  NOT NULL ,
    `nom` varchar(255)  NOT NULL ,
    `client_id` int  NOT NULL ,
    PRIMARY KEY (
        `projet_id`
    )
);

CREATE TABLE `devis` (
    `devis_id` int  NOT NULL ,
    `version` int  NOT NULL ,
    `reference` varchar(10)  NOT NULL ,
    `prix` float  NOT NULL ,
    `projet_id` int  NOT NULL ,
    PRIMARY KEY (
        `devis_id`
    )
);

CREATE TABLE `facture` (
    `facture_id` int  NOT NULL ,
    `reference` varchar(10)  NOT NULL ,
    `info` varchar(255)  NOT NULL ,
    `total` float  NOT NULL ,
    `date_crea` date  NOT NULL ,
    `date_paiement` date  NOT NULL ,
    `devis_id` int  NOT NULL ,
    PRIMARY KEY (
        `facture_id`
    )
);

ALTER TABLE `projet` ADD CONSTRAINT `fk_projet_client_id` FOREIGN KEY(`client_id`)
REFERENCES `client` (`client_id`);

ALTER TABLE `devis` ADD CONSTRAINT `fk_devis_projet_id` FOREIGN KEY(`projet_id`)
REFERENCES `projet` (`projet_id`);

ALTER TABLE `facture` ADD CONSTRAINT `fk_facture_devis_id` FOREIGN KEY(`devis_id`)
REFERENCES `devis` (`devis_id`);

ALTER TABLE `facture` MODIFY `date_paiement` DATE NULL;

-- AJOUT DES DONNEES

INSERT INTO `client` (`client_id`, `nom`) VALUES
(1, 'Mairie de Rennes'),
(2, 'Neo Soft'),
(3, 'Sopra'),
(4, 'Accenture'),
(5, 'Amazon');

INSERT INTO `projet` (`projet_id`, `nom`, `client_id`) VALUES
(1, 'Creation de site internet', 1),
(2, 'Creation de site internet', 1),
(3, 'Logiciel CRM', 2),
(4, 'Logiciel de devis', 3),
(5, 'Site internet ecommerce', 4),
(6, 'Logiciel ERP', 2),
(7, 'Logiciel gestion de stock', 5);

INSERT INTO `devis` (`devis_id`, `version`, `reference`, `prix`, `projet_id`) VALUES
(1, 1, 'DEV2100A', 3000, 1),
(2, 2, 'DEV2100B', 5000, 2),
(3, 1, 'DEV2100C', 5000, 3),
(4, 1, 'DEV2100D', 3000, 4),
(5, 1, 'DEV2100E', 5000, 5),
(6, 1, 'DEV2100F', 2000, 6),
(7, 1, 'DEV2100G', 1000, 7);

INSERT INTO `facture` (`facture_id`, `reference`, `info`, `total`, `date_crea`, `date_paiement`, `devis_id`) VALUES
(1, 'FA001', '	Site internet partie 1', 1500, '2023-09-01', '2023-10-01', 1),
(2, 'FA002', '	Site internet partie 2', 1500, '2023-09-20', NULL, 2),
(3, 'FA003', '	Logiciel de CRM', 5000, '2024-02-01', NULL, 3),
(4, 'FA004', '	Logiciel de devis', 3000, '2024-03-03', '2024-04-03', 4),
(5, 'FA005', '	Site internet ecommerce', 5000, '2023-03-01', NULL, 5),
(6, 'FA006', 'Logiciel ERP', 2000, '2023-03-01', NULL, 6);

-- Afficher toutes les factures avec le nom des clients

SELECT facture.reference, client.nom, facture.info, facture.total, facture.date_crea, facture.date_paiement
FROM `facture` 
INNER JOIN `devis` ON facture.devis_id = devis.devis_id
INNER JOIN `projet` ON devis.projet_id = projet.projet_id
INNER JOIN `client` ON projet.client_id = client.client_id

/* Afficher le nombre de factures par client
Afficher 0 factures si il n'y a pas de factures */

SELECT client.nom AS nom_client, COUNT(facture.facture_id) AS nombre_factures
FROM `client`
LEFT JOIN `projet` ON client.client_id = projet.client_id
LEFT JOIN `devis` ON projet.projet_id = devis.projet_id
LEFT JOIN `facture` ON devis.devis_id = facture.devis_id
GROUP BY client.nom;

-- Afficher le chiffre d'affaire par client

SELECT client.nom AS nom_client, COALESCE(SUM(facture.total), 0) AS chiffre_affaire
FROM `client`
LEFT JOIN `projet` ON client.client_id = projet.client_id
LEFT JOIN `devis` ON projet.projet_id = devis.projet_id
LEFT JOIN `facture` ON devis.devis_id = facture.devis_id
GROUP BY client.nom;

-- Afficher le CA total avec SUM() pour additioner les champs

SELECT COALESCE(SUM(facture.total), 0) AS chiffre_affaire_total
FROM `facture`;

-- Afficher la somme des factures en attente de paiement

SELECT COALESCE(SUM(facture.total), 0) AS somme_factures_en_attente
FROM `facture`
WHERE facture.date_paiement IS NULL;

/* Afficher les factures en retard de paiment 
30 jours max */

SELECT facture.reference AS facture_reference, DATEDIFF(CURDATE(), facture.date_crea) AS jours_en_retard
FROM `facture`
WHERE facture.date_paiement IS NULL AND DATEDIFF(CURDATE(), facture.date_crea) > 30;

/* Afficher les factures en retard de paiment avec le nom du client
30 jours max
Avec le nombre de jours de retard */

SELECT client.nom AS nom_client, facture.reference AS facture_reference, DATEDIFF(CURDATE(), facture.date_crea) AS jours_en_retard
FROM `client`
INNER JOIN `projet` ON client.client_id = projet.client_id
INNER JOIN `devis` ON projet.projet_id = devis.projet_id
INNER JOIN `facture` ON devis.devis_id = facture.devis_id
WHERE facture.date_paiement IS NULL AND DATEDIFF(CURDATE(), facture.date_crea) > 30;

-- Ajouter une pénalité de 2 euros par jours de retard

SELECT client.nom AS nom_client, facture.reference AS facture_reference, DATEDIFF(CURDATE(), facture.date_crea) AS jours_en_retard, (DATEDIFF(CURDATE(), facture.date_crea) * 2) AS penalite
FROM `client`
INNER JOIN `projet` ON client.client_id = projet.client_id
INNER JOIN `devis` ON projet.projet_id = devis.projet_id
INNER JOIN `facture` ON devis.devis_id = facture.devis_id
WHERE facture.date_paiement IS NULL AND DATEDIFF(CURDATE(), facture.date_crea) > 30;

-- A partir de la Question 3️⃣ Afficher la moyenne de de CA par client

SELECT client.nom AS nom_client, COALESCE(AVG(facture.total), 0) AS chiffre_affaire_moyen
FROM `client`
LEFT JOIN `projet` ON client.client_id = projet.client_id
LEFT JOIN `devis` ON projet.projet_id = devis.projet_id
LEFT JOIN `facture` ON devis.devis_id = facture.devis_id
GROUP BY client.nom;







