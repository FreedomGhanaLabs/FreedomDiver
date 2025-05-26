import 'package:equatable/equatable.dart';

class Finance extends Equatable {
  final double walletBalance;
  final double availableBalance;
  final double debt;
  final String debtStatus;
  final double debtPercentage;
  final bool bankDetailsProvided;
  final bool momoDetailsProvided;
  final List pendingWithdrawals;
  final double totalEarnings;
  final int rideCount;
  final List<Transaction> recentTransactions;
  final List<Withdrawal> withdrawals;
  final List<EarningRide> rides;
  final List<EarningsReport> earningsReport;
  final PaymentBreakdown paymentBreakdown;
  final WithdrawalMethods withdrawalMethods;

  const Finance({
    required this.walletBalance,
    required this.availableBalance,
    required this.debt,
    required this.debtStatus,
    required this.debtPercentage,
    required this.bankDetailsProvided,
    required this.momoDetailsProvided,
    required this.pendingWithdrawals,
    required this.totalEarnings,
    required this.rideCount,
    required this.recentTransactions,
    required this.withdrawals,
    required this.rides,
    required this.earningsReport,
    required this.paymentBreakdown,
    required this.withdrawalMethods,
  });

  factory Finance.fromJson(Map<String, dynamic> json) {
    return Finance(
      walletBalance:
          json['walletBalance']?.toDouble() ??
          json['wallet']?['balance']?.toDouble() ??
          0.0,
      availableBalance:
          json['availableBalance']?.toDouble() ??
          json['wallet']?['availableBalance']?.toDouble() ??
          0.0,
      debt:
          json['debt']?.toDouble() ??
          json['wallet']?['debt']?.toDouble() ??
          0.0,
      debtStatus: json['debtStatus'] ?? json['wallet']?['debtStatus'] ?? '',
      debtPercentage:
          json['debtPercentage']?.toDouble() ??
          json['wallet']?['debtPercentage']?.toDouble() ??
          0.0,
      bankDetailsProvided:
          json['bankDetailsProvided'] ??
          json['wallet']?['bankDetailsProvided'] ??
          false,
      momoDetailsProvided:
          json['momoDetailsProvided'] ??
          json['wallet']?['momoDetailsProvided'] ??
          false,
      pendingWithdrawals:
          (json['pendingWithdrawals'] as List? ?? [])
              .map((e) => PendingWithdrawal.fromJson(e))
              .toList(),
      totalEarnings: json['totalEarnings']?.toDouble() ?? 0.0,
      rideCount: json['rideCount'] ?? 0,
      recentTransactions:
          (json['recentTransactions'] as List? ?? [])
              .map((e) => Transaction.fromJson(e))
              .toList(),
      withdrawals:
          (json['withdrawals'] as List? ?? [])
              .map((e) => Withdrawal.fromJson(e))
              .toList(),
      rides:
          (json['rides'] as List? ?? [])
              .map((e) => EarningRide.fromJson(e))
              .toList(),
      earningsReport:
          (json['earningsReport'] as List? ?? [])
              .map((e) => EarningsReport.fromJson(e))
              .toList(),
      paymentBreakdown: PaymentBreakdown.fromJson(
        json['paymentBreakdown'] ?? {},
      ),
      withdrawalMethods: WithdrawalMethods.fromJson(
        json['withdrawalMethods'] ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'walletBalance': walletBalance,
      'availableBalance': availableBalance,
      'debt': debt,
      'debtStatus': debtStatus,
      'debtPercentage': debtPercentage,
      'bankDetailsProvided': bankDetailsProvided,
      'momoDetailsProvided': momoDetailsProvided,
      'pendingWithdrawals': pendingWithdrawals.map((e) => e.toJson()).toList(),
      'totalEarnings': totalEarnings,
      'rideCount': rideCount,
      'recentTransactions': recentTransactions.map((e) => e.toJson()).toList(),
      'withdrawals': withdrawals.map((e) => e.toJson()).toList(),
      'rides': rides.map((e) => e.toJson()).toList(),
      'earningsReport': earningsReport.map((e) => e.toJson()).toList(),
      'paymentBreakdown': paymentBreakdown.toJson(),
      'withdrawalMethods': withdrawalMethods.toJson(),
    };
  }

  Finance copyWith({
    double? walletBalance,
    double? availableBalance,
    double? debt,
    String? debtStatus,
    double? debtPercentage,
    bool? bankDetailsProvided,
    bool? momoDetailsProvided,
    List<PendingWithdrawal>? pendingWithdrawals,
    double? totalEarnings,
    int? rideCount,
    List<Transaction>? recentTransactions,
    List<Withdrawal>? withdrawals,
    List<EarningRide>? rides,
    List<EarningsReport>? earningsReport,
    PaymentBreakdown? paymentBreakdown,
    WithdrawalMethods? withdrawalMethods,
  }) {
    return Finance(
      walletBalance: walletBalance ?? this.walletBalance,
      availableBalance: availableBalance ?? this.availableBalance,
      debt: debt ?? this.debt,
      debtStatus: debtStatus ?? this.debtStatus,
      debtPercentage: debtPercentage ?? this.debtPercentage,
      bankDetailsProvided: bankDetailsProvided ?? this.bankDetailsProvided,
      momoDetailsProvided: momoDetailsProvided ?? this.momoDetailsProvided,
      pendingWithdrawals: pendingWithdrawals ?? this.pendingWithdrawals,
      totalEarnings: totalEarnings ?? this.totalEarnings,
      rideCount: rideCount ?? this.rideCount,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      withdrawals: withdrawals ?? this.withdrawals,
      rides: rides ?? this.rides,
      earningsReport: earningsReport ?? this.earningsReport,
      paymentBreakdown: paymentBreakdown ?? this.paymentBreakdown,
      withdrawalMethods: withdrawalMethods ?? this.withdrawalMethods,
    );
  }

  @override
  List<Object?> get props => [
    walletBalance,
    availableBalance,
    debt,
    debtStatus,
    debtPercentage,
    bankDetailsProvided,
    momoDetailsProvided,
    pendingWithdrawals,
    totalEarnings,
    rideCount,
    recentTransactions,
    withdrawals,
    rides,
    earningsReport,
    paymentBreakdown,
    withdrawalMethods,
  ];
}

class Transaction extends Equatable {
  final double amount;
  final String type;
  final String date;
  final String reference;

