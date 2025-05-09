import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:freedom_driver/core/config/api_constants.dart';
import 'package:freedom_driver/utilities/hive/token.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class DriverSocketService {
  io.Socket? _socket;

  Future<void> connect({
    VoidCallback? onConnect,
    VoidCallback? onDisconnect,
    Function(Map<String, dynamic>)? onNewRideRequest,
    Function(String status)? onNewRideAccepted,
    Function(String status)? onRideStatusUpdate,
  }) async {
    final token = await getTokenFromHive();
    _socket?.disconnect();
    _socket = io.io(
      ApiConstants.baseUrl,
      {
        'auth': {'token': token},
        'transports': ['websocket'],
        'autoConnect': false,
      },
    );

    _socket!.onConnect((_) {
      log('[Socket] Connected');
      onConnect?.call();
      setDriverStatus(available: true);
    });

    _socket!.onDisconnect((_) {
      log('[Socket] Disconnected');
      onDisconnect?.call();
    });

    _socket!.onConnectError((err) {
      log('[Socket] Connection error: $err');
    });

    _socket!.on('new_ride_request', (data) {
      log('[Socket] New ride request: $data');
      onNewRideRequest
          ?.call(Map<String, dynamic>.from(data as Map<dynamic, dynamic>));
    });

    _socket!.on('ride_accepted', (data) {
      log('[Socket] Confirmation of ride acceptance ${data['status']}');
      onNewRideAccepted?.call(data['status'] as String);
    });

    _socket!.on('ride_status_updated', (data) {
      log('[Socket] Ride status updated: ${data['status']}');
      onRideStatusUpdate?.call(data['status'] as String);
    });

    _socket!.connect();
  }

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }

  void updateDriverLocation(String rideId) {
    _socket?.emit('update_location', {'rideId': rideId});
  }

  void acceptRideRequest(String rideId) {
    _socket?.emit('accept_ride_request', {'rideId': rideId});
  }

  void rejectRideRequest(String rideId) {
    _socket?.emit('reject_ride_request', {'rideId': rideId});
  }

  void setDriverStatus({bool available = false}) {
    log('[Socket Driver status] available $available');
    _socket?.emit(
      'set_driver_status',
      {'status': available ? 'available' : 'unavailable'},
    );
  }
}
