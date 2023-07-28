import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mobiletimekeeping/config.dart';
import 'package:mobiletimekeeping/model/employee.dart';

class LoginAPI {
  Future<Map<String, dynamic>> verification(
      String username, String password) async {
    try {
      List<Employee> employee = [];
      final url = Uri.parse('${Config.apiUrl}${Config.employeeLoginAPI}');
      final response = await http
          .post(url, body: {'username': username, 'password': password});
      final responseData = json.decode(response.body);

      Map<String, dynamic> data = {};

      if (response.statusCode == 200) {
        if (responseData['msg'] != 'success') {
          final msg = responseData['msg'];
          final status = response.statusCode;
          data = {'status': status, 'msg': msg};
          return data;
        } else {
          final List<dynamic> jsonData = responseData['data'];
          employee = jsonData.map((data) => Employee.fromJson(data)).toList();

          final msg = responseData['msg'];
          final status = response.statusCode;
          data = {'status': status, 'msg': msg, 'data': employee};

          return data;
        }
      } else {
        final status = response.statusCode;
        final msg = responseData['msg'];
        data = {'status': status, 'msg': msg};

        return data;
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
