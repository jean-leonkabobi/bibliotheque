<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mon historique - Bibliothèque</title>
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
            min-width: 200px;
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

        .history-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        .history-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            display: flex;
            align-items: center;
            gap: 20px;
            transition: all 0.3s ease;
            border: 1px solid #E2E8F0;
            flex-wrap: wrap;
        }
        .history-card:hover {
            transform: translateX(5px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .history-icon {
            width: 55px;
            height: 55px;
            background: #F8FAFC;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .history-icon i {
            font-size: 28px;
            color: #38BDF8;
        }
        .history-info {
            flex: 2;
        }
        .history-document {
            font-weight: 600;
            color: #0F172A;
            margin-bottom: 8px;
            font-size: 16px;
        }
        .history-document i {
            margin-right: 8px;
            color: #0F172A;
        }
        .history-dates {
            display: flex;
            gap: 20px;
            font-size: 13px;
            color: #64748B;
            flex-wrap: wrap;
        }
        .history-dates span {
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .history-status {
            min-width: 100px;
            text-align: right;
        }
        .badge {
            display: inline-block;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        .badge-active { background: #ECFDF5; color: #10B981; }
        .badge-returned { background: #F1F5F9; color: #64748B; }
        .badge-overdue { background: #FEF2F2; color: #EF4444; }
        .badge-renewed { background: #EFF6FF; color: #3B82F6; }
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
        .info-section {
            background: white;
            border-radius: 16px;
            padding: 25px;
            margin-bottom: 25px;
            border: 1px solid #E2E8F0;
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
            <a href="${pageContext.request.contextPath}/member/loans" class="nav-item"><i class="fas fa-book"></i><span>Mes emprunts</span></a>
            <a href="${pageContext.request.contextPath}/member/history" class="nav-item active"><i class="fas fa-history"></i><span>Historique</span></a>
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
                <h1><i class="fas fa-history"></i> Historique des emprunts</h1>
                <p class="info-text"><i class="fas fa-chart-line"></i> Total : ${totalLoans} emprunt(s)</p>
            </div>

            <div class="stats-container">
                <div class="stat-card-simple blue">
                    <div class="stat-icon"><i class="fas fa-history"></i></div>
                    <div class="stat-value">${totalLoans}</div>
                    <div class="stat-label">Total emprunts</div>
                    <div class="stat-sub">depuis votre inscription</div>
                </div>
            </div>

            <div class="info-section">
                <c:choose>
                    <c:when test="${empty loanHistory}">
                        <div class="empty-state">
                            <div class="empty-icon"><i class="fas fa-history"></i></div>
                            <h3>Aucun historique</h3>
                            <p>Votre historique d'emprunts apparaîtra ici.</p>
                            <a href="${pageContext.request.contextPath}/member/catalog" class="btn-link">Découvrir le catalogue <i class="fas fa-arrow-right"></i></a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="history-list">
                            <c:forEach items="${loanHistory}" var="loan">
                                <div class="history-card">
                                    <div class="history-icon">
                                        <c:choose>
                                            <c:when test="${loan.documentType eq 'BOOK'}"><i class="fas fa-book"></i></c:when>
                                            <c:when test="${loan.documentType eq 'CD'}"><i class="fas fa-compact-disc"></i></c:when>
                                            <c:when test="${loan.documentType eq 'DVD'}"><i class="fas fa-film"></i></c:when>
                                            <c:otherwise><i class="fas fa-file-alt"></i></c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="history-info">
                                        <div class="history-document">
                                            <i class="fas fa-hashtag" style="color: #0F172A;"></i> Document ${loan.documentId} (${loan.documentType})
                                        </div>
                                        <div class="history-dates">
                                            <span><i class="fas fa-calendar-plus"></i> Emprunté le : <fmt:formatDate value="${loan.loanDateAsDate}" pattern="dd/MM/yyyy"/></span>
                                            <span><i class="fas fa-calendar-check"></i> Retour prévu : <fmt:formatDate value="${loan.dueDateAsDate}" pattern="dd/MM/yyyy"/></span>
                                            <c:if test="${not empty loan.returnDate}">
                                                <span><i class="fas fa-calendar-alt"></i> Retour effectif : <fmt:formatDate value="${loan.returnDateAsDate}" pattern="dd/MM/yyyy"/></span>
                                            </c:if>
                                        </div>
                                    </div>
                                    <div class="history-status">
                                        <span class="badge badge-${loan.status.name().toLowerCase()}">
                                            <c:choose>
                                                <c:when test="${loan.status eq 'ACTIVE'}"><i class="fas fa-play-circle"></i> En cours</c:when>
                                                <c:when test="${loan.status eq 'RETURNED'}"><i class="fas fa-check-circle"></i> Rendu</c:when>
                                                <c:when test="${loan.status eq 'OVERDUE'}"><i class="fas fa-exclamation-triangle"></i> En retard</c:when>
                                                <c:when test="${loan.status eq 'RENEWED'}"><i class="fas fa-hourglass-half"></i> Prolongé</c:when>
                                                <c:otherwise>${loan.status}</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>
</div>
</body>
</html>