class Earning {

  Earning({
    required this.totalRideEarnings,
    required this.totalRideFares,
    required this.completedRides,
    required this.byPaymentMethod,
    required this.pendingPayments,
    this.financialAccount,
  });

  factory Earning.fromJson(Map<String, dynamic> json) {
    return Earning(
      totalRideEarnings: double.parse(json['totalRideEarnings'].toString()) ,
      totalRideFares: double.parse(json['totalRideFares'].toString())  ,
      completedRides: int.parse(json['completedRides'].toString()) ,
      byPaymentMethod: Map<String, double>.from(
        (json['byPaymentMethod'] as Map<dynamic, dynamic>).map(
          (key, value) => MapEntry(key, double.parse(value.toString()) ),
        ),
      ),
      pendingPayments: double.parse(json['pendingPayments'].toString()) ,
      financialAccount: json['financialAccount'].toString(),
    );
  }
  final double totalRideEarnings;
  final double totalRideFares;
  final int completedRides;
  final Map<String, double> byPaymentMethod;
  final double pendingPayments;
  final String? financialAccount;

  Map<String, dynamic> toJson() {
    return {
      'totalRideEarnings': totalRideEarnings,
      'totalRideFares': totalRideFares,
      'completedRides': completedRides,
      'byPaymentMethod': byPaymentMethod,
      'pendingPayments': pendingPayments,
      'financialAccount': financialAccount,
    };
  }
}
