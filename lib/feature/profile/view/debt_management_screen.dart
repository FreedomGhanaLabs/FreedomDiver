import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/widgets/utility.dart';
import 'package:freedomdriver/feature/documents/driver_license/view/license_form.dart';
import 'package:freedomdriver/feature/driver/extension.dart';
import 'package:freedomdriver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';
import 'package:freedomdriver/shared/widgets/custom_divider.dart';
import 'package:freedomdriver/shared/widgets/custom_drop_down_button.dart';
import 'package:freedomdriver/shared/widgets/custom_screen.dart';
import 'package:freedomdriver/shared/widgets/decorated_container.dart';
import 'package:freedomdriver/shared/widgets/upload_button.dart';
import 'package:freedomdriver/utilities/ui.dart';
import 'package:get/get.dart';

import 'package:freedomdriver/feature/debt_financial_earnings/cubit/debt/debt_cubit.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/cubit/debt/debt_state.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/models/debt.dart';

class DebtManagementScreen extends StatefulWidget {
  const DebtManagementScreen({super.key});
  static const routeName = '/debt-management';

  @override
  State<DebtManagementScreen> createState() => _DebtManagementScreenState();
}

class _DebtManagementScreenState extends State<DebtManagementScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DebtCubit>().getDebtStatus(context);
    context.read<DebtCubit>().getDebtPaymentHistory(context);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: 'Debt Management',
      bodyHeader: 'Monitor & Pay Your Debts',
      bodyDescription:
          'Track your current debt status and payment history. Pay via Wallet or Mobile Money.',
      children: [
        BlocBuilder<DebtCubit, DebtState>(
          builder: (context, state) {
            final debt =
                state is DebtLoaded
                    ? state.debt
                    : Debt(
                      currentDebt: 0.00,
                      debtThreshold: 0.00,
                      debtPercentage: 0,
                      debtStatus: '',
                      canAcceptRides: false,
                      warningThreshold: 0,
                      suspensionThreshold: 0,
                      walletBalance: 0.00,
                      availableBalance: 0.00,
                    );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DebtStatusCard(debt: debt),
                const SizedBox(height: whiteSpace),
                DebtPaymentForm(debt: debt),
                const SizedBox(height: whiteSpace),
                DebtHistorySection(
                  debtPaymentHistory: debt.debtPaymentHistory ?? [],
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class DebtHistorySection extends StatelessWidget {
  const DebtHistorySection({super.key, required this.debtPaymentHistory});
  final List<DebtPaymentHistory> debtPaymentHistory;

  @override
  Widget build(BuildContext context) {
    final payments = debtPaymentHistory.isNotEmpty ? debtPaymentHistory : [];

    if (payments.isEmpty) {
      return Center(
        child: Text(
          'No debt payment history available.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade500),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Debt Payment History',
          style: TextStyle(fontSize: normalText, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...payments.map((e) {
          final statusColor =
              {
                'successful': greenColor,
                'pending': gradient1,
                'failed': redColor,
              }[e.status.toLowerCase()] ??
              Colors.grey.shade400;
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              e.method == 'wallet'
                  ? Icons.account_balance_wallet
                  : Icons.phone_android,
            ),
            title: Text(
              '$appCurrency ${e.amount.toStringAsFixed(2)}',
              style: normalTextStyle,
            ),
            subtitle: Text(
              '${e.notes} • ${e.paymentDate.toLocal()}',
              style: paragraphTextStyle.copyWith(color: Colors.grey.shade500),
            ),
            trailing: Text(
              e.status.capitalize!,
              style: TextStyle(
                fontSize: extraSmallText,
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }),
        const VSpace(normalWhiteSpace),
      ],
    );
  }
}

class DebtStatusCard extends StatelessWidget {
  const DebtStatusCard({super.key, required this.debt});
  final Debt debt;

  @override
  Widget build(BuildContext context) {
    final statusColor =
        {'good': greenColor, 'warning': gradient1, 'suspended': redColor}[debt
            .debtStatus] ??
        Colors.grey.shade400;

    final debtPercentage = debt.debtPercentage;

    return DecoratedContainer(
      backgroundImage: AssetImage(getPngImageUrl('wallet_bg')),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Debt',
                      style: descriptionTextStyle.copyWith(color: Colors.white),
                    ),
                    Text(
                      '$appCurrency ${debt.currentDebt.toStringAsFixed(2)}',
                      style: headingTextStyle.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const CustomDivider(height: 25, width: 2, color: Colors.white),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Wallet Balance',
                      style: descriptionTextStyle.copyWith(color: Colors.white),
                    ),
                    Text(
                      '$appCurrency ${debt.walletBalance.toStringAsFixed(2)}',
                      style: headingTextStyle.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const VSpace(medWhiteSpace),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Balance After Debt: ',
                  style: descriptionTextStyle.copyWith(color: Colors.white),
                ),
                TextSpan(
                  text:
                      '$appCurrency ${debt.availableBalance.toStringAsFixed(2)}',
                  style: descriptionTextStyle.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const VSpace(medWhiteSpace),
          LinearProgressIndicator(
            borderRadius: BorderRadius.circular(roundedLg),
            value: debtPercentage / 100,
            backgroundColor: Colors.grey[100],
            minHeight: 6,
            color:
                debtPercentage >= 40
                    ? gradient1
                    : debtPercentage >= 70
                    ? redColor
                    : greenColor,
          ),
          const VSpace(medWhiteSpace),
          CustomDottedBorder(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DecoratedContainer(
                    backgroundColor: Colors.black,
                    child: Text(
                      'Debt Usage: ${debt.debtPercentage}%',
                      style: descriptionTextStyle.copyWith(color: Colors.white),
                    ),
                  ),
                ),
                const HSpace(smallWhiteSpace),
                Expanded(
                  child: DecoratedContainer(
                    backgroundColor: Colors.white.withValues(alpha: 0.85),
                    child: Text(
                      'Status: ${debt.debtStatus.capitalize}',
                      textAlign: TextAlign.end,
                      style: TextStyle(color: statusColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DebtCard extends StatelessWidget {
  const DebtCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: const Alignment(-2, 0.72),
          end: const Alignment(0.99, 0.05),
          colors: cardGradientColor,
          stops: const [0.1, 0.58, 0.7],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(roundedLg),
          side: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(smallWhiteSpace),
        child: child,
      ),
    );
  }
}

class DebtPaymentForm extends StatefulWidget {
  const DebtPaymentForm({super.key, required this.debt});
  final Debt debt;

  @override
  State<DebtPaymentForm> createState() => DebtPaymentFormState();
}

class DebtPaymentFormState extends State<DebtPaymentForm> {
  final _formKey = GlobalKey<FormState>();

  String _method = 'Wallet';
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    _phoneController.text = context.driver?.phone ?? '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.debt.currentDebt == 0) return const SizedBox();
    _amountController.text = widget.debt.currentDebt.toString();
    return DecoratedContainer(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Make a Payment',
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: smallWhiteSpace),
            buildField(
              'Amount',
              _amountController,
              keyboardType: TextInputType.number,
            ),

            CustomDropDown(
              initialValue: _method,
              items: const ['Wallet', 'Mobile Money'],
              onChanged: (value) {
                setState(() {
                  _method = value;
                });
              },
            ),
            if (_method == 'Mobile Money') ...[
              buildField(
                'Momo Phone',
                _phoneController,
                keyboardType: TextInputType.number,
              ),
            ],
            const SizedBox(height: smallWhiteSpace),
            SimpleButton(
              title: '',
              backgroundColor: thickFillColor,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send, color: Colors.white),
                  HSpace(extraSmallWhiteSpace),
                  Text('Pay Debt', style: TextStyle(color: Colors.white)),
                ],
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<DebtCubit>().payDebt(
                    context,
                    amount: double.parse(_amountController.text),
                    paymentType: _method.replaceAll('Mobile Money', 'momo'),
                    phone: _phoneController.text,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
