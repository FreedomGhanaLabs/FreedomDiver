import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/shared/widgets/custom_screen.dart';
import 'package:get/get.dart';

import '../../debt_financial_earnings/cubit/debt/debt_cubit.dart';
import '../../debt_financial_earnings/cubit/debt/debt_state.dart';
import '../../debt_financial_earnings/models/debt.dart';


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
            if (state is DebtLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DebtLoaded) {
              final debt = state.debt;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DebtStatusCard(debt: debt),
                  const SizedBox(height: 20),
                  DebtPaymentForm(debt: debt),
                  const SizedBox(height: 30),
                  const DebtHistorySection(),
                ],
              );
            } else if (state is DebtError) {
              return Text(state.message);
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}

class DebtHistorySection extends StatelessWidget {
  const DebtHistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<DebtCubit>().getDebtPaymentHistory(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        final payments = <DebtPaymentHistory>[
          DebtPaymentHistory(
            amount: 200,
            method: "momo",
            notes: "This is a payment",
            paymentDate: DateTime.now(),
            reference: "xyz",
            status: "Successful",
          ),
          DebtPaymentHistory(
            amount: 200,
            method: "wallet",
            notes: "This is a wallet payment",
            paymentDate: DateTime.now(),
            reference: "xyz",
            status: "Successful",
          ),
          DebtPaymentHistory(
            amount: 200,
            method: "momo",
            notes: "This is a payment",
            paymentDate: DateTime.now(),
            reference: "xyz",
            status: "Successful",
          ),
        ];

        if (payments.isEmpty) {
          return const Text('No payment history available.');
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment History',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...payments.map(
              (e) => ListTile(
                leading: Icon(
                  e.method == 'wallet'
                      ? Icons.account_balance_wallet
                      : Icons.phone_android,
                ),
                title: Text('\$${e.amount.toStringAsFixed(2)}'),
                subtitle: Text('${e.notes} • ${e.paymentDate.toLocal()}'),
                trailing: Text(e.status.capitalize!),
              ),
            ),
          ],
        );
      },
    );
  }
}

class DebtStatusCard extends StatelessWidget {
  final DebtStatus debt;
  const DebtStatusCard({super.key, required this.debt});

  @override
  Widget build(BuildContext context) {
    final statusColor =
        {
          'normal': Colors.green,
          'warning': Colors.orange,
          'suspended': Colors.red,
        }[debt.debtStatus] ??
        Colors.grey;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Debt: \$${debt.currentDebt.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text('Wallet Balance: \$${debt.walletBalance.toStringAsFixed(2)}'),
            Text(
              'Available Balance: \$${debt.availableBalance.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: debt.debtPercentage / 100,
              backgroundColor: Colors.grey[200],
              color: statusColor,
            ),
            const SizedBox(height: 4),
            Text('Debt Usage: ${debt.debtPercentage}%'),
            const SizedBox(height: 4),
            Text(
              'Status: ${debt.debtStatus.capitalize}',
              style: TextStyle(color: statusColor),
            ),
          ],
        ),
      ),
    );
  }
}

class DebtPaymentForm extends StatefulWidget {
  final DebtStatus debt;
  const DebtPaymentForm({super.key, required this.debt});

  @override
  State<DebtPaymentForm> createState() => DebtPaymentFormState();
}

class DebtPaymentFormState extends State<DebtPaymentForm> {
  final _formKey = GlobalKey<FormState>();
  double _amount = 0.0;
  String _method = 'wallet';
  String? _phone;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Make a Payment',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                onChanged: (val) => _amount = double.tryParse(val) ?? 0.0,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _method,
                items: const [
                  DropdownMenuItem(value: 'wallet', child: Text('Wallet')),
                  DropdownMenuItem(value: 'momo', child: Text('Mobile Money')),
                ],
                onChanged: (val) => setState(() => _method = val!),
              ),
              if (_method == 'momo') ...[
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'MoMo Phone'),
                  keyboardType: TextInputType.phone,
                  onChanged: (val) => _phone = val,
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text('Pay Debt'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<DebtCubit>().payDebt(
                      context,
                      amount: _amount,
                      paymentType: _method,
                      phone: _phone,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
