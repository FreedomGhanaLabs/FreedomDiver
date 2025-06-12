import 'package:flutter_tts/flutter_tts.dart';

class TTS {
 static final FlutterTts _tts = FlutterTts();

 static Future<void> speak(String text) async {
    await _tts.speak(text);
  }
}
