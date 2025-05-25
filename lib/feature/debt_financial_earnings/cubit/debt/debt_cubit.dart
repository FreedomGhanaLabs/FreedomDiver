import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/api/api_controller.dart';
import '../../../../shared/api/api_handler.dart';
import 'debt_state.dart';

class DebtCubit extends Cubit<DebtState> {
  DebtCubit() : super(DebtInitial());

  final _apiController = ApiController('debt');

  static String errorMessage(String firstName) {
    return 'Sorry $firstName! We could not retrieve your earnings at the moment. Please ensure that you have a good internet connection or restart the app. If this difficulty persist please contact our support team';
  }

  Future<void> getWalletBalance(BuildContext context) async {
    await handleApiCall(
      context: context,
      apiRequest: () async {
        await _apiController.getData(context, 'wallet', (success, data) {
          if (success && data is Map<String, dynamic>) {
            log('[DebtCubit] wallet data $data');
            // final driver = Driver.fromJson(
            //   data['data'] as Map<String, dynamic>,
            // );

            // _updateDriver(driver);
          } else {
            emit(const DebtError('Failed to fetch driver wallet balance'));
          }
        });
      },
      onError: (_) => emit(const DebtError('Something went wrong')),
    );
  }

  Future<void> getDebtEarningReport(
    BuildContext context, {
    String reportType = 'daily',
  }) async {
    await handleApiCall(
      context: context,
      apiRequest: () async {
        await _apiController.getData(
          context,
          'earnings/report/?reportType=$reportType',
          (success, data) {
            if (success && data is Map<String, dynamic>) {
              log('[DebtCubit] financial earnings report: $data');
              // final driver = Driver.fromJson(
              //   data['data'] as Map<String, dynamic>,
              // );

              // _updateDriver(driver);
            } else {
              emit(
                const DebtError(
                  'Failed to fetch driver financial summary.',
                ),
              );
            }
          },
        );
      },
      onError: (_) => emit(const DebtError('Something went wrong')),
    );
  }

  Future<void> updateBankDetails(
    BuildContext context, {
    required String accountNumber,
    required String bankCode,
    required String accountName,
  }) async {
    await handleApiCall(
      context: context,
      apiRequest: () async {
        await _apiController.post(
          context,
          'bank-details',
          {
            "accountNumber": accountNumber,
            "bankCode": bankCode,
            "accountName": accountName,
          },
          (success, data) {
            if (success && data is Map<String, dynamic>) {
              log('[DebtCubit] bank details data $data');
              // final driver = Driver.fromJson(
              //   data['data'] as Map<String, dynamic>,
              // );

              // _updateDriver(driver);
            } else {
              emit(
                const DebtError('Failed to update driver bank details.'),
              );
            }
          },
          showOverlay: true,
        );
      },
      onError: (_) => emit(const DebtError('Something went wrong')),
    );
  }

}
