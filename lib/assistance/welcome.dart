import 'package:flutter/material.dart';
import 'package:walk_alone/api/speech_api.dart';
import 'package:walk_alone/utils.dart';
import 'package:walk_alone/assistance/command.dart';
import 'package:walk_alone/assistance/answer.dart';

class Welcome {
  static void index({@required ValueChanged<bool> onResult}) {
    SpeechApi.textTospeech(
        onResult: (_isFinishing) => {onResult(_isFinishing)},
        text: Answer.start);
  }
}
