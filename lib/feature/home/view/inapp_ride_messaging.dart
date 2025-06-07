import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/feature/documents/driver_license/view/license_form.dart';
import 'package:freedomdriver/feature/driver/extension.dart';
import 'package:freedomdriver/feature/rides/cubit/ride/ride_cubit.dart';
import 'package:freedomdriver/feature/rides/cubit/ride/ride_state.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';
import 'package:freedomdriver/shared/widgets/app_icon.dart';
import 'package:freedomdriver/shared/widgets/custom_screen.dart';
import 'package:freedomdriver/shared/widgets/decorated_container.dart';
import 'package:freedomdriver/shared/widgets/primary_button.dart';
import 'package:freedomdriver/utilities/responsive.dart';
import 'package:freedomdriver/utilities/ui.dart';

import '../../messaging/message_cubit.dart';
import '../../messaging/models/message.dart';

class InappRideMessaging extends StatefulWidget {
  const InappRideMessaging({super.key});
  static const routeName = '/inapp-ride-messaging';

  @override
  State<InappRideMessaging> createState() => _InappRideMessagingState();
}

class _InappRideMessagingState extends State<InappRideMessaging> {
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    context.read<MessageCubit>().loadMessages();
    super.initState();
  }

  void _sendMessage() {
    final content = messageController.text.trim();
    if (content.isEmpty) return;

    final rideState = context.read<RideCubit>().state;

    final ride = rideState is RideLoaded ? rideState.ride : null;

    final newMessage = MessageModel(
      sender: "driver",
      userId: ride?.user?.id ?? "",
      riderId: context.driver?.id ?? "",
      content: content,
      timestamp: DateTime.now(),
    );

    context.read<MessageCubit>().sendMessage(context, newMessage);
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      image: AssetImage('assets/app_images/chat_bg.png'),
      title: "Messaging",
      bottomNavigationBar: DecoratedContainer(
        margin: EdgeInsets.only(
          top: extraSmallWhiteSpace,
          left: smallWhiteSpace,
          right: smallWhiteSpace,
          bottom: Responsive.bottom(context),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildField(
              "",
              messageController,
              shouldValidate: false,
              placeholder: "Type your message here...",
              prefixIcon: AppIcon(
                iconName: 'message_bubble',
                padding: const EdgeInsets.all(medWhiteSpace),
              ),
              suffixIcon: AppIcon(
                iconName: 'ph_camera-fill',
                padding: const EdgeInsets.all(medWhiteSpace),
              ),
            ),
            FreedomButton(
              onPressed: _sendMessage,
              useGradient: true,
              title: "Send Message",
              gradient: LinearGradient(colors: gradientColor),
            ),
          ],
        ),
      ),
      differentUi: BlocBuilder<MessageCubit, MessageState>(
        builder: (context, state) {
          if (state is MessageLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MessageError) {
            return Center(child: Text(state.message));
          } else if (state is MessageLoaded) {
            if (state.messages.isEmpty) {
              return const Center(child: Text("No messages yet."));
            }

            return Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(smallWhiteSpace),
                reverse: true,
                itemCount: state.messages.length,
                itemBuilder: (context, index) {
                  final message =
                      state.messages[state.messages.length -
                          1 -
                          index]; // reverse order
                  final driverIsSender = message.sender == "driver";
                  return Align(
                    alignment:
                        driverIsSender
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment:
                          driverIsSender
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                      children: [
                        Text(
                          driverIsSender ? "You   " : "User",
                          style: TextStyle(
                            fontSize: smallText,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: Responsive.width(context) * 0.7,
                          ),
                          margin: const EdgeInsets.symmetric(
                            vertical: extraSmallWhiteSpace,
                          ),
                          padding: const EdgeInsets.all(smallWhiteSpace),
                          decoration: BoxDecoration(
                            color:
                                driverIsSender ? thickFillColor : Colors.black,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(roundedLg),
                              topRight: const Radius.circular(roundedLg),
                              bottomLeft: Radius.circular(
                                driverIsSender ? roundedLg : 0,
                              ),
                              bottomRight: Radius.circular(
                                driverIsSender ? 0 : roundedLg,
                              ),
                            ),
                          ),
                          child: Text(
                            message.content,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        Text(
                          "${message.timestamp.toIso8601String().split("T")[0].replaceAll("-", "/")}   ",
                          style: TextStyle(
                            fontSize: smallText,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        VSpace(smallWhiteSpace),
                      ],
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
