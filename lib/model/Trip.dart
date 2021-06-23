import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:walk_alone/actions/maps.dart';
import 'package:walk_alone/actions/subject.dart';
import 'package:walk_alone/api/google_maps_api.dart';
import 'package:walk_alone/api/speech_api.dart';
import 'package:walk_alone/model/DistanceMatrix.dart';
import 'package:walk_alone/utils.dart';

@JsonSerializable(explicitToJson: true)
class Trip {
  int nextStepld = 1;
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
      DistanceMatrix distanceMatrix =
          await GoogleMapsApi.onWalking(trip: this, position: position);
          //if the person changes its position
      if (distanceMatrix.change) {
        this.nextStepld++;

        String message = distanceMatrix.maneuver +
            ",    " +
            Answer.distaneToFinish +
            distanceMatrix.distanceTextToEnd.toString();
        SpeechApi.textTospeech(text: message, onResult: (value) => {});
      }
//check if the person is in the right trip

      if (this.nbrSteps + 1 == this.nextStepld) {
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
