### Description

Ce TP consiste à la mise en place d'une base de données à partir de zéro. Le pitch :
Un caviste veut créer un site internet pour mettre en vente sur le web ses bouteilles.
Il souhaite un moteur de recherche très pertinent avec des filtres adapatés.
Consevoir la base de données.

### Modèle relationnel de la base

![Modèle relationnel de la base](/TP12_Vin/ModèleBdd.png)

### Création de la base de données

```sql
CREATE DATABASE cave_a_vin;

USE cave_a_vin;

CREATE TABLE `utilisateurs` (
  `idUtilisateur` int PRIMARY KEY NOT NULL,
  `nom` varchar(50) NOT NULL,
  `prenom` varchar(50) NOT NULL,
  `email` varchar(100) UNIQUE NOT NULL,
  `motDePasse` varchar(255) NOT NULL,
  `adresse` varchar(255),
  `codePostal` varchar(5),
  `ville` varchar(50),
  `pays` varchar(50),
  `dateInscription` datetime
);

CREATE TABLE `categories` (
  `idCategorie` int PRIMARY KEY NOT NULL,
  `nomCategorie` varchar(100) NOT NULL
);

CREATE TABLE `bouteilles` (
  `idBouteille` int PRIMARY KEY NOT NULL,
  `nom` varchar(100) NOT NULL,
  `description` text,
  `prix` decimal(10,2) NOT NULL,
  `quantiteEnStock` int DEFAULT 0,
  `annee` int,
  `volume` decimal(5,2),
  `typeVin` enum('rouge', 'blanc', 'rosé', 'champagne', 'autre') NOT NULL,
  `region` varchar(100),
  `appellation` varchar(100),
  `photo` varchar(255)
);

CREATE TABLE `bouteille_categories` (
  `idBouteille` int,
  `idCategorie` int,
  PRIMARY KEY (idBouteille, idCategorie)
);

CREATE TABLE `commandes` (
  `idCommande` int PRIMARY KEY NOT NULL,
  `idUtilisateur` int,
  `dateCommande` datetime,
  `statut` enum('en_attente', 'expédiée', 'livrée'),
  `total` decimal(10,2) NOT NULL,
  `adresseLivraison` varchar(255)
);

CREATE TABLE `lignes_commande` (
  `idLigneCommande` int PRIMARY KEY NOT NULL,
  `idCommande` int,
  `idBouteille` int,
  `quantite` int NOT NULL,
  `prix` decimal(10,2) NOT NULL
);

CREATE TABLE `avis` (
  `idAvis` int PRIMARY KEY NOT NULL,
  `idBouteille` int,
  `idUtilisateur` int,
  `note` int,
  `commentaire` text,
  `dateAvis` datetime
);

-- Ajout des clés étrangères
ALTER TABLE `bouteille_categories` ADD FOREIGN KEY (`idBouteille`) REFERENCES `bouteilles` (`idBouteille`);

ALTER TABLE `bouteille_categories` ADD FOREIGN KEY (`idCategorie`) REFERENCES `categories` (`idCategorie`);

ALTER TABLE `commandes` ADD FOREIGN KEY (`idUtilisateur`) REFERENCES `utilisateurs` (`idUtilisateur`);

ALTER TABLE `lignes_commande` ADD FOREIGN KEY (`idCommande`) REFERENCES `commandes` (`idCommande`);

ALTER TABLE `lignes_commande` ADD FOREIGN KEY (`idBouteille`) REFERENCES `bouteilles` (`idBouteille`);

ALTER TABLE `avis` ADD FOREIGN KEY (`idBouteille`) REFERENCES `bouteilles` (`idBouteille`);

ALTER TABLE `avis` ADD FOREIGN KEY (`idUtilisateur`) REFERENCES `utilisateurs` (`idUtilisateur`);
```
