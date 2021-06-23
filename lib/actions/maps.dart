import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:geolocator/geolocator.dart';
import 'package:walk_alone/actions/subject.dart';
import 'package:walk_alone/api/google_maps_api.dart';
import 'package:walk_alone/api/speech_api.dart';
import 'package:walk_alone/config.dart';
import 'package:walk_alone/model/Destination.dart';
import 'package:walk_alone/model/Trip.dart';
import 'package:walk_alone/utils.dart';
import 'package:walk_alone/model/DistanceMatrix.dart';

class Maps {
  static bool ifAskedToConfirm = false;
  static bool userTalkAfterTextToSpeech = true;
  static bool multipleDestinations = false;
  static List<Destiantion> destinations = new List();
  static String destinationSelected;
  static DistanceMatrix distanceMatrix;
  static Trip trip;
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
        return body = 'S\'il te plaît, quelle est ta destination?';
      }
      destinations = await GoogleMapsApi.findDestinations(body);
      print(destinations[0].adr);
      if (destinations.length == 1) {
        print("find ");
        body = destinations[0].adr +
            ". la destination est trouvé voulez-vous confirmer ";
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
        body = "Le choix n'existe pas. Veuillez réessayer";
      } else {
        body = destinations[choice - 1].adr + Answer.confirm;
        destinationSelected = destinations[choice - 1].adr;
        multipleDestinations = false;
        ifAskedToConfirm = true;
      }
    } else if (text.contains(Command.confirm) && ifAskedToConfirm) {
      ifAskedToConfirm = false;
      userTalkAfterTextToSpeech = false;
      List resTestCon = await  Utils.testConnectionToBte(address: Config.adresseBLE);
      if (resTestCon[0]==false){
         SpeechApi.textTospeech(text: Answer.blAConnecte, onResult: (value) => {
              Maps.deleteDestination(),
              Subject.deleteSubject()
           
         });
       }else {
           print('tester avant ble');
           BluetoothConnection connection = await Utils.connectToBte(connection: resTestCon[1]);
            print('tester apres ble');

            if (connection!= null) {
             print('Connection réussite');
           } else {
          SpeechApi.textTospeech(
            text: Answer.blNonConnecte, onResult: (value) => {});
           }
          Position position = await Utils.determinePosition();

          trip = await GoogleMapsApi.startWalking(
          destination: destinationSelected, position: position);
          print(trip.id);
      
          SpeechApi.textTospeech(
          text: Answer.distaneToFinish +
              trip.distanceValue.toString(),
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
