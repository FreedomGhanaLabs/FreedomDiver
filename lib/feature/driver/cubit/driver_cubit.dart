import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freedom_driver/feature/driver/cubit/driver_state.dart';
import 'package:freedom_driver/feature/driver/cubit/methods.dart';
import 'package:freedom_driver/feature/driver/driver.model.dart';
import 'package:freedom_driver/shared/api/api_controller.dart';
import 'package:freedom_driver/shared/api/api_handler.dart';

class DriverCubit extends Cubit<DriverState> {
  DriverCubit() : super(DriverInitial());

  final ApiController apiController = ApiController('');
  Driver? _cachedDriver;

  Driver? get currentDriver => _cachedDriver;
  bool get hasDriver => _cachedDriver != null;

  void _updateDriver(Driver updated) {
    _cachedDriver = updated;
    emit(DriverLoaded(_cachedDriver!));
  }

  Future<void> getDriverProfile(
    BuildContext context, {
    bool forceRefresh = false,
  }) async {
    if (hasDriver && !forceRefresh) {
      log('[DriverCubit] Using cached driver data');
      _updateDriver(_cachedDriver!);
      return;
    }
    emit(DriverLoading());

    await handleApiCall(
      context: context,
      apiRequest: () async {
        await apiController.getData(context, 'profile', (success, data) {
          if (success && data is Map<String, dynamic>) {
            final driver =
                Driver.fromJson(data['data'] as Map<String, dynamic>);

            _updateDriver(driver);
          } else {
            emit(const DriverError('Failed to fetch driver data'));
          }
        });
      },
      onError: (_) => emit(const DriverError('Something went wrong')),
    );
  }

  Future<void> toggleStatus(BuildContext context) async {
    if (!hasDriver) return;

    final current = _cachedDriver!.status ?? DriverStatus.unavailable.name;
    final isUnavailable = current == DriverStatus.unavailable.name;
    final newStatus = isUnavailable
        ? DriverStatus.available.name
        : DriverStatus.unavailable.name;

    _updateDriverStatus(newStatus);
    emitIfChanged(
      _cachedDriver,
      _cachedDriver!.copyWith(status: newStatus),
      emit,
    );

    await handleApiCall(
      context: context,
      apiRequest: () => apiController.put(
        context,
        'status',
        {'status': newStatus},
        (success, _) {
          if (success) {
            log('[DriverCubit] Status updated: $newStatus');
          } else {
            emitIfChanged(
              _cachedDriver,
              _cachedDriver!.copyWith(status: current),
              emit,
            );
          }
        },
      ),
      onFailure: () => emitIfChanged(
        _cachedDriver,
        _cachedDriver!.copyWith(status: current),
        emit,
      ),
    );
  }

  Future<void> updateDriverLocation(BuildContext context) async {
    if (_cachedDriver == null) return;

    final currentLocation = _cachedDriver!.location!.coordinates;
    final newLocation = [3.3792057, 6.5243793];

    _updateDriverLocation(newLocation);

    try {
      await apiController.put(
        context,
        'location',
        {'coordinates': newLocation},
        (success, responseData) {
          if (success) {
            log('[DriverCubit] coordinates updated: $newLocation');
            _updateDriverLocation(newLocation);
          } else {
            _updateDriverLocation(currentLocation);
          }
        },
      );
    } catch (e) {
      log('[DriverCubit] location error: $e');
      _updateDriverLocation(currentLocation);
    }
  }

  Future<void> updateDriverRidePreference(
    BuildContext context, {
    String newRidePreference = 'longDistance',
  }) async {
    if (_cachedDriver == null) return;

    final currentRidePreference = _cachedDriver?.ridePreference ?? '';

    _updateDriverRidePreference(newRidePreference);

    try {
      await apiController.patch(
        context,
        'preference',
        {'ridePreference': newRidePreference},
        (success, responseData) {
          if (success) {
            log('[DriverCubit] newRidePreference updated: $newRidePreference');
            _updateDriverRidePreference(newRidePreference);
          } else {
            _updateDriverRidePreference(currentRidePreference);
          }
        },
      );
    } catch (e) {
      log('[DriverCubit] newRidePreference error: $e');
      _updateDriverRidePreference(currentRidePreference);
    }
  }

