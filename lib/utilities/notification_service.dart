import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:freedomdriver/feature/home/view/widgets/build_dialog.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';
import 'package:timezone/timezone.dart' as tz;

import 'package:freedomdriver/feature/app/app.dart';
import 'package:freedomdriver/feature/rides_and_delivery/cubit/ride/ride_cubit.dart';
import 'package:freedomdriver/feature/rides_and_delivery/models/request_ride.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'basic_channel', // channel ID
    'Basic Notifications', // channel name
    description: 'Notification channel for basic tests',
    importance: Importance.high,
    enableLights: true,
    ledColor: gradient1,
  );

  static Future<void> initializeNotifications() async {
    await Firebase.initializeApp();

    // Request permission
    await _requestPermissions();

    // Create channel (Android)
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    // Init plugin
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        // Handle local notification tap
        log('Local notification tapped: ${response.payload}');
        try {
          final jsonPayload = jsonDecode(response.payload ?? '{}');
          if (jsonPayload is Map<String, dynamic> &&
              jsonPayload.containsKey('rideId')) {
            final data = jsonPayload;
            final ride = RideRequest.fromJson(data);
            final context = navigatorKey.currentState?.context;
            if (context != null) {
              context.read<RideCubit>().foundRide(ride, context);
              context.showRideDialog();
            } else {
              log('Overlay context not available');
            }
          }
        } catch (e) {
          log('Failed to handle notification payload: $e');
        }
      },
    );

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Received foreground FCM: ${message.notification?.title}');
      _showLocalNotification(
        title: message.notification?.title ?? '',
        body: message.notification?.body ?? '',
        payload: message.data,
      );
    });

    // Handle background & terminated state messages (when tapped)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('Notification opened: ${message.notification?.title}');
    });

    log('[NOTIFICATION] initialized successfully');
  }

  static Future<void> _requestPermissions() async {
    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission();

    log('User granted permission: ${settings.authorizationStatus}');
  }

  static Future<void> _showLocalNotification({
    required String title,
    required String body,
    Map<String, dynamic>? payload,
    List<AndroidNotificationAction>? actions,
  }) async {
    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.max,
          priority: Priority.high,
          color: gradient1,
          enableLights: true,
          actions: actions,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: jsonEncode(payload),
    );
  }

  static Future<void> sendNotification({
    required String title,
    required String body,
    Map<String, dynamic>? payload,
    List<AndroidNotificationAction>? actions,
  }) async {
    await _showLocalNotification(
      title: title,
      body: body,
      payload: payload,
      actions: actions,
    );
  }

  static Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduleTime,
    Map<String, dynamic>? payload,
  }) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      tz.TZDateTime.from(scheduleTime, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: payload?.toString(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
