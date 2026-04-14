<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Validation des inscriptions - Bibliothèque</title>
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
            <a href="${pageContext.request.contextPath}/librarian/validate" class="nav-item active"><i class="fas fa-check-circle"></i><span>Validations</span></a>
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
                <h1><i class="fas fa-check-circle"></i> Validation des inscriptions</h1>
                <p class="info-text">Validez ou rejetez les demandes d'inscription des nouveaux membres.</p>
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

            <!-- Statistique - Carte moderne -->
            <div class="stats-row">
                <div class="stat-item warning">
                    <i class="fas fa-clock"></i>
                    <div class="stat-info">
                        <span class="stat-label">En attente</span>
                        <span class="stat-number">${pendingCount}</span>
                    </div>
                </div>
            </div>

            <!-- Liste des demandes -->
            <div class="section">
                <h2><i class="fas fa-list"></i> Demandes d'inscription</h2>

                <c:choose>
                    <c:when test="${empty pendingMembers}">
                        <div class="empty-state">
                            <div class="empty-icon"><i class="fas fa-check-circle"></i></div>
                            <h3>Aucune inscription en attente</h3>
                            <p>Toutes les demandes ont été traitées.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="pending-list">
                            <c:forEach items="${pendingMembers}" var="member">
                                <div class="pending-card">
                                    <div class="pending-avatar">${member.firstName.charAt(0)}${member.lastName.charAt(0)}</div>
                                    <div class="pending-info">
                                        <div class="pending-name">
                                            <i class="fas fa-user"></i> ${member.firstName} ${member.lastName}
                                        </div>
                                        <div class="pending-email">
                                            <i class="fas fa-envelope"></i> ${member.email}
                                        </div>
                                        <div class="pending-date">
                                            <i class="fas fa-calendar-alt"></i> Inscription le <fmt:formatDate value="${member.createdAtAsDate}" pattern="dd/MM/yyyy à HH:mm"/>
                                        </div>
                                    </div>
                                    <div class="pending-actions">
                                        <form action="${pageContext.request.contextPath}/librarian/validate" method="post" style="display: inline;">
                                            <input type="hidden" name="userId" value="${member.id}">
                                            <input type="hidden" name="action" value="validate">
                                            <button type="submit" class="btn-validate" onclick="return confirm('Valider l\'inscription de ${member.firstName} ${member.lastName} ?')">
                                                <i class="fas fa-check"></i> Valider
                                            </button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/librarian/validate" method="post" style="display: inline;">
                                            <input type="hidden" name="userId" value="${member.id}">
                                            <input type="hidden" name="action" value="reject">
                                            <button type="submit" class="btn-reject" onclick="return confirm('Rejeter l\'inscription de ${member.firstName} ${member.lastName} ? Cette action est irréversible.')">
                                                <i class="fas fa-times"></i> Rejeter
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Information -->
            <div class="info-box">
                <i class="fas fa-info-circle info-icon"></i>
                <div>
                    <strong>Comment ça fonctionne ?</strong><br>
                    Les nouveaux membres s'inscrivent en ligne. Leur compte est créé avec le statut "En attente".<br>
                    En tant que bibliothécaire, vous devez valider leur inscription pour qu'ils puissent se connecter et emprunter des ouvrages.
                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>