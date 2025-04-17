part of 'registration_cubit.dart';

class RegistrationFormState extends Equatable {
  const RegistrationFormState({
    this.phoneNumber = '',
    this.driversEmail = '',
    this.driversName = '',
    this.motorcycleType = '',
    this.motorcycleColor = '',
    this.licenseNumber = '',
    this.motorcycleNumber = '',
    this.motorcycleYear = '',
    this.address = '',
    this.password = '',
    this.profilePicture = '',
    this.formStatus = FormStatus.initial,
  });

  factory RegistrationFormState.fromJson(Map<String, dynamic> json) {
    return RegistrationFormState(
      phoneNumber: json['phone'] as String? ?? '',
      driversName: json['name'] as String? ?? '',
      driversEmail: json['email'] as String? ?? '',
      motorcycleType: json['motorcycleType'] as String? ?? '',
      motorcycleColor: json['motorcycleColor'] as String? ?? '',
      licenseNumber: json['licenseNumber'] as String? ?? '',
      motorcycleNumber: json['motorcycleNumber'] as String? ?? '',
      motorcycleYear: json['motorcycleYear'] as String? ?? '',
      address: json['address'] as String? ?? '',
      password: json['password'] as String? ?? '',
      profilePicture: json['profilePicture'] as String? ?? '',
    );
  }

  final String phoneNumber;
  final String driversName;
  final String driversEmail;
  final String motorcycleType;
  final String motorcycleColor;
  final String licenseNumber;
  final String motorcycleNumber;
  final String motorcycleYear;
  final String address;
  final String password;
  final String profilePicture;
  final FormStatus formStatus;

  RegistrationFormState copyWith({
    String? phoneNumber,
    String? driversName,
    String? driversEmail,
    String? motorcycleType,
    String? motorcycleColor,
    String? licenseNumber,
    String? motorcycleNumber,
    String? motorcycleYear,
    String? address,
    String? password,
    FormStatus? formStatus,
    String? profilePicture
  }) {
    return RegistrationFormState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      driversEmail: driversEmail ?? this.driversEmail,
      driversName: driversName ?? this.driversName,
      motorcycleType: motorcycleType ?? this.motorcycleType,
      motorcycleColor: motorcycleColor ?? this.motorcycleColor,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      motorcycleNumber: motorcycleNumber ?? this.motorcycleNumber,
      motorcycleYear: motorcycleYear ?? this.motorcycleYear,
      address: address ?? this.address,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
      profilePicture: profilePicture ?? this.profilePicture
    );
  }

  @override
  List<Object> get props => [
    phoneNumber,
    driversEmail,
    driversName,
    motorcycleType,
    motorcycleColor,
    licenseNumber,
    motorcycleNumber,
    motorcycleYear,
    address,
    password,
    formStatus,
    profilePicture
  ];

  Map<String, dynamic> toJson() => {
    'phone': phoneNumber,
    'name': driversName,
    'email': driversEmail,
    'motorcycleType': motorcycleType,
    'motorcycleColor': motorcycleColor,
    'licenseNumber': licenseNumber,
    'motorcycleNumber': motorcycleNumber,
    'motorcycleYear': motorcycleYear,
    'address': address,
    'password': password,
    'profilePicture': profilePicture
  };
}

enum FormStatus { initial, submitting, success, failure }