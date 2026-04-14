<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ajouter un membre - Bibliothèque</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .form-container {
            max-width: 700px;
            margin: 0 auto;
        }
        .info-card {
            background: #EFF6FF;
            border-radius: 12px;
            padding: 15px 20px;
            margin: 20px 0;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .info-card i {
            font-size: 24px;
            color: #38BDF8;
        }
        .info-card span {
            color: #0F172A;
            font-size: 14px;
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
            <a href="${pageContext.request.contextPath}/librarian/dashboard" class="nav-item"><i class="fas fa-chart-line"></i><span>Tableau de bord</span></a>
            <a href="${pageContext.request.contextPath}/librarian/members" class="nav-item active"><i class="fas fa-users"></i><span>Membres</span></a>
            <a href="${pageContext.request.contextPath}/librarian/validate" class="nav-item"><i class="fas fa-check-circle"></i><span>Validations</span></a>
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
            <div class="page-header">
                <div>
                    <a href="${pageContext.request.contextPath}/librarian/members" class="btn-link"><i class="fas fa-arrow-left"></i> Retour à la liste</a>
                    <h1><i class="fas fa-user-plus"></i> Ajouter un nouveau membre</h1>
                    <p class="info-text">Le compte sera créé en attente de validation.</p>
                </div>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${error}</div>
            </c:if>

            <div class="form-container">
                <form action="${pageContext.request.contextPath}/librarian/members/create" method="post" class="form">
                    <div class="form-row">
                        <div class="form-group">
                            <label><i class="fas fa-user"></i> Prénom <span class="required">*</span></label>
                            <input type="text" name="firstName" value="${firstName}" placeholder="Prénom du membre" required>
                        </div>
                        <div class="form-group">
                            <label><i class="fas fa-user"></i> Nom <span class="required">*</span></label>
                            <input type="text" name="lastName" value="${lastName}" placeholder="Nom du membre" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label><i class="fas fa-envelope"></i> Email <span class="required">*</span></label>
                        <input type="email" name="email" value="${email}" placeholder="exemple@email.com" required>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label><i class="fas fa-key"></i> Mot de passe <span class="required">*</span></label>
                            <input type="password" name="password" placeholder="••••••" required>
                            <small><i class="fas fa-info-circle"></i> Minimum 6 caractères</small>
                        </div>
                        <div class="form-group">
                            <label><i class="fas fa-check-double"></i> Confirmer le mot de passe <span class="required">*</span></label>
                            <input type="password" name="confirmPassword" placeholder="••••••" required>
                        </div>
                    </div>

                    <div class="info-card">
                        <i class="fas fa-clock"></i>
                        <span>Le membre devra être validé avant de pouvoir se connecter.</span>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn-primary"><i class="fas fa-save"></i> Créer le compte</button>
                        <a href="${pageContext.request.contextPath}/librarian/members" class="btn-secondary"><i class="fas fa-times"></i> Annuler</a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>
</body>
</html>