import '../api/speech_api.dart';
import 'api/google_maps_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class Command {
  static final all = [start, destination, browser2];

  static const start = 'bienvenue a walk alone comment puis-je vous aider';
  static const destination = 'je veux aller à';
  static const browser2 = 'go to';
}

class Utils {
  static void scanText(
      {@required String rawText, @required ValueChanged<bool> onResult}) async {
    final text = rawText.toLowerCase();
    if (text.contains("start")) {
      //start the interaction with the user
      textToSpeech(
          text: Command.start,
          onResult: (_isFinishing) => {onResult(_isFinishing)});

    } else if (text.contains(Command.destination)) {
      //get body text
      var body =
          await getTextAfterCommand(text: text, command: Command.destination);
      //find the user's location
      Position position = await determinePosition();

      //get all destinations exist
    //  http.Response response = await GoogleMapsApi.findDestinations(position, body);
      //print(response);
         int response = await GoogleMapsApi.simulationFindDestinations();

      /* if only one destination is found, confirm the position by the user
          if not, get one of them
      */
      if (response==1 ) {
          body = body+ " la destination est trouvé voulez-vous confirmer ";
      } else {
          
      }

      textToSpeech(
          text: body, onResult: (_isFinishing) => {onResult(_isFinishing)});
    }
  }

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
