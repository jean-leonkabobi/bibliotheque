<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Accès interdit - Bibliothèque</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/error.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="error-container">
    <div class="error-content">
        <div class="error-code">403</div>
        <div class="error-icon">⛔</div>
        <h1>Accès interdit</h1>
        <p>Vous n'avez pas les autorisations nécessaires pour accéder à cette page.</p>

        <div class="error-details">
            <p><strong>URL demandée :</strong> ${pageContext.errorData.requestURI}</p>
            <p><strong>Méthode :</strong> ${pageContext.errorData.method}</p>
            <p><strong>Votre rôle :</strong>
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        ${sessionScope.user.role}
                    </c:when>
                    <c:otherwise>
                        Non authentifié
                    </c:otherwise>
                </c:choose>
            </p>
        </div>

        <div class="error-actions">
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <c:choose>
                        <c:when test="${sessionScope.user.role == 'ADMIN'}">
                            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-primary">Tableau de bord Admin</a>
                        </c:when>
                        <c:when test="${sessionScope.user.role == 'LIBRARIAN'}">
                            <a href="${pageContext.request.contextPath}/librarian/dashboard" class="btn btn-primary">Tableau de bord Bibliothécaire</a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/member/dashboard" class="btn btn-primary">Tableau de bord Adhérent</a>
                        </c:otherwise>
                    </c:choose>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger">Déconnexion</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">Se connecter</a>
                    <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">Accueil</a>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="error-suggestions">
            <h3>Que faire ?</h3>
            <ul>
                <li>Vérifiez que vous êtes connecté avec le bon compte</li>
                <li>Contactez l'administrateur pour obtenir les droits nécessaires</li>
                <c:if test="${empty sessionScope.user}">
                    <li><a href="${pageContext.request.contextPath}/login">Connectez-vous</a> pour accéder à votre espace</li>
                </c:if>
            </ul>
        </div>
    </div>
</div>
</body>
</html>