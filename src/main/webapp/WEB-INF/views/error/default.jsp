<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Erreur - Bibliothèque</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/error.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="error-container">
    <div class="error-content">
        <div class="error-icon">⚠️</div>
        <h1>Une erreur est survenue</h1>
        <p>Nous sommes désolés, une erreur inattendue s'est produite.</p>

        <c:if test="${not empty pageContext.exception}">
            <div class="error-details">
                <p><strong>Message :</strong> ${pageContext.exception.message}</p>
            </div>
        </c:if>

        <div class="error-actions">
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Accueil</a>
            <a href="javascript:history.back()" class="btn btn-secondary">Retour</a>
        </div>
    </div>
</div>
</body>
</html>