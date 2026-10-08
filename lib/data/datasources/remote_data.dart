import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';

class RemoteData {
  Future<List<Map<String, dynamic>>> fetchTrips() async {
    final url = Uri.parse(AppConstants.apiUrl);
    final duration = const Duration(seconds: 20);
    final res = await http.get(url).timeout(duration);
    if (res.statusCode != 200) {
      throw Exception('Server error ${res.statusCode}');
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    return (body['Data']['FlightTrips'] as List).cast<Map<String, dynamic>>();
  }
}