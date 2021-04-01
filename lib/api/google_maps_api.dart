import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../config.dart';

class GoogleMapsApi {

  static Future<http.Response> findDestinations(
      Position position, String destination) async {
    var url = Uri.parse(Config.API);
    var response = await http.post(url, body: {
      'destination': destination,
      'latitude': position.latitude.toString(),
      'longitude': position.longitude.toString()
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    return response;
  }


  static Future<int> simulationFindDestinations() async{

    final result = await Future.value(42).timeout(const Duration(seconds: 9));
    
    int  r =1;
    return r;
  }
}
