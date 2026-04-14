<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tableau de bord - Administrateur</title>
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
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-item active"><i class="fas fa-chart-line"></i><span>Tableau de bord</span></a>
            <a href="${pageContext.request.contextPath}/admin/members" class="nav-item"><i class="fas fa-users"></i><span>Adhérents</span></a>
            <a href="${pageContext.request.contextPath}/admin/documents" class="nav-item"><i class="fas fa-book"></i><span>Ouvrages</span></a>
            <a href="${pageContext.request.contextPath}/admin/loans" class="nav-item"><i class="fas fa-exchange-alt"></i><span>Emprunts</span></a>
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
            <h1>Tableau de bord administrateur</h1>
            <p class="welcome-text">Bienvenue, ${sessionScope.user.firstName} ! Voici un aperçu de votre bibliothèque.</p>

            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon"><i class="fas fa-users"></i></div>
                    <div class="stat-info">
                        <h3>Total Adhérents</h3>
                        <div class="stat-value">${stats.totalMembers}</div>
                        <a href="${pageContext.request.contextPath}/admin/members" class="stat-link">Voir la liste <i class="fas fa-arrow-right"></i></a>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon"><i class="fas fa-book"></i></div>
                    <div class="stat-info">
                        <h3>Ouvrages</h3>
                        <div class="stat-value">${stats.totalBooks}</div>
                        <span class="stat-trend">Enrichissement en cours</span>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon"><i class="fas fa-exchange-alt"></i></div>
                    <div class="stat-info">
                        <h3>Emprunts en cours</h3>
                        <div class="stat-value">${stats.activeLoans}</div>
                        <span class="stat-trend">Sur ${stats.totalLoans} total</span>
                    </div>
                </div>

                <div class="stat-card warning">
                    <div class="stat-icon"><i class="fas fa-exclamation-triangle"></i></div>
                    <div class="stat-info">
                        <h3>Emprunts en retard</h3>
                        <div class="stat-value">${stats.overdueLoans}</div>
                        <span class="stat-trend">À surveiller</span>
                    </div>
                </div>
            </div>

            <div class="stats-grid">
                <div class="stat-card success">
                    <div class="stat-icon"><i class="fas fa-user-check"></i></div>
                    <div class="stat-info">
                        <h3>Adhérents actifs</h3>
                        <div class="stat-value">${stats.activeMembers}</div>
                        <a href="${pageContext.request.contextPath}/admin/members?status=ACTIVE" class="stat-link">Voir les actifs <i class="fas fa-arrow-right"></i></a>
                    </div>
                </div>

                <div class="stat-card warning">
                    <div class="stat-icon"><i class="fas fa-hourglass-half"></i></div>
                    <div class="stat-info">
                        <h3>En attente de validation</h3>
                        <div class="stat-value">${stats.pendingMembers}</div>
                        <a href="${pageContext.request.contextPath}/admin/members?status=PENDING" class="stat-link">À valider <i class="fas fa-arrow-right"></i></a>
                    </div>
                </div>

                <div class="stat-card danger">
                    <div class="stat-icon"><i class="fas fa-ban"></i></div>
                    <div class="stat-info">
                        <h3>Comptes suspendus</h3>
                        <div class="stat-value">${stats.suspendedMembers}</div>
                        <a href="${pageContext.request.contextPath}/admin/members?status=SUSPENDED" class="stat-link">À réactiver <i class="fas fa-arrow-right"></i></a>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon"><i class="fas fa-user-tie"></i></div>
                    <div class="stat-info">
                        <h3>Bibliothécaires</h3>
                        <div class="stat-value">${stats.totalLibrarians}</div>
                        <a href="${pageContext.request.contextPath}/admin/members?role=LIBRARIAN" class="stat-link">Gérer <i class="fas fa-arrow-right"></i></a>
                    </div>
                </div>
            </div>

            <div class="sections-grid">
                <div class="section">
                    <div class="section-header">
                        <h2><i class="fas fa-user-plus"></i> Inscriptions en attente</h2>
                        <a href="${pageContext.request.contextPath}/admin/members?status=PENDING" class="btn-link">Voir tout <i class="fas fa-arrow-right"></i></a>
                    </div>
                    <c:choose>
                        <c:when test="${empty pendingMembers}">
                            <div class="empty-state">
                                <p><i class="fas fa-check-circle"></i> Aucune inscription en attente</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <table class="data-table">
                                <thead><tr><th>Nom</th><th>Email</th><th>Date</th></tr></thead>
                                <tbody>
                                <c:forEach items="${pendingMembers}" var="member" begin="0" end="4">
                                    <tr>
                                        <td><a href="${pageContext.request.contextPath}/admin/members/${member.id}">${member.firstName} ${member.lastName}</a></td>
                                        <td>${member.email}</td>
                                        <td><fmt:formatDate value="${member.createdAtAsDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="section">
                    <div class="section-header">
                        <h2><i class="fas fa-user-graduate"></i> Bibliothécaires</h2>
                        <a href="${pageContext.request.contextPath}/admin/members/create" class="btn-link"><i class="fas fa-plus"></i> Ajouter</a>
                    </div>
                    <c:choose>
                        <c:when test="${empty librarians}">
                            <div class="empty-state">
                                <p><i class="fas fa-info-circle"></i> Aucun bibliothécaire enregistré</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="librarians-list">
                                <c:forEach items="${librarians}" var="lib">
                                    <div class="librarian-card">
                                        <div class="librarian-avatar">${lib.firstName.charAt(0)}${lib.lastName.charAt(0)}</div>
                                        <div class="librarian-info">
                                            <strong><a href="${pageContext.request.contextPath}/admin/members/${lib.id}" style="color: #0F172A;">${lib.firstName} ${lib.lastName}</a></strong>
                                            <span>${lib.email}</span>
                                        </div>
                                        <div class="librarian-actions">
                                            <a href="${pageContext.request.contextPath}/admin/members/${lib.id}/edit" class="icon-btn" title="Modifier"><i class="fas fa-edit"></i></a>
                                            <a href="${pageContext.request.contextPath}/admin/members/${lib.id}/role" class="icon-btn" title="Changer rôle"><i class="fas fa-user-tag"></i></a>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>
