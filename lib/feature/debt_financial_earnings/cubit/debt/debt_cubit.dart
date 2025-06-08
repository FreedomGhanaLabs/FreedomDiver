import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/shared/api/load_dashboard.dart';

import '../../../../shared/api/api_controller.dart';
import '../../../../shared/api/api_handler.dart';
import '../../models/debt.dart';
import 'debt_state.dart';

class DebtCubit extends Cubit<DebtState> {
  DebtCubit() : super(DebtInitial());

  final _apiController = ApiController('debt');

  Debt? _cachedDebt;
  bool get hasDebt => _cachedDebt != null;

  void _updateDebt(Debt updated) {
    _cachedDebt = updated;
    emit(DebtLoaded(_cachedDebt!));
  }

  void _emitIfChanged(Debt updated) {
    if (_cachedDebt != updated) {
      _updateDebt(updated);
    } else {
      log('[DebtCubit] No changes detected, not emitting new state');
    }
  }

  Future<void> getDebtStatus(BuildContext context) async {
    // if (hasDebt) return;
    await handleApiCall(
      context: context,
      apiRequest: () async {
        await _apiController.getData(context, 'status', (success, data) {
          if (success && data is Map<String, dynamic>) {
            final status = Debt.fromJson(data['data']);
            emit(DebtLoaded(status));

            _emitIfChanged(status);
          }
        });
      },
      onError: (_) {},
    );
  }

  Future<void> getDebtPaymentHistory(
    BuildContext context, {
    String? startDate,
    String? endDate,
    String? status,
  }) async {
    // if (_cachedDebt?.debtPaymentHistory != null) return;
    await handleApiCall(
      context: context,
      apiRequest: () async {
        await _apiController.getData(
          context,
          'payment-history/?startDate=$startDate&endDate=$endDate&status=$status',
          (success, data) {
            log("[Debt history] $data");
            if (success && data is Map<String, dynamic>) {
              final historyList =
                  (data['data'] as List)
                      .map((e) => DebtPaymentHistory.fromJson(e))
                      .toList();

              _emitIfChanged(
                _cachedDebt!.copyWith(debtPaymentHistory: historyList),
              );
            }
          },
        );
      },
      onError: (_) {},
    );
  }

  Future<void> payDebt(
    BuildContext context, {
    required double amount,
    String paymentType = 'wallet', // momo
    String provider = "mtn",
    String? phone,
  }) async {
    final walletPayload = {"amount": amount};
    final momoPayload = {
      ...walletPayload,
      "phone": phone,
      "provider": provider,
    };
    final payload = paymentType == 'wallet' ? walletPayload : momoPayload;
    await handleApiCall(
      context: context,
      apiRequest: () async {
        await _apiController.post(context, 'pay-$paymentType', payload, (
          success,
          data,
        ) {
          if (success && data is Map<String, dynamic>) {
            log('[DebtCubit] pay debt $data');
            // final driver = Driver.fromJson(
            //   data['data'] as Map<String, dynamic>,
            // );

            // _updateDebt(driver);
            loadDashboard(context);
          }
        }, showOverlay: true);
      },
      onError: (_) {},
    );
  }
}
