import '../api/speech_api.dart';
import 'api/google_maps_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class Command {
  
  static const destination = 'je veux aller à';
  static const confirm = 'oui';
  static const cancel = 'annuler';
}

class Answer {
 static const subjectNotDefined = 'Le sujet n\'a pas été déterminé. Veuillez réessayer';
 static const start = 'bienvenue a walk alone comment puis-je vous aider';
 static const cancel="la demande a été annulée";
}

class Utils {


  static void textToSpeech(
      {@required String text, @required ValueChanged<bool> onResult}) async {
    SpeechApi.textTospeech(
        onResult: (_isFinishing) => {onResult(_isFinishing)}, text: text);
  }

  static Future<String> getTextAfterCommand({
    @required String text,
    @required String command,
  }) async {
    final indexCommand = text.indexOf(command);
    final indexAfter = indexCommand + command.length;

    if (indexCommand == -1) {
      return null;
    } else {
      return text.substring(indexAfter).trim();
    }
  }

  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  
}
