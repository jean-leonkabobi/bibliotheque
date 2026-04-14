<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des membres - Bibliothèque</title>
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
                <h1><i class="fas fa-users"></i> Gestion des membres</h1>
                <a href="${pageContext.request.contextPath}/librarian/members/create" class="btn-primary"><i class="fas fa-user-plus"></i> Nouveau membre</a>
            </div>

            <!-- Statistiques -->
            <div class="stats-row">
                <div class="stat-item">
                    <i class="fas fa-chart-simple"></i>
                    <div class="stat-info">
                        <span class="stat-label">Total membres</span>
                        <span class="stat-number">${totalMembers}</span>
                    </div>
                </div>
                <div class="stat-item">
                    <i class="fas fa-check-circle"></i>
                    <div class="stat-info">
                        <span class="stat-label">Actifs</span>
                        <span class="stat-number">${activeMembers}</span>
                    </div>
                </div>
                <div class="stat-item">
                    <i class="fas fa-clock"></i>
                    <div class="stat-info">
                        <span class="stat-label">En attente</span>
                        <span class="stat-number">${pendingMembers}</span>
                    </div>
                </div>
                <div class="stat-item">
                    <i class="fas fa-ban"></i>
                    <div class="stat-info">
                        <span class="stat-label">Suspendus</span>
                        <span class="stat-number">${suspendedMembers}</span>
                    </div>
                </div>
            </div>

            <!-- Filtres -->
            <div class="filters">
                <form method="get" class="filter-form">
                    <div class="filter-group">
                        <label><i class="fas fa-filter"></i> Statut :</label>
                        <select name="status">
                            <option value="all" ${empty currentStatus or currentStatus eq 'all' ? 'selected' : ''}>Tous</option>
                            <option value="ACTIVE" ${currentStatus eq 'ACTIVE' ? 'selected' : ''}>Actifs</option>
                            <option value="PENDING" ${currentStatus eq 'PENDING' ? 'selected' : ''}>En attente</option>
                            <option value="SUSPENDED" ${currentStatus eq 'SUSPENDED' ? 'selected' : ''}>Suspendus</option>
                        </select>
                    </div>
                    <div class="filter-group search">
                        <i class="fas fa-search"></i>
                        <input type="text" name="search" placeholder="Rechercher par nom, email..." value="${currentSearch}">
                        <button type="submit" class="btn-search"><i class="fas fa-search"></i></button>
                    </div>
                    <a href="${pageContext.request.contextPath}/librarian/members" class="btn-reset"><i class="fas fa-undo"></i> Réinitialiser</a>
                </form>
            </div>

            <!-- Tableau des membres -->
            <div class="table-container">
                <table class="data-table">
                    <thead>
                    <tr>
                        <th><i class="fas fa-hashtag"></i> ID</th>
                        <th><i class="fas fa-user"></i> Nom complet</th>
                        <th><i class="fas fa-envelope"></i> Email</th>
                        <th><i class="fas fa-flag"></i> Statut</th>
                        <th><i class="fas fa-calendar"></i> Date d'inscription</th>
                        <th><i class="fas fa-cogs"></i> Actions</th>
                    </thead>
                    <tbody>
                    <c:forEach items="${users}" var="user">
                        <tr>
                            <td>${user.id}</td>
                            <td><strong>${user.firstName} ${user.lastName}</strong></td>
                            <td>${user.email}</td>
                            <td>
                                    <span class="badge badge-${user.status.name().toLowerCase()}">
                                        <i class="fas ${user.status.name() == 'ACTIVE' ? 'fa-check-circle' : (user.status.name() == 'PENDING' ? 'fa-clock' : 'fa-ban')}"></i>
                                        ${user.status.name()}
                                    </span>
                            </td>
                            <td><fmt:formatDate value="${user.createdAtAsDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                            <td class="actions">
                                <a href="${pageContext.request.contextPath}/librarian/members/${user.id}" class="btn-icon" title="Voir"><i class="fas fa-eye"></i></a>
                                <c:if test="${user.status eq 'ACTIVE'}">
                                    <a href="${pageContext.request.contextPath}/librarian/members/${user.id}/suspend" class="btn-icon" title="Suspendre" onclick="return confirm('Suspendre ce membre ?')"><i class="fas fa-pause-circle"></i></a>
                                </c:if>
                                <c:if test="${user.status eq 'SUSPENDED'}">
                                    <a href="${pageContext.request.contextPath}/librarian/members/${user.id}/activate" class="btn-icon" title="Réactiver" onclick="return confirm('Réactiver ce membre ?')"><i class="fas fa-play-circle"></i></a>
                                </c:if>
                                <c:if test="${user.status eq 'PENDING'}">
                                    <a href="${pageContext.request.contextPath}/librarian/members/${user.id}/validate" class="btn-icon" title="Valider" onclick="return confirm('Valider ce compte ?')"><i class="fas fa-check-circle"></i></a>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>
</body>
</html>