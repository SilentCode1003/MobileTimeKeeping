// ignore_for_file: use_build_context_synchronously
import 'dart:core';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobiletimekeeping/api/login.dart';
import 'package:mobiletimekeeping/component/loadingalertdialog.dart';
import 'package:mobiletimekeeping/model/employee.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../hidden_drawer.dart';
import 'package:permission_handler/permission_handler.dart';

import 'forgotpw.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formField = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  late String employeeid;
  late String fullname = '';
  String department = '';
  bool passToggle = true;
  bool rememberMe = false;

  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Add listener to email controller to automatically move focus to password field
    // emailController.addListener(() {
    //   if (emailController.text.length == 1) {
    //     FocusScope.of(context).requestFocus(_passwordFocusNode);
    //   }
    // });

    // Add listener to password controller to handle submission or any other actions
    passController.addListener(() {
      if (passController.text.isNotEmpty) {
        // You can add code here to handle form submission or any other actions
      }
    });
    enablePermissions();
    // createDirectory();
    loadRememberMeStatus();
    checkConnectivity().then((isConnected) {
      if (isConnected) {
        // Device is connected to the network
        // Perform actions or show UI accordingly
        // requestWritePermission();
        // _loadUserDetails();
      } else {
        // Device is not connected to the network
        // Perform actions or show UI accordingly

        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('No Connection'),
            content: const Text(
                'Please check your connectivity; after you click "OK," the page will close.'),
            actions: [
              TextButton(
                onPressed: closeApp,
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    });
  }

  Future<void> enablePermissions() async {
    // You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
    ].request();

    if (kDebugMode) {
      print(statuses[Permission.location]);
    }
  }

  void closeApp() {
    SystemNavigator.pop();
  }

  void loadRememberMeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool rememberMeStatus = prefs.getBool('rememberMeStatus') ?? false;
    setState(() {
      rememberMe = rememberMeStatus;
    });
    if (rememberMe) {
      String savedEmail = prefs.getString('email') ?? '';
      String savedPassword = prefs.getString('password') ?? '';
      emailController.text = savedEmail;
      passController.text = savedPassword;
    }
  }

  void saveRememberMeStatus(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('rememberMeStatus', value);
    if (!value) {
      prefs.remove('email');
      prefs.remove('password');
    }
  }

  void saveLoginCredentials(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
    prefs.setString('password', password);
  }

  Future<bool> checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<bool> _login(BuildContext context) async {
    final username = emailController.text;
    final password = passController.text;
    final result = await LoginAPI().verification(username, password);

    if (result['status'] == 200) {
      Navigator.of(context).pop();
      if (result['msg'] == 'notexist') {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Incorrect'),
            content: const Text('Incorrect username and password'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return false;
      } else {
        final List<Employee> employee = result['data'];

        setState(() {
          department = employee[0].department;
          employeeid = employee[0].employeeid;
          fullname =
              '${employee[0].lastname},${employee[0].firstname} ${employee[0].middlename}';
        });

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HiddenDrawer(
                  employeeid: employeeid,
                  fullname: fullname,
                  department: department)),
        );
      }
    } else {
      // Failed login
      Navigator.of(context).pop();
      const errorMessage = 'Login failed. Please try again.';
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Login Error'),
          content: const Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    double paddingValue = screenSize.width * 0.05;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.red, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(paddingValue),
            child: Form(
              key: _formField,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Image.asset(
                    'images/mtk.png',
                    height: 270,
                    width: 270,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    focusNode: _emailFocusNode, // Assign the email focus node

                    decoration: const InputDecoration(
                      hintStyle: TextStyle(color: Colors.teal),
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    // validator: (value) {
                    //   bool emailValid = RegExp(
                    //     r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                    //   ).hasMatch(value!);
                    //   if (value.isEmpty) {
                    //     return 'Enter Email';
                    //   } else if (!emailValid) {
                    //     return 'Enter Valid Email';
                    //   }
                    // },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: passController,
                    focusNode:
                        _passwordFocusNode, // Assign the password focus node

                    obscureText: passToggle,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            passToggle = !passToggle;
                          });
                        },
                        child: Icon(passToggle
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Password';
                      } else if (passController.text.length < 6) {
                        return 'Password too Short';
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Checkbox(
                        value: rememberMe,
                        onChanged: (value) {
                          setState(() {
                            rememberMe = value!;
                          });
                          saveRememberMeStatus(value!);
                        },
                      ),
                      const Text(
                        'Remember Me',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () async {
                      if (_formField.currentState!.validate()) {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return const LoadingAlertDialog();
                            });
                        await _login(context);
                        if (rememberMe) {
                          saveLoginCredentials(
                              emailController.text, passController.text);
                        }
                      }
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Center(
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Forgot Password?',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.w800),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const ForgotPassword();
                          }));
                        },
                        child: const Text(
                          'Click Here',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
