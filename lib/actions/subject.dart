import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:walk_alone/actions/maps.dart';
import 'package:walk_alone/api/google_maps_api.dart';
import 'package:walk_alone/api/speech_api.dart';
import 'package:walk_alone/utils.dart';

class Subject {
  /**
   * Subject pour traiter les commandes de type maps
   */
  static final MAPS_SUBJECT = 1;
  /**
   * Aucun subject déterminé
   */
  static final NONE_SUBJECT = 0;
  /**
   * Subject pour traiter les commandes qui a pour objectif 
   * connaitre la position actuelle
   * de l'utilisateur
   */
  static final LOCATION_SUBJECT = 2;
  static int SUBJECT = NONE_SUBJECT;

/**
 * Cette fonction identifie le sujet 
 */
  static void findSubject(
      {@required String rawText, @required ValueChanged<bool> onResult}) async {
    var subject = await _scanText(rawText);

    if (subject == MAPS_SUBJECT) {
      Maps.mapsSubject(text: rawText, onResult: (value) => {onResult(value)});
    } else if (subject == NONE_SUBJECT) {
      SpeechApi.textTospeech(
          onResult: (_isFinishing) => {onResult(_isFinishing)},
          text: Answer.subjectNotDefined);
    } else if (subject == LOCATION_SUBJECT) {
      Position position = await Utils.determinePosition();
      String currentPosition = await GoogleMapsApi.whereAmI(position);
      SpeechApi.textTospeech(
          onResult: (_isFinishing) => {},
          text: Answer.currentPosition + currentPosition);
      deleteSubject();
    }
  }

/**
 * Cette fonction extrait et analyse le texte dit, 
 * puis elle vérifie la contenance 
 * des mots qui définissent une telle commande 
 */
  static Future<int> _scanText(String text) async {
    text = text.toLowerCase();
    if (text.contains(Command.destination)) {
      SUBJECT = MAPS_SUBJECT;
      return SUBJECT;
    } else if (text.contains(Command.location)) {
      SUBJECT = LOCATION_SUBJECT;
      return SUBJECT;
    }

    return NONE_SUBJECT;
  }

  static void deleteSubject() {
    Subject.SUBJECT = NONE_SUBJECT;
  }
}
