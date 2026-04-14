<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Détails du membre - ${member.firstName} ${member.lastName}</title>
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
            <a href="${pageContext.request.contextPath}/librarian/members" class="nav-item active"><i class="fas fa-users"></i><span>Membres</span></a>
            <a href="${pageContext.request.contextPath}/librarian/validate" class="nav-item"><i class="fas fa-check-circle"></i><span>Validations</span></a>
            <a href="${pageContext.request.contextPath}/librarian/members/create" class="nav-item"><i class="fas fa-user-plus"></i><span>Nouveau membre</span></a>
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
                    <a href="${pageContext.request.contextPath}/librarian/members" class="btn-link"><i class="fas fa-arrow-left"></i> Retour à la liste</a>
                    <h1><i class="fas fa-user-circle"></i> ${member.firstName} ${member.lastName}</h1>
                </div>
                <div class="action-buttons">
                    <c:if test="${member.status eq 'ACTIVE'}">
                        <a href="${pageContext.request.contextPath}/librarian/members/${member.id}/suspend" class="btn-suspend" onclick="return confirm('Suspendre ce membre ?')"><i class="fas fa-pause-circle"></i> Suspendre</a>
                    </c:if>
                    <c:if test="${member.status eq 'SUSPENDED'}">
                        <a href="${pageContext.request.contextPath}/librarian/members/${member.id}/activate" class="btn-activate" onclick="return confirm('Réactiver ce membre ?')"><i class="fas fa-play-circle"></i> Réactiver</a>
                    </c:if>
                    <c:if test="${member.status eq 'PENDING'}">
                        <a href="${pageContext.request.contextPath}/librarian/members/${member.id}/validate" class="btn-validate" onclick="return confirm('Valider ce compte ?')"><i class="fas fa-check-circle"></i> Valider</a>
                    </c:if>
                </div>
            </div>

            <!-- Informations personnelles - Style carte moderne -->
            <div class="info-section">
                <h2><i class="fas fa-info-circle"></i> Informations personnelles</h2>
                <div class="info-grid">
                    <div class="info-card-item">
                        <div class="info-card-icon"><i class="fas fa-hashtag"></i></div>
                        <div class="info-card-content">
                            <span class="info-label">ID</span>
                            <span class="info-value">${member.id}</span>
                        </div>
                    </div>
                    <div class="info-card-item">
                        <div class="info-card-icon"><i class="fas fa-user"></i></div>
                        <div class="info-card-content">
                            <span class="info-label">Nom complet</span>
                            <span class="info-value">${member.firstName} ${member.lastName}</span>
                        </div>
                    </div>
                    <div class="info-card-item">
                        <div class="info-card-icon"><i class="fas fa-envelope"></i></div>
                        <div class="info-card-content">
                            <span class="info-label">Email</span>
                            <span class="info-value">${member.email}</span>
                        </div>
                    </div>
                    <div class="info-card-item">
                        <div class="info-card-icon"><i class="fas fa-flag"></i></div>
                        <div class="info-card-content">
                            <span class="info-label">Statut</span>
                            <span class="info-value">
                                <span class="badge badge-${member.status.name().toLowerCase()}">
                                    <i class="fas ${member.status.name() == 'ACTIVE' ? 'fa-check-circle' : (member.status.name() == 'PENDING' ? 'fa-clock' : 'fa-ban')}"></i>
                                    ${member.status.name()}
                                </span>
                            </span>
                        </div>
                    </div>
                    <div class="info-card-item">
                        <div class="info-card-icon"><i class="fas fa-calendar-alt"></i></div>
                        <div class="info-card-content">
                            <span class="info-label">Date d'inscription</span>
                            <span class="info-value"><fmt:formatDate value="${member.createdAtAsDate}" pattern="dd/MM/yyyy HH:mm"/></span>
                        </div>
                    </div>
                    <div class="info-card-item">
                        <div class="info-card-icon"><i class="fas fa-book"></i></div>
                        <div class="info-card-content">
                            <span class="info-label">Emprunts en cours</span>
                            <span class="info-value">${activeLoansCount}/3</span>
                        </div>
                    </div>
                    <div class="info-card-item">
                        <div class="info-card-icon"><i class="fas fa-euro-sign"></i></div>
                        <div class="info-card-content">
                            <span class="info-label">Total pénalités</span>
                            <span class="info-value">${totalPenalties} €</span>
                        </div>
                    </div>
                    <div class="info-card-item">
                        <div class="info-card-icon"><i class="fas fa-question-circle"></i></div>
                        <div class="info-card-content">
                            <span class="info-label">Peut emprunter</span>
                            <span class="info-value">${canBorrow ? '<i class="fas fa-check-circle" style="color:#10B981"></i> Oui' : '<i class="fas fa-times-circle" style="color:#EF4444"></i> Non'}</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Emprunts en cours -->
            <div class="info-section">
                <h2><i class="fas fa-book-open"></i> Emprunts en cours (${activeLoansCount}/3)</h2>
                <c:choose>
                    <c:when test="${empty activeLoans}">
                        <div class="empty-state">
                            <i class="fas fa-info-circle"></i>
                            <p>Aucun emprunt en cours</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="loans-list">
                            <c:forEach items="${activeLoans}" var="loan">
                                <div class="loan-item ${loan.overdue ? 'overdue' : ''}">
                                    <div class="loan-item-icon">
                                        <i class="fas fa-file-alt"></i>
                                    </div>
                                    <div class="loan-item-info">
                                        <div class="loan-item-title">Document #${loan.documentId} (${loan.documentType})</div>
                                        <div class="loan-item-dates">
                                            <span><i class="fas fa-calendar-plus"></i> Emprunt : <fmt:formatDate value="${loan.loanDateAsDate}" pattern="dd/MM/yyyy"/></span>
                                            <span><i class="fas fa-calendar-check"></i> Retour : <fmt:formatDate value="${loan.dueDateAsDate}" pattern="dd/MM/yyyy"/></span>
                                        </div>
                                    </div>
                                    <div class="loan-item-status">
                                        <c:choose>
                                            <c:when test="${loan.overdue}">
                                                <span class="status-badge overdue"><i class="fas fa-exclamation-triangle"></i> En retard</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge active"><i class="fas fa-check-circle"></i> En cours</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Historique des emprunts -->
            <div class="info-section">
                <h2><i class="fas fa-history"></i> Historique des emprunts (${totalLoansCount})</h2>
                <c:choose>
                    <c:when test="${empty loanHistory}">
                        <div class="empty-state">
                            <i class="fas fa-info-circle"></i>
                            <p>Aucun historique d'emprunt</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-container">
                            <table class="data-table">
                                <thead>
                                <tr>
                                    <th>Document</th>
                                    <th>Date d'emprunt</th>
                                    <th>Date de retour</th>
                                    <th>Statut</th>
                                </thead>
                                <tbody>
                                <c:forEach items="${loanHistory}" var="loan">
                                    <tr>
                                        <td>Document #${loan.documentId} (${loan.documentType})</td>
                                        <td><fmt:formatDate value="${loan.loanDateAsDate}" pattern="dd/MM/yyyy"/></td>
                                        <td><fmt:formatDate value="${loan.returnDateAsDate}" pattern="dd/MM/yyyy"/></td>
                                        <td><span class="badge badge-${loan.status.name().toLowerCase()}">${loan.status.name()}</span></td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Pénalités -->
            <div class="info-section">
                <h2><i class="fas fa-euro-sign"></i> Pénalités (Total: ${totalPenalties} €)</h2>
                <c:choose>
                    <c:when test="${empty penalties}">
                        <div class="empty-state">
                            <i class="fas fa-check-circle"></i>
                            <p>Aucune pénalité</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-container">
                            <table class="data-table">
                                <thead>
                                <tr>
                                    <th>Raison</th>
                                    <th>Montant</th>
                                    <th>Date</th>
                                    <th>Statut</th>
                                </thead>
                                <tbody>
                                <c:forEach items="${penalties}" var="penalty">
                                    <tr>
                                        <td>${penalty.reason}</td>
                                        <td>${penalty.amount} €</td>
                                        <td><fmt:formatDate value="${penalty.createdAtAsDate}" pattern="dd/MM/yyyy"/></td>
                                        <td><span class="badge badge-${penalty.status.name().toLowerCase()}">${penalty.status.name()}</span></td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>
</div>
</body>
</html>