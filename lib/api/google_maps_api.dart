import 'package:http/http.dart' as http;
import '../config.dart';

class GoogleMapsApi {
  static Future<http.Response> findDestinations(String destination) async {
    var url = Uri.parse(Config.API);
    var response = await http.post(url, body: {'destination': destination});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    return response;
  }
}
