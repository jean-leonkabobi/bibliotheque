
# Gestion de Bibliothèque - Application Jakarta EE

![Java Version](https://img.shields.io/badge/Java-17-blue.svg)
![Jakarta EE](https://img.shields.io/badge/Jakarta%20EE-10-red.svg)
![Tomcat](https://img.shields.io/badge/Tomcat-10.1-green.svg)
![MySQL](https://img.shields.io/badge/MySQL-8-orange.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

## Description

Application web complète de gestion de bibliothèque développée avec **Jakarta EE 10**. Elle permet à trois profils d'utilisateurs (Administrateur, Bibliothécaire, Membre) de gérer les adhérents, les ouvrages, les emprunts et les pénalités; pour l'administrateur et le bibliothecaire et pour le membre, d'emprunter.

### Fonctionnalités principales

| Module | Description |
|--------|-------------|
| **Authentification** | Connexion sécurisée avec BCrypt, 3 rôles distincts |
| **Tableaux de bord** | Vues personnalisées selon le rôle |
| **Gestion des adhérents** | CRUD complet, validation, suspension |
| **Gestion des ouvrages** | Livres, CDs, DVDs avec héritage JPA |
| **Gestion des emprunts** | Emprunts, retours, prolongations (max 3) |
| **Gestion des pénalités** | Calcul automatique (0,50€/jour de retard) |
| **Catalogue** | Consultation et emprunt direct pour les membres |
| **Responsive** | Interface adaptée à tous les écrans |

## Architecture Technique

### Stack utilisée

| Composant | Technologie | Version |
|-----------|-------------|---------|
| **Langage** | Java | 17 |
| **Framework** | Jakarta EE | 10 |
| **Serveur** | Apache Tomcat | 10.1.x |
| **ORM** | Hibernate (JPA) | 6.2.x |
| **Base de données** | MySQL | 8.x |
| **Front-end** | JSP / JSTL | 3.0 |
| **CSS** | Personnalisé + Font Awesome | 6.4 |
| **Build** | Maven | 3.8+ |

### Architecture en couches

Couche Présentation (JSP / CSS) -> Couche Contrôleur (Servlets / Filters) ->
Couche Service (Business Logic) -> Couche DAO (JPA / Hibernate) ->
Base de données (MySQL 8)          

### Structure du projet

src/main/java/com/kabobi/bibliotheque/
entity/          # Entités JPA (User, Loan, Penalty, Document, Book, CD, DVD)
dao/             # Data Access Objects
service/         # Business logic
servlet/         # Contrôleurs (admin, librarian, member)
filter/          # Filtres d'authentification
util/            # Utilitaires (PasswordUtil)

src/main/webapp/
├── css/             # Styles (dashboard.css, style.css)
├── WEB-INF/views/   # JSP (admin, librarian, member, error)
└── WEB-INF/web.xml  # Configuration

## Rôles et Permissions

| Fonctionnalité | Admin | Bibliothécaire | Membre |
|----------------|:-----:|:--------------:|:------:|
| Dashboard | OK | OK | OK |
| Gestion des adhérents | OK | OK (lecture seule) | KO |
| Gestion des ouvrages | OK | OK | KO |
| Gestion des emprunts | OK | OK | OK |
| Gestion des pénalités | OK | OK | OK |
| Validation des comptes | OK | OK | KO |
| Catalogue | KO | KO | OK |
| Mon profil | KO | KO | OK |

## Installation

### Prérequis

- Java 17 ou supérieur
- Apache Tomcat 10.1.x
- MySQL 8.x
- Maven 3.8+

### Étapes d'installation

#### 1. Cloner le repository
git clone https://github.com/ton-compte/bibliotheque.git
cd bibliotheque

#### 2. Configurer la base de données
CREATE DATABASE bibliotheque CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

#### 3. Configurer la connexion JPA

Modifie `src/main/resources/META-INF/persistence.xml` :
<property name="jakarta.persistence.jdbc.user" value="ton_utilisateur"/>
<property name="jakarta.persistence.jdbc.password" value="ton_mot_de_passe"/>

#### 4. Compiler le projet
mvn clean package

#### 5. Déployer sur Tomcat

# Copier le WAR dans le dossier webapps de Tomcat
cp target/bibliotheque.war /path/to/tomcat/webapps/

# Démarrer Tomcat
/path/to/tomcat/bin/startup.sh

#### 6. Accéder à l'application
http://localhost:8080/bibliotheque

## Comptes de démonstration

| Rôle | Email | Mot de passe |
|------|-------|--------------|
| **Administrateur** | admin@bibliotheque.com | admin123 |
| **Bibliothécaire** | librarian@bibliotheque.com | lib123 |
| **Membre** | user@example.com | user123 |

## Métriques du projet

| Métrique | Valeur |
|----------|--------|
| Entités JPA | 8 |
| Servlets | 25 |
| JSP | 30 |
| Lignes de code | ~5000 |
| Tables en base | 5 |
| Rôles | 3 |

## Défis techniques résolus

| Défi | Solution |
|------|----------|
| **Dates LocalDateTime vs java.util.Date** | Méthode `getCreatedAtAsDate()` dans les entités |
| **Calcul automatique des pénalités** | `LoanService.returnLoan()` calcule jours retard × 0,50€ |
| **Filtre d'authentification multi-rôles** | `AuthFilter` avec vérification des URLs publiques |
| **Responsive design** | Media queries (768px, 480px) + flexbox/grid |
| **Héritage JPA** | Table unique avec `@DiscriminatorColumn` |

## Palette de couleurs

| Élément | Code |
|---------|------|
| Primary | `#0F172A` (Bleu nuit profond) |
| Secondary | `#1E293B` (Bleu-gris) |
| Background | `#F8FAFC` (Blanc cassé) |
| Accent | `#38BDF8` (Bleu clair) |

## Responsive Design

| Breakpoint | Comportement |
|------------|--------------|
| > 768px | Sidebar complète (280px), grilles 4 colonnes |
| ≤ 768px | Sidebar réduite (70px, icônes seules) |
| ≤ 480px | Grilles 1 colonne, boutons pleine largeur |

## Sécurité

- **Mots de passe** : Hashés avec BCrypt (salt aléatoire)
- **Authentification** : Sessions HTTP
- **Autorisation** : Filtre personnalisé basé sur les rôles
- **Protection injections SQL** : Requêtes paramétrées JPA
- **Protection XSS** : Échappement JSTL automatique

## Développement

### Lancer en mode développement
# Avec IntelliJ IDEA
1. Ouvrir le projet
2. Configurer Tomcat 10.1
3. Déployer l'artefact bibliotheque:war exploded
4. Lancer le serveur

### Structure des URLs principales

| Rôle | URL |
|------|-----|
| Admin | `/admin/dashboard`, `/admin/members`, `/admin/documents`, `/admin/loans` |
| Librarian | `/librarian/dashboard`, `/librarian/members`, `/librarian/loans` |
| Member | `/member/dashboard`, `/member/catalog`, `/member/loans` |

## Contact

- **Auteur** : Jean-Léon Kabobi 
- **Email** : jeanleon.kabobi@gmail.com
- **GitHub** : jean-leonkabobi

## License

Distribué sous la licence MIT. Voir `LICENSE` pour plus d'informations.

## Remerciements

- Jakarta EE pour le framework
- Hibernate pour l'ORM
- Font Awesome pour les icônes
- La communauté Java

N'oublie pas de mettre une étoile si ce projet t'a aidé !
