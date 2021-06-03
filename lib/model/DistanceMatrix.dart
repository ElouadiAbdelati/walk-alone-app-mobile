import 'package:flutter/cupertino.dart';

class DistanceMatrix {
  String maneuver;
  String durationText;
  int durationValue;
  bool change;
  int distanceValue;
  String distanceText;
  String distanceTextToEnd;
  String durationTextToEnd;
  int distanceValueToEnd;
  int durationValueToEnd;

  DistanceMatrix({
    @required this.maneuver,
    @required this.durationText,
    @required this.durationValue,
    @required this.change,
    @required this.distanceValue,
    @required this.distanceText,
    @required this.distanceTextToEnd,
    @required this.durationTextToEnd,
    @required this.distanceValueToEnd,
    @required this.durationValueToEnd,
  });

  factory DistanceMatrix.fromJson(Map<String, dynamic> json) {
    return DistanceMatrix(

        maneuver: json['maneuver'],
        durationText: json['durationText'],
        durationValue: json['durationValue'],
        change: json['change'],
        distanceValue: json['distanceValue'],
        distanceText: json['distanceText'],
        distanceTextToEnd: json['distanceTextToEnd'],
        durationTextToEnd: json['durationTextToEnd'],
        distanceValueToEnd: json['distanceValueToEnd'],
        durationValueToEnd: json['durationValueToEnd']
        
        );
  }
}