  const Transaction({
    required this.amount,
    required this.type,
    required this.date,
    required this.reference,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    amount: json['amount']?.toDouble() ?? 0.0,
    type: json['type'] ?? '',
    date: json['date'] ?? '',
    reference: json['reference'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'type': type,
    'date': date,
    'reference': reference,
  };

  @override
  List<Object?> get props => [amount, type, date, reference];
}

class Withdrawal extends Equatable {
  final double amount;
  final String method;
  final String status;
  final String reference;
  final String createdAt;
  final String? processedAt;

  const Withdrawal({
    required this.amount,
    required this.method,
    required this.status,
    required this.reference,
    required this.createdAt,
    this.processedAt,
  });

  factory Withdrawal.fromJson(Map<String, dynamic> json) => Withdrawal(
    amount: json['amount']?.toDouble() ?? 0.0,
    method: json['method'] ?? '',
    status: json['status'] ?? '',
    reference: json['reference'] ?? '',
    createdAt: json['createdAt'] ?? '',
    processedAt: json['processedAt'],
  );

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'method': method,
    'status': status,
    'reference': reference,
    'createdAt': createdAt,
    'processedAt': processedAt,
  };

  @override
  List<Object?> get props => [
    amount,
    method,
    status,
    reference,
    createdAt,
    processedAt,
  ];
}

class EarningRide extends Equatable {
  final String id;
  final double fare;
  final double driverEarnings;
  final String completedAt;
  final String pickupLocation;
  final String dropoffLocation;

