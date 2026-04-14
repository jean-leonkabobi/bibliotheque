<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des pénalités - Bibliothèque</title>
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
            <a href="${pageContext.request.contextPath}/librarian/validate" class="nav-item"><i class="fas fa-check-circle"></i><span>Validations</span></a>
            <a href="${pageContext.request.contextPath}/librarian/penalties" class="nav-item active"><i class="fas fa-euro-sign"></i><span>Pénalités</span></a>
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
                <h1><i class="fas fa-euro-sign"></i> Gestion des pénalités</h1>
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

            <!-- Statistiques -->
            <div class="stats-row">
                <div class="stat-item">
                    <i class="fas fa-chart-line"></i>
                    <div class="stat-info">
                        <span class="stat-label">Total pénalités</span>
                        <span class="stat-number">${penalties.size()}</span>
                    </div>
                </div>
                <div class="stat-item">
                    <i class="fas fa-euro-sign"></i>
                    <div class="stat-info">
                        <span class="stat-label">Total impayé</span>
                        <span class="stat-number">${totalUnpaid} €</span>
                    </div>
                </div>
            </div>

            <!-- Filtres -->
            <div class="filter-bar">
                <div class="filter-buttons">
                    <a href="${pageContext.request.contextPath}/librarian/penalties" class="filter-btn ${empty currentFilter ? 'active' : ''}"><i class="fas fa-list"></i> Toutes</a>
                    <a href="${pageContext.request.contextPath}/librarian/penalties?filter=unpaid" class="filter-btn ${currentFilter eq 'unpaid' ? 'active' : ''}"><i class="fas fa-clock"></i> Impayées</a>
                </div>
            </div>

            <!-- Tableau des pénalités -->
            <div class="table-container">
                <table class="data-table">
                    <thead>
                    <tr>
                        <th><i class="fas fa-hashtag"></i> ID</th>
                        <th><i class="fas fa-user"></i> Membre</th>
                        <th><i class="fas fa-info-circle"></i> Raison</th>
                        <th><i class="fas fa-euro-sign"></i> Montant</th>
                        <th><i class="fas fa-calendar"></i> Date</th>
                        <th><i class="fas fa-flag"></i> Statut</th>
                        <th><i class="fas fa-cogs"></i> Actions</th>
                    </thead>
                    <tbody>
                    <c:forEach items="${penalties}" var="penalty">
                    <tr>
                        <td>${penalty.id}</td>
                        <td>${penalty.user.firstName} ${penalty.user.lastName}</td>
                        <td>${penalty.reason}</td>
                        <td><strong>${penalty.amount} €</strong></td>
                        <td><fmt:formatDate value="${penalty.createdAtAsDate}" pattern="dd/MM/yyyy"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${penalty.status eq 'PAID'}">
                                    <span class="badge badge-active"><i class="fas fa-check-circle"></i> Payé</span>
                                </c:when>
                                <c:when test="${penalty.status eq 'CANCELLED'}">
                                    <span class="badge badge-inactive"><i class="fas fa-ban"></i> Annulé</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-danger"><i class="fas fa-exclamation-triangle"></i> Impayé</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="actions">
                            <c:if test="${penalty.status eq 'UNPAID'}">
                                <form action="${pageContext.request.contextPath}/librarian/penalties" method="post" style="display: inline;">
                                    <input type="hidden" name="penaltyId" value="${penalty.id}">
                                    <input type="hidden" name="action" value="pay">
                                    <button type="submit" class="btn-pay" onclick="return confirm('Marquer comme payé ?')">
                                        <i class="fas fa-credit-card"></i> Payer
                                    </button>
                                </form>
                                <form action="${pageContext.request.contextPath}/librarian/penalties" method="post" style="display: inline;">
                                    <input type="hidden" name="penaltyId" value="${penalty.id}">
                                    <input type="hidden" name="action" value="cancel">
                                    <button type="submit" class="btn-cancel" onclick="return confirm('Annuler cette pénalité ?')">
                                        <i class="fas fa-times-circle"></i> Annuler
                                    </button>
                                </form>
                            </c:if>
                        </td>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
</main>
</div>
</body>
</html>