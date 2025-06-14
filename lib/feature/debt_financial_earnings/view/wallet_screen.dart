import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/cubit/finance/financial_cubit.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/cubit/finance/financial_state.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/widgets/utility.dart';
import 'package:freedomdriver/feature/documents/driver_license/view/license_form.dart';
import 'package:freedomdriver/feature/driver/extension.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/widgets/custom_drop_down_button.dart';
import 'package:freedomdriver/shared/widgets/custom_screen.dart';
import 'package:freedomdriver/shared/widgets/decorated_container.dart';
import 'package:freedomdriver/shared/widgets/upload_button.dart';
import 'package:freedomdriver/utilities/ui.dart';

import 'package:freedomdriver/shared/widgets/app_icon.dart';
import 'package:freedomdriver/utilities/show_custom_modal.dart';
import 'package:freedomdriver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedomdriver/feature/profile/widget/stacked_profile_card.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/widgets/bank_select.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});
  static const String routeName = '/wallet';

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _withdrawalFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _paymentFormKey = GlobalKey<FormState>();
  final TextEditingController amount = TextEditingController();
  final TextEditingController accountNumber = TextEditingController();
  final TextEditingController bankCode = TextEditingController();
  final TextEditingController accountName = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController withdrawalType = TextEditingController();

  @override
  void initState() {
    context.read<FinancialCubit>().getWalletBalance(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinancialCubit, FinancialState>(
      builder: (context, state) {
        final finance = state is FinancialLoaded ? state.finance : null;
        return CustomScreen(
          title: 'Wallet',
          children: [
            DecoratedContainer(
              backgroundImage: AssetImage(getPngImageUrl('wallet_bg')),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _BalanceSection(finance: finance)),
                      Expanded(child: _MomoSection()),
                    ],
                  ),
                  const VSpace(smallWhiteSpace),
                  _ActionButtons(
                    onWithdraw: () {
                      amount.text = finance?.availableBalance.toString() ?? '';
                      showCustomModal(
                        context,
                        child: WithdrawalForm(
                          formKey: _withdrawalFormKey,
                          amount: amount,
                          withdrawalType: withdrawalType,
                        ),
                        btnOkText: 'Withdraw',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () {
                          if (_withdrawalFormKey.currentState!.validate()) {
                            context.read<FinancialCubit>().makeWithdrawal(
                              context,
                              amount:
                                  double.tryParse(amount.text.trim()) ?? 0.0,
                              withdrawalType: withdrawalType.text.trim(),
                            );
                          }
                        },
                      ).show();
                    },
                  ),
                ],
              ),
            ),
            const VSpace(whiteSpace),
            const Text(
              'Manage Payment Method',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: smallText,
                fontWeight: FontWeight.w500,
              ),
            ),
            ManagePayment(
              walletSubheading:
                  "${finance?.bankDetailsProvided == null ? 'Update' : 'Add '} your bank account details to receive payments directly.",
              mobileMoneySubheading:
                  "${finance?.momoDetailsProvided == null ? 'Update' : 'Add'} your mobile money details to receive payments directly.",
              onAddMobileMoneyTap: () {
                phoneNumber.text = context.driver?.phone ?? '';
                showCustomModal(
                  context,
                  child: MobileMoneyForm(
                    formKey: _paymentFormKey,
                    phoneNumber: phoneNumber,
                  ),
                  btnOkText: 'Add Number',
                  btnOkOnPress: () {
                    if (_paymentFormKey.currentState!.validate()) {
                      context.read<FinancialCubit>().updateMomoDetails(
                        context,
                        phoneNumber: phoneNumber.text.trim(),
                      );
                    }
                  },
                  btnCancelOnPress: () {},
                ).show();
              },
              onAddWalletTap: () {
                accountName.text = context.driver?.fullName ?? '';
                showCustomModal(
                  context,
                  child: BankDetailsForm(
                    formKey: _formKey,
                    accountName: accountName,
                    accountNumber: accountNumber,
                    bankCode: bankCode,
                  ),
                  btnOkText: 'Add Account',
                  btnOkOnPress: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<FinancialCubit>().updateBankDetails(
                        context,
                        accountName: accountName.text.trim(),
                        accountNumber: accountNumber.text.trim(),
                        bankCode: bankCode.text.trim(),
                      );
                    }
                  },
                  btnCancelOnPress: () {},
                ).show();
              },
              padding: EdgeInsets.zero,
            ),
          ],
        );
      },
    );
  }
}

