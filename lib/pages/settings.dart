import 'package:flutter/material.dart';

import 'changepassword.dart';
import 'loginscreen.dart';
import 'testpage.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
  final settingsstyle = const TextStyle(fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65, // Adjust the height as needed
        backgroundColor: const Color.fromARGB(255, 49, 119, 177),
        automaticallyImplyLeading: false, // Remove the back button
        title: SizedBox(
          width: 500,
          height: 100, // Adjust the width as needed
          child: ListView.builder(
            itemCount: 1,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Handle navigation when the CircleAvatar is clicked
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TestPage(),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white, // Set the border color
                          width: 2, // Set the border width
                        ),
                      ),
                      child: const CircleAvatar(
                        backgroundImage: AssetImage(
                            'images/toge.png'), // Replace with the actual image path
                        radius: 20, // Adjust the radius as needed
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle navigation when the Registered Employee Name is clicked
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TestPage(), //// TEST PAGE
                        ),
                      );
                    },
                    child: const Text(
                      'Registered Employee Name',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Card(
            child: ListTile(
              leading: const Icon(Icons.password_outlined),
              title: Text('Change Password', style: settingsstyle),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const Changepassword();
                }));
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.device_hub),
              title: Text('Devices', style: settingsstyle),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.lock),
              title: Text('Privacy', style: settingsstyle),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.fingerprint),
              title: Text('Biometrics Authentication', style: settingsstyle),
              subtitle: const Text(
                'Disabled',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: Text('Logout', style: settingsstyle),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Thank you", textAlign: TextAlign.center),
                    content: const Text("Please Come back again!",
                        textAlign: TextAlign.center),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const LoginScreen(),
                          ));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          color: Colors.green,
                          padding: const EdgeInsets.all(14),
                          child: const Text(
                            "Okay",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

//dialog on ListTile click
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
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
