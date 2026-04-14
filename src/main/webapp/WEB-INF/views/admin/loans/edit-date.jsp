<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier la date de retour</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .info-card {
            background: #F8FAFC;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .info-card h3 {
            font-size: 16px;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 8px;
            color: #0F172A;
        }
        .info-card h3 i {
            color: #38BDF8;
        }
        .info-row {
            display: flex;
            padding: 8px 0;
            border-bottom: 1px solid #E2E8F0;
        }
        .info-label {
            width: 140px;
            font-weight: 600;
            color: #64748B;
        }
        .info-value {
            flex: 1;
            color: #0F172A;
        }
        .warning-card {
            background: #FEF2F2;
            border-left: 4px solid #EF4444;
        }
        .warning-card h3 i {
            color: #EF4444;
        }
        .current-date-card {
            background: #ECFDF5;
        }
        .current-date-card h3 i {
            color: #10B981;
        }
        .form-container {
            max-width: 700px;
            margin: 0 auto;
        }
        .required-field::after {
            content: "*";
            color: #EF4444;
            margin-left: 4px;
        }
    </style>
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
            <a href="${pageContext.request.contextPath}/admin/members" class="nav-item"><i class="fas fa-users"></i><span>Adhérents</span></a>
            <a href="${pageContext.request.contextPath}/admin/documents" class="nav-item"><i class="fas fa-book"></i><span>Ouvrages</span></a>
            <a href="${pageContext.request.contextPath}/admin/loans" class="nav-item active"><i class="fas fa-exchange-alt"></i><span>Emprunts</span></a>
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
                    <a href="${pageContext.request.contextPath}/admin/loans" class="btn-link"><i class="fas fa-arrow-left"></i> Retour à la liste</a>
                    <h1><i class="fas fa-calendar-edit"></i> Modifier la date de retour</h1>
                </div>
            </div>

            <div class="form-container">
                <!-- Informations de l'emprunt -->
                <div class="info-card">
                    <h3><i class="fas fa-info-circle"></i> Informations de l'emprunt</h3>
                    <div class="info-row">
                        <div class="info-label"><i class="fas fa-user"></i> Membre :</div>
                        <div class="info-value">${loan.user.firstName} ${loan.user.lastName}</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label"><i class="fas fa-file-alt"></i> Document :</div>
                        <div class="info-value">Document #${loan.documentId} (${loan.documentType})</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label"><i class="fas fa-calendar-plus"></i> Date d'emprunt :</div>
                        <div class="info-value"><fmt:formatDate value="${loan.loanDateAsDate}" pattern="dd/MM/yyyy HH:mm"/></div>
                    </div>
                </div>

                <!-- Date de retour actuelle -->
                <div class="info-card current-date-card">
                    <h3><i class="fas fa-calendar-check"></i> Date de retour actuelle</h3>
                    <div class="info-row">
                        <div class="info-label"><i class="fas fa-calendar-alt"></i> Retour prévu :</div>
                        <div class="info-value"><fmt:formatDate value="${loan.dueDateAsDate}" pattern="dd/MM/yyyy HH:mm"/></div>
                    </div>
                    <c:if test="${loan.overdue}">
                        <div class="info-row">
                            <div class="info-label"><i class="fas fa-exclamation-triangle"></i> Statut :</div>
                            <div class="info-value" style="color: #EF4444;"><i class="fas fa-clock"></i> Cet emprunt est en retard de ${loan.daysOverdue} jour(s) !</div>
                        </div>
                    </c:if>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${error}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/admin/loans/edit-date" method="post" class="form">
                    <input type="hidden" name="loanId" value="${loan.id}">

                    <div class="form-group">
                        <label class="required-field"><i class="fas fa-calendar-day"></i> Nouvelle date de retour</label>
                        <input type="datetime-local" name="dueDate"
                               value="<fmt:formatDate value="${loan.dueDateAsDate}" pattern="yyyy-MM-dd'T'HH:mm"/>"
                               required>
                        <small><i class="fas fa-info-circle"></i> Format : JJ/MM/AAAA HH:MM</small>
                    </div>

                    <div class="info-card warning-card">
                        <h3><i class="fas fa-exclamation-triangle"></i> Attention</h3>
                        <p style="margin: 0; color: #64748B;">La modification de la date de retour affectera le calcul des pénalités.
                            Si vous reculez la date, les pénalités seront recalculées.</p>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn-primary"><i class="fas fa-save"></i> Enregistrer</button>
                        <a href="${pageContext.request.contextPath}/admin/loans" class="btn-secondary"><i class="fas fa-times"></i> Annuler</a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>
</body>
</html>