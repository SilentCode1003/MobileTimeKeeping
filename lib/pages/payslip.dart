import 'package:flutter/material.dart';
import 'package:scratch/Repository/customhelper.dart';

class Item {
  Item(
      {required this.headerText,
      required this.sss,
      required this.pagibig,
      required this.philhealth,
      required this.deduction,
      required this.index,
      this.isExpanded = false});
  List<String> headerText;
  String sss;
  String pagibig;
  String philhealth;
  String deduction;
  int index;
  bool isExpanded;
}

class Payslip extends StatefulWidget {
  const Payslip({super.key});

  @override
  State<Payslip> createState() => _PayslipState();
}

class _PayslipState extends State<Payslip> {
  final List<Item> _data = List<Item>.generate(2, (int index) {
    return Item(
        headerText: getMonths(),
        sss: '100',
        pagibig: '100',
        philhealth: '100',
        deduction: '100',
        index: index);
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: ListView.separated(
        itemCount: 4,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
            child: ListTile(
              dense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: -10.0),
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              title: const Text('Jan 26 - Feb 10'),
              tileColor: const Color.fromARGB(255, 239, 235, 235),
              shape: const Border(
                bottom: BorderSide(color: Colors.black, width: 0.5),
                top: BorderSide(color: Colors.black, width: 0.5),
                left: BorderSide(color: Colors.black, width: 0.5),
                right: BorderSide(color: Colors.black, width: 0.5),
              ),
              onTap: () {
                showModalBottomSheet(
                    shape: const Border(
                      bottom: BorderSide(color: Colors.black, width: 0.5),
                      top: BorderSide(color: Colors.black, width: 0.5),
                      left: BorderSide(color: Colors.black, width: 0.5),
                      right: BorderSide(color: Colors.black, width: 0.5),
                    ),
                    backgroundColor: Colors.grey[100],
                    context: context,
                    builder: (BuildContext context) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              const Padding(
                                // padding: EdgeInsets.only(top: 20.0, bottom: 15.0),
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  'Jan 26 - Feb 10',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                              const Divider(
                                  height: 5, thickness: 1, color: Colors.black),
                              Center(
                                child: ExpansionTile(
                                  title: const Text('Compensation'),
                                  trailing: const Text('2,000'),
                                  children: [
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
                              const Divider(
                                  height: 1,
                                  thickness: 0.5,
                                  color: Colors.grey),
                              ExpansionTile(
                                title: const Text('Deductions'),
                                trailing: const Text('2,000'),
                                children: [
                                  DataTable(
                                    columns: const [
                                      DataColumn(label: Text('Column1')),
                                      DataColumn(label: Text('Column2')),
                                    ],
                                    rows: const [
                                      DataRow(cells: [
                                        DataCell(Text('Late / Undertime')),
                                        DataCell(Text('1,000')),
                                      ]),
                                      DataRow(cells: [
                                        DataCell(Text('Absences')),
                                        DataCell(Text('1,000')),
                                      ]),
                                      DataRow(cells: [
                                        DataCell(Text('Allowance')),
                                        DataCell(Text('1,000')),
                                      ]),
                                      DataRow(cells: [
                                        DataCell(Text('SSS')),
                                        DataCell(Text('1,000')),
                                      ]),
                                      DataRow(cells: [
                                        DataCell(Text('PhilHealth')),
                                        DataCell(Text('1,000')),
                                      ]),
                                      DataRow(cells: [
                                        DataCell(Text('Phil Health')),
                                        DataCell(Text('1,000')),
                                      ]),
                                      DataRow(cells: [
                                        DataCell(Text('HDMF')),
                                        DataCell(Text('1,000')),
                                      ]),
                                      DataRow(cells: [
                                        DataCell(Text('Tax')),
                                        DataCell(Text('1,000')),
                                      ]),
                                    ],
                                  )
                                ],
                              ),
                              const Divider(
                                  height: 1,
                                  thickness: 0.5,
                                  color: Colors.grey),
                              ExpansionTile(
                                title: const Text('Net Pay'),
                                trailing: const Text('2,000'),
                                children: [
                                  DataTable(
                                    columns: const [
                                      DataColumn(label: Text('Column1')),
                                      DataColumn(label: Text('Column2')),
                                    ],
                                    rows: const [
                                      DataRow(cells: [
                                        DataCell(Text('Total Compensation')),
                                        DataCell(Text('1,000')),
                                      ]),
                                      DataRow(cells: [
                                        DataCell(Text('Total Deduction')),
                                        DataCell(Text('1,000')),
                                      ]),
                                      DataRow(cells: [
                                        DataCell(Text('Netpay')),
                                        DataCell(Text('1,000')),
                                      ]),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
              leading: const Icon(Icons.person),
              trailing: const Icon(Icons.menu),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(
          color: Color.fromARGB(255, 215, 213, 213),
          thickness: 1,
        ),
      ),
    );
  }
}
