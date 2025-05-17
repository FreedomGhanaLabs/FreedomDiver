import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freedomdriver/feature/earnings/widgets/earnings_banner.dart';
import 'package:freedomdriver/feature/earnings/widgets/utility.dart';
import 'package:freedomdriver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedomdriver/shared/widgets/decorated_back_button.dart';
import 'package:freedomdriver/utilities/ui.dart';
import 'package:google_fonts/google_fonts.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  static const String routeName = '/wallet';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const DecoratedBackButton(),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Wallet',
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const VSpace(43),
              EarningsBanner(
                title: 'Account balance',
                  subtitle: 'c 500.00',
                  child2: SimpleButton(
                    title: '',
                    onPressed: () {
                      Navigator.of(context).pushNamed(WalletScreen.routeName);
                    },
                    padding: const EdgeInsets.symmetric(
                    horizontal: 19,
                    vertical: 12,
                  ),
                    borderRadius: BorderRadius.circular(6),
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/app_icons/withdraw_icons.svg'),
                        const HSpace(6),
                        Text(
                          'Withdraw',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                          ),
                      ),
                      ],
                    ),
                ),
                child: const SizedBox.shrink(),
              ),
              const VSpace(32),
              Text(
                'Manage Payment Method',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 12.49,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const ManagePayment(
                padding: EdgeInsets.symmetric(),
        
              ),
            ],
          ),
        ),
      ),
    );
  }
}
