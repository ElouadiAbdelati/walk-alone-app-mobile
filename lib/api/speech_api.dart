import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SpeechApi {
  static final _speech = SpeechToText();
  static final _flutterTts = FlutterTts();

  static Future<bool> toggleRecording({
    @required Function(String text) onResult,
    @required ValueChanged<bool> onListening,
  }) async {
    if (_speech.isListening) {
      _speech.stop();
      return true;
    }

    final isAvailable = await _speech.initialize(
      onStatus: (status) => onListening(_speech.isListening),
      onError: (e) => print('Error: $e'),
    );

    if (isAvailable) {
      _speech.listen(onResult: (value) => onResult(value.recognizedWords));
    }

    return isAvailable;
  }

  static void textTospeech({
    @required String text,
    @required ValueChanged<bool> onResult,
  }) async {
    if (text != null && text.isNotEmpty) {
      await _flutterTts.setLanguage('fr-FR');
      await _flutterTts.setSpeechRate(1.0);
      await _flutterTts.setPitch(1.0);
      _flutterTts.setCompletionHandler(() {
        bool isFinishing = true;
        onResult(isFinishing);
      });
      await _flutterTts.speak(text);
    }
  }
}
