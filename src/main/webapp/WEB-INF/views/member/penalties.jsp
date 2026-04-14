<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes pénalités - Bibliothèque</title>
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
        .stat-card-simple.red .stat-icon { color: #EF4444; }

        .penalties-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        .penalty-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            transition: all 0.3s ease;
            border: 1px solid #E2E8F0;
            flex-wrap: wrap;
            gap: 15px;
        }
        .penalty-card:hover {
            transform: translateX(5px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .penalty-info {
            flex: 2;
        }
        .penalty-reason {
            font-weight: 600;
            color: #0F172A;
            margin-bottom: 8px;
            font-size: 15px;
        }
        .penalty-reason i {
            margin-right: 8px;
            color: #EF4444;
        }
        .penalty-details {
            display: flex;
            gap: 20px;
            font-size: 13px;
            color: #64748B;
            flex-wrap: wrap;
        }
        .penalty-details span {
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .penalty-amount {
            font-size: 20px;
            font-weight: 700;
            color: #EF4444;
        }
        .penalty-status {
            min-width: 100px;
            text-align: center;
        }
        .badge {
            display: inline-block;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        .badge-paid { background: #ECFDF5; color: #10B981; }
        .badge-unpaid { background: #FEF2F2; color: #EF4444; }
        .badge-cancelled { background: #F1F5F9; color: #64748B; }
        .btn-pay {
            background: #10B981;
            color: white;
            border: none;
            padding: 8px 20px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 500;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-pay:hover {
            background: #059669;
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
        .info-section {
            background: white;
            border-radius: 16px;
            padding: 25px;
            margin-bottom: 25px;
            border: 1px solid #E2E8F0;
        }
        .alert {
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .alert-success {
            background: #ECFDF5;
            border-left: 4px solid #10B981;
            color: #059669;
        }
        .alert-error {
            background: #FEF2F2;
            border-left: 4px solid #EF4444;
            color: #DC2626;
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
            <a href="${pageContext.request.contextPath}/member/penalties" class="nav-item active"><i class="fas fa-euro-sign"></i><span>Pénalités</span></a>
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
                <h1><i class="fas fa-euro-sign"></i> Mes pénalités</h1>
            </div>

            <c:if test="${not empty sessionScope.success}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> ${sessionScope.success}
                    <% session.removeAttribute("success"); %>
                </div>
            </c:if>
            <c:if test="${not empty sessionScope.error}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i> ${sessionScope.error}
                    <% session.removeAttribute("error"); %>
                </div>
            </c:if>

            <!-- Statistique -->
            <div class="stats-container">
                <div class="stat-card-simple red">
                    <div class="stat-icon"><i class="fas fa-euro-sign"></i></div>
                    <div class="stat-value">${totalUnpaid} €</div>
                    <div class="stat-label">Total à payer</div>
                    <div class="stat-sub">pénalités impayées</div>
                </div>
            </div>

            <!-- Liste des pénalités -->
            <div class="info-section">
                <c:choose>
                    <c:when test="${empty penalties}">
                        <div class="empty-state">
                            <div class="empty-icon"><i class="fas fa-check-circle"></i></div>
                            <h3>Aucune pénalité</h3>
                            <p>Vous êtes à jour dans vos retours.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="penalties-list">
                            <c:forEach items="${penalties}" var="penalty">
                                <div class="penalty-card">
                                    <div class="penalty-info">
                                        <div class="penalty-reason">
                                            <i class="fas fa-exclamation-triangle"></i> ${penalty.reason}
                                        </div>
                                        <div class="penalty-details">
                                            <span><i class="fas fa-calendar-alt"></i> Date : <fmt:formatDate value="${penalty.createdAtAsDate}" pattern="dd/MM/yyyy"/></span>
                                            <span><i class="fas fa-euro-sign"></i> Montant : <strong>${penalty.amount} €</strong></span>
                                        </div>
                                    </div>
                                    <div class="penalty-status">
                                        <span class="badge badge-${penalty.status.name().toLowerCase()}">
                                            <c:choose>
                                                <c:when test="${penalty.status eq 'PAID'}"><i class="fas fa-check-circle"></i> Payé</c:when>
                                                <c:when test="${penalty.status eq 'UNPAID'}"><i class="fas fa-clock"></i> Impayé</c:when>
                                                <c:when test="${penalty.status eq 'CANCELLED'}"><i class="fas fa-ban"></i> Annulé</c:when>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <div class="penalty-action">
                                        <c:if test="${penalty.unpaid}">
                                            <form action="${pageContext.request.contextPath}/member/penalties" method="post">
                                                <input type="hidden" name="penaltyId" value="${penalty.id}">
                                                <button type="submit" class="btn-pay" onclick="return confirm('Payer ${penalty.amount} € ?')">
                                                    <i class="fas fa-credit-card"></i> Payer
                                                </button>
                                            </form>
                                        </c:if>
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