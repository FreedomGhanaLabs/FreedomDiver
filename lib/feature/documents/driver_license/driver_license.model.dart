class DriverLicense {
  DriverLicense({
    required this.documentUrl,
    required this.licenseNumber,
    required this.verificationStatus,
    required this.adminComments,
    required this.uploadedAt,
    this.dob,
    this.licenseClass,
    this.issueDate,
    this.expiryDate,
    this.verifiedAt,
  });

  factory DriverLicense.fromJson(Map<String, dynamic> json) {
    return DriverLicense(
      dob: json['dob'] as String? ?? '',
      licenseClass: json['licenseClass'] as String? ?? '',
      issueDate: json['issueDate'] as String? ?? '',
      expiryDate: json['expiryDate'] as String? ?? '',
      documentUrl: json['documentUrl'] as String,
      licenseNumber: json['licenseNumber'] as String,
      verificationStatus: json['verificationStatus'] as String,
      adminComments: json['adminComments'] as String,
      uploadedAt: DateTime.parse(
        json['uploadedAt'] as String,
      ),
      verifiedAt: json['verifiedAt'] != null
          ? DateTime.parse(json['verifiedAt'] as String)
          : null,
    );
  }
  String documentUrl;
  String licenseNumber;
  String verificationStatus;
  String adminComments;
  DateTime uploadedAt;
  DateTime? verifiedAt;
  String? dob;
  String? licenseClass;
  String? issueDate;
  String? expiryDate;

  Map<String, dynamic> toJson() {
    return {
      'documentUrl': documentUrl,
      'licenseNumber': licenseNumber,
      'verificationStatus': verificationStatus,
      'adminComments': adminComments,
      'uploadedAt': uploadedAt.toIso8601String(),
      'verifiedAt': verifiedAt?.toIso8601String(),
      'dob': dob,
      'licenseClass': licenseClass,
      'issueDate': issueDate,
      'expiryDate': expiryDate,
    };
  }

  DriverLicense copyWith({
    String? licenseNumber,
    String? dob,
    String? licenseClass,
    String? issueDate,
    String? expiryDate,
    String? documentUrl,
    String? verificationStatus,
    String? adminComments,
    DateTime? uploadedAt,
  }) {
    return DriverLicense(
      licenseNumber: licenseNumber ?? this.licenseNumber,
      dob: dob ?? this.dob,
      licenseClass: licenseClass ?? this.licenseClass,
      issueDate: issueDate ?? this.issueDate,
      expiryDate: expiryDate ?? this.expiryDate,
      documentUrl: documentUrl ?? this.documentUrl,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      adminComments: adminComments ?? this.adminComments,
      uploadedAt: DateTime.now(),
    );
  }
}
