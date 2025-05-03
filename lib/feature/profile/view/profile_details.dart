import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_driver/feature/authentication/register/register.dart';
import 'package:freedom_driver/feature/driver/cubit/driver_cubit.dart';
import 'package:freedom_driver/feature/driver/cubit/driver_state.dart';
import 'package:freedom_driver/feature/driver/extension.dart';
import 'package:freedom_driver/feature/earnings/widgets/utility.dart';
import 'package:freedom_driver/shared/app_config.dart';
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
      final driverCubit = context.read<DriverCubit>();

      final driver = context.driver;
      if (driverCubit.state is! DriverLoaded && driver == null) {
        driverCubit.getDriverProfile(context);
      } else {
        nameController.text = driver?.fullName ?? '';
        emailController.text = driver?.email ?? '';
        phoneController.text = driver?.phone ?? '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: 'Profile Details',
      children: [
        TextFieldFactory(
          controller: nameController,
          hintText: 'John Doe',
          label: 'Full Name',
          prefixSvgUrl: getIconUrl('typing'),
          suffixIcon: EditButton(
            label: 'Edit Name',
            onTap: () {
              context
                  .read<DriverCubit>()
                  .requestNameUpdate(context, newFullName: nameController.text);
            },
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Full name is required';
            }
            if (value.trim().split(' ').length < 2) {
              return 'At least 2 names are required';
            }
            return null;
          },
        ),
        const VSpace(smallWhiteSpace + 5),
        TextFieldFactory(
          controller: emailController,
          hintText: 'email@freedomgh.com',
          label: 'Email',
          labelWidget: _verifiedBadge(),
          prefixSvgUrl: getIconUrl('envelope'),
          suffixIcon: EditButton(
            label: 'Change Email',
            onTap: () => context
                .read<DriverCubit>()
                .requestEmailUpdate(context, emailController.text),
          ),
          validator: (val) =>
              val == null || val.trim().isEmpty ? 'Email is required' : null,
        ),
        const VSpace(smallWhiteSpace + 5),
        TextFieldFactory(
          controller: phoneController,
          label: 'Phone Number',
          labelWidget: _verifiedBadge(),
          keyboardType: TextInputType.number,
          hintText: '+244-902-345-909',
          suffixIcon: EditButton(
            label: 'Change Number',
            onTap: () => context
                .read<DriverCubit>()
                .requestPhoneUpdate(context, phoneController.text),
          ),
          prefixSvgUrl: getIconUrl('numbers'),
          validator: (val) =>
              val == null || val.trim().isEmpty
              ? 'Phone number is required'
              : null,
        ),
      ],
    );
  }

  Widget _verifiedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: extraSmallWhiteSpace,
        horizontal: smallWhiteSpace + 5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffBFFF9F).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(roundedLg),
      ),
      child: Text(
        'Verified',
        style: TextStyle(
          fontSize: extraSmallText.sp,
          color: const Color(0xff52C01B),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class EditButton extends StatelessWidget {
  const EditButton({required this.label, super.key, this.onTap});
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(
          right: 10,
          top: extraSmallWhiteSpace,
          bottom: extraSmallWhiteSpace,
        ),
        padding: const EdgeInsets.all(extraSmallWhiteSpace),
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.edit,
              color: Colors.white,
              size: 18,
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: smallText),
            ),
          ],
        ),
      ),
    );
  }
}
