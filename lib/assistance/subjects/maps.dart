import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:geolocator/geolocator.dart';
import 'package:walk_alone/api/google_maps_api.dart';
import 'package:walk_alone/api/speech_api.dart';
import 'package:walk_alone/config.dart';
import 'package:walk_alone/model/Destination.dart';
import 'package:walk_alone/model/Trip.dart';
import 'package:walk_alone/utils.dart';
import 'package:walk_alone/model/DistanceMatrix.dart';
import 'package:walk_alone/assistance/findSubject.dart';
import 'package:walk_alone/assistance/command.dart';
import 'package:walk_alone/assistance/answer.dart';
class Maps {
  static bool ifAskedToConfirm = false;
  static bool userTalkAfterTextToSpeech = true;
  static bool multipleDestinations = false;
  static List<Destiantion> destinations = new List();
  static String destinationSelected;
  static DistanceMatrix distanceMatrix;
  static Trip trip;

/**
 * Cette fonction traite tous les sujets de navigation
 */
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
    //Body est le texte résultant de l'analyse
    var body;
    if (text.contains(Command.destination)) {
      body = await Utils.getTextAfterCommand(
          text: text, command: Command.destination);
      if (body == '') {
        return body = Answer.bodyOfDestinationIsEmpty;
      }

      destinations = await GoogleMapsApi.findDestinations(body);
      //S'il a trouvé un seul résultat
      if (destinations.length == 1) {
        body = destinations[0].adr + Answer.askedToChooseDestination;
        destinationSelected = destinations[0].adr;
        ifAskedToConfirm = true;
      } else {
        multipleDestinations = true;
        body = "Nous avons trouvé " +
            destinations.length.toString() +
            " destinations, choisissez-en une.";
        for (int i = 0; i < destinations.length; i++) {
          body += (i + 1).toString() + " " + destinations[i].adr;
        }
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
        body = Answer.destinationChosenNotExist;
      } else {
        body = destinations[choice - 1].adr + Answer.confirm;
        destinationSelected = destinations[choice - 1].adr;
        multipleDestinations = false;
        ifAskedToConfirm = true;
      }
    } else if (text.contains(Command.confirm) && ifAskedToConfirm) {
      ifAskedToConfirm = false;
      //Début du traitement de la navigation, donc on doit pas donner la main à l'utilisateur pour parler
      userTalkAfterTextToSpeech = false;
      //Ici on doit vérifier la connexion avec le connecteur Bluetooth
      List resTestCon =
          await Utils.testConnectionToBte(address: Config.adresseBLE);
      if (resTestCon[0] == false) {
        SpeechApi.textTospeech(
            text: Answer.blAConnecte,
            onResult: (value) =>
                {Maps.deleteDestination(), Subject.deleteSubject()});
      } else {
        BluetoothConnection connection =
            await Utils.connectToBte(connection: resTestCon[1]);
        if (connection != null) {
          print('Connection réussite');
        } else {
          SpeechApi.textTospeech(
              text: Answer.blNonConnecte, onResult: (value) => {});
        }
        Position position = await Utils.determinePosition();
        print('startWalking');
        trip = await GoogleMapsApi.startWalking(
            destination: destinationSelected, position: position);

        SpeechApi.textTospeech(
            text: Answer.distaneToFinish + trip.distanceValue.toString(),
            onResult: (value) => {});

        trip.streamPosition();
      }
    } else if (text.contains(Command.cancel) && ifAskedToConfirm) {
      body = Answer.cancel;
      ifAskedToConfirm = false;
      Subject.SUBJECT = Subject.NONE_SUBJECT;
      userTalkAfterTextToSpeech = false;
    }
    return body;
  }

  static void deleteDestination() {
    Maps.destinationSelected = null;
    Maps.destinations = null;
  }
}
