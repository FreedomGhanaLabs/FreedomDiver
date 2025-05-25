enum DriverDocumentType {
  driverLicense,
  ghanaCard,
  profilePicture,
  motorcycleImage,
  addressProof,
}

extension DriverDocumentTypeExtension on DriverDocumentType {
  String get name {
    switch (this) {
      case DriverDocumentType.driverLicense:
        return 'driverLicense';
      case DriverDocumentType.ghanaCard:
        return 'ghanaCard';
      case DriverDocumentType.profilePicture:
        return 'profilePicture';
      case DriverDocumentType.motorcycleImage:
        return 'motorcycleImage';
      case DriverDocumentType.addressProof:
        return 'addressProof';
    }
  }

  static DriverDocumentType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'driverlicense':
        return DriverDocumentType.driverLicense;
      case 'ghanacard':
        return DriverDocumentType.ghanaCard;
      case 'profilepicture':
        return DriverDocumentType.profilePicture;
      case 'motorcycleimage':
        return DriverDocumentType.motorcycleImage;
      case 'addressproof':
        return DriverDocumentType.addressProof;
      default:
        throw ArgumentError('Invalid DriverDocumentType: $value');
    }
  }
}

class DriverDocument {
  final String overallStatus;
  final DocumentDetail? driverLicense;
  final DocumentHistory? driverLicenseHistory;
  final SimpleDocument? ghanaCard;
  final DocumentHistory? ghanaCardHistory;
  final SimpleDocument? profilePicture;
  final DocumentHistory? profilePictureHistory;
  final SimpleDocument? motorcycleImage;
  final DocumentHistory? motorcycleImageHistory;
  final AddressProof? addressProof;
  final DocumentHistory? addressProofHistory;

  DriverDocument({
    required this.overallStatus,
    this.driverLicense,
    this.ghanaCard,
    this.profilePicture,
    this.motorcycleImage,
    this.addressProof,
    this.driverLicenseHistory,
    this.ghanaCardHistory,
    this.profilePictureHistory,
    this.motorcycleImageHistory,
    this.addressProofHistory,
  });

  factory DriverDocument.fromJson(Map<String, dynamic> json) {
    return DriverDocument(
      overallStatus: json['overallStatus'],
      driverLicense:
          json['driverLicense'] != null
              ? DocumentDetail.fromJson(json['driverLicense'])
              : null,
      ghanaCard:
          json['ghanaCard'] != null
              ? SimpleDocument.fromJson(json['ghanaCard'])
              : null,
      profilePicture:
          json['profilePicture'] != null
              ? SimpleDocument.fromJson(json['profilePicture'])
              : null,
      motorcycleImage:
          json['motorcycleImage'] != null
              ? SimpleDocument.fromJson(json['motorcycleImage'])
              : null,
      addressProof:
          json['addressProof'] != null
              ? AddressProof.fromJson(json['addressProof'])
              : null,
    );
  }

  DriverDocument copyWith({
    String? overallStatus,
    DocumentDetail? driverLicense,
    DocumentHistory? driverLicenseHistory,
    SimpleDocument? ghanaCard,
    DocumentHistory? ghanaCardHistory,
    SimpleDocument? profilePicture,
    DocumentHistory? profilePictureHistory,
    SimpleDocument? motorcycleImage,
    DocumentHistory? motorcycleImageHistory,
    AddressProof? addressProof,
    DocumentHistory? addressProofHistory,
  }) {
    return DriverDocument(
      overallStatus: overallStatus ?? this.overallStatus,
      driverLicense: driverLicense ?? this.driverLicense,
      driverLicenseHistory: driverLicenseHistory ?? this.driverLicenseHistory,
      ghanaCard: ghanaCard ?? this.ghanaCard,
      ghanaCardHistory: ghanaCardHistory ?? this.ghanaCardHistory,
      profilePicture: profilePicture ?? this.profilePicture,
      profilePictureHistory:
          profilePictureHistory ?? this.profilePictureHistory,
      motorcycleImage: motorcycleImage ?? this.motorcycleImage,
      motorcycleImageHistory:
          motorcycleImageHistory ?? this.motorcycleImageHistory,
      addressProof: addressProof ?? this.addressProof,
      addressProofHistory: addressProofHistory ?? this.addressProofHistory,
    );
  }

  Map<String, dynamic> toJson() => {
    'overallStatus': overallStatus,
    'driverLicense': driverLicense?.toJson(),
    'ghanaCard': ghanaCard?.toJson(),
    'profilePicture': profilePicture?.toJson(),
    'motorcycleImage': motorcycleImage?.toJson(),
    'addressProof': addressProof?.toJson(),
  };
}

