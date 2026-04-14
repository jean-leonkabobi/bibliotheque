<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Créer un compte - Administration</title>
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
                    <a href="${pageContext.request.contextPath}/admin/members" class="btn-link"><i class="fas fa-arrow-left"></i> Retour à la liste</a>
                    <h1><i class="fas fa-user-plus"></i> Créer un nouveau compte</h1>
                    <p class="info-text">Remplissez les informations pour créer un nouvel adhérent</p>
                </div>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${error}</div>
            </c:if>

            <div class="form-container">
                <form action="${pageContext.request.contextPath}/admin/members/create" method="post" class="form">
                    <div class="form-row">
                        <div class="form-group">
                            <label><i class="fas fa-user"></i> Prénom <span class="required">*</span></label>
                            <input type="text" name="firstName" value="${firstName}" required placeholder="Prénom de l'utilisateur">
                        </div>
                        <div class="form-group">
                            <label><i class="fas fa-user"></i> Nom <span class="required">*</span></label>
                            <input type="text" name="lastName" value="${lastName}" required placeholder="Nom de l'utilisateur">
                        </div>
                    </div>

                    <div class="form-group">
                        <label><i class="fas fa-envelope"></i> Email <span class="required">*</span></label>
                        <input type="email" name="email" value="${email}" required placeholder="exemple@email.com">
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label><i class="fas fa-key"></i> Mot de passe <span class="required">*</span></label>
                            <input type="password" name="password" required>
                            <small><i class="fas fa-info-circle"></i> Minimum 6 caractères</small>
                        </div>
                        <div class="form-group">
                            <label><i class="fas fa-check-double"></i> Confirmer le mot de passe <span class="required">*</span></label>
                            <input type="password" name="confirmPassword" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label><i class="fas fa-tag"></i> Rôle</label>
                            <select name="role">
                                <option value="MEMBER" ${selectedRole eq 'MEMBER' ? 'selected' : ''}><i class="fas fa-user"></i> Membre</option>
                                <option value="LIBRARIAN" ${selectedRole eq 'LIBRARIAN' ? 'selected' : ''}><i class="fas fa-user-tie"></i> Bibliothécaire</option>
                                <option value="ADMIN" ${selectedRole eq 'ADMIN' ? 'selected' : ''}><i class="fas fa-user-shield"></i> Administrateur</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label><i class="fas fa-flag"></i> Statut initial</label>
                            <select name="status">
                                <option value="ACTIVE" ${selectedStatus eq 'ACTIVE' ? 'selected' : ''}><i class="fas fa-check-circle"></i> Actif (peut se connecter)</option>
                                <option value="PENDING" ${selectedStatus eq 'PENDING' ? 'selected' : ''}><i class="fas fa-clock"></i> En attente (à valider)</option>
                                <option value="SUSPENDED" ${selectedStatus eq 'SUSPENDED' ? 'selected' : ''}><i class="fas fa-ban"></i> Suspendu</option>
                            </select>
                        </div>
                    </div>

                    <div class="info-box">
                        <i class="fas fa-info-circle info-icon"></i>
                        <div>
                            <strong>Informations</strong><br>
                            Un compte actif peut immédiatement se connecter. Un compte en attente nécessite une validation par un bibliothécaire.
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn-primary"><i class="fas fa-save"></i> Créer le compte</button>
                        <a href="${pageContext.request.contextPath}/admin/members" class="btn-secondary"><i class="fas fa-times"></i> Annuler</a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>
</body>
</html>