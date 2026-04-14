package com.kabobi.bibliotheque.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "penalty")
public class Penalty {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne
    @JoinColumn(name = "loan_id")
    private Loan loan;

    @Column(nullable = false)
    private Double amount;

    @Column(nullable = false)
    private String reason;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private PenaltyStatus status;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @Column(name = "paid_at")
    private LocalDateTime paidAt;

    public Penalty() {
        this.status = PenaltyStatus.UNPAID;
        this.createdAt = LocalDateTime.now();
    }

    public Penalty(User user, Loan loan, Double amount, String reason) {
        this();
        this.user = user;
        this.loan = loan;
        this.amount = amount;
        this.reason = reason;
    }

    // Getters et Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public Loan getLoan() { return loan; }
    public void setLoan(Loan loan) { this.loan = loan; }

    public Double getAmount() { return amount; }
    public void setAmount(Double amount) { this.amount = amount; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public PenaltyStatus getStatus() { return status; }
    public void setStatus(PenaltyStatus status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getPaidAt() { return paidAt; }
    public void setPaidAt(LocalDateTime paidAt) { this.paidAt = paidAt; }

    // Méthodes utilitaires
    public void pay() {
        this.status = PenaltyStatus.PAID;
        this.paidAt = LocalDateTime.now();
    }

    public boolean isPaid() {
        return this.status == PenaltyStatus.PAID;
    }

    public boolean isUnpaid() {
        return this.status == PenaltyStatus.UNPAID;
    }

    public java.util.Date getCreatedAtAsDate() {
        if (createdAt == null) return null;
        return java.util.Date.from(createdAt.atZone(java.time.ZoneId.systemDefault()).toInstant());
    }

    public java.util.Date getPaidAtAsDate() {
        if (paidAt == null) return null;
        return java.util.Date.from(paidAt.atZone(java.time.ZoneId.systemDefault()).toInstant());
    }
}