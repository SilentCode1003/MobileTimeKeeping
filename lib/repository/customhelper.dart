import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

List<String> getMonths() {
  final months = <String>[];
  final now = DateTime.now();
  final year = now.year;
  final startDate = DateTime(year, 1);

  // Generate a list of 12 dates, one for each month of the year
  final dates = List.generate(12, (index) => DateTime(year, index + 1));

  // Format each date as a month string
  final formatter = DateFormat.MMMM();
  for (final date in dates) {
    final monthString = formatter.format(date);
    months.add(monthString);
  }

  return months;
}

void createJsonFile(data) async {
  // final Map<dynamic> jsonData = {
  //   'fullname': 'John Doe',
  //   'role': 'johndoe@example.com',
  //   'position': 30,
  // };
  if (kDebugMode) {
    print(data);
  }
  final jsonString = json.encode(data);
  final file = File('data/user.json');
  file.writeAsString(jsonString);

  if (kDebugMode) {
    print('Done Saving $data');
  }
}

Future<Map<String, dynamic>> readJsonData() async {
  var jsonString = await rootBundle.loadString('data/user.json');
  Map<String, dynamic> data = json.decode(jsonString);

  if (kDebugMode) {
    print('hit');
    print(data);
  }
  return data;
}

void deleteFile(path) {
  String filePath = path; // Replace with the actual file path
  File file = File(filePath);

  file.delete().then((_) {
    if (kDebugMode) {
      print('File deleted successfully');
    }
  }).catchError((error) {
    if (kDebugMode) {
      print('Error deleting file: $error');
    }
  });
}
