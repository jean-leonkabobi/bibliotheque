<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Rechercher - Bibliothèque</title>
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
            <a href="${pageContext.request.contextPath}/member/dashboard" class="nav-item">🏠 Tableau de bord</a>
            <a href="${pageContext.request.contextPath}/member/loans" class="nav-item">📖 Mes emprunts</a>
            <a href="${pageContext.request.contextPath}/member/history" class="nav-item">📜 Historique</a>
            <a href="${pageContext.request.contextPath}/member/penalties" class="nav-item">💰 Pénalités</a>
            <a href="${pageContext.request.contextPath}/member/search" class="nav-item active">🔍 Rechercher</a>
            <a href="${pageContext.request.contextPath}/member/profile" class="nav-item">👤 Mon profil</a>
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
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">🚪 Déconnexion</a>
        </header>

        <div class="content">
            <div class="page-header">
                <h1>🔍 Rechercher un ouvrage</h1>
            </div>

            <div class="form-container">
                <form action="${pageContext.request.contextPath}/member/search" method="post" class="form">
                    <div class="form-row">
                        <div class="form-group" style="flex: 2;">
                            <input type="text" name="search" placeholder="Titre, auteur, mots-clés..." value="${searchQuery}" required>
                        </div>
                        <div class="form-group">
                            <select name="searchType">
                                <option value="title" ${searchType eq 'title' ? 'selected' : ''}>Par titre</option>
                                <option value="author" ${searchType eq 'author' ? 'selected' : ''}>Par auteur</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <button type="submit" class="btn-primary">🔍 Rechercher</button>
                        </div>
                    </div>
                </form>
            </div>

            <c:if test="${not empty searchQuery}">
                <div class="section">
                    <div class="section-header">
                        <h2>Résultats pour "${searchQuery}"</h2>
                        <span class="badge">${resultCount} résultat(s)</span>
                    </div>

                    <c:choose>
                        <c:when test="${empty results}">
                            <div class="empty-state">
                                <div class="empty-icon">📚</div>
                                <h3>Aucun résultat trouvé</h3>
                                <p>Essayez avec d'autres mots-clés.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="documents-list">
                                <c:forEach items="${results}" var="doc">
                                    <div class="document-card">
                                        <div class="document-icon">
                                            <c:choose>
                                                <c:when test="${doc['class'].simpleName eq 'Book'}">📖</c:when>
                                                <c:when test="${doc['class'].simpleName eq 'CD'}">💿</c:when>
                                                <c:when test="${doc['class'].simpleName eq 'DVD'}">🎬</c:when>
                                                <c:otherwise>📄</c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="document-info">
                                            <div class="document-title">${doc.title}</div>
                                            <div class="document-type">
                                                <c:choose>
                                                    <c:when test="${doc['class'].simpleName eq 'Book'}">
                                                        Livre
                                                        <c:if test="${not empty doc.author}"> - ${doc.author}</c:if>
                                                    </c:when>
                                                    <c:when test="${doc['class'].simpleName eq 'CD'}">
                                                        CD
                                                        <c:if test="${not empty doc.artist}"> - ${doc.artist}</c:if>
                                                    </c:when>
                                                    <c:when test="${doc['class'].simpleName eq 'DVD'}">
                                                        DVD
                                                        <c:if test="${not empty doc.director}"> - ${doc.director}</c:if>
                                                    </c:when>
                                                </c:choose>
                                            </div>
                                            <div class="document-copies">
                                                Exemplaires disponibles : ${doc.availableCopies}/${doc.totalCopies}
                                            </div>
                                        </div>
                                        <div class="document-actions">
                                            <c:choose>
                                                <c:when test="${doc.availableCopies > 0}">
                                                    <a href="#" class="btn-success" onclick="return confirm('Emprunter cet ouvrage ?')">📥 Emprunter</a>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-suspended">Indisponible</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>
        </div>
    </main>
</div>
</body>
</html>