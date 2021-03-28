import '../api/speech_api.dart';

import 'package:flutter/cupertino.dart';

class Command {
  static final all = [start, browser1, browser2];

  static const start = 'bienvenue a walk alone comment puis-je vous aider';
  static const browser1 = 'open';
  static const browser2 = 'go to';
}

class Utils {
   static bool isPlaying =false;
  static Future<void>  scanText(String rawText) async {
    final text = rawText.toLowerCase();
    
    if (text.contains("start")) {
        await textToSpeech(Command.start);
    } 
  }

  static Future<void>  textToSpeech(String text) async {
     await SpeechApi.textTospeech(
      onResult: (_isPlaying)=> {
            
     }, text: text
    );

  }
  

}

