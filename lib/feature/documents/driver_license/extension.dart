import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/feature/documents/address_proof/cubit/address_details_state.dart';
import 'package:freedomdriver/feature/documents/cubit/document_image.dart';
import 'package:freedomdriver/feature/documents/cubit/document_image_state.dart';
import 'package:freedomdriver/feature/documents/driver_license/cubit/license_cubit.dart';
import 'package:freedomdriver/feature/documents/driver_license/driver_license.model.dart';


extension DriverExtension on BuildContext {
  DriverLicense? get driverLicense {
    final state = read<DriverLicenseDetailsCubit>().state;
    if (state is DriverLicenseDetailsLoaded) {
      return state.driverLicense;
    }
    return null;
  }

  File? get document {
    final state = read<DriverLicenseImageCubit>().state;
    if (state is DriverLicenseImageSelected) {
      return state.image;
    }
    return null;
  }
}
