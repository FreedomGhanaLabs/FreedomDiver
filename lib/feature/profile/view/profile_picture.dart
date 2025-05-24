import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/feature/driver/cubit/driver_cubit.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/widgets/custom_screen.dart';
import 'package:freedomdriver/utilities/ui.dart';

import '../../driver/cubit/driver_state.dart';

class ProfilePictureScreen extends StatelessWidget {
  const ProfilePictureScreen({super.key});
  static const String routeName = '/profile-picture';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverCubit, DriverState>(
      builder: (context, state) {
        final driver = (state is DriverLoaded) ? state.driver : null;
        return CustomScreen(
          title: driver?.fullName ?? '',
          children: [
            VSpace(normalWhiteSpace),
            ClipRRect(
              borderRadius: BorderRadius.circular(roundedLg),
              child: CachedNetworkImage(
                imageUrl: driver?.profilePicture ?? '',
                placeholder: (context, url) => const CircularProgressIndicator(),
              ),
            ),
          ],
        );
      },
    );
  }
}
