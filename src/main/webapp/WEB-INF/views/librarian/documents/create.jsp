<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Ajouter un ouvrage - Bibliothèque</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    .type-selector {
      display: flex;
      gap: 15px;
      margin-bottom: 25px;
      flex-wrap: wrap;
    }
    .type-btn {
      flex: 1;
      text-align: center;
      padding: 20px;
      background: #F8FAFC;
      border-radius: 12px;
      text-decoration: none;
      color: #0F172A;
      transition: all 0.3s ease;
      border: 2px solid transparent;
      min-width: 150px;
    }
    .type-btn:hover {
      background: #E2E8F0;
      transform: translateY(-3px);
    }
    .type-btn.active {
      background: #0F172A;
      color: white;
      border-color: #38BDF8;
    }
    .type-icon {
      font-size: 32px;
      display: block;
      margin-bottom: 10px;
    }
    .type-btn.active .type-icon {
      color: #38BDF8;
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
        <div>
          <a href="${pageContext.request.contextPath}/librarian/documents" class="btn-link"><i class="fas fa-arrow-left"></i> Retour à la liste</a>
          <h1><i class="fas fa-plus-circle"></i> Ajouter un nouvel ouvrage</h1>
          <p class="info-text">Choisissez le type d'ouvrage et remplissez les informations</p>
        </div>
      </div>

      <!-- Sélecteur de type -->
      <div class="type-selector">
        <a href="${pageContext.request.contextPath}/librarian/documents/create?type=BOOK"
           class="type-btn ${type eq 'BOOK' ? 'active' : ''}">
          <i class="fas fa-book type-icon"></i>
          <strong>Livre</strong>
          <small>Romans, essais, BD...</small>
        </a>
        <a href="${pageContext.request.contextPath}/librarian/documents/create?type=CD"
           class="type-btn ${type eq 'CD' ? 'active' : ''}">
          <i class="fas fa-compact-disc type-icon"></i>
          <strong>CD</strong>
          <small>Musique, audio...</small>
        </a>
        <a href="${pageContext.request.contextPath}/librarian/documents/create?type=DVD"
           class="type-btn ${type eq 'DVD' ? 'active' : ''}">
          <i class="fas fa-film type-icon"></i>
          <strong>DVD</strong>
          <small>Films, documentaires...</small>
        </a>
      </div>

      <c:if test="${not empty error}">
        <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${error}</div>
      </c:if>

      <form action="${pageContext.request.contextPath}/librarian/documents/create" method="post">
        <input type="hidden" name="type" value="${type}">

        <!-- Informations générales -->
        <div class="form-section">
          <h3><i class="fas fa-info-circle"></i> Informations générales</h3>
          <div class="form-row">
            <div class="form-group">
              <label class="required-field"><i class="fas fa-heading"></i> Titre</label>
              <input type="text" name="title" placeholder="Titre de l'ouvrage" required>
            </div>
            <div class="form-group">
              <label class="required-field"><i class="fas fa-copy"></i> Nombre d'exemplaires</label>
              <input type="number" name="totalCopies" value="1" min="1" required>
              <small><i class="fas fa-info-circle"></i> Quantité disponible en stock</small>
            </div>
          </div>
        </div>

        <c:choose>
          <c:when test="${type eq 'BOOK'}">
            <div class="form-section">
              <h3><i class="fas fa-book"></i> Informations du livre</h3>
              <div class="form-row">
                <div class="form-group">
                  <label class="required-field"><i class="fas fa-user-pen"></i> Auteur</label>
                  <input type="text" name="author" placeholder="Nom de l'auteur" required>
                </div>
                <div class="form-group">
                  <label><i class="fas fa-barcode"></i> ISBN</label>
                  <input type="text" name="isbn" placeholder="978-2-1234-5678-9">
                  <small>Code ISBN à 13 chiffres</small>
                </div>
              </div>
              <div class="form-row">
                <div class="form-group">
                  <label><i class="fas fa-building"></i> Éditeur</label>
                  <input type="text" name="publisher" placeholder="Maison d'édition">
                </div>
                <div class="form-group">
                  <label><i class="fas fa-calendar"></i> Année de publication</label>
                  <input type="number" name="publicationYear" placeholder="2024">
                </div>
              </div>
              <div class="form-group">
                <label><i class="fas fa-file-alt"></i> Nombre de pages</label>
                <input type="number" name="numberOfPages" placeholder="Nombre de pages">
              </div>
            </div>
          </c:when>

          <c:when test="${type eq 'CD'}">
            <div class="form-section">
              <h3><i class="fas fa-compact-disc"></i> Informations du CD</h3>
              <div class="form-row">
                <div class="form-group">
                  <label class="required-field"><i class="fas fa-microphone-alt"></i> Artiste</label>
                  <input type="text" name="artist" placeholder="Nom de l'artiste/groupe" required>
                </div>
                <div class="form-group">
                  <label><i class="fas fa-hourglass-half"></i> Durée (minutes)</label>
                  <input type="number" name="duration" placeholder="Durée totale">
                </div>
              </div>
              <div class="form-group">
                <label><i class="fas fa-building"></i> Maison de disque</label>
                <input type="text" name="recordCompany" placeholder="Label / Maison de disque">
              </div>
            </div>
          </c:when>

          <c:when test="${type eq 'DVD'}">
            <div class="form-section">
              <h3><i class="fas fa-film"></i> Informations du DVD</h3>
              <div class="form-row">
                <div class="form-group">
                  <label class="required-field"><i class="fas fa-clapperboard"></i> Réalisateur</label>
                  <input type="text" name="director" placeholder="Nom du réalisateur" required>
                </div>
                <div class="form-group">
                  <label><i class="fas fa-hourglass-half"></i> Durée (minutes)</label>
                  <input type="number" name="duration" placeholder="Durée du film">
                </div>
              </div>
              <div class="form-group">
                <label><i class="fas fa-language"></i> Sous-titres</label>
                <input type="text" name="subtitles" placeholder="Langues des sous-titres">
                <small>Ex: Français, Anglais, etc.</small>
              </div>
            </div>
          </c:when>
        </c:choose>

        <div class="info-card">
          <i class="fas fa-info-circle"></i>
          <span>Un bibliothécaire peut ajouter des ouvrages qui seront immédiatement disponibles dans le catalogue.</span>
        </div>

        <div class="form-actions">
          <button type="submit" class="btn-primary"><i class="fas fa-save"></i> Créer l'ouvrage</button>
          <a href="${pageContext.request.contextPath}/librarian/documents" class="btn-secondary"><i class="fas fa-times"></i> Annuler</a>
        </div>
      </form>
    </div>
  </main>
</div>
</body>
</html>