import 'package:flutter/material.dart';

class EarningsBackgroundWidget extends StatelessWidget {
  const EarningsBackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/app_images/decorated_scaffold.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