// --- Reusable Widgets ---

class _BalanceSection extends StatelessWidget {
  const _BalanceSection({required this.finance});
  final dynamic finance;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account Balance',
          style: descriptionTextStyle.copyWith(color: Colors.white),
        ),
        Text(
          '$appCurrency ${finance?.availableBalance.toStringAsFixed(2) ?? '0.00'}',
          style: headingTextStyle.copyWith(color: Colors.white),
        ),
      ],
    );
  }
}

class _MomoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Momo Pay  ',
          style: descriptionTextStyle.copyWith(color: Colors.white),
        ),
        const DriverContactInfo(),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.onWithdraw});
  final VoidCallback onWithdraw;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(roundedLg),
      ),
      child: CustomDottedBorder(
        child: Row(
          children: [
            Expanded(
              child: SimpleButton(
                title: '',
                onPressed: onWithdraw,
                child: const Row(
                  children: [
                    AppIcon(iconName: 'withdraw_icons'),
                    HSpace(extraSmallWhiteSpace),
                    Text(
                      'Withdraw',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: smallText,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const HSpace(smallWhiteSpace),
            Expanded(
              child: SimpleButton(
                title: '',
                onPressed: () {},
                backgroundColor: Colors.white,
                child: const Row(
                  children: [
                    AppIcon(iconName: 'transaction'),
                    HSpace(extraSmallWhiteSpace),
                    Text(
                      'Transaction ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: smallText,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Generic Form Section Widget ---

class FormSection extends StatelessWidget {

  const FormSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
  });
  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: normalTextStyle),
        Text(
          subtitle,
          style: paragraphTextStyle.copyWith(
            color: Colors.grey.shade600,
            fontSize: smallText,
          ),
        ),
        const VSpace(smallWhiteSpace),
        ...children,
      ],
    );
  }
}

// --- Forms ---

class WithdrawalForm extends StatelessWidget {
  const WithdrawalForm({
    super.key,
    required this.formKey,
    required this.amount,
    required this.withdrawalType,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController amount;
  final TextEditingController withdrawalType;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: FormSection(
        title: 'Make Withdrawal',
        subtitle: 'Withdraw your earnings to your bank account.',
        children: [
          CustomDropDown(
            label: 'Withdrawal Type',
            initialValue: 'Bank',
            items: const ['Bank', 'Mobile Money'],
            onChanged: (value) {
              withdrawalType.text =
                  value.replaceFirst('Mobile Money', 'momo').toLowerCase();
              log('message: ${withdrawalType.text}');
            },
          ),
          buildField('Amount', amount, keyboardType: TextInputType.phone),
        ],
      ),
    );
  }
}

class BankDetailsForm extends StatelessWidget {
  const BankDetailsForm({
    super.key,
    required this.formKey,
    required this.accountNumber,
    required this.bankCode,
    required this.accountName,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController accountNumber;
  final TextEditingController bankCode;
  final TextEditingController accountName;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: FormSection(
        title: 'Bank Account Details',
        subtitle:
            'Add your bank details to receive payments directly to your bank account.',
        children: [
          BankDropdown(
            onBankSelected: (code) {
              debugPrint('Selected bank code: $code');
              bankCode.text = code;
            },
          ),
          const VSpace(smallWhiteSpace),
          buildField(
            'Account Number',
            accountNumber,
            keyboardType: TextInputType.phone,
          ),
          buildField(
            'Account Name',
            accountName,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }
}

class MobileMoneyForm extends StatelessWidget {
  const MobileMoneyForm({
    super.key,
    required this.formKey,
    required this.phoneNumber,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: FormSection(
        title: 'Mobile Money',
        subtitle:
            'Add your mobile money details to receive payments directly to your mobile wallet.',
        children: [
          buildField(
            'Momo Phone Number',
            phoneNumber,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }
}
