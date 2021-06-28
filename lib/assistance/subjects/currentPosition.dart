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

class CurrentPosition {
  
 static void currentPositionSubject( )async{
  Position position = await Utils.determinePosition();
      String currentPosition = await GoogleMapsApi.whereAmI(position);
      SpeechApi.textTospeech(
          onResult: (_isFinishing) => {},
          text: Answer.currentPosition + currentPosition);
      Subject.deleteSubject();
 }

}