class DocumentDetail {
  final String documentUrl;
  final String licenseNumber;
  final String verificationStatus;
  final String? adminComments;
  final DateTime uploadedAt;
  final DateTime? verifiedAt;

  DocumentDetail({
    required this.documentUrl,
    required this.licenseNumber,
    required this.verificationStatus,
    this.adminComments,
    required this.uploadedAt,
    this.verifiedAt,
  });

  factory DocumentDetail.fromJson(Map<String, dynamic> json) {
    return DocumentDetail(
      documentUrl: json['documentUrl'],
      licenseNumber: json['licenseNumber'],
      verificationStatus: json['verificationStatus'],
      adminComments: json['adminComments'],
      uploadedAt: DateTime.parse(json['uploadedAt']),
      verifiedAt:
          json['verifiedAt'] != null
              ? DateTime.parse(json['verifiedAt'])
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'documentUrl': documentUrl,
    'licenseNumber': licenseNumber,
    'verificationStatus': verificationStatus,
    'adminComments': adminComments,
    'uploadedAt': uploadedAt.toIso8601String(),
    'verifiedAt': verifiedAt?.toIso8601String(),
  };
}

class SimpleDocument {
  final String verificationStatus;
  final String? adminComments;
  final DateTime uploadedAt;

  SimpleDocument({
    required this.verificationStatus,
    this.adminComments,
    required this.uploadedAt,
  });

  factory SimpleDocument.fromJson(Map<String, dynamic> json) {
    return SimpleDocument(
      verificationStatus: json['verificationStatus'],
      adminComments: json['adminComments'],
      uploadedAt: DateTime.parse(json['uploadedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'verificationStatus': verificationStatus,
    'adminComments': adminComments,
    'uploadedAt': uploadedAt.toIso8601String(),
  };
}

class AddressProof {
  final String documentUrl;
  final String addressType;
  final String street;
  final String city;
  final String state;
  final String country;
  final String postalCode;
  final String verificationStatus;
  final String? adminComments;
  final DateTime uploadedAt;
  final DateTime? verifiedAt;

  AddressProof({
    required this.documentUrl,
    required this.addressType,
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    required this.verificationStatus,
    this.adminComments,
    required this.uploadedAt,
    this.verifiedAt,
  });

  factory AddressProof.fromJson(Map<String, dynamic> json) {
    return AddressProof(
      documentUrl: json['documentUrl'],
      addressType: json['addressType'],
      street: json['street'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      postalCode: json['postalCode'],
      verificationStatus: json['verificationStatus'],
      adminComments: json['adminComments'],
      uploadedAt: DateTime.parse(json['uploadedAt']),
      verifiedAt:
          json['verifiedAt'] != null
              ? DateTime.parse(json['verifiedAt'])
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'documentUrl': documentUrl,
    'addressType': addressType,
    'street': street,
    'city': city,
    'state': state,
    'country': country,
    'postalCode': postalCode,
    'verificationStatus': verificationStatus,
    'adminComments': adminComments,
    'uploadedAt': uploadedAt.toIso8601String(),
    'verifiedAt': verifiedAt?.toIso8601String(),
  };
}

class DocumentHistory {
  final String documentType;
  final HDocument current;
  final List<HDocument> history;

  DocumentHistory({
    required this.documentType,
    required this.current,
    required this.history,
  });

  factory DocumentHistory.fromJson(Map<String, dynamic> json) {
    return DocumentHistory(
      documentType: json['documentType'].toString(),
      current: HDocument.fromJson(json['current']),
      history:
          (json['history'] as List)
              .map((item) => HDocument.fromJson(item))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'documentType': documentType,
      'current': current.toJson(),
      'history': history.map((item) => item.toJson()).toList(),
    };
  }
}

class HDocument {
  final String documentUrl;
  final String verificationStatus;
  final DateTime uploadedAt;
  final DateTime? verifiedAt;
  final String? adminComments;

  HDocument({
    required this.documentUrl,
    required this.verificationStatus,
    required this.uploadedAt,
    this.verifiedAt,
    this.adminComments,
  });

  factory HDocument.fromJson(Map<String, dynamic> json) {
    return HDocument(
      documentUrl: json['documentUrl'].toString(),
      verificationStatus: json['verificationStatus'].toString(),
      uploadedAt: DateTime.parse(json['uploadedAt']),
      verifiedAt:
          json['verifiedAt'] != null
              ? DateTime.tryParse(json['verifiedAt'])
              : null,
      adminComments: json['adminComments'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'documentUrl': documentUrl,
      'verificationStatus': verificationStatus,
      'uploadedAt': uploadedAt.toIso8601String(),
      'verifiedAt': verifiedAt?.toIso8601String(),
      'adminComments': adminComments,
    };
  }
}
