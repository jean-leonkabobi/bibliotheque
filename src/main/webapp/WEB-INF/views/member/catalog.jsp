<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Catalogue - Bibliothèque</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .stats-cards {
            display: flex;
            gap: 20px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }
        .stat-box {
            background: white;
            border-radius: 16px;
            padding: 20px;
            flex: 1;
            min-width: 150px;
            text-align: center;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            transition: transform 0.3s ease;
            border: 1px solid #E2E8F0;
        }
        .stat-box:hover {
            transform: translateY(-3px);
        }
        .stat-box .stat-icon {
            font-size: 32px;
            margin-bottom: 10px;
        }
        .stat-box .stat-value {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 5px;
            color: #0F172A;
        }
        .stat-box .stat-label {
            color: #64748B;
            font-size: 14px;
        }
        .filter-bar {
            background: white;
            border-radius: 12px;
            padding: 15px 20px;
            margin-bottom: 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
            border: 1px solid #E2E8F0;
        }
        .filter-buttons {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        .filter-btn {
            padding: 8px 20px;
            background: #F8FAFC;
            border-radius: 25px;
            text-decoration: none;
            color: #0F172A;
            font-size: 14px;
            transition: all 0.3s ease;
        }
        .filter-btn:hover {
            background: #E2E8F0;
        }
        .filter-btn.active {
            background: #0F172A;
            color: white;
        }
        .search-form {
            display: flex;
            gap: 10px;
        }
        .search-form input {
            padding: 8px 15px;
            border: 1px solid #E2E8F0;
            border-radius: 25px;
            width: 250px;
        }
        .search-form button {
            background: #38BDF8;
            border: none;
            padding: 8px 15px;
            border-radius: 25px;
            cursor: pointer;
            color: white;
        }
        .document-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
            border: 1px solid #E2E8F0;
        }
        .document-card:hover {
            transform: translateX(5px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .document-card.unavailable {
            opacity: 0.8;
        }
        .document-info {
            flex: 2;
        }
        .document-title {
            font-size: 18px;
            font-weight: 600;
            color: #0F172A;
            margin-bottom: 5px;
        }
        .document-title i {
            margin-right: 8px;
            color: #38BDF8;
        }
        .document-details {
            font-size: 14px;
            color: #64748B;
            margin-bottom: 5px;
        }
        .document-copies {
            font-size: 13px;
            color: #64748B;
        }
        .document-status {
            text-align: right;
            min-width: 150px;
        }
        .availability {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
            margin-bottom: 10px;
        }
        .availability.available {
            background: #ECFDF5;
            color: #10B981;
        }
        .availability.unavailable {
            background: #FEF2F2;
            color: #EF4444;
        }
        .btn-borrow {
            background: #0F172A;
            color: white;
            border: none;
            padding: 8px 20px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-borrow:hover {
            background: #1E293B;
            transform: translateY(-2px);
        }
        .btn-borrow.disabled {
            background: #94A3B8;
            cursor: not-allowed;
        }
        .btn-borrow.disabled:hover {
            transform: none;
        }
        .empty-state {
            text-align: center;
            padding: 60px;
            background: white;
            border-radius: 16px;
            border: 1px solid #E2E8F0;
        }
        .empty-icon {
            font-size: 64px;
            margin-bottom: 20px;
            opacity: 0.5;
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
            <a href="${pageContext.request.contextPath}/member/dashboard" class="nav-item"><i class="fas fa-tachometer-alt"></i><span>Tableau de bord</span></a>
            <a href="${pageContext.request.contextPath}/member/loans" class="nav-item"><i class="fas fa-book"></i><span>Mes emprunts</span></a>
            <a href="${pageContext.request.contextPath}/member/history" class="nav-item"><i class="fas fa-history"></i><span>Historique</span></a>
            <a href="${pageContext.request.contextPath}/member/penalties" class="nav-item"><i class="fas fa-euro-sign"></i><span>Pénalités</span></a>
            <a href="${pageContext.request.contextPath}/member/catalog" class="nav-item active"><i class="fas fa-search"></i><span>Catalogue</span></a>
            <a href="${pageContext.request.contextPath}/member/profile" class="nav-item"><i class="fas fa-user"></i><span>Mon profil</span></a>
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
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Déconnexion</a>
        </header>

        <div class="content">
            <div class="page-header">
                <h1><i class="fas fa-search"></i> Catalogue de la bibliothèque</h1>
                <p class="info-text">Découvrez tous les ouvrages disponibles à l'emprunt</p>
            </div>

            <!-- Statistiques -->
            <div class="stats-cards">
                <div class="stat-box">
                    <div class="stat-icon"><i class="fas fa-chart-simple"></i></div>
                    <div class="stat-value">${totalCount}</div>
                    <div class="stat-label">Total ouvrages</div>
                </div>
                <div class="stat-box">
                    <div class="stat-icon"><i class="fas fa-book"></i></div>
                    <div class="stat-value">${booksCount}</div>
                    <div class="stat-label">Livres</div>
                </div>
                <div class="stat-box">
                    <div class="stat-icon"><i class="fas fa-compact-disc"></i></div>
                    <div class="stat-value">${cdsCount}</div>
                    <div class="stat-label">CDs</div>
                </div>
                <div class="stat-box">
                    <div class="stat-icon"><i class="fas fa-film"></i></div>
                    <div class="stat-value">${dvdsCount}</div>
                    <div class="stat-label">DVDs</div>
                </div>
            </div>

            <!-- Filtres et recherche -->
            <div class="filter-bar">
                <div class="filter-buttons">
                    <a href="${pageContext.request.contextPath}/member/catalog" class="filter-btn ${empty currentType ? 'active' : ''}"><i class="fas fa-list"></i> Tous</a>
                    <a href="${pageContext.request.contextPath}/member/catalog?type=BOOK" class="filter-btn ${currentType eq 'BOOK' ? 'active' : ''}"><i class="fas fa-book"></i> Livres</a>
                    <a href="${pageContext.request.contextPath}/member/catalog?type=CD" class="filter-btn ${currentType eq 'CD' ? 'active' : ''}"><i class="fas fa-compact-disc"></i> CDs</a>
                    <a href="${pageContext.request.contextPath}/member/catalog?type=DVD" class="filter-btn ${currentType eq 'DVD' ? 'active' : ''}"><i class="fas fa-film"></i> DVDs</a>
                </div>
                <form method="get" class="search-form">
                    <input type="text" name="search" placeholder="Rechercher un titre..." value="${searchQuery}">
                    <button type="submit"><i class="fas fa-search"></i></button>
                </form>
            </div>

            <!-- Liste des ouvrages -->
            <c:choose>
                <c:when test="${empty documents}">
                    <div class="empty-state">
                        <div class="empty-icon"><i class="fas fa-book"></i></div>
                        <h3>Aucun ouvrage trouvé</h3>
                        <p>Essayez de modifier votre recherche ou revenez plus tard.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${documents}" var="doc">
                        <div class="document-card ${doc.availableCopies == 0 ? 'unavailable' : ''}">
                            <div class="document-info">
                                <div class="document-title">
                                    <c:choose>
                                        <c:when test="${doc['class'].simpleName eq 'Book'}"><i class="fas fa-book"></i></c:when>
                                        <c:when test="${doc['class'].simpleName eq 'CD'}"><i class="fas fa-compact-disc"></i></c:when>
                                        <c:when test="${doc['class'].simpleName eq 'DVD'}"><i class="fas fa-film"></i></c:when>
                                    </c:choose>
                                        ${doc.title}
                                </div>
                                <div class="document-details">
                                    <c:choose>
                                        <c:when test="${doc['class'].simpleName eq 'Book'}">
                                            <i class="fas fa-user-pen"></i> Auteur : ${doc.author}
                                        </c:when>
                                        <c:when test="${doc['class'].simpleName eq 'CD'}">
                                            <i class="fas fa-microphone-alt"></i> Artiste : ${doc.artist}
                                        </c:when>
                                        <c:when test="${doc['class'].simpleName eq 'DVD'}">
                                            <i class="fas fa-clapperboard"></i> Réalisateur : ${doc.director}
                                        </c:when>
                                    </c:choose>
                                </div>
                                <div class="document-copies">
                                    <i class="fas fa-copy"></i> Exemplaires : ${doc.availableCopies}/${doc.totalCopies} disponible(s)
                                </div>
                            </div>
                            <div class="document-status">
                                <c:choose>
                                    <c:when test="${doc.availableCopies > 0}">
                                        <div class="availability available"><i class="fas fa-check-circle"></i> Disponible</div>
                                        <form action="${pageContext.request.contextPath}/member/borrow" method="post">
                                            <input type="hidden" name="documentId" value="${doc.id}">
                                            <input type="hidden" name="documentType" value="${doc['class'].simpleName}">
                                            <button type="submit" class="btn-borrow" onclick="return confirm('Emprunter cet ouvrage ?')">
                                                <i class="fas fa-hand-peace"></i> Emprunter
                                            </button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="availability unavailable"><i class="fas fa-times-circle"></i> Indisponible</div>
                                        <button class="btn-borrow disabled" disabled><i class="fas fa-ban"></i> Indisponible</button>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
</div>
</body>
</html>