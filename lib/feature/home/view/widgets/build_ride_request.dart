import 'package:flutter/material.dart';
import 'package:freedom_driver/app/view/app.dart';
import 'package:freedom_driver/shared/theme/text_style.dart';

List<Widget> buildCustomerDetail() {
  return List.generate(4, (index) {
    final context = navigatorKey.currentContext;
    final width = MediaQuery.of(context!).size.width;
    return Container(
      width: width,
      margin: const EdgeInsets.only(bottom: 15),
      decoration: ShapeDecoration(
        color: const Color(0x0FFFBA40),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1.15,
            strokeAlign: BorderSide.strokeAlignOutside,
            color: Colors.black.withOpacity(0.23),
          ),
          borderRadius: BorderRadius.circular(6.90),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 13.93,
          left: 13.2,
          right: 13.2,
          bottom: 13.93,
        ),
        child: Column(

            crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (index == 0)
            Row(
              children: [
                Text(
                  'Customer Name',
                  style: rideRequestTitleTextStyle,
                ),
                const Spacer(),
                Text(
                  '${rideRequest['customerName']}',
                  style: rideRequestDetailTextStyle,
                ),
              ],
            ),
          if (index == 1)
            Row(
              children: [
                Text('Pickup', style: rideRequestTitleTextStyle),
                const Spacer(),
                Text('${rideRequest['pickup']}',
                    style: rideRequestDetailTextStyle),
              ],
            ),
          if (index == 2)
            Row(
              children: [
                Text(
                  'Drop-off',
                  style: rideRequestTitleTextStyle,
                ),
                const Spacer(),
                Flexible(
                  flex: 2,
                  child: Text(
                    '${rideRequest['destination']}',
                    style: rideRequestDetailTextStyle,
                  ),
                ),
              ],
            ),
          if (index == 3)
            Row(
              children: [
                Text(
                  'Estimated Fare',
                  style: rideRequestTitleTextStyle,
                ),
                const Spacer(),
                Text('${rideRequest['estimatedFee']}',
                    style: rideRequestDetailTextStyle),
              ],
            ),
        ]),
      ),
    );
  });
}

Map<String, dynamic> rideRequest = {
  'customerName': 'James Elvis',
  'pickup': '123 Main St, New York',
  'destination': '456 Elm St, Los Angeles',
  'estimatedFee': 'GHc 50.00',
  'date': '2023-08-01',
};
