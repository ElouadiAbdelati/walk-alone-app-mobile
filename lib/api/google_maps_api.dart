import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:walk_alone/model/Destination.dart';
import 'package:walk_alone/model/DistanceMatrix.dart';
import 'package:walk_alone/model/Trip.dart';
import '../config.dart';

class GoogleMapsApi {
  /**
   * Cette fonction donne le résultat de larecherche de la destination choisie
   */
  static Future<List<Destiantion>> findDestinations(String destination) async {
    dynamic response = await http.get(
        (Uri.http(Config.API, Config.SERVICEFINDDESTINATIONS + destination)));

    var desObjsJson = json.decode(response.body.toString());

    List<Destiantion> des =
        List<Destiantion>.from(desObjsJson.map((i) => Destiantion.fromJson(i)));
    return des;
  }

  static Future<Trip> startWalking(
      {String destination, Position position}) async {
    dynamic response = await http.post(
      Uri.http(Config.API, Config.SERVICESTARTWALKING),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'destination': destination,
        'latitude': position.latitude.toString(),
        'altitude': position.longitude.toString(),
      }),
    );
    Trip trip;

    Map<String, dynamic> tripMap = json.decode(response.body.toString());
    trip = Trip.fromJson(tripMap);

    return trip;
  }

  static Future<DistanceMatrix> onWalking(
      {Trip trip, Position position}) async {
    dynamic reponse = await http.post(
      Uri.http(Config.API, Config.SERVICESONWALKING),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id': trip.id,
        'nextStepId': trip.nextStepld.toString(),
        'originLat': position.latitude.toString(),
        'originLng': position.longitude.toString()
      }),
    );
    print(reponse.body.toString());
    Map<String, dynamic> disMap = json.decode(reponse.body.toString());
    DistanceMatrix distanceMatrix = DistanceMatrix.fromJson(disMap);

    print(distanceMatrix.distanceValueToEnd);
    return distanceMatrix;
  }

  static void finishWalking({Trip trip}) async {
    http.post(
      Uri.http(Config.API, Config.SERVICEFINISHWALKING),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'id': trip.id}),
    );
  }

  static Future<String> whereAmI(Position position) async {
    dynamic response = await http.post(
      Uri.http(Config.API, Config.SERVICEWHEREAMI),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'lat': position.latitude.toString(),
        'lng': position.longitude.toString()
      }),
    );
    return response.body.toString();
  }
}
