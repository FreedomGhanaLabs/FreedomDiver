import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/api/api_controller.dart';
import '../../../../shared/api/api_handler.dart';
import '../../models/debt.dart';
import 'debt_state.dart';

class DebtCubit extends Cubit<DebtState> {
  DebtCubit() : super(DebtInitial());

  final _apiController = ApiController('debt');

  DebtStatus? _cachedDebt;
  bool get hasDriver => _cachedDebt != null;

  void _updateDriver(DebtStatus updated) {
    _cachedDebt = updated;
    emit(DebtLoaded(_cachedDebt!));
  }

  void _emitIfChanged(DebtStatus updated) {
    if (_cachedDebt != updated) {
      _updateDriver(updated);
    } else {
      log('[DebtCubit] No changes detected, not emitting new state');
    }
  }

  static String errorMessage(String firstName) {
    return 'Sorry $firstName! We could not retrieve your earnings at the moment. Please ensure that you have a good internet connection or restart the app. If this difficulty persist please contact our support team';
  }

  Future<void> getDebtStatus(BuildContext context) async {
    await handleApiCall(
      context: context,
      apiRequest: () async {
        await _apiController.getData(context, 'status', (success, data) {
          if (success && data is Map<String, dynamic>) {
            log('[DebtCubit] debt status: $data');

            final status = DebtStatus.fromJson(data['data']);
            emit(DebtLoaded(status));

            _emitIfChanged(status);
          } else {
            emit(const DebtError('Failed to fetch driver debt status'));
          }
        });
      },
      onError: (_) => emit(const DebtError('Something went wrong')),
    );
  }

  Future<void> getDebtPaymentHistory(
    BuildContext context, {
    String? startDate,
    String? endDate,
    String? status,
  }) async {
    await handleApiCall(
      context: context,
      apiRequest: () async {
        await _apiController.getData(
          context,
          'payment-history/?startDate=$startDate&endDate=$endDate&status=$status',
          (success, data) {
            if (success && data is Map<String, dynamic>) {
              log('[DebtCubit] debt payment history: $data');
              // final driver = Driver.fromJson(
              //   data['data'] as Map<String, dynamic>,
              // );

              // _updateDriver(driver);
            } else {
              emit(const DebtError('Failed to fetch driver debt summary.'));
            }
          },
        );
      },
      onError: (_) => emit(const DebtError('Something went wrong')),
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

            // _updateDriver(driver);
          } else {
            emit(const DebtError('Failed to update driver bank details.'));
          }
        }, showOverlay: true);
      },
      onError: (_) => emit(const DebtError('Something went wrong')),
    );
  }
}
