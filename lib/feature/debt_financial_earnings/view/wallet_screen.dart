import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/cubit/earnings/earnings_cubit.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/cubit/earnings/earnings_state.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/widgets/earnings_banner.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/widgets/utility.dart';
import 'package:freedomdriver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/widgets/app_icon.dart';
import 'package:freedomdriver/shared/widgets/custom_screen.dart';
import 'package:freedomdriver/utilities/ui.dart';
import 'package:google_fonts/google_fonts.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  static const String routeName = '/wallet';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EarningCubit, EarningState>(
      builder: (context, state) {
        final earning = state is EarningLoaded ? state.earning : null;
        return CustomScreen(
          title: 'Wallet',
          children: [
            const VSpace(whiteSpace),
            EarningsBanner(
              title:
                  '$appCurrency ${earning?.pendingPayments.toStringAsFixed(2) ?? '0.00'}',
              subtitle: 'Account balance',
              child2: SimpleButton(
                title: '',
                onPressed: () {
                  // Navigator.of(context).pushNamed(WalletScreen.routeName);
                },
                child: Row(
                  children: [
                    AppIcon(iconName: 'withdraw_icons'),
                    const HSpace(extraSmallWhiteSpace),
                    Text(
                      'Withdraw',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: paragraphText,
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
            const ManagePayment(padding: EdgeInsets.symmetric()),
          ],
        );
      },
    );
  }
}
