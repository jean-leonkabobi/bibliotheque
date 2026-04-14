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
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-item"><i class="fas fa-chart-line"></i><span>Tableau de bord</span></a>
            <a href="${pageContext.request.contextPath}/admin/members" class="nav-item active"><i class="fas fa-users"></i><span>Adhérents</span></a>
            <a href="${pageContext.request.contextPath}/admin/documents" class="nav-item"><i class="fas fa-book"></i><span>Ouvrages</span></a>
            <a href="${pageContext.request.contextPath}/admin/loans" class="nav-item"><i class="fas fa-exchange-alt"></i><span>Emprunts</span></a>
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
                <div>
                    <a href="${pageContext.request.contextPath}/admin/members" class="btn-link"><i class="fas fa-arrow-left"></i> Retour à la liste</a>
                    <h1><i class="fas fa-user-circle"></i> ${member.firstName} ${member.lastName}</h1>
                </div>
            </div>

            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/admin/members/${member.id}/edit" class="btn-edit"><i class="fas fa-edit"></i> Modifier</a>
                <a href="${pageContext.request.contextPath}/admin/members/${member.id}/role" class="btn-role"><i class="fas fa-user-tag"></i> Changer rôle</a>
                <c:if test="${member.status eq 'ACTIVE'}">
                    <a href="${pageContext.request.contextPath}/admin/members/${member.id}/suspend" class="btn-suspend" onclick="return confirm('Suspendre ce membre ?')"><i class="fas fa-pause-circle"></i> Suspendre</a>
                </c:if>
                <c:if test="${member.status eq 'SUSPENDED'}">
                    <a href="${pageContext.request.contextPath}/admin/members/${member.id}/activate" class="btn-activate" onclick="return confirm('Réactiver ce membre ?')"><i class="fas fa-play-circle"></i> Réactiver</a>
                </c:if>
                <c:if test="${member.status eq 'PENDING'}">
                    <a href="${pageContext.request.contextPath}/admin/members/${member.id}/validate" class="btn-validate" onclick="return confirm('Valider ce compte ?')"><i class="fas fa-check-circle"></i> Valider</a>
                </c:if>
                <a href="${pageContext.request.contextPath}/admin/members/${member.id}/delete" class="btn-delete" onclick="return confirm('Supprimer définitivement ce membre ?')"><i class="fas fa-trash-alt"></i> Supprimer</a>
            </div>

            <div class="info-section">
                <h2><i class="fas fa-info-circle"></i> Informations personnelles</h2>
                <div class="info-grid">
                    <div><i class="fas fa-hashtag"></i> <strong>ID :</strong> ${member.id}</div>
                    <div><i class="fas fa-user"></i> <strong>Nom :</strong> ${member.firstName} ${member.lastName}</div>
                    <div><i class="fas fa-envelope"></i> <strong>Email :</strong> ${member.email}</div>
                    <div><i class="fas fa-tag"></i> <strong>Rôle :</strong> <span class="badge badge-${member.role.name().toLowerCase()}">${member.role.name()}</span></div>
                    <div><i class="fas fa-flag"></i> <strong>Statut :</strong> <span class="badge badge-${member.status.name().toLowerCase()}">${member.status.name()}</span></div>
                    <div><i class="fas fa-calendar-plus"></i> <strong>Date d'inscription :</strong> <fmt:formatDate value="${member.createdAtAsDate}" pattern="dd/MM/yyyy HH:mm"/></div>
                    <div><i class="fas fa-calendar-alt"></i> <strong>Dernière modification :</strong> <fmt:formatDate value="${member.updatedAtAsDate}" pattern="dd/MM/yyyy HH:mm"/></div>
                    <div><i class="fas fa-book"></i> <strong>Peut emprunter :</strong> ${canBorrow ? '<i class="fas fa-check-circle" style="color:#10B981"></i> Oui' : '<i class="fas fa-times-circle" style="color:#EF4444"></i> Non'}</div>
                    <div><i class="fas fa-euro-sign"></i> <strong>Total pénalités :</strong> ${totalPenalties} €</div>
                </div>
            </div>

            <div class="info-section">
                <h2><i class="fas fa-book-open"></i> Emprunts en cours (${activeLoansCount}/3)</h2>
                <c:choose>
                    <c:when test="${empty activeLoans}">
                        <div class="empty-state"><i class="fas fa-info-circle"></i> Aucun emprunt en cours</div>
                    </c:when>
                    <c:otherwise>
                        <table class="data-table">
                            <thead><tr><th>Document</th><th>Date d'emprunt</th><th>Date de retour</th><th>Statut</th><th>Actions</th></tr></thead>
                            <tbody>
                            <c:forEach items="${activeLoans}" var="loan">
                                <tr>
                                    <td>Document #${loan.documentId} (${loan.documentType})</td>
                                    <td><fmt:formatDate value="${loan.loanDateAsDate}" pattern="dd/MM/yyyy"/></td>
                                    <td><fmt:formatDate value="${loan.dueDateAsDate}" pattern="dd/MM/yyyy"/></td>
                                    <td>${loan.overdue ? '<span class="badge badge-danger"><i class="fas fa-exclamation-triangle"></i> En retard</span>' : '<span class="badge badge-active"><i class="fas fa-check-circle"></i> En cours</span>'}</td>
                                    <td><a href="#" class="btn-icon"><i class="fas fa-redo-alt"></i></a></td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="info-section">
                <h2><i class="fas fa-history"></i> Historique des emprunts (${totalLoansCount})</h2>
                <c:choose>
                    <c:when test="${empty loanHistory}">
                        <div class="empty-state"><i class="fas fa-info-circle"></i> Aucun historique d'emprunt</div>
                    </c:when>
                    <c:otherwise>
                        <table class="data-table">
                            <thead><tr><th>Document</th><th>Date d'emprunt</th><th>Date de retour prévue</th><th>Date de retour effectif</th><th>Statut</th></tr></thead>
                            <tbody>
                            <c:forEach items="${loanHistory}" var="loan">
                                <tr>
                                    <td>Document #${loan.documentId} (${loan.documentType})</td>
                                    <td><fmt:formatDate value="${loan.loanDateAsDate}" pattern="dd/MM/yyyy"/></td>
                                    <td><fmt:formatDate value="${loan.dueDateAsDate}" pattern="dd/MM/yyyy"/></td>
                                    <td><fmt:formatDate value="${loan.returnDateAsDate}" pattern="dd/MM/yyyy"/></td>
                                    <td><span class="badge badge-${loan.status.name().toLowerCase()}">${loan.status.name()}</span></td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="info-section">
                <h2><i class="fas fa-euro-sign"></i> Pénalités (Total: ${totalPenalties} €)</h2>
                <c:choose>
                    <c:when test="${empty penalties}">
                        <div class="empty-state"><i class="fas fa-check-circle"></i> Aucune pénalité</div>
                    </c:when>
                    <c:otherwise>
                        <table class="data-table">
                            <thead><tr><th>Raison</th><th>Montant</th><th>Date</th><th>Statut</th><th>Actions</th></tr></thead>
                            <tbody>
                            <c:forEach items="${penalties}" var="penalty">
                                <tr>
                                    <td>${penalty.reason}</td>
                                    <td>${penalty.amount} €</td>
                                    <td><fmt:formatDate value="${penalty.createdAtAsDate}" pattern="dd/MM/yyyy"/></td>
                                    <td><span class="badge badge-${penalty.status.name().toLowerCase()}">${penalty.status.name()}</span></td>
                                    <td>
                                        <c:if test="${penalty.unpaid}">
                                            <a href="#" class="btn-icon"><i class="fas fa-credit-card"></i></a>
                                            <a href="#" class="btn-icon"><i class="fas fa-times-circle"></i></a>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>
</div>
</body>
</html>