import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/feature/documents/address_proof/cubit/address_details_state.dart';
import 'package:freedomdriver/feature/documents/driver_license/driver_license.model.dart';


class AddressDetailsCubit extends Cubit<DriverLicenseDetailsState> {
  AddressDetailsCubit() : super(DriverLicenseDetailsInitial());

  // ------ Set address Details ------
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

    emit(DriverLicenseLoaded(driverLicense));
  }
}
