import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:freedom_driver/core/config/api_constants.dart';
import 'package:freedom_driver/feature/rides/models/rides.model.dart';
import 'package:freedom_driver/utilities/hive/token.dart';
import 'package:freedom_driver/utilities/notification_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class DriverSocketConstants {
  static const String transportWebSocket = 'websocket';
  static const String authKey = 'auth';
  static const String tokenKey = 'token';
  static const String transportsKey = 'transports';
  static const String autoConnectKey = 'autoConnect';

  static const String newRideRequest = 'new_ride_request';
  static const String rideAccepted = 'ride_accepted';
  static const String rideStatusUpdated = 'ride_status_updated';

  static const String updateLocation = 'update_location';
  static const String acceptRideRequest = 'accept_ride_request';
  static const String rejectRideRequest = 'reject_ride_request';
  static const String setDriverStatus = 'set_driver_status';

  static const String status = 'status';
  static const String available = 'available';
  static const String unavailable = 'unavailable';

  static const String socketConnected = '[Socket] Connected';
  static const String socketDisconnected = '[Socket] Disconnected';
  static const String socketConnectionError = '[Socket] Connection error: ';
  static const String newRideRequestLog = '[Socket] New ride request: ';
  static const String rideAcceptedLog =
      '[Socket] Confirmation of ride acceptance ';
  static const String rideStatusUpdatedLog = '[Socket] Ride status updated: ';
  static const String driverStatusLog = '[Socket Driver status] available ';
}

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
        DriverSocketConstants.authKey: {
          DriverSocketConstants.tokenKey: token,
        },
        DriverSocketConstants.transportsKey: [
          DriverSocketConstants.transportWebSocket,
        ],
        DriverSocketConstants.autoConnectKey: false,
      },
    );

    _socket!.onConnect((_) {
      log(DriverSocketConstants.socketConnected);
      setDriverStatus(available: true);
      onConnect?.call();
    });

    _socket!.onDisconnect((_) {
      log(DriverSocketConstants.socketDisconnected);
      onDisconnect?.call();
    });

    _socket!.onConnectError((err) {
      log('${DriverSocketConstants.socketConnectionError}$err');
    });

    _socket!.on(DriverSocketConstants.newRideRequest, (data) {
      log('${DriverSocketConstants.newRideRequestLog}$data');
      final ride = AcceptRide.fromJson(data as Map<String, dynamic>);
      NotificationService.sendNotification(
        title: 'New ride request',
        body: 'New ride from ${ride.pickupLocation.address}',
      );

      onNewRideRequest
          ?.call(Map<String, dynamic>.from(data as Map<dynamic, dynamic>));
    });

    _socket!.on(DriverSocketConstants.rideAccepted, (data) {
      log('${DriverSocketConstants.rideAcceptedLog}${data[DriverSocketConstants.status]}');
      onNewRideAccepted?.call(data[DriverSocketConstants.status] as String);
    });

    _socket!.on(DriverSocketConstants.rideStatusUpdated, (data) {
      log('${DriverSocketConstants.rideStatusUpdatedLog}${data[DriverSocketConstants.status]}');
      onRideStatusUpdate?.call(data[DriverSocketConstants.status] as String);
    });

    _socket!.connect();
  }

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }

  void updateDriverLocation(String rideId) {
    _socket?.emit(
      DriverSocketConstants.updateLocation,
      {'rideId': rideId},
    );
  }

  void acceptRideRequest(String rideId) {
    _socket?.emit(
      DriverSocketConstants.acceptRideRequest,
      {'rideId': rideId},
    );
  }

  void rejectRideRequest(String rideId) {
    _socket?.emit(
      DriverSocketConstants.rejectRideRequest,
      {'rideId': rideId},
    );
  }

  void setDriverStatus({bool available = false}) {
    log('${DriverSocketConstants.driverStatusLog}$available');
    _socket?.emit(
      DriverSocketConstants.setDriverStatus,
      {
        DriverSocketConstants.status: available
            ? DriverSocketConstants.available
            : DriverSocketConstants.unavailable,
      },
    );
  }
}
