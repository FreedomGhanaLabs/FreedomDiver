import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedom_driver/feature/documents/driver_license/cubit/license_details_state.dart';
import 'package:freedom_driver/feature/documents/driver_license/driver_license.model.dart';

class DriverLicenseDetailsCubit extends Cubit<DriverLicenseDetailsState> {
  DriverLicenseDetailsCubit() : super(DriverLicenseDetailsInitial());

  // ------ Set Driver License Details ------
  void setDriverLicenseDetails({
    required String licenseNumber,
    required String dob,
    required String licenseClass,
    required String issueDate,
    required String expiryDate,
  }) {
    final driverLicense = DriverLicense(
      licenseNumber: licenseNumber,
      dob: dob,
      licenseClass: licenseClass,
      issueDate: issueDate,
      expiryDate: expiryDate,
      documentUrl: '',
      verificationStatus: '',
      adminComments: '',
      uploadedAt: DateTime.now(),
    );

    emit(DriverLicenseDetailsLoaded(driverLicense));
  }
}
