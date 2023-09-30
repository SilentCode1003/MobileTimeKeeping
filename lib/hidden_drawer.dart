import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'pages/homepage.dart';
import 'pages/payslip.dart';
import 'pages/settings.dart';
import 'pages/logs.dart';

class HiddenDrawer extends StatefulWidget {
  final String? employeeid;
  final String? fullname;
  const HiddenDrawer(
      {Key? key, required this.employeeid, required this.fullname})
      : super(key: key);

  @override
  State<HiddenDrawer> createState() => _HiddeDrawerState();
}

class _HiddeDrawerState extends State<HiddenDrawer> {
  List<ScreenHiddenDrawer> _pages = [];

  final menutextstyle = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 17,
    color: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    _pages = [
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Dashboard',
          baseStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          selectedStyle: menutextstyle,
          colorLineSelected: const Color.fromARGB(255, 201, 62, 71),
        ),
        HomePage(
          employeeid: widget.employeeid,
          fullname: widget.fullname,
        ),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Logs',
          baseStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          selectedStyle: menutextstyle,
          colorLineSelected: const Color.fromARGB(255, 201, 62, 71),
        ),
        Logs(
          employeeid: widget.employeeid,
        ),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Payslip',
          baseStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          selectedStyle: menutextstyle,
          colorLineSelected: const Color.fromARGB(255, 201, 62, 71),
        ),
        Payslip(
          employeeid: widget.employeeid,
          fullname: widget.fullname,
        ),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Settings',
          baseStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          selectedStyle: menutextstyle,
          colorLineSelected: const Color.fromARGB(255, 201, 62, 71),
        ),
        Settings(
          employeeid: widget.employeeid,
          fullname: widget.fullname,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      backgroundColorMenu: const Color.fromARGB(255, 106, 40, 40),
      screens: _pages,
      isTitleCentered: true,
      slidePercent: 35,
    );
  }
}
