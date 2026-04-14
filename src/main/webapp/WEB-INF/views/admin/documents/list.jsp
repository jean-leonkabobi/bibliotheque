<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Gestion des ouvrages - Administration</title>
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
            <a href="${pageContext.request.contextPath}/admin/members" class="nav-item"><i class="fas fa-users"></i><span>Adhérents</span></a>
            <a href="${pageContext.request.contextPath}/admin/documents" class="nav-item active"><i class="fas fa-book"></i><span>Ouvrages</span></a>
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
                <h1><i class="fas fa-book"></i> Gestion des ouvrages</h1>
                <div>
                    <a href="${pageContext.request.contextPath}/admin/documents/create?type=BOOK" class="btn-primary"><i class="fas fa-book"></i> Livre</a>
                    <a href="${pageContext.request.contextPath}/admin/documents/create?type=CD" class="btn-primary"><i class="fas fa-compact-disc"></i> CD</a>
                    <a href="${pageContext.request.contextPath}/admin/documents/create?type=DVD" class="btn-primary"><i class="fas fa-film"></i> DVD</a>
                </div>
            </div>

            <div class="filters">
                <form method="get" class="filter-form">
                    <div class="filter-group search">
                        <i class="fas fa-search"></i>
                        <input type="text" name="search" placeholder="Rechercher par titre..." value="${searchQuery}">
                        <button type="submit" class="btn-search"><i class="fas fa-search"></i></button>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/documents" class="btn-reset"><i class="fas fa-undo"></i> Réinitialiser</a>
                </form>
            </div>

            <div class="stats-mini">
                <div class="stat-mini">
                    <i class="fas fa-chart-simple"></i>
                    <span class="stat-label">Total</span>
                    <span class="stat-number">${totalDocuments}</span>
                </div>
            </div>

            <div class="table-container">
                <table class="data-table">
                    <thead>
                    <tr>
                        <th><i class="fas fa-hashtag"></i> ID</th>
                        <th><i class="fas fa-tag"></i> Type</th>
                        <th><i class="fas fa-heading"></i> Titre</th>
                        <th><i class="fas fa-user"></i> Détails</th>
                        <th><i class="fas fa-copy"></i> Exemplaires</th>
                        <th><i class="fas fa-check-circle"></i> Disponibles</th>
                        <th><i class="fas fa-cogs"></i> Actions</th>
                    </thead>
                    <tbody>
                    <c:forEach items="${documents}" var="doc">
                        <tr>
                            <td>${doc.id}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${doc['class'].simpleName eq 'Book'}"><i class="fas fa-book"></i> Livre</c:when>
                                    <c:when test="${doc['class'].simpleName eq 'CD'}"><i class="fas fa-compact-disc"></i> CD</c:when>
                                    <c:when test="${doc['class'].simpleName eq 'DVD'}"><i class="fas fa-film"></i> DVD</c:when>
                                </c:choose>
                            </td>
                            <td><strong>${doc.title}</strong></td>
                            <td>
                                <c:choose>
                                    <c:when test="${doc['class'].simpleName eq 'Book'}"><i class="fas fa-user-pen"></i> ${doc.author}</c:when>
                                    <c:when test="${doc['class'].simpleName eq 'CD'}"><i class="fas fa-microphone-alt"></i> ${doc.artist}</c:when>
                                    <c:when test="${doc['class'].simpleName eq 'DVD'}"><i class="fas fa-clapperboard"></i> ${doc.director}</c:when>
                                </c:choose>
                            </td>
                            <td>${doc.totalCopies}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${doc.availableCopies > 0}">
                                        <span class="badge badge-active"><i class="fas fa-check-circle"></i> ${doc.availableCopies}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-danger"><i class="fas fa-times-circle"></i> 0</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="actions">
                                <a href="${pageContext.request.contextPath}/admin/documents/${doc.id}" class="btn-icon" title="Voir"><i class="fas fa-eye"></i></a>
                                <a href="${pageContext.request.contextPath}/admin/documents/${doc.id}/edit" class="btn-icon" title="Modifier"><i class="fas fa-edit"></i></a>
                                <a href="${pageContext.request.contextPath}/admin/documents/${doc.id}/delete" class="btn-icon danger" title="Supprimer" onclick="return confirm('Supprimer cet ouvrage ?')"><i class="fas fa-trash-alt"></i></a>
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