<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mon profil - Bibliothèque</title>
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
        .info-card .content {
            flex: 1;
        }
        .info-card .content strong {
            display: block;
            margin-bottom: 4px;
            color: #0F172A;
        }
        .info-card .content span {
            font-size: 13px;
            color: #64748B;
        }
        .warning-card {
            background: #FEF2F2;
        }
        .warning-card i {
            color: #EF4444;
        }
        .required-field::after {
            content: "*";
            color: #EF4444;
            margin-left: 4px;
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
            <a href="${pageContext.request.contextPath}/member/dashboard" class="nav-item"><i class="fas fa-tachometer-alt"></i><span>Tableau de bord</span></a>
            <a href="${pageContext.request.contextPath}/member/loans" class="nav-item"><i class="fas fa-book"></i><span>Mes emprunts</span></a>
            <a href="${pageContext.request.contextPath}/member/history" class="nav-item"><i class="fas fa-history"></i><span>Historique</span></a>
            <a href="${pageContext.request.contextPath}/member/penalties" class="nav-item"><i class="fas fa-euro-sign"></i><span>Pénalités</span></a>
            <a href="${pageContext.request.contextPath}/member/catalog" class="nav-item"><i class="fas fa-search"></i><span>Catalogue</span></a>
            <a href="${pageContext.request.contextPath}/member/profile" class="nav-item active"><i class="fas fa-user"></i><span>Mon profil</span></a>
        </nav>
    </aside>

    <main class="main-content">
        <header class="top-bar">
            <div class="user-info">
                <div class="user-avatar">${sessionScope.user.firstName.charAt(0)}${sessionScope.user.lastName.charAt(0)}</div>
                <div class="user-details">
                    <span class="user-name">${sessionScope.user.firstName} ${sessionScope.user.lastName}</span>
                    <span class="user-role">Adhérent</span>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Déconnexion</a>
        </header>

        <div class="content">
            <div class="page-header">
                <h1><i class="fas fa-user-circle"></i> Mon profil</h1>
                <p class="info-text">Gérez vos informations personnelles</p>
            </div>

            <c:if test="${not empty sessionScope.success}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> ${sessionScope.success}
                    <% session.removeAttribute("success"); %>
                </div>
            </c:if>
            <c:if test="${not empty sessionScope.error}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i> ${sessionScope.error}
                    <% session.removeAttribute("error"); %>
                </div>
            </c:if>

            <div class="form-container">
                <form action="${pageContext.request.contextPath}/member/profile" method="post" class="form">
                    <div class="form-row">
                        <div class="form-group">
                            <label><i class="fas fa-user"></i> Prénom</label>
                            <input type="text" name="firstName" value="${member.firstName}" required>
                        </div>
                        <div class="form-group">
                            <label><i class="fas fa-user"></i> Nom</label>
                            <input type="text" name="lastName" value="${member.lastName}" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label><i class="fas fa-envelope"></i> Email</label>
                        <input type="email" name="email" value="${member.email}" required>
                    </div>

                    <div class="info-card">
                        <i class="fas fa-lock"></i>
                        <div class="content">
                            <strong>Changer le mot de passe</strong>
                            <span>Laissez vide pour conserver le mot de passe actuel.</span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label><i class="fas fa-key"></i> Mot de passe actuel</label>
                        <input type="password" name="currentPassword" placeholder="Requis pour modifier">
                        <small>Requis pour toute modification du mot de passe</small>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label><i class="fas fa-lock"></i> Nouveau mot de passe</label>
                            <input type="password" name="newPassword" placeholder="Laissez vide pour ne pas changer">
                            <small>Minimum 6 caractères</small>
                        </div>
                        <div class="form-group">
                            <label><i class="fas fa-check-double"></i> Confirmer le mot de passe</label>
                            <input type="password" name="confirmPassword" placeholder="Confirmez le nouveau mot de passe">
                        </div>
                    </div>

                    <div class="info-card">
                        <i class="fas fa-info-circle"></i>
                        <div class="content">
                            <strong>Informations complémentaires</strong>
                            <span>Inscrit depuis le <fmt:formatDate value="${member.createdAtAsDate}" pattern="dd/MM/yyyy"/></span>
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn-primary"><i class="fas fa-save"></i> Enregistrer les modifications</button>
                        <a href="${pageContext.request.contextPath}/member/dashboard" class="btn-secondary"><i class="fas fa-times"></i> Annuler</a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>
</body>
</html>