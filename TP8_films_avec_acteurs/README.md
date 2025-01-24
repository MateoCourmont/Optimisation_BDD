# TP8 - Films avec acteurs

### Description

Ce TP consiste uniquement à effectuer des requêtes sur la base de données afin d'en extraire des informations

### Création de la BDD et des tables et insertion des données

```sql
DROP DATABASE IF EXISTS prime_vdo;
CREATE DATABASE prime_vdo CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE prime_vdo;

CREATE TABLE film (
  id INT  NOT NULL AUTO_INCREMENT,
  nom VARCHAR(100) NOT NULL,
  CONSTRAINT pk_film PRIMARY KEY(id)
)ENGINE=INNODB;

CREATE TABLE acteur (
  id INT NOT NULL AUTO_INCREMENT,
  prenom VARCHAR(100) NOT NULL,
  nom VARCHAR(100) NOT NULL,
   CONSTRAINT pk_acteur PRIMARY KEY(id)
)ENGINE=INNODB;

CREATE TABLE film_has_acteur (
  film_id INT NOT NULL,
  acteur_id INT NOT NULL,
  CONSTRAINT pk_film_has_acteur PRIMARY KEY (film_id, acteur_id)
)ENGINE=INNODB;

ALTER TABLE film_has_acteur ADD CONSTRAINT fk_acteur FOREIGN KEY (acteur_id) REFERENCES acteur (id);
ALTER TABLE film_has_acteur ADD CONSTRAINT fk_film FOREIGN KEY (film_id) REFERENCES film (id);

##############
## Les données
##############

INSERT INTO acteur (id, prenom, nom) VALUES
(1, 'Brad', 'PITT'),
(2, 'Léonardo', 'Dicaprio');

INSERT INTO film (id, nom) VALUES
(1, 'Fight Club'),
(2, 'Once Upon a time in Hollywood');

INSERT INTO film_has_acteur
(film_id, acteur_id)
VALUES
('1', '1'),
('2', '1'),
('2', '2');
```

### 1️⃣ Afficher tous les films de Brad PITT

```sql
SELECT acteur.prenom, acteur.nom, film.nom
FROM acteur
INNER JOIN film_has_acteur ON film_has_acteur.acteur_id = acteur.id
INNER JOIN film ON film.id = film_has_acteur.film_id
WHERE acteur.nom = 'PITT';
```

### 2️⃣ Afficher le nombre de films par acteur

```sql
SELECT acteur.prenom, acteur.nom, COUNT(film_has_acteur.film_id) AS nb_film
FROM acteur
INNER JOIN film_has_acteur ON film_has_acteur.acteur_id = acteur.id
INNER JOIN film ON film.id = film_has_acteur.film_id
GROUP BY acteur.prenom, acteur.nom;
```

### 3️⃣ Ajouter un film : TITANIC

```sql
INSERT INTO film (id, nom) VALUES
(3, 'Titanic');
```

### 4️⃣ Trouver le film qui n'a pas d'acteur

```sql
SELECT film.nom
FROM film
LEFT JOIN film_has_acteur ON film_has_acteur.film_id = film.id
WHERE film_has_acteur.film_id IS NULL;
```

### 5️⃣ Associer Leonardo DICAPRIO dans le film TITANIC

```sql
INSERT INTO film_has_acteur (film_id, acteur_id)
VALUES
(3, 2);
```

### 6️⃣ Afficher tous les film avec acteurs avec COUNT () et ORDER BY

```sql
SELECT film.nom AS film, acteur.prenom AS acteur_prenom, acteur.nom AS acteur_nom
FROM film
INNER JOIN film_has_acteur ON film.id = film_has_acteur.film_id
INNER JOIN acteur ON acteur.id = film_has_acteur.acteur_id
ORDER BY film.nom;
```

### 7️⃣ Ajouter un acteur TOM CRUISE

```sql
INSERT INTO acteur (prenom, nom) VALUES
('Tom', 'CRUISE');
```

### 8️⃣ Afficher le nombre de films par acteur en incluant TOM CRUISE

```sql
SELECT acteur.prenom, acteur.nom, COUNT(film_has_acteur.film_id) AS nb_film
FROM acteur
LEFT JOIN film_has_acteur ON film_has_acteur.acteur_id = acteur.id
LEFT JOIN film ON film.id = film_has_acteur.film_id
GROUP BY acteur.prenom, acteur.nom
ORDER BY nb_film DESC;
```

### 9️⃣ Afficher les acteurs ayant jouer dans 2 films avec HAVING

```sql
SELECT acteur.prenom, acteur.nom, COUNT(film_has_acteur.film_id) AS nb_film
FROM acteur
LEFT JOIN film_has_acteur ON film_has_acteur.acteur_id = acteur.id
LEFT JOIN film ON film.id = film_has_acteur.film_id
GROUP BY acteur.prenom, acteur.nom
HAVING COUNT(film_has_acteur.film_id) = 2
```

### 1️⃣0️⃣ En moyenne Combien d'acteurs jouent dans 1 film ?

```sql
SELECT AVG(nb_film) AS acteur_par_film
FROM (
    SELECT acteur.prenom, acteur.nom, COUNT(film_has_acteur.film_id) AS nb_film
    FROM acteur
    LEFT JOIN film_has_acteur ON film_has_acteur.acteur_id = acteur.id
    LEFT JOIN film ON film.id = film_has_acteur.film_id
    GROUP BY acteur.prenom, acteur.nom
    ) AS subquery;
```

### 1️⃣1️⃣ Effacer les 3 tables avec DROP TABLE

```sql
DROP TABLE film_has_acteur;
DROP TABLE film;
DROP TABLE acteur;
```
