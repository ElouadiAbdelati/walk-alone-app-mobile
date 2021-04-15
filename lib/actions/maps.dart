import 'package:flutter/material.dart';
import 'package:walk_alone/actions/subject.dart';
import 'package:walk_alone/api/google_maps_api.dart';
import 'package:walk_alone/model/Destination.dart';
import 'package:walk_alone/utils.dart';
import 'package:http/http.dart' as http;

class Maps {
  static bool ifAskedToConfirm = false;
  static bool userTalkAfterTextToSpeech = true;
  static bool multipleDestinations = false;
  static List<Destiantion> destinations = new List();
  static void mapsSubject(
      {@required String text, @required ValueChanged<bool> onResult}) async {
    var body = await scanText(text);

    if (userTalkAfterTextToSpeech) {
      Utils.textToSpeech(
          text: body, onResult: (_isFinishing) => {onResult(_isFinishing)});
    } else {
      Utils.textToSpeech(text: body, onResult: (_isFinishing) => {});
      userTalkAfterTextToSpeech = true;
    }
  }

  static Future<String> scanText(String text) async {
    text = text.toLowerCase();
    var body;
    if (text.contains(Command.destination)) {
      body = await Utils.getTextAfterCommand(
          text: text, command: Command.destination);
      if (body == '') {
        return body ='djkcsndchniosd';
      } 
       destinations = await GoogleMapsApi.findDestinations(body);
       //print(destinations);
       if (destinations.length == 1) {
        body = destinations[0].adr + " la destination est trouvé voulez-vous confirmer ";
        ifAskedToConfirm = true;
      } else {
      
        multipleDestinations = true;
        body =
            "Nous avons trouvé 2 destinations, choisissez-en une. 1 : Casa 2: Marrakech";
      }
    } else if (multipleDestinations) {
      int choice = -1;
      for (int i = 1; i <= destinations.length; i++) {
        if (text.contains(i.toString())) {
          choice = i;
          break;
        }
      }
      if (choice == -1) {
        body = "Le choix n'existe pas. Veuillez réessayer";
      } else {
        body = destinations[choice - 1].adr + Answer.confirm;
        multipleDestinations = false;
        ifAskedToConfirm = true;
      }
    } else if (text.contains(Command.confirm) && ifAskedToConfirm) {
      body = "ok";
      ifAskedToConfirm = false;
      userTalkAfterTextToSpeech = false;
    } else if (text.contains(Command.cancel) && ifAskedToConfirm) {
      body = Answer.cancel;
      ifAskedToConfirm = false;
      Subject.SUBJECT = Subject.NONE_SUBJECT;
      userTalkAfterTextToSpeech = false;
    }

    return body;
  }
}
