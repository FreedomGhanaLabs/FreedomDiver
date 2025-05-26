import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/cubit/finance/financial_cubit.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/cubit/finance/financial_state.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/widgets/earnings_banner.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/widgets/utility.dart';
import 'package:freedomdriver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/widgets/app_icon.dart';
import 'package:freedomdriver/shared/widgets/custom_screen.dart';
import 'package:freedomdriver/shared/widgets/decorated_container.dart';
import 'package:freedomdriver/utilities/ui.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});
  static const String routeName = '/wallet';

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  void initState() {
    context.read<FinancialCubit>().getWalletBalance(context);
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController licenseNumber = TextEditingController();
  final TextEditingController classOfLicense = TextEditingController();
    
  @override
  Widget build(BuildContext context) {

    return BlocBuilder<FinancialCubit, FinancialState>(
      builder: (context, state) {
        final finance = state is FinancialLoaded ? state.finance : null;
        return CustomScreen(
          title: 'Account',
          children: [
            const VSpace(whiteSpace),
            EarningsBanner(
              title:
                  '$appCurrency ${finance?.availableBalance.toStringAsFixed(2) ?? '0.00'}',
              subtitle: 'Account balance',
              child2: SimpleButton(
                title: '',
                onPressed: () {
                  // Navigator.of(context).pushNamed(WalletScreen.routeName);
                },
                child: Row(
                  children: [
                    AppIcon(iconName: 'withdraw_icons'),
                    const HSpace(smallWhiteSpace),
                    Text(
                      'Withdraw',
                      style: TextStyle(
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
            const VSpace(normalWhiteSpace),
            Text(
              'Manage Payment Method',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: smallText,
                fontWeight: FontWeight.w500,
              ),
            ),
            ManagePayment(
              onAddMobileMoneyTap: () {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.noHeader,
                  animType: AnimType.topSlide,
                  title: 'Mobile Money',
                  desc: 'This feature is not available yet.',
                  customHeader: DecoratedContainer(
                    child: Form(key: _formKey, child: Column()),
                  ),
                  showCloseIcon: true,
                  btnOkIcon: Icons.add,
                  btnCancelIcon: Icons.cancel,
                  // btnOkColor: gradient1,
                  autoDismiss: false,
                  onDismissCallback: (type) {
                    if (type == DismissType.topIcon ||
                        type == DismissType.btnCancel) {
                      Navigator.of(context).pop();
                    }
                  },
                  btnOkText: 'Add Mobile Money',
                  btnCancelText: 'Cancel',
                  btnOkOnPress: () {
                    context.read<FinancialCubit>().updateBankDetails(
                      context,
                      accountName: '',
                      accountNumber: '',
                      bankCode: '',
                    );
                  },
                ).show();
              },
              onAddWalletTap: () {},
              padding: EdgeInsets.zero,
            ),
          ],
        );
      },
    );
  }
}