  const EarningRide({
    required this.id,
    required this.fare,
    required this.driverEarnings,
    required this.completedAt,
    required this.pickupLocation,
    required this.dropoffLocation,
  });

  factory EarningRide.fromJson(Map<String, dynamic> json) => EarningRide(
    id: json['_id'] ?? '',
    fare: json['fare']?.toDouble() ?? 0.0,
    driverEarnings: json['driverEarnings']?.toDouble() ?? 0.0,
    completedAt: json['completedAt'] ?? '',
    pickupLocation: json['pickupLocation'] ?? '',
    dropoffLocation: json['dropoffLocation'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'fare': fare,
    'driverEarnings': driverEarnings,
    'completedAt': completedAt,
    'pickupLocation': pickupLocation,
    'dropoffLocation': dropoffLocation,
  };

  @override
  List<Object?> get props => [
    id,
    fare,
    driverEarnings,
    completedAt,
    pickupLocation,
    dropoffLocation,
  ];
}

class EarningsReport extends Equatable {
  final String period;
  final double totalEarnings;
  final int rideCount;

  const EarningsReport({
    required this.period,
    required this.totalEarnings,
    required this.rideCount,
  });

  factory EarningsReport.fromJson(Map<String, dynamic> json) => EarningsReport(
    period: json['period'] ?? '',
    totalEarnings: json['totalEarnings']?.toDouble() ?? 0.0,
    rideCount: json['rideCount'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'period': period,
    'totalEarnings': totalEarnings,
    'rideCount': rideCount,
  };

  @override
  List<Object?> get props => [period, totalEarnings, rideCount];
}

class PaymentBreakdown extends Equatable {
  final PaymentChannel cash;
  final PaymentChannel card;
  final PaymentChannel mobileMoney;

  const PaymentBreakdown({
    required this.cash,
    required this.card,
    required this.mobileMoney,
  });

  factory PaymentBreakdown.fromJson(Map<String, dynamic> json) =>
      PaymentBreakdown(
        cash: PaymentChannel.fromJson(json['cash'] ?? {}),
        card: PaymentChannel.fromJson(json['card'] ?? {}),
        mobileMoney: PaymentChannel.fromJson(json['mobile_money'] ?? {}),
      );

  Map<String, dynamic> toJson() => {
    'cash': cash.toJson(),
    'card': card.toJson(),
    'mobile_money': mobileMoney.toJson(),
  };

  @override
  List<Object?> get props => [cash, card, mobileMoney];
}

class PaymentChannel extends Equatable {
  final double total;
  final int count;

  const PaymentChannel({required this.total, required this.count});

  factory PaymentChannel.fromJson(Map<String, dynamic> json) => PaymentChannel(
    total: json['total']?.toDouble() ?? 0.0,
    count: json['count'] ?? 0,
  );

  Map<String, dynamic> toJson() => {'total': total, 'count': count};

  @override
  List<Object?> get props => [total, count];
}

class WithdrawalMethods extends Equatable {
  final bool bank;
  final bool momo;

  const WithdrawalMethods({required this.bank, required this.momo});

  factory WithdrawalMethods.fromJson(Map<String, dynamic> json) =>
      WithdrawalMethods(
        bank: json['bank'] ?? false,
        momo: json['momo'] ?? false,
      );

  Map<String, dynamic> toJson() => {'bank': bank, 'momo': momo};

  @override
  List<Object?> get props => [bank, momo];
}

class PendingWithdrawal {
  final double amount;
  final String method;
  final String status;
  final String reference;
  final DateTime createdAt;

  PendingWithdrawal({
    required this.amount,
    required this.method,
    required this.status,
    required this.reference,
    required this.createdAt,
  });

  factory PendingWithdrawal.fromJson(Map<String, dynamic> json) {
    return PendingWithdrawal(
      amount: (json['amount'] as num).toDouble(),
      method: json['method'] as String,
      status: json['status'] as String,
      reference: json['reference'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'method': method,
      'status': status,
      'reference': reference,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
