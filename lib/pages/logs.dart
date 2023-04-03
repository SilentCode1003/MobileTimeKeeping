

import 'package:flutter/material.dart';

class Logs extends StatefulWidget {
  const Logs({Key? key}) : super(key: key);

  @override
  State<Logs> createState() => _LogsState();
}

class _LogsState extends State<Logs> {
  final itmborder = const Border(
    bottom: BorderSide(color: Colors.black, width: 0.5),
    top: BorderSide(color: Colors.black, width: 0.5),
    // left: BorderSide(color: Colors.black, width: 0.5),
    // right: BorderSide(color: Colors.black, width: 0.5),
  );

  final menutextstyle = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 20,
    color: Colors.black,
  );
  final _submenustyle = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 15,
    color: Colors.black87,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latest Logs'),
        automaticallyImplyLeading: false,
        toolbarHeight: 35,
        backgroundColor: Colors.green[700],
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 20.0),
        // padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
        child: ListView.separated(
          itemCount: 4,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(top: 1.0, bottom: 1.0),
              child: ListTile(
                dense: true,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: -10.0),
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                title: const Text('Jan 26 - Feb 10'),
                tileColor: const Color.fromARGB(255, 239, 235, 235),
                shape: itmborder,
                onTap: () {
                  showModalBottomSheet(
                      shape: itmborder,
                      backgroundColor: Colors.grey[100],
                      context: context,
                      builder: (BuildContext context) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            child: Column(
                              children: const <Widget>[
                                Padding(
                                  // padding: EdgeInsets.only(top: 20.0, bottom: 15.0),
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    'Jan 26 - Feb 10',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                                // Divider(
                                //     height: 5,
                                //     thickness: 1,
                                //     color: Colors.black),
                                Center(
                                  child: ExpansionTile(
                                    title: Text('Time in'),
                                    trailing: Text('7:70 AM'),
                                    children: [],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                },
                leading: const Icon(Icons.person),
                // trailing: const Icon(Icons.menu),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(
            color: Color.fromARGB(255, 215, 213, 213),
            // color: Color.fromARGB(200, 225, 10, 20),
            thickness: 0,
          ),
        ),
      ),
    );
  }

  GestureDetector buildAccountOption(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('option 1'),
                    Text('option 2'),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('close'),
                  )
                ],
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: _submenustyle,
            ),
            // const Icon(
            //   Icons.arrow_forward_ios,
            //   color: Colors.grey,
            // )
          ],
        ),
      ),
    );
  }
}
