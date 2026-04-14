<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Détails - ${document.title}</title>
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
                    <a href="${pageContext.request.contextPath}/admin/documents" class="btn-link"><i class="fas fa-arrow-left"></i> Retour à la liste</a>
                    <h1><i class="fas fa-info-circle"></i> ${document.title}</h1>
                </div>
            </div>

            <div class="info-section">
                <h2><i class="fas fa-info-circle"></i> Informations générales</h2>
                <div class="info-grid">
                    <div><i class="fas fa-hashtag"></i> <strong>ID :</strong> ${document.id}</div>
                    <div><i class="fas fa-tag"></i> <strong>Type :</strong>
                        <c:choose>
                            <c:when test="${document['class'].simpleName eq 'Book'}"><i class="fas fa-book"></i> Livre</c:when>
                            <c:when test="${document['class'].simpleName eq 'CD'}"><i class="fas fa-compact-disc"></i> CD</c:when>
                            <c:when test="${document['class'].simpleName eq 'DVD'}"><i class="fas fa-film"></i> DVD</c:when>
                        </c:choose>
                    </div>
                    <div><i class="fas fa-heading"></i> <strong>Titre :</strong> ${document.title}</div>
                    <div><i class="fas fa-copy"></i> <strong>Exemplaires total :</strong> ${document.totalCopies}</div>
                    <div><i class="fas fa-check-circle"></i> <strong>Exemplaires disponibles :</strong>
                        <c:choose>
                            <c:when test="${document.availableCopies > 0}">
                                <span style="color: #10B981;"><i class="fas fa-check-circle"></i> ${document.availableCopies}</span>
                            </c:when>
                            <c:otherwise>
                                <span style="color: #EF4444;"><i class="fas fa-times-circle"></i> ${document.availableCopies}</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <div class="info-section">
                <c:choose>
                    <c:when test="${document['class'].simpleName eq 'Book'}">
                        <h2><i class="fas fa-book"></i> Détails du livre</h2>
                        <div class="info-grid">
                            <div><i class="fas fa-user-pen"></i> <strong>Auteur :</strong> ${document.author}</div>
                            <div><i class="fas fa-barcode"></i> <strong>ISBN :</strong> ${document.isbn}</div>
                            <div><i class="fas fa-building"></i> <strong>Éditeur :</strong> ${document.publisher}</div>
                            <div><i class="fas fa-calendar"></i> <strong>Année :</strong> ${document.publicationYear}</div>
                            <div><i class="fas fa-file-alt"></i> <strong>Pages :</strong> ${document.numberOfPages}</div>
                        </div>
                    </c:when>
                    <c:when test="${document['class'].simpleName eq 'CD'}">
                        <h2><i class="fas fa-compact-disc"></i> Détails du CD</h2>
                        <div class="info-grid">
                            <div><i class="fas fa-microphone-alt"></i> <strong>Artiste :</strong> ${document.artist}</div>
                            <div><i class="fas fa-hourglass-half"></i> <strong>Durée :</strong> ${document.duration} min</div>
                            <div><i class="fas fa-building"></i> <strong>Maison de disque :</strong> ${document.recordCompany}</div>
                        </div>
                    </c:when>
                    <c:when test="${document['class'].simpleName eq 'DVD'}">
                        <h2><i class="fas fa-film"></i> Détails du DVD</h2>
                        <div class="info-grid">
                            <div><i class="fas fa-clapperboard"></i> <strong>Réalisateur :</strong> ${document.director}</div>
                            <div><i class="fas fa-hourglass-half"></i> <strong>Durée :</strong> ${document.duration} min</div>
                            <div><i class="fas fa-language"></i> <strong>Sous-titres :</strong> ${document.subtitles}</div>
                        </div>
                    </c:when>
                </c:choose>
            </div>

            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/admin/documents/${document.id}/edit" class="btn-edit"><i class="fas fa-edit"></i> Modifier</a>
                <a href="${pageContext.request.contextPath}/admin/documents/${document.id}/delete" class="btn-delete" onclick="return confirm('Supprimer définitivement ?')"><i class="fas fa-trash-alt"></i> Supprimer</a>
            </div>
        </div>
    </main>
</div>
</body>
</html>