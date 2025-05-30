import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/api/api_controller.dart';
import '../../home/cubit/home_cubit.dart';
import 'delivery_state.dart';

class DeliveryCubit extends Cubit<DeliveryState> {
  DeliveryCubit() : super(DeliveryInitial());

  // AcceptDelivery? _cachedAcceptDelivery;

  // AcceptDelivery? get currentDriver => _cachedAcceptDelivery;
  // bool get hasAcceptedDelivery => _cachedAcceptDelivery != null;

  // void _updateAcceptDelivery(AcceptDelivery updated) {
  //   _cachedAcceptDelivery = updated;
  //   emit(DeliveryLoaded(_cachedAcceptDelivery!));
  // }

  // void _emitIfChanged(AcceptDelivery updated) {
  //   if (_cachedAcceptDelivery != updated) {
  //     _updateAcceptDelivery(updated);
  //   } else {
  //     log('[DeliveryCubit] No changes detected, not emitting new state');
  //   }
  // }

  final ApiController apiController = ApiController('delivery');

  Future<void> fetchDelivery(BuildContext context, String rideId) async {
    emit(DeliveryLoading());
    try {
      await apiController.getData(context, rideId, (success, data) {
        if (success) {
          // final delivery = AcceptDelivery.fromJson(data as Map<String, dynamic>);
          // emit(DeliveryLoaded(delivery));
        }
      });
    } catch (e) {
      emit(DeliveryError('Failed to load delivery'));
    }
  }

  Future<void> acceptDelivery(
    BuildContext context, {
    required String rideId,
    double latitude = 6.520379,
    double longitude = 3.375206,
  }) async {
    emit(DeliveryLoading());
    try {
      await apiController.post(
        context,
        '$rideId/accept',
        {'latitude': latitude, 'longitude': longitude},
        (success, data) {
          if (success) {
            // final delivery = AcceptDelivery.fromJson(data as Map<String, dynamic>);
            // _updateAcceptDelivery(delivery);
            // updateStatus(context, TransitStatus.accepted);
          }
        },
      );
    } catch (e) {
      emit(DeliveryError('Failed to load delivery'));
    }
  }

  Future<void> rejectDelivery(
    BuildContext context, {
    required String rideId,
    String reason = 'Too far from my current location',
  }) async {
    try {
      await apiController.post(context, '$rideId/reject', {'reason': reason}, (
        success,
        data,
      ) {
        if (success) {
          log('[DeliveryCubit] delivery rejected');
          updateStatus(context, TransitStatus.declined);
        }
      });
    } catch (e) {
      emit(DeliveryError('Failed to reject delivery'));
    }
  }

  Future<void> cancelDelivery(
    BuildContext context, {
    required String rideId,
    String reason = 'Too far from my current location',
    double latitude = 6.520379,
    double longitude = 3.375206,
  }) async {
    try {
      await apiController.post(
        context,
        '$rideId/cancel',
        {'reason': reason, 'latitude': latitude, 'longitude': longitude},
        (success, data) {
          if (success) {
            log('[DeliveryCubit] delivery cancel');
            updateStatus(context, TransitStatus.initial);
          }
        },
      );
    } catch (e) {
      emit(DeliveryError('Failed to cancel delivery'));
    }
  }

  Future<void> arrivedDelivery(
    BuildContext context, {
    required String rideId,
    double latitude = 6.520379,
    double longitude = 3.375206,
  }) async {
    try {
      await apiController.post(
        context,
        '$rideId/arrived',
        {'latitude': latitude, 'longitude': longitude},
        (success, data) {
          if (success) {
            log('[DeliveryCubit] delivery arrived');
          }
        },
      );
    } catch (e) {
      emit(DeliveryError('Failed to arrive delivery'));
    }
  }

  Future<void> startDelivery(
    BuildContext context, {
    required String rideId,
    double latitude = 6.520379,
    double longitude = 3.375206,
  }) async {
    try {
      await apiController.post(
        context,
        '$rideId/start',
        {'latitude': latitude, 'longitude': longitude},
        (success, data) {
          if (success) {
            log('[DeliveryCubit] delivery started');
            // updateStatus(context, TransitStatus.started);
          }
        },
      );
    } catch (e) {
      emit(DeliveryError('Failed to cancel delivery'));
    }
  }

  Future<void> completeDelivery(
    BuildContext context, {
    required String rideId,
    double latitude = 6.520379,
    double longitude = 3.375206,
  }) async {
    try {
      await apiController.post(
        context,
        '$rideId/complete',
        {'latitude': latitude, 'longitude': longitude},
        (success, data) {
          if (success) {
            log('[DeliveryCubit] delivery completed');
            updateStatus(context, TransitStatus.completed);
          }
        },
        showOverlay: true,
      );
    } catch (e) {
      emit(DeliveryError('Failed to end delivery'));
    }
  }

  Future<void> confirmDeliveryPayment(
    BuildContext context, {
    required String rideId,
  }) async {
    try {
      await apiController.post(context, '$rideId/confirm-payment', {}, (
        success,
        data,
      ) {
        if (success) {
          log('[DeliveryCubit] delivery confirm payment');
        }
      }, showOverlay: true);
    } catch (e) {
      emit(DeliveryError('Failed to end delivery'));
    }
  }

  Future<void> rateDeliveryUser(
    BuildContext context, {
    required String rideId,
    double rating = 5,
    String comment = 'Very polite and punctual',
  }) async {
    try {
      await apiController.post(
        context,
        '$rideId/rate',
        {'rating': rating, 'comment': comment},
        (success, data) {
          if (success) {
            log('[DeliveryCubit] delivery user rated $rating');
          }
        },
        showOverlay: true,
      );
    } catch (e) {
      emit(DeliveryError('Failed to end delivery'));
    }
  }

  Future<void> updateStatus(BuildContext context, TransitStatus newStatus) async {
    // if (!hasAcceptedDelivery) return;

    // final previousStatusName = _cachedAcceptDelivery!.status;

    // emit(DeliveryUpdating(_cachedAcceptDelivery!.copyWith(status: newStatus.name)));
    // emit(DeliveryLoaded(_cachedAcceptDelivery!.copyWith(status: newStatus.name)));

    try {
      await apiController.patch(
        context,
        '_cachedAcceptDelivery!.rideId',
        {'status': newStatus.name},
        (success, data) {
          if (success) {
            log('[delivery cubit] status has been updated');
          } else {
            // emit(
            //   DeliveryLoaded(
            //     _cachedAcceptDelivery!.copyWith(status: previousStatusName),
            //   ),
            // );
          }
        },
      );
    } catch (_) {
      emit(DeliveryError('Failed to update status'));
      // emit(
      //   DeliveryLoaded(_cachedAcceptDelivery!.copyWith(status: previousStatusName)),
      // ); // restore
    }
  }
}
