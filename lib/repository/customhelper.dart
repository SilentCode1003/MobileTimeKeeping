import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

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

Future<void> createJsonFile(data) async {
  final path = await getDirectory();
  final String jsonString = json.encode(data);
  final file = File('$path/user.json');

  if (kDebugMode) {
    print(path);
  }
  if (kDebugMode) {
    print(jsonString);
  }
  await file.writeAsString(jsonString);

  if (kDebugMode) {
    print(jsonString);
  }
}

Future<Map<String, dynamic>> readJsonData() async {
  final path = await getDirectory();

  var jsonString = await rootBundle.loadString('$path/user.json');
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

Future<void> createDirectory() async {
  // Get the application documents directory
  Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();

  // Create a new directory within the documents directory
  String folderName = 'userdata';
  Directory newDirectory =
      Directory('${appDocumentsDirectory.path}/$folderName');

  // Check if the directory already exists
  if (await newDirectory.exists()) {
    if (kDebugMode) {
      print('Directory already exists');
    }
    return;
  }

  // Create the directory
  await newDirectory.create();

  if (kDebugMode) {
    print('Directory created: ${newDirectory.path}');
  }
}

Future<String> getDirectory() async {
  // Get the application documents directory
  Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();

  // Create a new directory within the documents directory
  String folderName = 'userdata';
  String newDirectory =
      Directory('${appDocumentsDirectory.path}/$folderName').path;

  if (kDebugMode) {
    print(newDirectory);
  }
  return newDirectory;
}
