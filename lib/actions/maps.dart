import 'package:flutter/material.dart';
import 'package:walk_alone/actions/subject.dart';
import 'package:walk_alone/utils.dart';

class Maps {
  static bool ifAskedToConfirm = false;
  static bool userTalkAfterTextToSpeech = true;
  static void mapsSubject(
      {@required String text, @required ValueChanged<bool> onResult}) async {
    var body = await scanText(text);
    if (userTalkAfterTextToSpeech) {
      Utils.textToSpeech(
          text: body, onResult: (_isFinishing) => {onResult(_isFinishing)});
    } else {
      Utils.textToSpeech(text: body, onResult: (_isFinishing) => {});
    }
  }

  static Future<String> scanText(String text) async {
    text = text.toLowerCase();
    var body;
    if (text.contains(Command.destination)) {
      body = await Utils.getTextAfterCommand(
          text: text, command: Command.destination);

      body = body + " la destination est trouvé voulez-vous confirmer ";
      ifAskedToConfirm = true;
    } else if (text.contains(Command.confirm) && ifAskedToConfirm) {
      body = "oui";
      ifAskedToConfirm = false;
    } else if (text.contains(Command.cancel) && ifAskedToConfirm) {
      body = Answer.cancel;
      ifAskedToConfirm = false;
      Subject.SUBJECT = Subject.NONE_SUBJECT;
      userTalkAfterTextToSpeech=false;
    }

    return body;
  }
}
