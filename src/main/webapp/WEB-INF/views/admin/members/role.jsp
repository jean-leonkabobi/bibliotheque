<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Changer le rôle - ${targetUser.firstName} ${targetUser.lastName}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body>
<div class="dashboard">
    <aside class="sidebar">
        <div class="sidebar-header">
            <div class="logo">
                <span class="logo-icon">📚</span>
                <h2>Bibliothèque</h2>
            </div>
        </div>
        <nav class="sidebar-nav">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-item">📊 Tableau de bord</a>
            <a href="${pageContext.request.contextPath}/admin/members" class="nav-item active">👥 Adhérents</a>
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
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">🚪 Déconnexion</a>
        </header>

        <div class="content">
            <div class="page-header">
                <div>
                    <a href="${pageContext.request.contextPath}/admin/members/${targetUser.id}" class="btn-link">← Retour au profil</a>
                    <h1>Changer le rôle de ${targetUser.firstName} ${targetUser.lastName}</h1>
                </div>
            </div>

            <div class="form-container">
                <form action="${pageContext.request.contextPath}/admin/members/${targetUser.id}/role" method="post" class="form">
                    <input type="hidden" name="userId" value="${targetUser.id}">

                    <div class="form-group">
                        <label>Rôle actuel</label>
                        <input type="text" value="${targetUser.role.name()}" disabled>
                    </div>

                    <div class="form-group">
                        <label>Nouveau rôle</label>
                        <select name="role" required>
                            <option value="MEMBER" ${targetUser.role.name() == 'MEMBER' ? 'selected' : ''}>Membre</option>
                            <option value="LIBRARIAN" ${targetUser.role.name() == 'LIBRARIAN' ? 'selected' : ''}>Bibliothécaire</option>
                            <option value="ADMIN" ${targetUser.role.name() == 'ADMIN' ? 'selected' : ''}>Administrateur</option>
                        </select>
                    </div>

                    <div class="info-box">
                        <span class="info-icon">⚠️</span>
                        <div>
                            <strong>Attention :</strong> Le changement de rôle modifie les permissions de l'utilisateur.
                            Un bibliothécaire pourra gérer les emprunts, un administrateur aura tous les droits.
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn-primary">Modifier le rôle</button>
                        <a href="${pageContext.request.contextPath}/admin/members/${targetUser.id}" class="btn-secondary">Annuler</a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>
</body>
</html>