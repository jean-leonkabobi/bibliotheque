<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mon espace - Bibliothèque</title>
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
            font-size: 28px;
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
        .stat-card-simple.orange .stat-icon { color: #F59E0B; }
        .stat-card-simple.red .stat-icon { color: #EF4444; }
        .stat-card-simple.green .stat-icon { color: #10B981; }

        /* Loan Cards */
        .loan-card {
            display: flex;
            align-items: center;
            gap: 20px;
            padding: 20px;
            background: #F8FAFC;
            border-radius: 12px;
            margin-bottom: 15px;
            transition: all 0.3s ease;
            border: 1px solid #E2E8F0;
        }
        .loan-card:hover {
            background: #F1F5F9;
            transform: translateX(5px);
        }
        .loan-card.overdue {
            background: #FEF2F2;
        }
        .loan-icon {
            width: 55px;
            height: 55px;
            background: white;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .loan-icon i {
            font-size: 28px;
            color: #38BDF8;
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
            margin-right: 6px;
            color: #64748B;
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

        /* History Cards */
        .history-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        .history-card {
            background: #F8FAFC;
            border-radius: 12px;
            padding: 15px 20px;
            display: flex;
            align-items: center;
            gap: 15px;
            transition: all 0.3s ease;
            border: 1px solid #E2E8F0;
        }
        .history-card:hover {
            background: #F1F5F9;
            transform: translateX(5px);
        }
        .history-icon {
            width: 45px;
            height: 45px;
            background: white;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .history-icon i {
            font-size: 22px;
            color: #38BDF8;
        }
        .history-content {
            flex: 1;
        }
        .history-title {
            font-weight: 600;
            color: #0F172A;
            margin-bottom: 6px;
            font-size: 15px;
        }
        .history-title i {
            margin-right: 6px;
            color: #38BDF8;
        }
        .history-meta {
            display: flex;
            gap: 20px;
            font-size: 12px;
            color: #64748B;
            flex-wrap: wrap;
        }
        .history-meta span {
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        .history-badge {
            min-width: 90px;
            text-align: right;
        }
        .badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
        }
        .badge-active { background: #ECFDF5; color: #10B981; }
        .badge-returned { background: #F1F5F9; color: #64748B; }
        .badge-overdue { background: #FEF2F2; color: #EF4444; }

        .info-section {
            background: white;
            border-radius: 16px;
            padding: 25px;
            margin-bottom: 25px;
            border: 1px solid #E2E8F0;
        }
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #F1F5F9;
        }
        .section-header h2 {
            font-size: 18px;
            color: #0F172A;
            display: flex;
            align-items: center;
            gap: 8px;
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
        .empty-state {
            text-align: center;
            padding: 40px;
            color: #64748B;
        }
        .empty-icon {
            font-size: 48px;
            margin-bottom: 15px;
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
            <a href="${pageContext.request.contextPath}/member/dashboard" class="nav-item active"><i class="fas fa-tachometer-alt"></i><span>Tableau de bord</span></a>
            <a href="${pageContext.request.contextPath}/member/loans" class="nav-item"><i class="fas fa-book"></i><span>Mes emprunts</span></a>
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
            <h1><i class="fas fa-smile-wink"></i> Bonjour, ${sessionScope.user.firstName} !</h1>
            <p class="welcome-text">Bienvenue dans votre espace adhérent.</p>

            <!-- Statistiques -->
            <div class="stats-container">
                <div class="stat-card-simple blue">
                    <div class="stat-icon"><i class="fas fa-book-open"></i></div>
                    <div class="stat-value">${currentLoans}</div>
                    <div class="stat-label">Emprunts en cours</div>
                    <div class="stat-sub">sur ${maxLoans} maximum</div>
                </div>

                <div class="stat-card-simple orange">
                    <div class="stat-icon"><i class="fas fa-clock"></i></div>
                    <div class="stat-value">${overdueLoans}</div>
                    <div class="stat-label">Retards</div>
                    <div class="stat-sub">emprunt(s) en retard</div>
                </div>

                <div class="stat-card-simple red">
                    <div class="stat-icon"><i class="fas fa-euro-sign"></i></div>
                    <div class="stat-value">${totalPenalties} €</div>
                    <div class="stat-label">Pénalités</div>
                    <div class="stat-sub">à payer</div>
                </div>

                <div class="stat-card-simple green">
                    <div class="stat-icon"><i class="fas fa-chart-line"></i></div>
                    <div class="stat-value">${totalLoansHistory}</div>
                    <div class="stat-label">Total emprunts</div>
                    <div class="stat-sub">depuis l'inscription</div>
                </div>
            </div>

            <!-- Emprunts en cours -->
            <div class="info-section">
                <div class="section-header">
                    <h2><i class="fas fa-book-open"></i> Mes emprunts en cours</h2>
                    <a href="${pageContext.request.contextPath}/member/loans" class="btn-link">Voir tout <i class="fas fa-arrow-right"></i></a>
                </div>
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
                                <div class="loan-icon">
                                    <c:choose>
                                        <c:when test="${loan.documentType eq 'BOOK'}"><i class="fas fa-book"></i></c:when>
                                        <c:when test="${loan.documentType eq 'CD'}"><i class="fas fa-compact-disc"></i></c:when>
                                        <c:when test="${loan.documentType eq 'DVD'}"><i class="fas fa-film"></i></c:when>
                                    </c:choose>
                                </div>
                                <div class="loan-info">
                                    <div class="loan-title">
                                        <i class="fas ${loan.documentType eq 'BOOK' ? 'fa-book' : (loan.documentType eq 'CD' ? 'fa-compact-disc' : 'fa-film')}"></i>
                                        Document ${loan.documentId} - ${loan.documentType}
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
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Derniers emprunts -->
            <div class="info-section">
                <div class="section-header">
                    <h2><i class="fas fa-history"></i> Derniers emprunts</h2>
                    <a href="${pageContext.request.contextPath}/member/history" class="btn-link">Voir tout l'historique <i class="fas fa-arrow-right"></i></a>
                </div>
                <c:choose>
                    <c:when test="${empty loanHistory}">
                        <div class="empty-state">
                            <div class="empty-icon"><i class="fas fa-history"></i></div>
                            <h3>Aucun historique</h3>
                            <p>Votre historique d'emprunts apparaîtra ici.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="history-list">
                            <c:forEach items="${loanHistory}" var="loan" begin="0" end="4">
                                <div class="history-card">
                                    <div class="history-icon">
                                        <c:choose>
                                            <c:when test="${loan.documentType eq 'BOOK'}"><i class="fas fa-book"></i></c:when>
                                            <c:when test="${loan.documentType eq 'CD'}"><i class="fas fa-compact-disc"></i></c:when>
                                            <c:when test="${loan.documentType eq 'DVD'}"><i class="fas fa-film"></i></c:when>
                                        </c:choose>
                                    </div>
                                    <div class="history-content">
                                        <div class="history-title">
                                            <i class="fas ${loan.documentType eq 'BOOK' ? 'fa-book' : (loan.documentType eq 'CD' ? 'fa-compact-disc' : 'fa-film')}"></i>
                                            Document ${loan.documentId} - ${loan.documentType}
                                        </div>
                                        <div class="history-meta">
                                            <span><i class="fas fa-calendar-plus"></i> Emprunt : <fmt:formatDate value="${loan.loanDateAsDate}" pattern="dd/MM/yyyy"/></span>
                                            <c:if test="${not empty loan.returnDate}">
                                                <span><i class="fas fa-calendar-check"></i> Retour : <fmt:formatDate value="${loan.returnDateAsDate}" pattern="dd/MM/yyyy"/></span>
                                            </c:if>
                                            <c:if test="${empty loan.returnDate}">
                                                <span><i class="fas fa-hourglass-half"></i> Statut : En cours</span>
                                            </c:if>
                                        </div>
                                    </div>
                                    <div class="history-badge">
                                        <span class="badge badge-${loan.status.name().toLowerCase()}">
                                            <c:choose>
                                                <c:when test="${loan.status eq 'ACTIVE'}"><i class="fas fa-play-circle"></i> En cours</c:when>
                                                <c:when test="${loan.status eq 'RETURNED'}"><i class="fas fa-check-circle"></i> Rendu</c:when>
                                                <c:when test="${loan.status eq 'OVERDUE'}"><i class="fas fa-exclamation-triangle"></i> Retard</c:when>
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