// debt_status_model.dart
class Debt {

  Debt({
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

  factory Debt.fromJson(Map<String, dynamic> json) => Debt(
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

  Debt copyWith({
    double? currentDebt,
    double? debtThreshold,
    int? debtPercentage,
    String? debtStatus,
    bool? canAcceptRides,
    int? warningThreshold,
    int? suspensionThreshold,
    double? walletBalance,
    double? availableBalance,
    List<DebtPaymentHistory>? debtPaymentHistory,
  }) {
    return Debt(
      currentDebt: currentDebt ?? this.currentDebt,
      debtThreshold: debtThreshold ?? this.debtThreshold,
      debtPercentage: debtPercentage ?? this.debtPercentage,
      debtStatus: debtStatus ?? this.debtStatus,
      canAcceptRides: canAcceptRides ?? this.canAcceptRides,
      warningThreshold: warningThreshold ?? this.warningThreshold,
      suspensionThreshold: suspensionThreshold ?? this.suspensionThreshold,
      walletBalance: walletBalance ?? this.walletBalance,
      availableBalance: availableBalance ?? this.availableBalance,
      debtPaymentHistory: debtPaymentHistory ?? this.debtPaymentHistory,
    );
  }
}

class DebtPaymentHistory {

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
  final double amount;
  final String method;
  final String reference;
  final String status;
  final String notes;
  final DateTime paymentDate;

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
