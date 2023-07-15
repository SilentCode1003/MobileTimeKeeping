import 'package:flutter/material.dart';

class Item {
  Item({
    required this.headerText,
    required this.sss,
    required this.pagibig,
    required this.philhealth,
    required this.deduction,
    required this.index,
    this.isExpanded = false,
  });

  List<String> headerText;
  String sss;
  String pagibig;
  String philhealth;
  String deduction;
  int index;
  bool isExpanded;
}

class Payslip extends StatefulWidget {
  final String? employeeid;
  final String? fullname;
  const Payslip({Key? key, required this.employeeid, required this.fullname})
      : super(key: key);

  @override
  State<Payslip> createState() => _PayslipState();
}

class _PayslipState extends State<Payslip> {
  final itmborder = const Border(
    bottom: BorderSide(color: Colors.black, width: 0.5),
    top: BorderSide(color: Colors.black, width: 0.5),
  );

  final List<String> _items = ['Item 1', 'Item 2', 'Item 3'];
  late DateTime _fromDate;
  late DateTime _toDate;

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _fromDate) {
      setState(() {
        _fromDate = pickedDate;
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _toDate) {
      setState(() {
        _toDate = pickedDate;
      });
    }
  }

  void _showModalSheet(BuildContext context, String item) {
    showModalBottomSheet(
      shape: itmborder,
      backgroundColor: Colors.grey[100],
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Date',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                DataTable(
                  columns: const [
                    DataColumn(label: Text('Column1')),
                    DataColumn(label: Text('Column2')),
                  ],
                  rows: const [
                    DataRow(cells: [
                      DataCell(Text('Basic')),
                      DataCell(Text('1,000')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('benefits')),
                      DataCell(Text('1,000')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Holiday')),
                      DataCell(Text('1,000')),
                    ]),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  bool _sortAscending = true;
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
  void initState() {
    super.initState();
    _fromDate = DateTime.now();
    _toDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      'Payslip',
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        const Text(
                          'From: ',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          _fromDate.toString().substring(0, 10),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        const Text(
                          'To: ',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          _toDate.toString().substring(0, 10),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Sorting
            IconButton(
              icon: Icon(_sortAscending
                  ? Icons.filter_alt
                  : Icons.filter_alt_outlined),
              onPressed: _sortLogs,
            ),
            // Date range selectors
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () {
                    _selectFromDate(context);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () {
                    _selectToDate(context);
                  },
                ),
              ],
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        toolbarHeight: 75,
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
