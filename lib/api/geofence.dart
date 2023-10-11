import 'dart:convert';

import '../config.dart';
import 'package:http/http.dart' as http;

class GeofenceAPI {
  Future<Map<String, dynamic>> getgeofence(String? department) async {
    final url = Uri.parse('${Config.apiUrl}${Config.getGeofenceAPI}');
    final response = await http.post(url, body: {'department': department});

    final responseData = json.decode(response.body);
    final status = response.statusCode;
    final msg = responseData['msg'];
    final results = responseData['data'];

    Map<String, dynamic> data = {};
    data = {'msg': msg, 'status': status, 'data': results};

    return data;
  }
}
