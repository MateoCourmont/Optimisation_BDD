# TP9 - Site e-ecommerce

### Description

Ce projet définit une base de données pour un système e-commerce. Elle inclut la gestion des articles, des commandes, des clients, et des lignes d'achat. Le modèle relationnel est conçu pour représenter les interactions d'achat.

### 1️⃣ + 2️⃣ Création de la BDD et des tables

```sql
CREATE DATABASE ecom;
USE ecom;

CREATE TABLE `article` (
    `article_id` int  NOT NULL ,
    `nom` varchar(100)  NOT NULL ,
    `prix` float  NOT NULL ,
    PRIMARY KEY (
        `article_id`
    )
);

CREATE TABLE `ligne` (
    `article_id` int  NOT NULL ,
    `commande_id` int  NOT NULL ,
    `nombre` int  NOT NULL ,
    `prix` float  NOT NULL
);

CREATE TABLE `commande` (
    `commande_id` int  NOT NULL ,
    `date_achat` datetime  NOT NULL ,
    `client_id` int  NOT NULL ,
    PRIMARY KEY (
        `commande_id`
    )
);

CREATE TABLE `client` (
    `client_id` int  NOT NULL ,
    `nom` varchar(100)  NOT NULL ,
    `prenom` varchar(100)  NOT NULL ,
    PRIMARY KEY (
        `client_id`
    )
);

ALTER TABLE `ligne` ADD CONSTRAINT `fk_ligne_article_id` FOREIGN KEY(`article_id`)
REFERENCES `article` (`article_id`);

ALTER TABLE `ligne` ADD CONSTRAINT `fk_ligne_commande_id` FOREIGN KEY(`commande_id`)
REFERENCES `commande` (`commande_id`);

ALTER TABLE `commande` ADD CONSTRAINT `fk_commande_client_id` FOREIGN KEY(`client_id`)
REFERENCES `client` (`client_id`);
```

### 3️⃣ Ajout des données

```sql
INSERT INTO `article` (`article_id`, `nom`, `prix`) VALUES
(1, 'PlayStation 5', 400.0),
(2, 'Xbox', 350.0),
(3, 'Machine à café', 300.0),
(4, 'PlayStation 3', 100.0);

INSERT INTO `client` (`client_id`, `prenom`, `nom`) VALUES
(1, 'Brad', 'PITT'),
(2, 'George', 'CLOONEY'),
(3, 'Jean', 'DUJARDIN'),

INSERT INTO `commande` (`date_achat`, `commande_id`, `client_id`) VALUES
('2024-09-08 10:15:00', 1, 1);

INSERT INTO `ligne` (`article_id`, `commande_id`, `nombre`, `prix`) VALUES
(4, 1, 2, 200.0),
(3, 1, 1, 300.0),
(2, 1, 1, 350.0);
```

### 4️⃣ Afficher la commande de Brad PITT

```sql
SELECT client.prenom, client.nom, date_achat, article.nom, article.prix, ligne.nombre, ligne.prix AS total
FROM commande
JOIN client ON commande.client_id = client.client_id
JOIN ligne ON commande.commande_id = ligne.commande_id
JOIN article ON ligne.article_id = article.article_id
WHERE client.nom = 'PITT'
ORDER BY commande.commande_id DESC;
```

#### Affichage du prix total HT et TTC + TVA

```sql
SELECT SUM(ligne.prix) AS total_HT, SUM(ligne.prix)*0.2 AS total_TVA, SUM(ligne.prix + ligne.prix*0.2) AS total_TTC
FROM commande
JOIN client ON commande.client_id = client.client_id
JOIN ligne ON commande.commande_id = ligne.commande_id
JOIN article ON ligne.article_id = article.article_id
WHERE client.nom = 'PITT'
ORDER BY commande.commande_id DESC;
```

### Bonus : Créer la base de données sur db diagram

![BDD_model](/TP9_Site_ecommmerce/Schema_BDD.png)