  Future<void> requestEmailUpdate(
    BuildContext context,
    String newEmail,
  ) async {
    if (_cachedDriver == null) return;

    final email = _cachedDriver?.email ?? '';

    _updateDriverEmail(newEmail);

    try {
      await apiController.post(
        context,
        'request-email-update',
        {'newEmail': newEmail},
        (success, responseData) {
          if (success) {
            log('[DriverCubit] email updated: $newEmail');
            _updateDriverEmail(newEmail);
          } else {
            _updateDriverEmail(email);
          }
        },
      );
    } catch (e) {
      log('[DriverCubit] email error: $e');
      _updateDriverEmail(email);
    }
  }

  Future<void> verifyEmailUpdate(
    BuildContext context,
    String verificationCode,
  ) async {
    if (_cachedDriver == null) return;

    final email = _cachedDriver?.email ?? '';

    emit(DriverLoading());
    try {
      await apiController.post(
        context,
        'verify-email-update',
        {'verificationCode': verificationCode},
        (success, responseData) {
          if (success) {
            log('[DriverCubit] email verification: $verificationCode');
            _updateDriverEmail(email);
          } else {
            _updateDriverEmail(email);
          }
        },
      );
    } catch (e) {
      log('[DriverCubit] email verification error: $e');
      _updateDriverEmail(email);
    }
  }

  Future<void> requestPhoneUpdate(
    BuildContext context,
    String newPhone,
  ) async {
    if (_cachedDriver == null) return;

    final phone = _cachedDriver?.phone ?? '';

    _updateDriverPhone(newPhone);

    try {
      await apiController.post(
        context,
        'request-phone-update',
        {'newPhone': newPhone},
        (success, responseData) {
          if (success) {
            log('[DriverCubit] phone updated: $newPhone');
            _updateDriverPhone(newPhone);
          } else {
            _updateDriverPhone(phone);
          }
        },
      );
    } catch (e) {
      log('[DriverCubit] phone error: $e');
      _updateDriverPhone(phone);
    }
  }

  Future<void> verifyPhoneUpdate(
    BuildContext context,
    String verificationCode,
  ) async {
    if (_cachedDriver == null) return;

    final email = _cachedDriver?.email ?? '';

    emit(DriverLoading());
    try {
      await apiController.post(
        context,
        'verify-phone-update',
        {'verificationCode': verificationCode},
        (success, responseData) {
          if (success) {
            log('[DriverCubit] email verification: $verificationCode');
            _updateDriverEmail(email);
          } else {
            _updateDriverEmail(email);
          }
        },
      );
    } catch (e) {
      log('[DriverCubit] email verification error: $e');
      _updateDriverEmail(email);
    }
  }

  Future<void> requestNameUpdate(
    BuildContext context, {
    required String newFirstName,
    required String newOtherName,
    required String newSurname,
  }) async {
    if (_cachedDriver == null) return;

    final firstName = _cachedDriver?.firstName ?? '';
    final otherName = _cachedDriver?.otherName ?? '';
    final surname = _cachedDriver?.surname ?? '';

    _updatePendingDriverName(newFirstName, newOtherName, newSurname);

    try {
      await apiController.post(
        context,
        'request-name-update',
        {
          'firstName': newFirstName,
          'surname': newSurname,
          'otherName': newOtherName,
        },
        (success, responseData) {
          if (success) {
            log('[DriverCubit] name update sent: $firstName');
            _updatePendingDriverName(firstName, otherName, surname);
          } else {
            _updatePendingDriverName(firstName, otherName, surname);
          }
        },
      );
    } catch (e) {
      log('[DriverCubit] name error: $e');
      _updatePendingDriverName(firstName, otherName, surname);
    }
  }

