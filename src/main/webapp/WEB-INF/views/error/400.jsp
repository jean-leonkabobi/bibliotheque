<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Requête invalide - Bibliothèque</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/error.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="error-container">
    <div class="error-content">
        <div class="error-code">400</div>
        <div class="error-icon">❓</div>
        <h1>Requête invalide</h1>
        <p>La requête envoyée au serveur est mal formulée ou incomplète.</p>

        <div class="error-actions">
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Accueil</a>
            <a href="javascript:history.back()" class="btn btn-secondary">Retour</a>
        </div>
    </div>
</div>
</body>
</html>