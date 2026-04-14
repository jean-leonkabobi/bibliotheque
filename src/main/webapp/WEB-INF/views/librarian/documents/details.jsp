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
        <a href="${pageContext.request.contextPath}/librarian/documents" class="btn-link"><i class="fas fa-arrow-left"></i> Retour à la liste</a>
        <h1><i class="fas fa-info-circle"></i> ${document.title}</h1>
      </div>

      <!-- Informations générales -->
      <div class="info-section">
        <h2><i class="fas fa-info-circle"></i> Informations générales</h2>
        <div class="info-grid">
          <div class="info-card-item">
            <div class="info-card-icon"><i class="fas fa-hashtag"></i></div>
            <div class="info-card-content">
              <span class="info-label">ID</span>
              <span class="info-value">${document.id}</span>
            </div>
          </div>
          <div class="info-card-item">
            <div class="info-card-icon"><i class="fas fa-tag"></i></div>
            <div class="info-card-content">
              <span class="info-label">Type</span>
              <span class="info-value">
                                <c:choose>
                                  <c:when test="${document['class'].simpleName eq 'Book'}"><i class="fas fa-book"></i> Livre</c:when>
                                  <c:when test="${document['class'].simpleName eq 'CD'}"><i class="fas fa-compact-disc"></i> CD</c:when>
                                  <c:when test="${document['class'].simpleName eq 'DVD'}"><i class="fas fa-film"></i> DVD</c:when>
                                </c:choose>
                            </span>
            </div>
          </div>
          <div class="info-card-item">
            <div class="info-card-icon"><i class="fas fa-heading"></i></div>
            <div class="info-card-content">
              <span class="info-label">Titre</span>
              <span class="info-value">${document.title}</span>
            </div>
          </div>
          <div class="info-card-item">
            <div class="info-card-icon"><i class="fas fa-copy"></i></div>
            <div class="info-card-content">
              <span class="info-label">Exemplaires</span>
              <span class="info-value">${document.totalCopies} exemplaire(s)</span>
            </div>
          </div>
          <div class="info-card-item">
            <div class="info-card-icon"><i class="fas fa-check-circle"></i></div>
            <div class="info-card-content">
              <span class="info-label">Disponibilité</span>
              <span class="info-value">
                                <c:choose>
                                  <c:when test="${document.availableCopies > 0}">
                                    <span class="availability-badge available"><i class="fas fa-check-circle"></i> ${document.availableCopies} disponible(s)</span>
                                  </c:when>
                                  <c:otherwise>
                                    <span class="availability-badge unavailable"><i class="fas fa-times-circle"></i> Indisponible</span>
                                  </c:otherwise>
                                </c:choose>
                            </span>
            </div>
          </div>
        </div>
      </div>

      <!-- Détails spécifiques -->
      <div class="info-section">
        <c:choose>
          <c:when test="${document['class'].simpleName eq 'Book'}">
            <h2><i class="fas fa-book"></i> Détails du livre</h2>
            <div class="info-grid">
              <div class="info-card-item">
                <div class="info-card-icon"><i class="fas fa-user-pen"></i></div>
                <div class="info-card-content">
                  <span class="info-label">Auteur</span>
                  <span class="info-value">${document.author}</span>
                </div>
              </div>
              <div class="info-card-item">
                <div class="info-card-icon"><i class="fas fa-barcode"></i></div>
                <div class="info-card-content">
                  <span class="info-label">ISBN</span>
                  <span class="info-value">${document.isbn}</span>
                </div>
              </div>
              <div class="info-card-item">
                <div class="info-card-icon"><i class="fas fa-building"></i></div>
                <div class="info-card-content">
                  <span class="info-label">Éditeur</span>
                  <span class="info-value">${document.publisher}</span>
                </div>
              </div>
              <div class="info-card-item">
                <div class="info-card-icon"><i class="fas fa-calendar"></i></div>
                <div class="info-card-content">
                  <span class="info-label">Année</span>
                  <span class="info-value">${document.publicationYear}</span>
                </div>
              </div>
              <div class="info-card-item">
                <div class="info-card-icon"><i class="fas fa-file-alt"></i></div>
                <div class="info-card-content">
                  <span class="info-label">Pages</span>
                  <span class="info-value">${document.numberOfPages} pages</span>
                </div>
              </div>
            </div>
          </c:when>

          <c:when test="${document['class'].simpleName eq 'CD'}">
            <h2><i class="fas fa-compact-disc"></i> Détails du CD</h2>
            <div class="info-grid">
              <div class="info-card-item">
                <div class="info-card-icon"><i class="fas fa-microphone-alt"></i></div>
                <div class="info-card-content">
                  <span class="info-label">Artiste</span>
                  <span class="info-value">${document.artist}</span>
                </div>
              </div>
              <div class="info-card-item">
                <div class="info-card-icon"><i class="fas fa-hourglass-half"></i></div>
                <div class="info-card-content">
                  <span class="info-label">Durée</span>
                  <span class="info-value">${document.duration} min</span>
                </div>
              </div>
              <div class="info-card-item">
                <div class="info-card-icon"><i class="fas fa-building"></i></div>
                <div class="info-card-content">
                  <span class="info-label">Maison de disque</span>
                  <span class="info-value">${document.recordCompany}</span>
                </div>
              </div>
            </div>
          </c:when>

          <c:when test="${document['class'].simpleName eq 'DVD'}">
            <h2><i class="fas fa-film"></i> Détails du DVD</h2>
            <div class="info-grid">
              <div class="info-card-item">
                <div class="info-card-icon"><i class="fas fa-clapperboard"></i></div>
                <div class="info-card-content">
                  <span class="info-label">Réalisateur</span>
                  <span class="info-value">${document.director}</span>
                </div>
              </div>
              <div class="info-card-item">
                <div class="info-card-icon"><i class="fas fa-hourglass-half"></i></div>
                <div class="info-card-content">
                  <span class="info-label">Durée</span>
                  <span class="info-value">${document.duration} min</span>
                </div>
              </div>
              <div class="info-card-item">
                <div class="info-card-icon"><i class="fas fa-language"></i></div>
                <div class="info-card-content">
                  <span class="info-label">Sous-titres</span>
                  <span class="info-value">${document.subtitles}</span>
                </div>
              </div>
            </div>
          </c:when>
        </c:choose>
      </div>

      <!-- Actions -->
      <div class="action-buttons">
        <a href="${pageContext.request.contextPath}/librarian/documents/${document.id}/edit" class="btn-edit">
          <i class="fas fa-edit"></i> Modifier
        </a>
      </div>
    </div>
  </main>
</div>
</body>
</html>