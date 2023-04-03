import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:scratch/pages/home.dart';
import 'package:scratch/pages/payslip.dart';
import 'pages/settings.dart';
import 'pages/logs.dart';

class HiddeDrawer extends StatefulWidget {
  const HiddeDrawer({super.key});

  @override
  State<HiddeDrawer> createState() => _HiddeDrawerState();
}

class _HiddeDrawerState extends State<HiddeDrawer> {
  List<ScreenHiddenDrawer> _pages = [];

  final menutextstyle = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 15,
    color: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    _pages = [
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            name: 'Dashboard',
            baseStyle:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            selectedStyle: menutextstyle,
            colorLineSelected: Colors.green),
        const HomePage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            name: 'Logs',
            baseStyle:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            selectedStyle: menutextstyle,
            colorLineSelected: Colors.green),
        const Logs(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            name: 'Payslip',
            baseStyle:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            selectedStyle: menutextstyle,
            colorLineSelected: Colors.green),
        const Payslip(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            name: 'Settings',
            baseStyle:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            selectedStyle: menutextstyle,
            colorLineSelected: Colors.green),
        const Settings(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      backgroundColorMenu: Colors.teal.shade900,
      screens: _pages,
      isTitleCentered: true,
      slidePercent: 40,
    );
  }
}
