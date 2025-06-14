import 'package:flutter/material.dart';
import 'package:freedomdriver/feature/kyc/view/background_verification_screen.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';

import 'package:freedomdriver/feature/debt_financial_earnings/models/bank.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/services/bank.dart';

class BankDropdown extends StatefulWidget {

  const BankDropdown({super.key, required this.onBankSelected});
  final Function(String bankCode) onBankSelected;

  @override
  BankDropdownState createState() => BankDropdownState();
}

class BankDropdownState extends State<BankDropdown> {
  final BankService _bankService = BankService();
  List<Bank> _banks = [];
  String? _selectedBankCode;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBanks();
  }

  void _loadBanks() async {
    try {
      final banks = await _bankService.getGhanaBanks();
      setState(() {
        _banks = banks;
      });
    } catch (e) {
      debugPrint('Error loading banks: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return showProgressIndicator();
    } else {
      return DropdownButtonFormField<String>(
          value: _selectedBankCode,
          decoration: InputDecoration(
            labelText: 'Select a Bank',
          labelStyle: normalTextStyle.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: gradient1),
            ),
          ),
          focusColor: gradient1,
          dropdownColor: Colors.white,
          items:
              _banks.map((bank) {
                return DropdownMenuItem(
                  value: '${bank.code}-${bank.id}',
                  child: Text(bank.name),
                );
              }).toList(),
          onChanged: (value) {
            final newValue = value?.split('-')[0];
            setState(() => _selectedBankCode = value);
            if (newValue != null) widget.onBankSelected(newValue);
          },
        );
    }
  }
}
