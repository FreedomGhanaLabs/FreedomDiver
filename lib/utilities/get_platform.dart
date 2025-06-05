import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;

String getCurrentPlatform() {
  if (kIsWeb) {
    return 'web';
  } else if (Platform.isAndroid) {
    return 'android';
  } else if (Platform.isIOS) {
    return 'ios';
  } else {
    return 'unknown';
  }
}
