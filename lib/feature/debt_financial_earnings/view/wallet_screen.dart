import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/cubit/finance/financial_cubit.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/cubit/finance/financial_state.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/widgets/earnings_banner.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/widgets/utility.dart';
import 'package:freedomdriver/feature/documents/driver_license/view/license_form.dart';
import 'package:freedomdriver/feature/driver/extension.dart';
import 'package:freedomdriver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/widgets/app_icon.dart';
import 'package:freedomdriver/shared/widgets/custom_drop_down_button.dart';
import 'package:freedomdriver/shared/widgets/custom_screen.dart';
import 'package:freedomdriver/utilities/ui.dart';

import '../../../utilities/show_custom_modal.dart';
import '../widgets/bank_select.dart';

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
                          amount: double.tryParse(amount.text.trim()) ?? 0.0,
                          withdrawalType: withdrawalType.text.trim(),
                        );
                      }
                    },
                  ).show();
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

class WithdrawalForm extends StatefulWidget {
  const WithdrawalForm({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.amount,
    required this.withdrawalType,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;
  final TextEditingController amount;
  final TextEditingController withdrawalType;

  @override
  State<WithdrawalForm> createState() => _WithdrawalFormState();
}

class _WithdrawalFormState extends State<WithdrawalForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Make Withdrawal', style: normalTextStyle),
          Text(
            'Withdraw your earnings to your bank account.',
            style: paragraphTextStyle.copyWith(
              color: Colors.grey.shade600,
              fontSize: smallText,
            ),
          ),
          const VSpace(smallWhiteSpace),
          CustomDropDown(
            label: 'Withdrawal Type',
            initialValue: 'Bank',
            items: const ['Bank', 'Mobile Money'],
            onChanged: (value) {
              widget.withdrawalType.text =
                  value.replaceFirst('Mobile Money', 'momo').toLowerCase();
              log('message: ${widget.withdrawalType.text}');
            },
          ),
          buildField(
            'Amount',
            widget.amount,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }
}

class BankDetailsForm extends StatelessWidget {
  const BankDetailsForm({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.accountNumber,
    required this.bankCode,
    required this.accountName,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;
  final TextEditingController accountNumber;
  final TextEditingController bankCode;
  final TextEditingController accountName;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bank Account Details', style: normalTextStyle),
          Text(
            'Add your bank details to receive payments directly to your bank account.',
            style: paragraphTextStyle.copyWith(
              color: Colors.grey.shade600,
              fontSize: smallText,
            ),
          ),
          const VSpace(smallWhiteSpace),
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
          // buildField('Bank Code', bankCode, keyboardType: TextInputType.phone),
        ],
      ),
    );
  }
}

class MobileMoneyForm extends StatelessWidget {
  const MobileMoneyForm({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.phoneNumber,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;
  final TextEditingController phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mobile Money', style: normalTextStyle),
          Text(
            'Add your mobile money details to receive payments directly to your mobile wallet.',
            style: paragraphTextStyle.copyWith(
              color: Colors.grey.shade600,
              fontSize: smallText,
            ),
          ),
          const VSpace(smallWhiteSpace),
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
