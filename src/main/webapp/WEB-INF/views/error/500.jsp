<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Erreur serveur - Bibliothèque</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/error.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="error-container">
    <div class="error-content">
        <div class="error-code">500</div>
        <div class="error-icon">💥</div>
        <h1>Erreur interne du serveur</h1>
        <p>Une erreur inattendue s'est produite. Nos équipes ont été notifiées.</p>

        <div class="error-details">
            <p><strong>URL demandée :</strong> ${pageContext.errorData.requestURI}</p>
            <p><strong>Méthode :</strong> ${pageContext.errorData.method}</p>
            <p><strong>Statut :</strong> ${pageContext.errorData.statusCode}</p>
            <p><strong>Message :</strong> ${pageContext.exception.message}</p>
        </div>

        <c:if test="${initParam['debug'] == 'true'}">
            <div class="error-stacktrace">
                <h3>Détails techniques (mode debug) :</h3>
                <pre><c:forEach items="${pageContext.exception.stackTrace}" var="trace">${trace}
                </c:forEach></pre>
            </div>
        </c:if>

        <div class="error-actions">
            <a href="javascript:location.reload()" class="btn btn-primary">Réessayer</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">Accueil</a>
            <a href="javascript:history.back()" class="btn btn-secondary">Retour</a>
        </div>

        <div class="error-suggestions">
            <h3>Suggestions :</h3>
            <ul>
                <li>Rafraîchissez la page et réessayez</li>
                <li>Vérifiez votre connexion internet</li>
                <li>Contactez l'administrateur si le problème persiste</li>
            </ul>
        </div>
    </div>
</div>
</body>
</html>