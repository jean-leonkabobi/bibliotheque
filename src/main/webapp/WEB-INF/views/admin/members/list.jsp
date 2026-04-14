<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des adhérents - Administration</title>
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
            <a href="${pageContext.request.contextPath}/admin/penalties" class="nav-item"><i class="fas fa-euro-sign"></i><span>Pénalités</span></a>
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
                <h1><i class="fas fa-users"></i> Gestion des adhérents</h1>
                <a href="${pageContext.request.contextPath}/admin/members/create" class="btn-primary"><i class="fas fa-user-plus"></i> Nouvel adhérent</a>
            </div>

            <!-- Statistiques -->
            <div class="stats-mini">
                <div class="stat-mini"><i class="fas fa-chart-simple"></i><span class="stat-label">Total</span><span class="stat-number">${totalUsers}</span></div>
                <div class="stat-mini"><i class="fas fa-user"></i><span class="stat-label">Membres</span><span class="stat-number">${totalMembers}</span></div>
                <div class="stat-mini"><i class="fas fa-user-tie"></i><span class="stat-label">Bibliothécaires</span><span class="stat-number">${totalLibrarians}</span></div>
                <div class="stat-mini"><i class="fas fa-user-shield"></i><span class="stat-label">Administrateurs</span><span class="stat-number">${totalAdmins}</span></div>
                <div class="stat-mini success"><i class="fas fa-check-circle"></i><span class="stat-label">Actifs</span><span class="stat-number">${activeCount}</span></div>
                <div class="stat-mini warning"><i class="fas fa-clock"></i><span class="stat-label">En attente</span><span class="stat-number">${pendingCount}</span></div>
                <div class="stat-mini danger"><i class="fas fa-ban"></i><span class="stat-label">Suspendus</span><span class="stat-number">${suspendedCount}</span></div>
            </div>

            <!-- Filtres -->
            <div class="filters">
                <form method="get" class="filter-form">
                    <div class="filter-group">
                        <label><i class="fas fa-tag"></i> Rôle :</label>
                        <select name="role">
                            <option value="all" ${empty currentRole or currentRole eq 'all' ? 'selected' : ''}>Tous</option>
                            <option value="MEMBER" ${currentRole eq 'MEMBER' ? 'selected' : ''}>Membres</option>
                            <option value="LIBRARIAN" ${currentRole eq 'LIBRARIAN' ? 'selected' : ''}>Bibliothécaires</option>
                            <option value="ADMIN" ${currentRole eq 'ADMIN' ? 'selected' : ''}>Administrateurs</option>
                        </select>
                    </div>
                    <div class="filter-group">
                        <label><i class="fas fa-flag"></i> Statut :</label>
                        <select name="status">
                            <option value="all" ${empty currentStatus or currentStatus eq 'all' ? 'selected' : ''}>Tous</option>
                            <option value="ACTIVE" ${currentStatus eq 'ACTIVE' ? 'selected' : ''}>Actifs</option>
                            <option value="PENDING" ${currentStatus eq 'PENDING' ? 'selected' : ''}>En attente</option>
                            <option value="SUSPENDED" ${currentStatus eq 'SUSPENDED' ? 'selected' : ''}>Suspendus</option>
                        </select>
                    </div>
                    <div class="filter-group search">
                        <i class="fas fa-search"></i>
                        <input type="text" name="search" placeholder="Rechercher..." value="${currentSearch}">
                        <button type="submit" class="btn-search"><i class="fas fa-search"></i></button>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/members" class="btn-reset"><i class="fas fa-undo"></i> Réinitialiser</a>
                </form>
            </div>

            <!-- Tableau des adhérents -->
            <div class="table-container">
                <table class="data-table">
                    <thead>
                    <tr>
                        <th><i class="fas fa-hashtag"></i> ID</th>
                        <th><i class="fas fa-user"></i> Nom complet</th>
                        <th><i class="fas fa-envelope"></i> Email</th>
                        <th><i class="fas fa-tag"></i> Rôle</th>
                        <th><i class="fas fa-flag"></i> Statut</th>
                        <th><i class="fas fa-calendar"></i> Date d'inscription</th>
                        <th><i class="fas fa-cogs"></i> Actions</th>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${empty users}">
                            <tr>
                                <td colspan="7" class="empty-table"><i class="fas fa-info-circle"></i> Aucun adhérent trouvé</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${users}" var="user">
                                <tr>
                                    <td>${user.id}</td>
                                    <td><strong>${user.firstName} ${user.lastName}</strong></td>
                                    <td>${user.email}</td>
                                    <td><span class="badge badge-${user.role.name().toLowerCase()}"><i class="fas ${user.role.name() == 'ADMIN' ? 'fa-user-shield' : (user.role.name() == 'LIBRARIAN' ? 'fa-user-tie' : 'fa-user')}"></i> ${user.role.name()}</span></td>
                                    <td><span class="badge badge-${user.status.name().toLowerCase()}"><i class="fas ${user.status.name() == 'ACTIVE' ? 'fa-check-circle' : (user.status.name() == 'PENDING' ? 'fa-clock' : 'fa-ban')}"></i> ${user.status.name()}</span></td>
                                    <td><fmt:formatDate value="${user.createdAtAsDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                    <td class="actions">
                                        <a href="${pageContext.request.contextPath}/admin/members/${user.id}" class="btn-icon" title="Voir"><i class="fas fa-eye"></i></a>
                                        <a href="${pageContext.request.contextPath}/admin/members/${user.id}/edit" class="btn-icon" title="Modifier"><i class="fas fa-edit"></i></a>
                                        <c:if test="${user.status eq 'ACTIVE'}">
                                            <a href="${pageContext.request.contextPath}/admin/members/${user.id}/suspend" class="btn-icon" title="Suspendre" onclick="return confirm('Suspendre cet utilisateur ?')"><i class="fas fa-pause-circle"></i></a>
                                        </c:if>
                                        <c:if test="${user.status eq 'SUSPENDED'}">
                                            <a href="${pageContext.request.contextPath}/admin/members/${user.id}/activate" class="btn-icon" title="Réactiver" onclick="return confirm('Réactiver cet utilisateur ?')"><i class="fas fa-play-circle"></i></a>
                                        </c:if>
                                        <c:if test="${user.status eq 'PENDING'}">
                                            <a href="${pageContext.request.contextPath}/admin/members/${user.id}/validate" class="btn-icon" title="Valider" onclick="return confirm('Valider ce compte ?')"><i class="fas fa-check-circle"></i></a>
                                        </c:if>
                                        <a href="${pageContext.request.contextPath}/admin/members/${user.id}/delete" class="btn-icon danger" title="Supprimer" onclick="return confirm('Supprimer définitivement cet utilisateur ?')"><i class="fas fa-trash-alt"></i></a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>
</body>
</html>