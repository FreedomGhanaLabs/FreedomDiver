

import 'package:freedomdriver/feature/documents/driver_license/driver_license.model.dart';

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

class DriverVerification {
  DriverVerification({
    required this.overallStatus,
    this.driverLicense,
    this.ghanaCard,
    this.profilePicture,
    this.motorcycleImage,
    this.addressProof,
  });

  // fromJson method
  factory DriverVerification.fromJson(Map<String, dynamic> json) {
    return DriverVerification(
      overallStatus: json['overallStatus'] as String,
      driverLicense: json['driverLicense'] != null
          ? DriverLicense.fromJson(
              json['driverLicense'] as Map<String, dynamic>,)
          : null,
      ghanaCard: json['ghanaCard'] as String?,
      profilePicture: json['profilePicture'] != null
          ? ProfilePicture.fromJson(
              json['profilePicture'] as Map<String, dynamic>,)
          : null,
      motorcycleImage: json['motorcycleImage'] as String?,
      addressProof: json['addressProof'] as String?,
    );
  }
  String overallStatus;
  DriverLicense? driverLicense;
  String? ghanaCard;
  ProfilePicture? profilePicture;
  String? motorcycleImage;
  String? addressProof;

  // CopyWith method
  DriverVerification copyWith({
    String? overallStatus,
    DriverLicense? driverLicense,
    String? ghanaCard,
    ProfilePicture? profilePicture,
    String? motorcycleImage,
    String? addressProof,
  }) {
    return DriverVerification(
      overallStatus: overallStatus ?? this.overallStatus,
      driverLicense: driverLicense ?? this.driverLicense,
      ghanaCard: ghanaCard ?? this.ghanaCard,
      profilePicture: profilePicture ?? this.profilePicture,
      motorcycleImage: motorcycleImage ?? this.motorcycleImage,
      addressProof: addressProof ?? this.addressProof,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'overallStatus': overallStatus,
      'driverLicense': driverLicense?.toJson(),
      'ghanaCard': ghanaCard,
      'profilePicture': profilePicture?.toJson(),
      'motorcycleImage': motorcycleImage,
      'addressProof': addressProof,
    };
  }
}

class ProfilePicture {
  ProfilePicture({
    required this.documentUrl,
    required this.verificationStatus,
    required this.adminComments,
    required this.uploadedAt,
    required this.verifiedAt,
  });

  // fromJson method
  factory ProfilePicture.fromJson(Map<String, dynamic> json) {
    return ProfilePicture(
      documentUrl: json['documentUrl'] as String, // Explicit cast to String
      verificationStatus: json['verificationStatus'] as String,
      adminComments: json['adminComments'] as String,
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
      verifiedAt: DateTime.parse(json['verifiedAt'] as String),
    );
  }
  String documentUrl;
  String verificationStatus;
  String adminComments;
  DateTime uploadedAt;
  DateTime verifiedAt;

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'documentUrl': documentUrl,
      'verificationStatus': verificationStatus,
      'adminComments': adminComments,
      'uploadedAt': uploadedAt.toIso8601String(),
      'verifiedAt': verifiedAt.toIso8601String(),
    };
  }
}
