<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Page non trouvée - Bibliothèque</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/error.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="error-container">
    <div class="error-content">
        <div class="error-code">404</div>
        <div class="error-icon">🔍</div>
        <h1>Page non trouvée</h1>
        <p>Désolé, la page que vous recherchez n'existe pas ou a été déplacée.</p>

        <div class="error-details">
            <p><strong>URL demandée :</strong> ${pageContext.errorData.requestURI}</p>
            <p><strong>Méthode :</strong> ${pageContext.errorData.method}</p>
            <p><strong>Statut :</strong> ${pageContext.errorData.statusCode}</p>
        </div>

        <div class="error-actions">
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Accueil</a>
            <a href="javascript:history.back()" class="btn btn-secondary">Retour</a>
        </div>

        <div class="error-suggestions">
            <h3>Suggestions :</h3>
            <ul>
                <li>Vérifiez l'URL que vous avez saisie</li>
                <li>Retournez à la <a href="${pageContext.request.contextPath}/">page d'accueil</a></li>
                <li>Contactez l'administrateur si le problème persiste</li>
            </ul>
        </div>
    </div>
</div>
</body>
</html>