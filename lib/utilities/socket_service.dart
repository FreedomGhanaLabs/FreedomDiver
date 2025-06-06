import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:freedomdriver/core/config/api_constants.dart';
import 'package:freedomdriver/feature/rides/models/request_ride.dart';
import 'package:freedomdriver/utilities/hive/token.dart';
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
    Function(RideRequest)? onNewRideRequest,
    Function(String status)? onNewRideAccepted,
    Function(String status)? onRideStatusUpdate,
  }) async {
    final token = await getTokenFromHive();
    _socket?.disconnect();

    _socket = io.io(ApiConstants.baseUrl, {
      DriverSocketConstants.authKey: {DriverSocketConstants.tokenKey: token},
      DriverSocketConstants.transportsKey: [
        DriverSocketConstants.transportWebSocket,
      ],
      DriverSocketConstants.autoConnectKey: false,
    });

    _socket!
      ..onConnect((_) {
        log("${DriverSocketConstants.socketConnected} ${_socket!.id}");
        setDriverStatus(available: true);
        onConnect?.call();
      })
      ..onDisconnect((_) {
        log(DriverSocketConstants.socketDisconnected);
        onDisconnect?.call();
      })
      ..onConnectError((err) {
        log('${DriverSocketConstants.socketConnectionError}$err');
      });

    _registerRideEvent<RideRequest>(
      DriverSocketConstants.newRideRequest,
      (data) => RideRequest.fromJson(data),
      (ride) {
        log('${DriverSocketConstants.newRideRequestLog}${ride.toJson()}');
        onNewRideRequest?.call(ride);
      },
    );

    // _registerRideEvent<RideRequest>(
    //   DriverSocketConstants.rideAccepted,
    //   (data) => RideRequest.fromJson(data),
    //   (ride) {
    //     log('${DriverSocketConstants.rideAcceptedLog}${ride.status}');
    //     onNewRideAccepted?.call(ride.status);
    //   },
    // );

    // _registerRideEvent<RideRequest>(
    //   DriverSocketConstants.rideStatusUpdated,
    //   (data) => RideRequest.fromJson(data),
    //   (ride) {
    //     log('${DriverSocketConstants.rideStatusUpdatedLog}${ride.status}');
    //     onRideStatusUpdate?.call(ride.status);
    //   },
    // );

    _socket!.connect();
  }

  void _registerRideEvent<T>(
    String event,
    T Function(Map<String, dynamic>) fromJson,
    void Function(T) onData,
  ) {
    _socket!.on(event, (data) {
      if (data == null) {
        log('⚠️ $event received null data.');
        return;
      }
      if (data is Map<String, dynamic>) {
        try {
          final parsed = fromJson(data);
          onData(parsed);
        } catch (e) {
          log('❌ Error parsing $event data: $e');
        }
      } else {
        log('⚠️ Unexpected $event data: $data');
      }
    });
  }

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }

  void updateDriverLocation(String rideId) =>
      _emit(DriverSocketConstants.updateLocation, {'rideId': rideId});

  void acceptRideRequest(String rideId) =>
      _emit(DriverSocketConstants.acceptRideRequest, {'rideId': rideId});

  void rejectRideRequest(String rideId) =>
      _emit(DriverSocketConstants.rejectRideRequest, {'rideId': rideId});

  void setDriverStatus({bool available = false}) {
    log('${DriverSocketConstants.driverStatusLog}$available');
    _emit(DriverSocketConstants.setDriverStatus, {
      DriverSocketConstants.status:
          available
              ? DriverSocketConstants.available
              : DriverSocketConstants.unavailable,
    });
  }

  void _emit(String event, Map<String, dynamic> data) {
    _socket?.emit(event, data);
  }
}
