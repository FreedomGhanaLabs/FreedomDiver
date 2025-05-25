import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/feature/documents/address_proof/view/address_proof_form.dart';
import 'package:freedomdriver/feature/documents/cubit/driver_document_cubit.dart';
import 'package:freedomdriver/feature/documents/cubit/driver_document_state.dart';
import 'package:freedomdriver/feature/documents/driver_license/view/license_form.dart';
import 'package:freedomdriver/feature/documents/ghana_card/view/ghana_card_form.dart';
import 'package:freedomdriver/feature/documents/motorcycle/view/motorcycle_image.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/widgets/utility.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/widgets/custom_screen.dart';
import 'package:freedomdriver/utilities/ui.dart';
import 'package:get/get_utils/get_utils.dart';

class DebtManagementScreen extends StatefulWidget {
  const DebtManagementScreen({super.key});
  static const routeName = '/debt-management';

  @override
  State<DebtManagementScreen> createState() =>
      _DebtManagementScreenState();
}

class _DebtManagementScreenState extends State<DebtManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentCubit, DocumentState>(
      builder: (context, state) {
        final document = state is DocumentLoaded ? state.document : null;
        return CustomScreen(
          title: 'Debt Management',
          bodyHeader: 'Keep your details accurate',
          bodyDescription:
              'If you change your Motorcycle or any relevant details, update the information here to maintain accuracy and transparency.',
          children: [
            ManageDocuments(
              padding: EdgeInsets.zero,
              addressStatus:
                  document?.addressProof?.verificationStatus.capitalize,
              ghanaCardStatus:
                  document?.ghanaCard?.verificationStatus.capitalize,
              licenseStatus:
                  document?.driverLicense?.verificationStatus.capitalize,
              motorcycleStatus:
                  document?.motorcycleImage?.verificationStatus.capitalize,
              onLicenseTap:
                  () =>
                      Navigator.pushNamed(context, DriverLicenseForm.routeName),
              onAddressTap:
                  () =>
                      Navigator.pushNamed(context, AddressProofForm.routeName),
              onGhanaCardTap:
                  () => Navigator.pushNamed(context, GhanaCardForm.routeName),
                  onMotorcycleImageTap:  () => Navigator.pushNamed(context, MotorcycleImageScreen .routeName),
            ),

            const VSpace(whiteSpace),
          ],
        );
      },
    );
  }
}
