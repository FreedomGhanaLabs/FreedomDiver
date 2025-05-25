// debt_status_model.dart
class DebtStatus {
  final double currentDebt;
  final double debtThreshold;
  final int debtPercentage;
  final String debtStatus;
  final bool canAcceptRides;
  final int warningThreshold;
  final int suspensionThreshold;
  final double walletBalance;
  final double availableBalance;
  final List<DebtPaymentHistory>? debtPaymentHistory;

  DebtStatus({
    required this.currentDebt,
    required this.debtThreshold,
    required this.debtPercentage,
    required this.debtStatus,
    required this.canAcceptRides,
    required this.warningThreshold,
    required this.suspensionThreshold,
    required this.walletBalance,
    required this.availableBalance,
    this.debtPaymentHistory,
  });

  factory DebtStatus.fromJson(Map<String, dynamic> json) => DebtStatus(
    currentDebt: (json['currentDebt'] as num).toDouble(),
    debtThreshold: (json['debtThreshold'] as num).toDouble(),
    debtPercentage: json['debtPercentage'],
    debtStatus: json['debtStatus'],
    canAcceptRides: json['canAcceptRides'],
    warningThreshold: json['warningThreshold'],
    suspensionThreshold: json['suspensionThreshold'],
    walletBalance: (json['walletBalance'] as num).toDouble(),
    availableBalance: (json['availableBalance'] as num).toDouble(),
  );
}

class DebtPaymentHistory {
  final double amount;
  final String method;
  final String reference;
  final String status;
  final String notes;
  final DateTime paymentDate;

  DebtPaymentHistory({
    required this.amount,
    required this.method,
    required this.reference,
    required this.status,
    required this.notes,
    required this.paymentDate,
  });

  factory DebtPaymentHistory.fromJson(Map<String, dynamic> json) {
    return DebtPaymentHistory(
      amount: (json['amount'] as num).toDouble(),
      method: json['method'],
      reference: json['reference'],
      status: json['status'],
      notes: json['notes'],
      paymentDate: DateTime.parse(json['paymentDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'method': method,
      'reference': reference,
      'status': status,
      'notes': notes,
      'paymentDate': paymentDate.toIso8601String(),
    };
  }
}
