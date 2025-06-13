import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/feature/home/view/widgets/rider_time_line.dart';
import 'package:freedomdriver/feature/rides/cubit/ride_history/ride_history_cubit.dart';
import 'package:freedomdriver/feature/rides/cubit/ride_history/ride_history_state.dart';
import 'package:freedomdriver/feature/rides/models/ride_history.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';
import 'package:freedomdriver/shared/widgets/app_icon.dart';
import 'package:freedomdriver/shared/widgets/custom_screen.dart';
import 'package:freedomdriver/utilities/responsive.dart';
import 'package:freedomdriver/utilities/ui.dart';

class RidesScreen extends StatefulWidget {
  const RidesScreen({super.key});

  @override
  State<RidesScreen> createState() => _RidesScreenState();
}

class _RidesScreenState extends State<RidesScreen> {
  RideTabEnum rideTabEnum = RideTabEnum.completed;

  @override
  void initState() {
    super.initState();
    context.read<RideHistoryCubit>().getAllRideHistories(context);
  }

  // void _onTabChanged(RideTabEnum tab) {
  //   setState(() {
  //     rideTabEnum = tab;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RideHistoryCubit, RideHistoryState>(
      builder: (context, state) {
        Widget content;

        if (state is RideHistoryError) {
          content = _ErrorContent(message: state.message);
        } else if (state is RideHistoryLoaded) {
          if (state.ride.count <= 0) {
            content = const _EmptyContent();
          } else {
            content = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // RideTab(onTabChanged: _onTabChanged, rideTabEnum: rideTabEnum),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal:
                          Responsive.isTablet(context)
                              ? whiteSpace
                              : smallWhiteSpace,
                      vertical: smallWhiteSpace,
                    ),
                    itemCount: state.ride.count,
                    itemBuilder: (context, index) {
                      return RidesTile(ride: state.ride.data[index]);
                    },
                  ),
                ),
              ],
            );
          }
        } else {
          content = const SizedBox();
        }

        return CustomScreen(
          title: 'Ride History',
          onRefresh:
              () =>
                  context.read<RideHistoryCubit>().refreshRideHistory(context),
          hasBackButton: false,
          differentUi: Expanded(child: content),
        );
      },
    );
  }
}

class RidesTile extends StatelessWidget {
  const RidesTile({super.key, required this.ride});

  final Ride ride;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: smallWhiteSpace),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            strokeAlign: BorderSide.strokeAlignOutside,
            color: Color(0xFFF5F5F5),
          ),
          borderRadius: BorderRadius.circular(roundedLg),
        ),
      ),
      child: RiderTimeLine(
        destinationDetails: ride.dropoffLocation.address,
        pickUpDetails: ride.pickupLocation.address,
        riderId: ride.id,
        currency: ride.currency,
        fare: ride.totalFare,
        status: ride.status,
      ),
    );
  }
}

enum RideTabEnum { cancelled, completed }

class RideTab extends StatelessWidget {
  const RideTab({
    required this.rideTabEnum,
    required this.onTabChanged,
    super.key,
  });

  final RideTabEnum rideTabEnum;
  final void Function(RideTabEnum) onTabChanged;

  Widget _buildTab({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    double fontSize = paragraphText,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 7,
          horizontal: medWhiteSpace,
        ),
        decoration: BoxDecoration(
          color: isSelected ? darkGoldColor : null,
          borderRadius: BorderRadius.circular(roundedMd),
          border: Border.all(
            color: isSelected ? Colors.transparent : darkGoldColor,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : darkGoldColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(whiteSpace),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTab(
            label: 'Completed',
            isSelected: rideTabEnum == RideTabEnum.completed,
            onTap: () => onTabChanged(RideTabEnum.completed),
          ),
          const SizedBox(width: 12),
          _buildTab(
            label: 'Cancelled',
            isSelected: rideTabEnum == RideTabEnum.cancelled,
            onTap: () => onTabChanged(RideTabEnum.cancelled),
          ),
        ],
      ),
    );
  }
}


class _ErrorContent extends StatelessWidget {
  const _ErrorContent({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Responsive.height(context) * 0.75,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Ride History',
            style: normalTextStyle.copyWith(color: redColor),
            textAlign: TextAlign.center,
          ),
          Text(
            message,
            style: descriptionTextStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _EmptyContent extends StatelessWidget {
  const _EmptyContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const AppIcon(iconName: 'no_ride_history'),
        const VSpace(extraSmallWhiteSpace),
        Text(
          'You have no cancelled Ride ',
          textAlign: TextAlign.center,
          style: headingTextStyle,
        ),
      ],
    );
  }
}
