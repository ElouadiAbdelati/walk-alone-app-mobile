import 'package:flutter/material.dart';
import 'package:walk_alone/actions/maps.dart';
import 'package:walk_alone/api/speech_api.dart';
import 'package:walk_alone/utils.dart';

class Subject {
  static final MAPS_SUBJECT = 1;
  static final NONE_SUBJECT = 0;

  static int SUBJECT = NONE_SUBJECT;

  static void findSubject(
      {@required String rawText, @required ValueChanged<bool> onResult}) async {
    var subject = await scanText(rawText);
    if (subject == MAPS_SUBJECT) {
      Maps.mapsSubject(text: rawText, onResult: (value) => {onResult(value)});
    } else if (subject == NONE_SUBJECT) {
       SpeechApi.textTospeech(
        onResult: (_isFinishing) => {onResult(_isFinishing)}, text: Answer.subjectNotDefined);
    }
  }

  static Future<int> scanText(String text) async {
    text = text.toLowerCase();

    if (text.contains(Command.destination)) {
      SUBJECT = MAPS_SUBJECT;
      return SUBJECT;
    }
    return NONE_SUBJECT;
  }
}