import 'package:flutter/material.dart';
import 'package:freedomdriver/core/constants/documents.dart';
import 'package:freedomdriver/feature/documents/extension.dart';
import 'package:freedomdriver/feature/documents/widget/uploaded_document_image.dart';
import 'package:freedomdriver/feature/driver/extension.dart';
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
  State<MotorcycleImageScreen> createState() => _MotorcycleImageState();
}

class _MotorcycleImageState extends State<MotorcycleImageScreen> {
  @override
  Widget build(BuildContext context) {
    final documentUrl =
        context.driverDocument?.motorcycleImageHistory?.current.documentUrl;
    return CustomScreen(
      title: 'Motorcycle Information',
      bodyHeader: 'Update Your Motorcycle Image',
      bodyDescription:
          'Please provide image about your motorcycle. Keeping your information current helps us ensure your records are correct and improves your experience. click the Next button to submit motorcycle image.',
      children: [
        UploadedDocumentImage(
          heading: 'Uploaded Motorcycle Image',
          documentUrl: documentUrl,
        ),
        DecoratedContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MotorcycleDetailTile(
                title: 'Motorcycle Type',
                subtitle: context.driver?.motorcycleType,
              ),
              MotorcycleDetailTile(
                title: 'Motorcycle Color',
                subtitle: context.driver?.motorcycleColor,
              ),
              MotorcycleDetailTile(
                title: 'Motorcycle Number',
                subtitle: context.driver?.motorcycleNumber,
              ),
              MotorcycleDetailTile(
                title: 'Motorcycle Year',
                subtitle: context.driver?.motorcycleYear,
              ),

              const VSpace(whiteSpace),
              FreedomButton(
                onPressed: submitForm,
                useGradient: true,
                gradient: redLinearGradient,
                title: documentUrl != null ? 'Update Image' : 'Next',
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

class MotorcycleDetailTile extends StatelessWidget {
  const MotorcycleDetailTile({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(fontSize: smallText, color: Colors.grey),
      ),
      subtitle: Text(
        subtitle ?? 'Not provided',
        style: paragraphTextStyle.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
