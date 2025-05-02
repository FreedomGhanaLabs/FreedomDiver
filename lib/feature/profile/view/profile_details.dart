import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedom_driver/feature/authentication/register/register.dart';
import 'package:freedom_driver/feature/authentication/register/view/register_form_screen.dart';
import 'package:freedom_driver/feature/driver/cubit/driver_cubit.dart';
import 'package:freedom_driver/feature/driver/cubit/driver_state.dart';
import 'package:freedom_driver/shared/app_config.dart';
import 'package:freedom_driver/shared/widgets/app_icon.dart';
import 'package:freedom_driver/shared/widgets/custom_screen.dart';
import 'package:freedom_driver/utilities/ui.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({super.key});
  static const routeName = 'profileDetails';

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<DriverCubit>();
      if (cubit.state is! DriverLoaded) {
        cubit.getDriverProfile(context);
      } else {
        _setDriverFields(cubit.state);
      }
    });
  }

  void _setDriverFields(DriverState state) {
    if (state is DriverLoaded) {
      final driver = state.driver;
      nameController.text = driver.fullName;
      emailController.text = driver.email;
      phoneController.text = driver.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverCubit, DriverState>(
      builder: (context, state) {
        if (state is DriverLoaded) {
          _setDriverFields(state);
        }
        return CustomScreen(
          children: [
            buildTextField(
              controller: nameController,
              label: 'Full Name',
              placeholder: 'Enter your full name',
            ),
            const VSpace(smallWhiteSpace),
            Row(
              children: [
                const Text(
                  'Email',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: paragraphText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const HSpace(10),
                _verifiedBadge(),
              ],
            ),
            TextFieldFactory(
              controller: emailController,
              fillColor: Colors.white,
              hintText: 'email@freedomgh.com',
            ),
            const VSpace(smallWhiteSpace),
            Row(
              children: [
                const Text(
                  'Phone Number',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13.09,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const HSpace(10),
                _verifiedBadge(),
              ],
            ),
            TextFieldFactory.phone(
              controller: phoneController,
              fillColor: Colors.white,
              hintText: '+244-902-345-909',
              fontStyle: const TextStyle(),
              focusedBorderColor: Colors.black,
              enabledColorBorder: const Color(0xFFE1E1E1),
              suffixIcon: _editPhoneButton(),
              prefixText: _phonePrefix(),
              hintTextStyle: const TextStyle(),
            ),
          ],
        );
      },
    );
  }

  Widget _verifiedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xffBFFF9F),
        borderRadius: BorderRadius.circular(roundedFull),
      ),
      child: const Text(
        'Verified',
        style: TextStyle(
          fontSize: extraSmallText,
          color: Color(0xff52C01B),
        ),
      ),
    );
  }

  Widget _editPhoneButton() {
    return Container(
      margin: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.edit,
            color: Colors.white,
            size: 18,
          ),
          Text(
            'Change Number',
            style: TextStyle(color: Colors.white, fontSize: smallText),
          ),
        ],
      ),
    );
  }

  Widget _phonePrefix() {
    return Container(
      height: 20,
      width: 20,
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(left: 10, top: 9, bottom: 9, right: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Color(0xffFFF7BC),
      ),
      child: const AppIcon(iconName: 'phone_numbers'),
    );
  }
}
