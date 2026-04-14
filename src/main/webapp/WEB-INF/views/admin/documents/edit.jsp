<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Modifier - ${document.title}</title>
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
                <a href="${pageContext.request.contextPath}/admin/documents/${document.id}" class="btn-link"><i class="fas fa-arrow-left"></i> Retour</a>
                <h1><i class="fas fa-edit"></i> Modifier ${document.title}</h1>
            </div>

            <div class="form-container">
                <form action="${pageContext.request.contextPath}/admin/documents/${document.id}/edit" method="post">
                    <input type="hidden" name="id" value="${document.id}">

                    <div class="form-group">
                        <label class="required-field"><i class="fas fa-heading"></i> Titre</label>
                        <input type="text" name="title" value="${document.title}" required>
                    </div>

                    <div class="form-group">
                        <label class="required-field"><i class="fas fa-copy"></i> Nombre d'exemplaires</label>
                        <input type="number" name="totalCopies" value="${document.totalCopies}" min="1" required>
                        <small>Modifier le nombre total d'exemplaires</small>
                    </div>

                    <c:choose>
                        <c:when test="${document['class'].simpleName eq 'Book'}">
                            <div class="form-row">
                                <div class="form-group">
                                    <label><i class="fas fa-barcode"></i> ISBN</label>
                                    <input type="text" name="isbn" value="${document.isbn}">
                                </div>
                                <div class="form-group">
                                    <label class="required-field"><i class="fas fa-user-pen"></i> Auteur</label>
                                    <input type="text" name="author" value="${document.author}" required>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group">
                                    <label><i class="fas fa-building"></i> Éditeur</label>
                                    <input type="text" name="publisher" value="${document.publisher}">
                                </div>
                                <div class="form-group">
                                    <label><i class="fas fa-calendar"></i> Année publication</label>
                                    <input type="number" name="publicationYear" value="${document.publicationYear}">
                                </div>
                            </div>
                            <div class="form-group">
                                <label><i class="fas fa-file-alt"></i> Nombre de pages</label>
                                <input type="number" name="numberOfPages" value="${document.numberOfPages}">
                            </div>
                        </c:when>

                        <c:when test="${document['class'].simpleName eq 'CD'}">
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="required-field"><i class="fas fa-microphone-alt"></i> Artiste</label>
                                    <input type="text" name="artist" value="${document.artist}" required>
                                </div>
                                <div class="form-group">
                                    <label><i class="fas fa-hourglass-half"></i> Durée (minutes)</label>
                                    <input type="number" name="duration" value="${document.duration}">
                                </div>
                            </div>
                            <div class="form-group">
                                <label><i class="fas fa-building"></i> Maison de disque</label>
                                <input type="text" name="recordCompany" value="${document.recordCompany}">
                            </div>
                        </c:when>

                        <c:when test="${document['class'].simpleName eq 'DVD'}">
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="required-field"><i class="fas fa-clapperboard"></i> Réalisateur</label>
                                    <input type="text" name="director" value="${document.director}" required>
                                </div>
                                <div class="form-group">
                                    <label><i class="fas fa-hourglass-half"></i> Durée (minutes)</label>
                                    <input type="number" name="duration" value="${document.duration}">
                                </div>
                            </div>
                            <div class="form-group">
                                <label><i class="fas fa-language"></i> Sous-titres</label>
                                <input type="text" name="subtitles" value="${document.subtitles}">
                            </div>
                        </c:when>
                    </c:choose>

                    <div class="form-actions">
                        <button type="submit" class="btn-primary"><i class="fas fa-save"></i> Enregistrer</button>
                        <a href="${pageContext.request.contextPath}/admin/documents/${document.id}" class="btn-secondary"><i class="fas fa-times"></i> Annuler</a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>
</body>
</html>