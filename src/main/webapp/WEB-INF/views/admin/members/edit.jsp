<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier - ${member.firstName} ${member.lastName}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-item"><i class="fas fa-chart-line"></i><span>Tableau de bord</span></a>
            <a href="${pageContext.request.contextPath}/admin/members" class="nav-item active"><i class="fas fa-users"></i><span>Adhérents</span></a>
            <a href="${pageContext.request.contextPath}/admin/documents" class="nav-item"><i class="fas fa-book"></i><span>Ouvrages</span></a>
            <a href="${pageContext.request.contextPath}/admin/loans" class="nav-item"><i class="fas fa-exchange-alt"></i><span>Emprunts</span></a>
        </nav>
    </aside>

    <main class="main-content">
        <header class="top-bar">
            <div class="user-info">
                <div class="user-avatar">${sessionScope.user.firstName.charAt(0)}${sessionScope.user.lastName.charAt(0)}</div>
                <div class="user-details">
                    <span class="user-name">${sessionScope.user.firstName} ${sessionScope.user.lastName}</span>
                    <span class="user-role">Administrateur</span>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Déconnexion</a>
        </header>

        <div class="content">
            <div class="page-header">
                <div>
                    <a href="${pageContext.request.contextPath}/admin/members/${member.id}" class="btn-link"><i class="fas fa-arrow-left"></i> Retour au profil</a>
                    <h1><i class="fas fa-user-edit"></i> Modifier les informations</h1>
                    <p class="info-text">Utilisateur : ${member.firstName} ${member.lastName}</p>
                </div>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${error}</div>
            </c:if>

            <div class="form-container">
                <form action="${pageContext.request.contextPath}/admin/members/${member.id}/edit" method="post" class="form">
                    <input type="hidden" name="userId" value="${member.id}">

                    <div class="form-row">
                        <div class="form-group">
                            <label><i class="fas fa-user"></i> Prénom <span class="required">*</span></label>
                            <input type="text" name="firstName" value="${not empty firstName ? firstName : member.firstName}" required>
                        </div>
                        <div class="form-group">
                            <label><i class="fas fa-user"></i> Nom <span class="required">*</span></label>
                            <input type="text" name="lastName" value="${not empty lastName ? lastName : member.lastName}" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label><i class="fas fa-envelope"></i> Email <span class="required">*</span></label>
                        <input type="email" name="email" value="${not empty email ? email : member.email}" required>
                    </div>

                    <div class="info-box">
                        <i class="fas fa-lock info-icon"></i>
                        <div>
                            <strong>Changer le mot de passe</strong><br>
                            Laissez vide pour conserver le mot de passe actuel.
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label><i class="fas fa-key"></i> Nouveau mot de passe</label>
                            <input type="password" name="newPassword" placeholder="Laissez vide pour ne pas changer">
                            <small>Minimum 6 caractères</small>
                        </div>
                        <div class="form-group">
                            <label><i class="fas fa-check-double"></i> Confirmer le mot de passe</label>
                            <input type="password" name="confirmPassword" placeholder="Confirmez le nouveau mot de passe">
                        </div>
                    </div>

                    <div class="info-box warning-box">
                        <i class="fas fa-exclamation-triangle info-icon"></i>
                        <div>
                            <strong>Attention :</strong> Les modifications seront appliquées immédiatement.
                            L'utilisateur devra utiliser ses nouvelles informations pour se connecter.
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn-primary"><i class="fas fa-save"></i> Enregistrer les modifications</button>
                        <a href="${pageContext.request.contextPath}/admin/members/${member.id}" class="btn-secondary"><i class="fas fa-times"></i> Annuler</a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>
</body>
</html>