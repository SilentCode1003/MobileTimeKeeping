import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:scratch/pages/homepage.dart';
import 'package:scratch/pages/payslip.dart';
import 'pages/settings.dart';
import 'pages/logs.dart';

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({Key? key}) : super(key: key);

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
          colorLineSelected: Colors.blue,
        ),
        const HomePage(),
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
          colorLineSelected: Colors.blue,
        ),
        const Logs(),
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
          colorLineSelected: Colors.blue,
        ),
        const Payslip(),
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
          colorLineSelected: Colors.blue,
        ),
        const Settings(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      backgroundColorMenu: const Color.fromARGB(255, 36, 48, 114),
      screens: _pages,
      isTitleCentered: true,
      slidePercent: 35,
    );
  }
}
