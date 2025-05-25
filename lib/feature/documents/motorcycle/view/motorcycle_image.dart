import 'package:flutter/material.dart';
import 'package:freedomdriver/core/constants/documents.dart';
import 'package:freedomdriver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';
import 'package:freedomdriver/shared/widgets/custom_screen.dart';
import 'package:freedomdriver/shared/widgets/decorated_container.dart';
import 'package:freedomdriver/shared/widgets/primary_button.dart';
import 'package:freedomdriver/utilities/ui.dart';

class MotorcycleImageScreen extends StatefulWidget {
  const MotorcycleImageScreen({super.key});
  static const routeName = '/motorcycle-image';

  @override
  State<MotorcycleImageScreen> createState() => _AddressProofFormState();
}

class _AddressProofFormState extends State<MotorcycleImageScreen> {

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: 'Motorcycle Information',
      bodyHeader: 'Update Your Motorcycle Image',
      bodyDescription:
          'Please provide image about your motorcycle. Keeping your information current helps us ensure your records are correct and improves your experience. click the Next button to submit motorcycle image.',
      children: [
        DecoratedContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
      ],
    );
  }

  void submitForm() {
    Navigator.pushNamed(
      context,
      BackgroundVerificationScreen.routeName,
      arguments: {'type': motorCycle},
    );
  }
}
