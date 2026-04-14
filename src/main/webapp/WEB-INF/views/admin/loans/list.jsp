<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des emprunts - Administration</title>
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
            <a href="${pageContext.request.contextPath}/admin/documents" class="nav-item"><i class="fas fa-book"></i><span>Ouvrages</span></a>
            <a href="${pageContext.request.contextPath}/admin/loans" class="nav-item active"><i class="fas fa-exchange-alt"></i><span>Emprunts</span></a>
            <a href="${pageContext.request.contextPath}/admin/penalties" class="nav-item"><i class="fas fa-euro-sign"></i><span>Pénalités</span></a>
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
                <h1><i class="fas fa-exchange-alt"></i> Gestion des emprunts</h1>
                <a href="${pageContext.request.contextPath}/admin/loans/create" class="btn-primary"><i class="fas fa-plus"></i> Nouvel emprunt</a>
            </div>

            <!-- Statistiques centrées -->
            <div class="stats-row">
                <div class="stat-item">
                    <i class="fas fa-chart-bar"></i>
                    <div class="stat-info">
                        <span class="stat-label">Total emprunts</span>
                        <span class="stat-number">${loans.size()}</span>
                    </div>
                </div>
                <div class="stat-item">
                    <i class="fas fa-play-circle"></i>
                    <div class="stat-info">
                        <span class="stat-label">En cours</span>
                        <span class="stat-number">${activeCount}</span>
                    </div>
                </div>
                <div class="stat-item">
                    <i class="fas fa-exclamation-triangle"></i>
                    <div class="stat-info">
                        <span class="stat-label">En retard</span>
                        <span class="stat-number">${overdueCount}</span>
                    </div>
                </div>
            </div>

            <div class="filter-bar">
                <div class="filter-buttons">
                    <a href="${pageContext.request.contextPath}/admin/loans" class="filter-btn ${empty currentFilter ? 'active' : ''}"><i class="fas fa-list"></i> Tous</a>
                    <a href="${pageContext.request.contextPath}/admin/loans?filter=active" class="filter-btn ${currentFilter eq 'active' ? 'active' : ''}"><i class="fas fa-play"></i> En cours</a>
                    <a href="${pageContext.request.contextPath}/admin/loans?filter=overdue" class="filter-btn ${currentFilter eq 'overdue' ? 'active' : ''}"><i class="fas fa-clock"></i> En retard</a>
                    <a href="${pageContext.request.contextPath}/admin/loans?filter=history" class="filter-btn ${currentFilter eq 'history' ? 'active' : ''}"><i class="fas fa-history"></i> Historique</a>
                </div>
            </div>

            <c:choose>
                <c:when test="${empty loans}">
                    <div class="empty-state">
                        <div class="empty-icon"><i class="fas fa-book-open"></i></div>
                        <h3>Aucun emprunt trouvé</h3>
                        <p>Commencez par enregistrer un nouvel emprunt.</p>
                        <a href="${pageContext.request.contextPath}/admin/loans/create" class="btn-primary"><i class="fas fa-plus"></i> Nouvel emprunt</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${loans}" var="loan">
                        <div class="loan-card ${loan.overdue ? 'overdue' : (loan.status eq 'RETURNED' ? 'returned' : '')}">
                            <div class="loan-header">
                                <div class="loan-member">
                                    <div class="member-avatar">${loan.user.firstName.charAt(0)}${loan.user.lastName.charAt(0)}</div>
                                    <div class="member-info">
                                        <div class="name">${loan.user.firstName} ${loan.user.lastName}</div>
                                        <div class="email">${loan.user.email}</div>
                                    </div>
                                </div>
                                <div class="loan-status-badge">
                                    <c:choose>
                                        <c:when test="${loan.status eq 'ACTIVE' and loan.overdue}">
                                            <span class="status-badge overdue"><i class="fas fa-exclamation-circle"></i> En retard (${loan.daysOverdue}j)</span>
                                        </c:when>
                                        <c:when test="${loan.status eq 'ACTIVE'}">
                                            <span class="status-badge active"><i class="fas fa-check-circle"></i> En cours</span>
                                        </c:when>
                                        <c:when test="${loan.status eq 'RETURNED'}">
                                            <span class="status-badge returned"><i class="fas fa-check-double"></i> Rendu</span>
                                        </c:when>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="loan-document">
                                <i class="fas fa-file-alt"></i> Document #${loan.documentId} (${loan.documentType})
                            </div>
                            <div class="loan-dates">
                                <span><i class="fas fa-calendar-plus"></i> Emprunt : <fmt:formatDate value="${loan.loanDateAsDate}" pattern="dd/MM/yyyy"/></span>
                                <span><i class="fas fa-calendar-check"></i> Retour prévu : <fmt:formatDate value="${loan.dueDateAsDate}" pattern="dd/MM/yyyy"/></span>
                                <c:if test="${not empty loan.returnDate}">
                                    <span><i class="fas fa-calendar-alt"></i> Retour effectif : <fmt:formatDate value="${loan.returnDateAsDate}" pattern="dd/MM/yyyy"/></span>
                                </c:if>
                            </div>
                            <c:if test="${loan.status eq 'ACTIVE'}">
                                <div class="loan-actions">
                                    <form action="${pageContext.request.contextPath}/admin/loans/return" method="post" style="display: inline;">
                                        <input type="hidden" name="loanId" value="${loan.id}">
                                        <button type="submit" class="btn-return" onclick="return confirm('Enregistrer le retour ?')"><i class="fas fa-undo-alt"></i> Enregistrer le retour</button>
                                    </form>
                                    <c:if test="${loan.canRenew}">
                                        <form action="${pageContext.request.contextPath}/admin/loans/renew" method="post" style="display: inline;">
                                            <input type="hidden" name="loanId" value="${loan.id}">
                                            <button type="submit" class="btn-renew" onclick="return confirm('Prolonger de 7 jours ?')"><i class="fas fa-hourglass-half"></i> Prolonger</button>
                                        </form>
                                    </c:if>
                                    <a href="${pageContext.request.contextPath}/admin/loans/edit-date?id=${loan.id}" class="btn-edit-date"><i class="fas fa-calendar-edit"></i> Modifier la date</a>
                                </div>
                            </c:if>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
</div>
</body>
</html>