import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../utilities/get_platform.dart';
import '../../utilities/hive/fcm_token.dart';
import 'api_controller.dart';

class FCMService {
  ApiController apiController = ApiController("fcm", noDriver: true);

  Future<void> registerFCM(BuildContext context) async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken == null || fcmToken.isEmpty) {
        log('[FCM TOKEN] Failed to get token');
        return;
      }
      log('[FCM TOKEN] $fcmToken');
      await addFCMTokenToHive(fcmToken);
      log('[FCM TOKEN] token added to hive');
      await apiController.post(
        context,
        "register",
        {'fcmToken': fcmToken, 'platform': getCurrentPlatform()},
        (success, data) {
          if (success) {
            log("[FCM Backend] $data");
          } else {
            log("[FCM Backend] Registration failed: $data");
          }
        },
      );
    } catch (e, stack) {
      log('[FCM ERROR] $e', stackTrace: stack);
    }
  }
}
