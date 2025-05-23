class GhanaCard {
  GhanaCard({
    required this.personalIdNumber,
    required this.surname,
    required this.firstName,
    required this.otherName,
    required this.sex,
    required this.dateOfBirth,
    required this.height,
    required this.expiryDate,
    required this.verificationStatus,
    required this.adminComments,
    required this.uploadedAt,
    this.verifiedAt,
  });

  factory GhanaCard.fromJson(Map<String, dynamic> json) {
    return GhanaCard(
      personalIdNumber: json['personalIdNumber'] ?? '',
      surname: json['surname'] ?? '',
      firstName: json['firstName'] ?? '',
      otherName: json['otherName'] ?? '',
      sex: json['sex'] ?? '',
      dateOfBirth: json['dateOfBirth'],
      height: json['height'] ?? '',
      expiryDate: json['expiryDate'],
      verificationStatus: json['verificationStatus'] ?? '',
      adminComments: json['adminComments'] ?? '',
      uploadedAt: DateTime.parse(json['uploadedAt']),
      verifiedAt:
          json['verifiedAt'] != null
              ? DateTime.parse(json['verifiedAt'])
              : null,
    );
  }

  String personalIdNumber;
  String surname;
  String firstName;
  String otherName;
  String sex;
  String? dateOfBirth;
  String height;
  String? expiryDate;
  String verificationStatus;
  String adminComments;
  DateTime uploadedAt;
  DateTime? verifiedAt;

  Map<String, dynamic> toJson() {
    return {
      'personalIdNumber': personalIdNumber,
      'surname': surname,
      'firstName': firstName,
      'otherName': otherName,
      'sex': sex,
      'dateOfBirth': dateOfBirth,
      'height': height,
      'expiryDate': expiryDate,
      'verificationStatus': verificationStatus,
      'adminComments': adminComments,
      'uploadedAt': uploadedAt.toIso8601String(),
      'verifiedAt': verifiedAt?.toIso8601String(),
    };
  }

  GhanaCard copyWith({
    String? personalIdNumber,
    String? surname,
    String? firstName,
    String? otherName,
    String? sex,
    String? dateOfBirth,
    String? height,
    String? expiryDate,
    String? verificationStatus,
    String? adminComments,
    DateTime? uploadedAt,
    DateTime? verifiedAt,
  }) {
    return GhanaCard(
      personalIdNumber: personalIdNumber ?? this.personalIdNumber,
      surname: surname ?? this.surname,
      firstName: firstName ?? this.firstName,
      otherName: otherName ?? this.otherName,
      sex: sex ?? this.sex,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      height: height ?? this.height,
      expiryDate: expiryDate ?? this.expiryDate,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      adminComments: adminComments ?? this.adminComments,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      verifiedAt: verifiedAt ?? this.verifiedAt,
    );
  }
}
