import 'package:flutter/material.dart';
import 'package:scratch/pages/loginscreen.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Account',
                  style: menutextstyle,
                )
              ],
            ),
            const Divider(height: 20, thickness: 1, color: Colors.black),
            // const SizedBox(
            //   height: 10,
            // ),

            buildAccountOption(context, 'Change Password'),
            const Divider(height: 0, thickness: 1),
            buildAccountOption(context, 'Privacy'),
            const Divider(height: 0, thickness: 1),
            logoutprompt(),
            const Divider(height: 0, thickness: 1),
          ],
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
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }

  Widget logoutprompt() => GestureDetector(
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
                      builder: (BuildContext context) => const LoginScreen(),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Logout',
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
