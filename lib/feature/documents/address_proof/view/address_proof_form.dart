import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedomdriver/core/constants/documents.dart';
import 'package:freedomdriver/feature/authentication/register/view/register_form_screen.dart';
import 'package:freedomdriver/feature/driver/cubit/driver_cubit.dart';
import 'package:freedomdriver/feature/driver/cubit/driver_state.dart';
import 'package:freedomdriver/feature/driver/extension.dart';
import 'package:freedomdriver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';
import 'package:freedomdriver/shared/widgets/custom_screen.dart';
import 'package:freedomdriver/shared/widgets/decorated_container.dart';
import 'package:freedomdriver/shared/widgets/primary_button.dart';
import 'package:freedomdriver/utilities/ui.dart';

class AddressProofForm extends StatefulWidget {
  const AddressProofForm({super.key});
  static const routeName = '/address-proof';

  @override
  State<AddressProofForm> createState() => _AddressProofFormState();
}

class _AddressProofFormState extends State<AddressProofForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final postalCodeController = TextEditingController();

  String countryValue = '';
  String stateValue = '';
  String cityValue = '';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final driverCubit = context.read<DriverCubit>();
      final address = context.driver?.address;

      if (driverCubit.state is! DriverLoaded && address == null) {
        await driverCubit.getDriverProfile(context);
      }

      countryValue = address?.country ?? '';
      stateValue = address?.state ?? '';
      cityValue = address?.city ?? '';
      postalCodeController.text = address?.postalCode ?? '';
    });

    super.initState();
  }

  @override
  void dispose() {
    postalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: 'Address Information',
      bodyHeader: 'Keep your Address information up-to-date',
      bodyDescription:
          'If you change home address or any relevant details, update the information here to maintain accuracy and transparency. If your current address provided during registration, please click the Next button',
      children: [
        DecoratedContainer(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Your Current Address',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: normalText.sp,
                  ),
                ),
                Text(
                  '${context.driver?.address.street}, ${context.driver?.address.city} ${context.driver?.address.state} ${context.driver?.address.country}.'
                      .trim(),
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: smallText.sp,
                    color: Colors.black54,
                  ),
                ),
                SelectState(
                  dropdownColor: Colors.white,
                  onCountryChanged: (value) {
                    setState(() {
                      countryValue = value;
                    });
                  },
                  onStateChanged: (value) {
                    setState(() {
                      stateValue = value;
                    });
                  },
                  onCityChanged: (value) {
                    setState(() {
                      cityValue = value;
                    });
                  },
                ),
                buildTextField(
                  controller: postalCodeController,
                  label: 'Postal Code',
                  prefixIconUrl: 'assets/app_icons/numbers.svg',
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
      context.read<DriverCubit>().updateDriverAddress(
            city: cityValue,
            country: countryValue,
            state: stateValue,
            street: context.driver!.address.street,
            postalCode: postalCodeController.text.trim(),
          );

      Navigator.pushNamed(
        context,
        BackgroundVerificationScreen.routeName,
        arguments: {'type': address},
      );
    }
  }
}
