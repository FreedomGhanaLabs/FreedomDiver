import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedom_driver/feature/authentication/register/register.dart';
import 'package:freedom_driver/feature/documents/driver_license/cubit/license_cubit.dart';
import 'package:freedom_driver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedom_driver/shared/app_config.dart';
import 'package:freedom_driver/shared/theme/app_colors.dart';
import 'package:freedom_driver/shared/widgets/custom_drop_down_button.dart';
import 'package:freedom_driver/shared/widgets/custom_screen.dart';
import 'package:freedom_driver/shared/widgets/decorated_container.dart';
import 'package:freedom_driver/shared/widgets/primary_button.dart';
import 'package:freedom_driver/utilities/ui.dart';

class AddressProofForm extends StatefulWidget {
  const AddressProofForm({super.key});
  static const routeName = '/address-proof';

  @override
  State<AddressProofForm> createState() => _AddressProofFormState();
}

class _AddressProofFormState extends State<AddressProofForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController documentType = TextEditingController();
  final TextEditingController licenseNumber = TextEditingController();
  final TextEditingController classOfLicense = TextEditingController();

  Widget buildField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: paragraphText,
          ),
        ),
        const VSpace(extraSmallWhiteSpace),
        TextFieldFactory.itemField(
          controller: controller,
          fillColor: Colors.white,
          enabledBorderColor: Colors.black.withValues(alpha: 0.2),
          validator: (val) {
            return val == null || val.trim().isEmpty
                ? '$label is required'
                : null;
          },
        ),
        const VSpace(smallWhiteSpace),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: 'Proof of Address',
      bodyHeader: 'Keep your Address information up-to-date',
      bodyDescription:
          'If you change home address or any relevant details, update the information here to maintain accuracy and transparency.',
      children: [
        DecoratedContainer(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                buildField('License Number', licenseNumber),
                const CustomDropDown(
                  label: 'Date of Birth',
                  value: 'Choose date',
                ),
                buildField('Class of License', classOfLicense),
                const CustomDropDown(
                  label: 'Issue Date',
                  value: 'Choose date',
                ),
                const CustomDropDown(
                  label: 'Expiry Date',
                  value: 'Choose date',
                ),
                const VSpace(smallWhiteSpace),
                FreedomButton(
                  onPressed: submitForm,
                  useGradient: true,
                  gradient: redLinearGradient,
                  title: 'Next',
                  buttonTitle: const Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: paragraphText,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<DriverLicenseDetailsCubit>();

      Navigator.pushNamed(context, BackgroundVerificationScreen.routeName);
    }
  }
}
