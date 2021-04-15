import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:walk_alone/model/Destination.dart';
import '../config.dart';

class GoogleMapsApi {
  static Future<List<Destiantion>> findDestinations(String destination) async {
    dynamic response =
        await http.get((Uri.https(Config.API, "/api/places/" + destination)));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    var desObjsJson = json.decode(response.body.toString());
    print({desObjsJson});
    List<Destiantion> des = desObjsJson
        .map((desObjsJson) => Destiantion.fromJson(desObjsJson))
        .toList();
    print({des});
    return des;
  }
}
