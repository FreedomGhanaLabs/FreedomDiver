import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:freedomdriver/utilities/notification_service.dart';

import '../../utilities/get_platform.dart';
import '../../utilities/hive/fcm_token.dart';
import 'api_controller.dart';

class FCMService {
  ApiController apiController = ApiController("fcm", noDriver: true);

  Future<void> registerFCM(BuildContext context) async {
    try {
      await NotificationService.initializeNotifications();
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken == null || fcmToken.isEmpty) {
        log('[FCM TOKEN] Failed to get token');
        return;
      }

      await addFCMTokenToHive(fcmToken);
      log('[FCM TOKEN] token added to hive');
      final platform = getCurrentPlatform();

      await apiController.post(
        context,
        "register",
        {'token': fcmToken, 'platform': platform},
        (success, data) {
          if (success) {
            log("[FCM Backend] $data");
          } else {
            log("[FCM Backend] Registration failed: $data");
          }
        },
        shouldShowToast: false
      );
    } catch (e, stack) {
      log('[FCM ERROR] $e', stackTrace: stack);
    }
  }
}
