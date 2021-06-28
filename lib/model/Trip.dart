import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:walk_alone/assistance/subjects/maps.dart';
import 'package:walk_alone/assistance/findSubject.dart';
import 'package:walk_alone/api/google_maps_api.dart';
import 'package:walk_alone/api/speech_api.dart';
import 'package:walk_alone/model/DistanceMatrix.dart';
import 'package:walk_alone/utils.dart';
import 'package:walk_alone/assistance/command.dart';
import 'package:walk_alone/assistance/answer.dart';

@JsonSerializable(explicitToJson: true)
class Trip {
  int nextStepld = 0;
  String id;
  int nbrSteps;
  int durationValue;
  int distanceValue;
  Trip(
      {@required this.id,
      @required this.nbrSteps,
      @required this.durationValue,
      @required this.distanceValue});

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
        id: json['id'],
        nbrSteps: json['nbrSteps'],
        durationValue: json['durationValue'],
        distanceValue: json['distanceValue']);
  }

  void streamPosition() async {
    Utils.streamPosition(onResult: (position) async {
      print("befor onwal");
      DistanceMatrix distanceMatrix =
          await GoogleMapsApi.onWalking(trip: this, position: position);
      print("after onwal");
      print(distanceMatrix);
      //if the person changes its position
      if (distanceMatrix.change) {
        this.nextStepld++;

        String message = distanceMatrix.maneuver +
            "," +
            Answer.distaneToFinish +
            distanceMatrix.distanceTextToEnd.toString();
        SpeechApi.textTospeech(text: message, onResult: (value) => {});
      }
//check if the person is in the right trip
      print("nbrSteps" + this.nbrSteps.toString());
      print("NextStep" + this.nextStepld.toString());
      if ((this.nbrSteps + 1) == this.nextStepld) {
        GoogleMapsApi.finishWalking(trip: this);
        Subject.deleteSubject();
        Maps.deleteDestination();
        Utils.finishConnection();
        SpeechApi.textTospeech(
            text: Answer.finishWalking, onResult: (value) => {});
      }
    });
  }
}
