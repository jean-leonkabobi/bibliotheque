<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tableau de bord - Bibliothécaire</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Ajustement pour les actions rapides - 2 lignes de 3 */
        .quick-actions {
            margin-bottom: 30px;
        }
        .actions-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 20px;
        }
        @media (max-width: 768px) {
            .actions-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        @media (max-width: 480px) {
            .actions-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<div class="dashboard">
    <aside class="sidebar">
        <div class="sidebar-header">
            <div class="logo">
                <i class="fas fa-book-open logo-icon"></i>
                <h2>Bibliothèque</h2>
            </div>
        </div>
        <nav class="sidebar-nav">
            <a href="${pageContext.request.contextPath}/librarian/dashboard" class="nav-item active"><i class="fas fa-chart-line"></i><span>Tableau de bord</span></a>
            <a href="${pageContext.request.contextPath}/librarian/members" class="nav-item"><i class="fas fa-users"></i><span>Gestion des membres</span></a>
            <a href="${pageContext.request.contextPath}/librarian/validate" class="nav-item"><i class="fas fa-check-circle"></i><span>Validations</span></a>
            <a href="${pageContext.request.contextPath}/librarian/documents" class="nav-item"><i class="fas fa-book"></i><span>Gestion des ouvrages</span></a>
            <a href="${pageContext.request.contextPath}/librarian/loans" class="nav-item"><i class="fas fa-exchange-alt"></i><span>Gestion des emprunts</span></a>
            <a href="${pageContext.request.contextPath}/librarian/penalties" class="nav-item"><i class="fas fa-euro-sign"></i><span>Pénalités</span></a>
            <a href="${pageContext.request.contextPath}/librarian/members/create" class="nav-item"><i class="fas fa-user-plus"></i><span>Nouveau membre</span></a>
        </nav>
    </aside>

    <main class="main-content">
        <header class="top-bar">
            <div class="user-info">
                <div class="user-avatar">${sessionScope.user.firstName.charAt(0)}${sessionScope.user.lastName.charAt(0)}</div>
                <div class="user-details">
                    <span class="user-name">${sessionScope.user.firstName} ${sessionScope.user.lastName}</span>
                    <span class="user-role">Bibliothécaire</span>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Déconnexion</a>
        </header>

        <div class="content">
            <h1>Tableau de bord bibliothécaire</h1>
            <p class="welcome-text">Bienvenue, ${sessionScope.user.firstName} ! Gérez les opérations quotidiennes.</p>

            <!-- Actions rapides - 2 lignes de 3 -->
            <div class="quick-actions">
                <h3><i class="fas fa-bolt"></i> Actions rapides</h3>
                <div class="actions-grid">
                    <a href="${pageContext.request.contextPath}/librarian/loans/create" class="action-card">
                        <i class="fas fa-plus-circle"></i>
                        <span>Enregistrer emprunt</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/librarian/loans" class="action-card">
                        <i class="fas fa-undo-alt"></i>
                        <span>Enregistrer retour</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/librarian/documents/create?type=BOOK" class="action-card">
                        <i class="fas fa-book"></i>
                        <span>Ajouter ouvrage</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/librarian/members/create" class="action-card">
                        <i class="fas fa-user-plus"></i>
                        <span>Nouvel adhérent</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/librarian/validate" class="action-card">
                        <i class="fas fa-check-double"></i>
                        <span>Valider inscriptions</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/librarian/members" class="action-card">
                        <i class="fas fa-list"></i>
                        <span>Liste des membres</span>
                    </a>
                </div>
            </div>

            <!-- Statistiques - 4 cartes sur une ligne -->
            <div class="stats-row">
                <div class="stat-item">
                    <i class="fas fa-calendar-day"></i>
                    <div class="stat-info">
                        <span class="stat-label">Emprunts du jour</span>
                        <span class="stat-number">${stats.todayLoans}</span>
                    </div>
                </div>
                <div class="stat-item">
                    <i class="fas fa-calendar-check"></i>
                    <div class="stat-info">
                        <span class="stat-label">Retours attendus</span>
                        <span class="stat-number">${stats.todayReturns}</span>
                    </div>
                </div>
                <div class="stat-item">
                    <i class="fas fa-exclamation-triangle"></i>
                    <div class="stat-info">
                        <span class="stat-label">En retard</span>
                        <span class="stat-number">${stats.overdueLoans}</span>
                        <a href="${pageContext.request.contextPath}/librarian/loans?filter=overdue" class="stat-link">Voir les retards <i class="fas fa-arrow-right"></i></a>
                    </div>
                </div>
                <div class="stat-item">
                    <i class="fas fa-euro-sign"></i>
                    <div class="stat-info">
                        <span class="stat-label">Adhérents avec pénalités</span>
                        <span class="stat-number">${stats.membersWithPenalties}</span>
                        <a href="${pageContext.request.contextPath}/librarian/penalties" class="stat-link">Gérer <i class="fas fa-arrow-right"></i></a>
                    </div>
                </div>
            </div>

            <!-- Sections -->
            <div class="sections-grid">
                <div class="section">
                    <div class="section-header">
                        <h2><i class="fas fa-user-clock"></i> Inscriptions en attente</h2>
                        <a href="${pageContext.request.contextPath}/librarian/validate" class="btn-link">Voir tout <i class="fas fa-arrow-right"></i></a>
                    </div>
                    <div class="info-card">
                        <i class="fas fa-clock"></i>
                        <span>${stats.pendingValidations} inscription(s) en attente de validation</span>
                    </div>
                </div>

                <div class="section">
                    <div class="section-header">
                        <h2><i class="fas fa-star"></i> Ouvrages les plus empruntés</h2>
                    </div>
                    <div class="info-card">
                        <i class="fas fa-chart-line"></i>
                        <span>Les statistiques apparaîtront bientôt</span>
                    </div>
                </div>
            </div>

            <!-- Retards à surveiller -->
            <div class="section">
                <div class="section-header">
                    <h2><i class="fas fa-bell"></i> Retards à surveiller</h2>
                    <a href="${pageContext.request.contextPath}/librarian/loans?filter=overdue" class="btn-link">Voir tout <i class="fas fa-arrow-right"></i></a>
                </div>
                <div class="info-card">
                    <i class="fas fa-check-circle"></i>
                    <span>Aucun emprunt en retard</span>
                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>