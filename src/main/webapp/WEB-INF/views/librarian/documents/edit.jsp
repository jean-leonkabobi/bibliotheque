<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier - ${document.title}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .form-container {
            max-width: 800px;
            margin: 0 auto;
        }
        .form-section {
            background: white;
            border-radius: 16px;
            padding: 25px;
            margin-bottom: 25px;
            border: 1px solid #E2E8F0;
        }
        .form-section h3 {
            font-size: 18px;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #F1F5F9;
            display: flex;
            align-items: center;
            gap: 8px;
            color: #0F172A;
        }
        .form-section h3 i {
            color: #38BDF8;
        }
        .required-field::after {
            content: "*";
            color: #EF4444;
            margin-left: 4px;
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
        .info-card span {
            color: #0F172A;
            font-size: 14px;
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
            <a href="${pageContext.request.contextPath}/librarian/dashboard" class="nav-item"><i class="fas fa-chart-line"></i><span>Tableau de bord</span></a>
            <a href="${pageContext.request.contextPath}/librarian/members" class="nav-item"><i class="fas fa-users"></i><span>Membres</span></a>
            <a href="${pageContext.request.contextPath}/librarian/documents" class="nav-item active"><i class="fas fa-book"></i><span>Ouvrages</span></a>
            <a href="${pageContext.request.contextPath}/librarian/validate" class="nav-item"><i class="fas fa-check-circle"></i><span>Validations</span></a>
            <a href="${pageContext.request.contextPath}/librarian/penalties" class="nav-item"><i class="fas fa-euro-sign"></i><span>Pénalités</span></a>
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
                <a href="${pageContext.request.contextPath}/librarian/documents/${document.id}" class="btn-link"><i class="fas fa-arrow-left"></i> Retour</a>
                <h1><i class="fas fa-edit"></i> Modifier ${document.title}</h1>
            </div>

            <div class="form-container">
                <form action="${pageContext.request.contextPath}/librarian/documents/${document.id}/edit" method="post">
                    <input type="hidden" name="id" value="${document.id}">

                    <div class="form-section">
                        <h3><i class="fas fa-info-circle"></i> Informations générales</h3>
                        <div class="form-row">
                            <div class="form-group">
                                <label class="required-field"><i class="fas fa-heading"></i> Titre</label>
                                <input type="text" name="title" value="${document.title}" required>
                            </div>
                            <div class="form-group">
                                <label class="required-field"><i class="fas fa-copy"></i> Nombre d'exemplaires</label>
                                <input type="number" name="totalCopies" value="${document.totalCopies}" min="1" required>
                                <small><i class="fas fa-info-circle"></i> Modifier le nombre total d'exemplaires</small>
                            </div>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${document['class'].simpleName eq 'Book'}">
                            <div class="form-section">
                                <h3><i class="fas fa-book"></i> Informations du livre</h3>
                                <div class="form-row">
                                    <div class="form-group">
                                        <label><i class="fas fa-barcode"></i> ISBN</label>
                                        <input type="text" name="isbn" value="${document.isbn}" placeholder="978-2-1234-5678-9">
                                    </div>
                                    <div class="form-group">
                                        <label class="required-field"><i class="fas fa-user-pen"></i> Auteur</label>
                                        <input type="text" name="author" value="${document.author}" required>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="form-group">
                                        <label><i class="fas fa-building"></i> Éditeur</label>
                                        <input type="text" name="publisher" value="${document.publisher}" placeholder="Maison d'édition">
                                    </div>
                                    <div class="form-group">
                                        <label><i class="fas fa-calendar"></i> Année publication</label>
                                        <input type="number" name="publicationYear" value="${document.publicationYear}" placeholder="2024">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label><i class="fas fa-file-alt"></i> Nombre de pages</label>
                                    <input type="number" name="numberOfPages" value="${document.numberOfPages}" placeholder="Nombre de pages">
                                </div>
                            </div>
                        </c:when>

                        <c:when test="${document['class'].simpleName eq 'CD'}">
                            <div class="form-section">
                                <h3><i class="fas fa-compact-disc"></i> Informations du CD</h3>
                                <div class="form-row">
                                    <div class="form-group">
                                        <label class="required-field"><i class="fas fa-microphone-alt"></i> Artiste</label>
                                        <input type="text" name="artist" value="${document.artist}" required>
                                    </div>
                                    <div class="form-group">
                                        <label><i class="fas fa-hourglass-half"></i> Durée (minutes)</label>
                                        <input type="number" name="duration" value="${document.duration}" placeholder="Durée totale">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label><i class="fas fa-building"></i> Maison de disque</label>
                                    <input type="text" name="recordCompany" value="${document.recordCompany}" placeholder="Label / Maison de disque">
                                </div>
                            </div>
                        </c:when>

                        <c:when test="${document['class'].simpleName eq 'DVD'}">
                            <div class="form-section">
                                <h3><i class="fas fa-film"></i> Informations du DVD</h3>
                                <div class="form-row">
                                    <div class="form-group">
                                        <label class="required-field"><i class="fas fa-clapperboard"></i> Réalisateur</label>
                                        <input type="text" name="director" value="${document.director}" required>
                                    </div>
                                    <div class="form-group">
                                        <label><i class="fas fa-hourglass-half"></i> Durée (minutes)</label>
                                        <input type="number" name="duration" value="${document.duration}" placeholder="Durée du film">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label><i class="fas fa-language"></i> Sous-titres</label>
                                    <input type="text" name="subtitles" value="${document.subtitles}" placeholder="Langues des sous-titres">
                                    <small>Ex: Français, Anglais, etc.</small>
                                </div>
                            </div>
                        </c:when>
                    </c:choose>

                    <div class="info-card">
                        <i class="fas fa-info-circle"></i>
                        <span>La modification du nombre d'exemplaires affecte automatiquement la disponibilité.</span>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn-primary"><i class="fas fa-save"></i> Enregistrer</button>
                        <a href="${pageContext.request.contextPath}/librarian/documents/${document.id}" class="btn-secondary"><i class="fas fa-times"></i> Annuler</a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>
</body>
</html>