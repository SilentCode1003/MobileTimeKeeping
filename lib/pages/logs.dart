import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobiletimekeeping/config.dart';
import 'package:http/http.dart' as http;
import 'package:mobiletimekeeping/model/timelogs.dart';

class Logs extends StatefulWidget {
  final String? employeeid;
  const Logs({Key? key, required this.employeeid}) : super(key: key);

  @override
  State<Logs> createState() => _LogsState();
}

class _LogsState extends State<Logs> {
  List<TimeLogs> timelogs = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final employeeid = widget.employeeid;
    getTimeLogs(employeeid);
  }

  final itmborder = const Border(
    bottom: BorderSide(color: Colors.black, width: 0.5),
    top: BorderSide(color: Colors.black, width: 0.5),
  );
  final menutextstyle = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 20,
    color: Colors.black,
  );
  // final _submenustyle = const TextStyle(
  //   fontWeight: FontWeight.normal,
  //   fontSize: 15,
  //   color: Colors.black87,
  // );
  List<String> _items = [];
  bool _sortAscending = true;

  void _showModalSheet(BuildContext context, TimeLogs timelog) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      backgroundColor: Colors.grey[100],
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  timelog.date,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                title: const Text('LOC'),
                trailing:
                    Text('LON: ${timelog.longitude} LAT: ${timelog.latitude}'),
              ),
              const SizedBox(height: 10),
              ListTile(
                title: const Text('LOG'),
                trailing:
                    Text('Type: ${timelog.type} - Time: ${timelog.time}H'),
              ),
            ],
          ),
        );
      },
    );
  }

  // void _sortLogs() {
  //   setState(() {
  //     _sortAscending = !_sortAscending;
  //     _items.sort((a, b) {
  //       if (_sortAscending) {
  //         return a.compareTo(b);
  //       } else {
  //         return b.compareTo(a);
  //       }
  //     });
  //   });
  // }

  Future<void> getTimeLogs(employeeid) async {
    final url = Uri.parse('${Config.apiUrl}${Config.attendanceGetTimeLogsAPI}');
    final response = await http.post(url, body: {'employeeid': employeeid});

    if (kDebugMode) {
      print(response.statusCode);
    }

    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      final List<dynamic> dataJson = jsonMap['data'];

      setState(() {
        timelogs = dataJson.map((data) => TimeLogs.fromJson(data)).toList();

        if (kDebugMode) {
          print(timelogs);
        }
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Attendance Logs'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
        toolbarHeight: 38,
        backgroundColor: const Color.fromARGB(255, 69,123,157),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 20.0),
        child: ListView.builder(
          itemCount: timelogs.length,
          itemBuilder: (context, index) {
            final TimeLogs timelog = timelogs[index];

            return Card(
              child: InkWell(
                onTap: () => _showModalSheet(context, timelog),
                child: ListTile(
                  leading: const Icon(Icons.article_outlined),
                  title: Text(
                    timelog.date,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: timelog.type == 'IN'
                      ? Text(
                          '${timelog.type} - ${timelog.time} - H',
                          style: const TextStyle(color: Colors.green),
                        )
                      : Text(
                          '${timelog.type} - ${timelog.time} - H',
                          style: const TextStyle(color: Colors.red),
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
