<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes emprunts - Bibliothèque</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .stats-container {
            display: flex;
            gap: 20px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }
        .stat-card-simple {
            background: white;
            border-radius: 16px;
            padding: 20px;
            flex: 1;
            min-width: 180px;
            text-align: center;
            border: 1px solid #E2E8F0;
            transition: all 0.3s ease;
        }
        .stat-card-simple:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1);
        }
        .stat-card-simple .stat-icon {
            font-size: 32px;
            margin-bottom: 10px;
        }
        .stat-card-simple .stat-value {
            font-size: 32px;
            font-weight: 700;
            color: #0F172A;
        }
        .stat-card-simple .stat-label {
            font-size: 14px;
            color: #64748B;
            margin-top: 5px;
        }
        .stat-card-simple .stat-sub {
            font-size: 11px;
            color: #94A3B8;
            margin-top: 5px;
        }
        .stat-card-simple.blue .stat-icon { color: #3B82F6; }
        .stat-card-simple.green .stat-icon { color: #10B981; }

        .loan-card {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 20px;
            background: #F8FAFC;
            border-radius: 12px;
            margin-bottom: 15px;
            transition: all 0.3s ease;
            border: none;
            flex-wrap: wrap;
            gap: 15px;
        }
        .loan-card:hover {
            background: #F1F5F9;
            transform: translateX(5px);
        }
        .loan-card.overdue {
            background: #FEF2F2;
        }
        .loan-info {
            flex: 1;
        }
        .loan-title {
            font-weight: 600;
            color: #0F172A;
            margin-bottom: 8px;
            font-size: 16px;
        }
        .loan-title i {
            margin-right: 8px;
            color: #38BDF8;
        }
        .loan-date, .due-date {
            font-size: 13px;
            color: #64748B;
            margin-bottom: 5px;
        }
        .loan-date i, .due-date i {
            margin-right: 6px;
        }
        .remaining-days {
            color: #10B981;
            font-weight: 500;
            margin-left: 10px;
        }
        .overdue-badge {
            color: #EF4444;
            font-weight: 500;
            margin-left: 10px;
        }
        .btn-renew {
            background: #F59E0B;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 500;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-renew:hover {
            background: #D97706;
            transform: translateY(-2px);
        }
        .empty-state {
            text-align: center;
            padding: 60px;
            color: #64748B;
        }
        .empty-icon {
            font-size: 64px;
            margin-bottom: 20px;
            opacity: 0.5;
        }
        .btn-link {
            background: none;
            border: none;
            color: #38BDF8;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
        }
        .btn-link:hover {
            text-decoration: underline;
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
            <a href="${pageContext.request.contextPath}/member/loans" class="nav-item active"><i class="fas fa-book"></i><span>Mes emprunts</span></a>
            <a href="${pageContext.request.contextPath}/member/history" class="nav-item"><i class="fas fa-history"></i><span>Historique</span></a>
            <a href="${pageContext.request.contextPath}/member/penalties" class="nav-item"><i class="fas fa-euro-sign"></i><span>Pénalités</span></a>
            <a href="${pageContext.request.contextPath}/member/catalog" class="nav-item"><i class="fas fa-search"></i><span>Catalogue</span></a>
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
                <h1><i class="fas fa-book"></i> Mes emprunts</h1>
            </div>

            <!-- Statistiques -->
            <div class="stats-container">
                <div class="stat-card-simple blue">
                    <div class="stat-icon"><i class="fas fa-book-open"></i></div>
                    <div class="stat-value">${activeLoansCount}</div>
                    <div class="stat-label">Emprunts en cours</div>
                    <div class="stat-sub">actuellement</div>
                </div>
                <div class="stat-card-simple green">
                    <div class="stat-icon"><i class="fas fa-chart-line"></i></div>
                    <div class="stat-value">${maxLoans}</div>
                    <div class="stat-label">Limite maximum</div>
                    <div class="stat-sub">emprunts autorisés</div>
                </div>
            </div>

            <!-- Liste des emprunts -->
            <div class="info-section">
                <c:choose>
                    <c:when test="${empty activeLoans}">
                        <div class="empty-state">
                            <div class="empty-icon"><i class="fas fa-book"></i></div>
                            <h3>Aucun emprunt en cours</h3>
                            <p>Vous n'avez pas encore emprunté d'ouvrage.</p>
                            <a href="${pageContext.request.contextPath}/member/catalog" class="btn-link">Rechercher des ouvrages <i class="fas fa-arrow-right"></i></a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${activeLoans}" var="loan">
                            <div class="loan-card ${loan.overdue ? 'overdue' : ''}">
                                <div class="loan-info">
                                    <div class="loan-title">
                                        <i class="fas fa-file-alt"></i>
                                        Document #${loan.documentId}
                                        <c:choose>
                                            <c:when test="${loan.documentType eq 'BOOK'}">(Livre)</c:when>
                                            <c:when test="${loan.documentType eq 'CD'}">(CD)</c:when>
                                            <c:when test="${loan.documentType eq 'DVD'}">(DVD)</c:when>
                                        </c:choose>
                                    </div>
                                    <div class="loan-date">
                                        <i class="fas fa-calendar-plus"></i> Emprunté le <fmt:formatDate value="${loan.loanDateAsDate}" pattern="dd/MM/yyyy"/>
                                    </div>
                                    <div class="due-date">
                                        <i class="fas fa-calendar-check"></i> À rendre le <fmt:formatDate value="${loan.dueDateAsDate}" pattern="dd/MM/yyyy"/>
                                        <c:if test="${loan.overdue}">
                                            <span class="overdue-badge"><i class="fas fa-exclamation-triangle"></i> En retard de ${loan.daysOverdue} jour(s)</span>
                                        </c:if>
                                        <c:if test="${not loan.overdue}">
                                            <span class="remaining-days"><i class="fas fa-hourglass-half"></i> Plus que ${loan.remainingDays} jour(s)</span>
                                        </c:if>
                                    </div>
                                </div>
                                <div class="loan-actions">
                                    <c:if test="${loan.canRenew}">
                                        <form action="${pageContext.request.contextPath}/member/loans/renew" method="post">
                                            <input type="hidden" name="loanId" value="${loan.id}">
                                            <button type="submit" class="btn-renew" onclick="return confirm('Prolonger cet emprunt de 7 jours ?')">
                                                <i class="fas fa-hourglass-half"></i> Prolonger
                                            </button>
                                        </form>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>
</div>
</body>
</html>