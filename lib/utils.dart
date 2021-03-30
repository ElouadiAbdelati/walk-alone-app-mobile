import '../api/speech_api.dart';

import 'package:flutter/cupertino.dart';

class Command {
  static final all = [start, browser1, browser2];

  static const start = 'bienvenue a walk alone comment puis-je vous aider';
  static const browser1 = 'open';
  static const browser2 = 'go to';
}

class Utils {
  static void scanText({
      @required String rawText, @required ValueChanged<bool> onResult}) async {
    final text = rawText.toLowerCase();
    if (text.contains("start")) {
       textToSpeech(
          text:Command.start,
          onResult: (_isFinishing) => {onResult(_isFinishing)});
    }
  }

  static void textToSpeech({
      @required String text, @required ValueChanged<bool> onResult}) async {
      SpeechApi.textTospeech(
        onResult: (_isFinishing) => {onResult(_isFinishing)}, text: text);
  }
}