  Future<void> checkNameUpdateStatus(BuildContext context) async {
    if (_cachedDriver == null) return;

    final firstName = _cachedDriver?.firstName ?? '';
    final otherName = _cachedDriver?.otherName ?? '';
    final surname = _cachedDriver?.surname ?? '';

    try {
      await apiController.getData(
        context,
        'name-update-status',
        (success, responseData) {
          if (success) {
            final pendingNameUpdate = responseData['pendingNameUpdate'];
            log('[DriverCubit] cancelNameUpdate update sent: $firstName');
            _updateDriverName(
              pendingNameUpdate['firstName'].toString(),
              pendingNameUpdate['otherName'].toString(),
              pendingNameUpdate['surname'].toString(),
              pendingNameUpdate['status'].toString(),
              DateTime.tryParse(pendingNameUpdate['requestedAt'].toString()),
            );
          } else {
            _updateDriverName(firstName, otherName, surname, 'pending', null);
          }
        },
      );
    } catch (e) {
      log('[DriverCubit] pendingNameUpdate error: $e');
      _updateDriverName(firstName, otherName, surname, 'pending', null);
    }
  }

  Future<void> cancelNameUpdate(BuildContext context) async {
    if (_cachedDriver == null) return;

    try {
      await apiController.destroy(
        context,
        'cancel-update-update',
        (success, responseData) {
          if (success) {
            log('[DriverCubit] Canceled pendingNameUpdate');
            _cancelPendingDriverNameRequest();
          } else {
            _cancelPendingDriverNameRequest();
          }
        },
      );
    } catch (e) {
      log('[DriverCubit] Cancel pendingNameUpdate error: $e');
      _cancelPendingDriverNameRequest();
    }
  }

  void resetDriverCache() => _cachedDriver = null;

  // Private helpers
  void _updateDriverStatus(String status) {
    _cachedDriver = _cachedDriver?.copyWith(status: status);
    if (_cachedDriver != null) emit(DriverLoaded(_cachedDriver!));
  }

  void _updateDriverLocation(List<double> coordinates) {
    _cachedDriver = _cachedDriver?.copyWith(
      location: DriverLocation(type: 'Point', coordinates: coordinates),
    );
    if (_cachedDriver != null) emit(DriverLoaded(_cachedDriver!));
  }

  void _updateDriverRidePreference(String ridePreference) {
    _cachedDriver = _cachedDriver?.copyWith(ridePreference: ridePreference);
    if (_cachedDriver != null) emit(DriverLoaded(_cachedDriver!));
  }

  void _updateDriverEmail(String email) {
    _cachedDriver = _cachedDriver?.copyWith(email: email);
    if (_cachedDriver != null) emit(DriverLoaded(_cachedDriver!));
  }

  void _updateDriverPhone(String phone) {
    _cachedDriver = _cachedDriver?.copyWith(phone: phone);
    if (_cachedDriver != null) emit(DriverLoaded(_cachedDriver!));
  }

  void _updatePendingDriverName(
    String firstName,
    String otherName,
    String surname,
  ) {
    _cachedDriver = _cachedDriver?.copyWith(
      pendingNameUpdate: PendingNameUpdate(
        status: 'pending',
        requestedAt: DateTime.now(),
        firstName: firstName,
        otherName: otherName,
        surname: surname,
      ),
    );
    if (_cachedDriver != null) emit(DriverLoaded(_cachedDriver!));
  }

  void _updateDriverName(
    String firstName,
    String otherName,
    String surname,
    String status,
    DateTime? requestedAt,
  ) {
    if (status != 'pending') {
      _cachedDriver = _cachedDriver?.copyWith(
        firstName: firstName,
        otherName: otherName,
        surname: surname,
        pendingNameUpdate: PendingNameUpdate(
          status: status,
          requestedAt: requestedAt,
          firstName: firstName,
          otherName: otherName,
          surname: surname,
        ),
      );
    }
    if (_cachedDriver != null) emit(DriverLoaded(_cachedDriver!));
  }

  void _cancelPendingDriverNameRequest() {
    _cachedDriver = _cachedDriver?.copyWith(
      pendingNameUpdate: PendingNameUpdate(
        status: '',
        firstName: '',
        otherName: '',
        surname: '',
        requestedAt: null,
      ),
    );
    if (_cachedDriver != null) emit(DriverLoaded(_cachedDriver!));
  }
}
