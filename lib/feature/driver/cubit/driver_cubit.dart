import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/feature/authentication/register/view/verify_otp_screen.dart';
import 'package:freedomdriver/feature/driver/cubit/driver_state.dart';
import 'package:freedomdriver/feature/driver/driver.model.dart';
import 'package:freedomdriver/feature/profile/view/profile_details.dart';
import 'package:freedomdriver/shared/api/api_controller.dart';
import 'package:freedomdriver/shared/api/api_handler.dart';
import 'package:freedomdriver/utilities/driver_location_service.dart';
import 'package:freedomdriver/utilities/socket_service.dart';


class DriverCubit extends Cubit<DriverState> {
  DriverCubit() : super(DriverInitial());

  final ApiController apiController = ApiController('');
  final DriverSocketService driverSocketService = DriverSocketService();
  Driver? _cachedDriver;

  Driver? get currentDriver => _cachedDriver;
  bool get hasDriver => _cachedDriver != null;

  void _updateDriver(Driver updated) {
    _cachedDriver = updated;
    emit(DriverLoaded(_cachedDriver!));
  }

  void _emitIfChanged(Driver updated) {
    if (_cachedDriver != updated) {
      _updateDriver(updated);
    } else {
      log('[DriverCubit] No changes detected, not emitting new state');
    }
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

  Future<void> toggleStatus(
    BuildContext context, {
    bool setAvailable = false,
    bool toggleOnlyApi = false,
  }) async {
    if (!hasDriver) return;

    final current = setAvailable
        ? DriverStatus.unavailable.name
        : (_cachedDriver!.status ?? DriverStatus.unavailable.name);
    final isUnavailable = current == DriverStatus.unavailable.name;
    final newStatus = isUnavailable
        ? DriverStatus.available.name
        : DriverStatus.unavailable.name;

    _emitIfChanged(_cachedDriver!.copyWith(status: newStatus));
    DriverLocationService().sendCurrentLocationOnce(context);

    await handleApiCall(
      context: context,
      apiRequest: () => apiController.put(
        context,
        'status',
        {'status': newStatus},
        (success, _) {
          if (success) {
            log('[DriverCubit] Status updated: $newStatus');
            if (toggleOnlyApi) return;
            driverSocketService.setDriverStatus(available: isUnavailable);
          } else {
            _emitIfChanged(_cachedDriver!.copyWith(status: current));
          }
        },
      ),
      onFailure: () => _emitIfChanged(_cachedDriver!.copyWith(status: current)),
    );
  }

  Future<void> updateDriverLocation(
    BuildContext context,
    List<double> newLocation,
  ) async {
    if (_cachedDriver == null) return;

    final previous = _cachedDriver?.location?.coordinates ?? [];

    if (newLocation == previous) return;

    _emitIfChanged(
      _cachedDriver!.copyWith(
        location: DriverLocation(type: 'Point', coordinates: newLocation),
      ),
    );

    try {
      await apiController.put(
        context,
        'location',
        {'coordinates': newLocation},
        (success, responseData) {
          if (success) {
            log('[DriverCubit] coordinates updated: $newLocation');
          } else {
            _emitIfChanged(
              _cachedDriver!.copyWith(
                location: DriverLocation(
                  type: 'Point',
                  coordinates: previous,
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      log('[DriverCubit] location error: $e');
      _emitIfChanged(
        _cachedDriver!.copyWith(
          location: DriverLocation(
            type: 'Point',
            coordinates: previous,
          ),
        ),
      );
    }
  }

  Future<void> updateDriverRidePreference(
    BuildContext context, {
    String newRidePreference = 'both',
  }) async {
    if (_cachedDriver == null) return;

    final currentRidePreference = _cachedDriver?.ridePreference ?? '';

    if (currentRidePreference.trim() == newRidePreference.trim()) return;

    _updateDriverRidePreference(newRidePreference);

    try {
      await apiController.patch(
        context,
        'preference',
        {'ridePreference': newRidePreference},
        (success, responseData) {
          if (success) {
            log('[DriverCubit] new Ride Preference updated: $newRidePreference');
            _updateDriverRidePreference(newRidePreference);
          } else {
            _updateDriverRidePreference(currentRidePreference);
          }
        },
        // showOverlay: true,
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
    if (!hasDriver) return;

    final previous = _cachedDriver?.email ?? '';
    if (previous.trim() == newEmail.trim()) return;

    _emitIfChanged(_cachedDriver!.copyWith(email: newEmail));

    try {
      await apiController.post(
        context,
        'request-email-update',
        {'newEmail': newEmail},
        (success, responseData) {
          if (success) {
            log('[DriverCubit] email updated: $newEmail');
            // context.read<RegistrationFormCubit>().setEmail(newEmail);
            Navigator.pushNamed(
              context,
              VerifyOtpScreen.routeName,
              arguments: {'type': 'emailUpdate'},
            );
          } else {
            _updateDriverEmail(previous);
          }
        },
        showOverlay: true,
      );
    } catch (e) {
      log('[DriverCubit] email error: $e');
      _updateDriverEmail(previous);
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
      log('[DriverCubit] email verification: $verificationCode');
      await apiController.post(
        context,
        'verify-email-update',
        {'verificationCode': verificationCode},
        (success, responseData) {
          if (success) {
            _updateDriverEmail(email);
            Navigator.pushReplacementNamed(
              context,
              ProfileDetails.routeName,
            );
          } else {
            _updateDriverEmail(email);
          }
        },
        showOverlay: true,
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
            Navigator.pushNamed(
              context,
              VerifyOtpScreen.routeName,
              arguments: {'type': 'phoneUpdate'},
            );
          } else {
            _updateDriverPhone(phone);
          }
        },
        showOverlay: true,
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
            log('[DriverCubit] phone verification: $verificationCode');
            _updateDriverEmail(email);
            Navigator.pushReplacementNamed(
              context,
              ProfileDetails.routeName,
            );
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
    required String newFullName,
  }) async {
    if (_cachedDriver == null) return;

    final firstName = _cachedDriver?.firstName ?? '';
    final otherName = _cachedDriver?.otherName ?? '';
    final surname = _cachedDriver?.surname ?? '';

    if (_cachedDriver?.fullName.trim() == newFullName.trim()) return;

    final newNameSplit = newFullName.split(' ');

    final newFirstName = newNameSplit[0];
    final newOtherName = newNameSplit[1];
    final newSurname = newNameSplit[newNameSplit.length - 1];

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
            log('[DriverCubit] name update sent: $newFullName');
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
  void _updateDriverRidePreference(String newRidePreference) {
    log(newRidePreference);
    _cachedDriver = _cachedDriver?.copyWith(ridePreference: newRidePreference);
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

  void updateDriverAddress({
    required String street,
    required String city,
    required String state,
    required String country,
    required String postalCode,
  }) {
    _cachedDriver = _cachedDriver?.copyWith(
      address: Address(
        street: street,
        city: city,
        state: state,
        country: country,
        postalCode: postalCode,
      ),
    );
    if (_cachedDriver != null) emit(DriverLoaded(_cachedDriver!));
  }
}
