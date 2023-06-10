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
  final List<String> _items = ['Item 1', 'Item 2', 'Item 3'];
  bool _sortAscending = true;

  void _showModalSheet(BuildContext context, String item) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      backgroundColor: Colors.grey[100],
      context: context,
      builder: (BuildContext context) {
        return const Padding(
          padding:  EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding:  EdgeInsets.all(10.0),
                child: Text(
                  'Jan 26 - Feb 10',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
               SizedBox(height: 10),
              ListTile(
                title: Text('Time in'),
                trailing: Text('7:70 AM'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _sortLogs() {
    setState(() {
      _sortAscending = !_sortAscending;
      _items.sort((a, b) {
        if (_sortAscending) {
          return a.compareTo(b);
        } else {
          return b.compareTo(a);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Expanded(
              child: Text(
                'Latest Logs',
                textAlign: TextAlign.left,
                style:  TextStyle(color: Colors.black),
              ),
            ),
            IconButton(
              icon: Icon(_sortAscending ? Icons.sort : Icons.sort_outlined),
              onPressed: _sortLogs,
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        toolbarHeight: 38,
        backgroundColor: const Color.fromARGB(255, 150, 166, 255),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 20.0),
        child: ListView.builder(
          itemCount: _items.length,
          itemBuilder: (BuildContext context, int index) {
            final String item = _items[index];
            return Card(
              child: InkWell(
                onTap: () => _showModalSheet(context, item),
                child: ListTile(
                  leading: const Icon(Icons.article_outlined),
                  title: Text(item),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
