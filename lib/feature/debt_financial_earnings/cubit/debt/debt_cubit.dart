import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/cubit/finance/financial_state.dart';

import '../../../../shared/api/api_controller.dart';
import '../../../../shared/api/api_handler.dart';

class FinancialCubit extends Cubit<FinancialState> {
  FinancialCubit() : super(FinancialInitial());

  final _apiController = ApiController('financial');

  static String errorMessage(String firstName) {
    return 'Sorry $firstName! We could not retrieve your earnings at the moment. Please ensure that you have a good internet connection or restart the app. If this difficulty persist please contact our support team';
  }

  Future<void> getWalletBalance(BuildContext context) async {
    await handleApiCall(
      context: context,
      apiRequest: () async {
        await _apiController.getData(context, 'wallet', (success, data) {
          if (success && data is Map<String, dynamic>) {
            log('[FinancialCubit] wallet data $data');
            // final driver = Driver.fromJson(
            //   data['data'] as Map<String, dynamic>,
            // );

            // _updateDriver(driver);
          } else {
            emit(const FinancialError('Failed to fetch driver wallet balance'));
          }
        });
      },
      onError: (_) => emit(const FinancialError('Something went wrong')),
    );
  }

  Future<void> getFinancialSummary(BuildContext context) async {
    await handleApiCall(
      context: context,
      apiRequest: () async {
        await _apiController.getData(context, 'financial-summary', (
          success,
          data,
        ) {
          if (success && data is Map<String, dynamic>) {
            log('[FinancialCubit] financial-summary data $data');
            // final driver = Driver.fromJson(
            //   data['data'] as Map<String, dynamic>,
            // );

            // _updateDriver(driver);
          } else {
            emit(
              const FinancialError('Failed to fetch driver financial summary.'),
            );
          }
        });
      },
      onError: (_) => emit(const FinancialError('Something went wrong')),
    );
  }

  Future<void> getWithdrawalHistory(
    BuildContext context, {
    String? status,
    String? startDate,
    String? endDate,
    String? method,
  }) async {
    await handleApiCall(
      context: context,
      apiRequest: () async {
        await _apiController.getData(
          context,
          'withdrawals/?status=$status&startDate=$startDate&endDate=$endDate&method=$method',
          (success, data) {
            if (success && data is Map<String, dynamic>) {
              log('[FinancialCubit] withdrawals: $data');
              // final driver = Driver.fromJson(
              //   data['data'] as Map<String, dynamic>,
              // );

              // _updateDriver(driver);
            } else {
              emit(const FinancialError('Failed to fetch driver withdrawals.'));
            }
          },
        );
      },
      onError: (_) => emit(const FinancialError('Something went wrong')),
    );
  }

  Future<void> getFinancialEarnings(
    BuildContext context, {
    String? startDate,
    String? endDate,
  }) async {
    await handleApiCall(
      context: context,
      apiRequest: () async {
        await _apiController.getData(
          context,
          'earnings/?startDate=$startDate&endDate=$endDate',
          (success, data) {
            if (success && data is Map<String, dynamic>) {
              log('[FinancialCubit] financial earnings: $data');
              // final driver = Driver.fromJson(
              //   data['data'] as Map<String, dynamic>,
              // );

              // _updateDriver(driver);
            } else {
              emit(
                const FinancialError(
                  'Failed to fetch driver financial summary.',
                ),
              );
            }
          },
        );
      },
      onError: (_) => emit(const FinancialError('Something went wrong')),
    );
  }

  Future<void> getFinancialEarningReport(
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
              log('[FinancialCubit] financial earnings report: $data');
              // final driver = Driver.fromJson(
              //   data['data'] as Map<String, dynamic>,
              // );

              // _updateDriver(driver);
            } else {
              emit(
                const FinancialError(
                  'Failed to fetch driver financial summary.',
                ),
              );
            }
          },
        );
      },
      onError: (_) => emit(const FinancialError('Something went wrong')),
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
              log('[FinancialCubit] bank details data $data');
              // final driver = Driver.fromJson(
              //   data['data'] as Map<String, dynamic>,
              // );

              // _updateDriver(driver);
            } else {
              emit(
                const FinancialError('Failed to update driver bank details.'),
              );
            }
          },
          showOverlay: true,
        );
      },
      onError: (_) => emit(const FinancialError('Something went wrong')),
    );
  }

  Future<void> updateMomoDetails(
    BuildContext context, {
    required String phoneNumber,
    String? provider,
  }) async {
    await handleApiCall(
      context: context,
      apiRequest: () async {
        await _apiController.post(
          context,
          'momo-details',
          {"phoneNumber": phoneNumber, "provider": provider ?? "mtn"},
          (success, data) {
            if (success && data is Map<String, dynamic>) {
              log('[FinancialCubit] bank details data $data');
              // final driver = Driver.fromJson(
              //   data['data'] as Map<String, dynamic>,
              // );

              // _updateDriver(driver);
            } else {
              emit(
                const FinancialError('Failed to update driver bank details.'),
              );
            }
          },
          showOverlay: true,
        );
      },
      onError: (_) => emit(const FinancialError('Something went wrong')),
    );
  }

  Future<void> verifyMomoDetails(BuildContext context) async {
    await handleApiCall(
      context: context,
      apiRequest: () async {
        await _apiController.post(context, 'verify-momo', {}, (success, data) {
          if (success && data is Map<String, dynamic>) {
            log('[FinancialCubit] verify-momo $data');
            // final driver = Driver.fromJson(
            //   data['data'] as Map<String, dynamic>,
            // );

            // _updateDriver(driver);
          } else {
            emit(const FinancialError('Failed to verify momo details.'));
          }
        }, showOverlay: true);
      },
      onError: (_) => emit(const FinancialError('Something went wrong')),
    );
  }

  Future<void> makeWithdrawal(
    BuildContext context, {
    required double amount,
    String withdrawalMethod = 'bank', // momo
  }) async {
    await handleApiCall(
      context: context,
      apiRequest: () async {
        await _apiController.post(
          context,
          'withdraw/$withdrawalMethod',
          {"amount": amount},
          (success, data) {
            if (success && data is Map<String, dynamic>) {
              log('[FinancialCubit] $withdrawalMethod withdrawal $data');
              // final driver = Driver.fromJson(
              //   data['data'] as Map<String, dynamic>,
              // );

              // _updateDriver(driver);
            } else {
              emit(FinancialError('Failed to $withdrawalMethod.'));
            }
          },
          showOverlay: true,
        );
      },
      onError: (_) => emit(const FinancialError('Something went wrong')),
    );
  }
}
