import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scratch/hidden_drawer.dart';
import 'package:scratch/pages/forgotpw.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formField = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool passToggle = true;
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    loadRememberMeStatus();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Form(
            key: _formField,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HiddenDrawer()),
                    );
                  },
                  child: const Icon(Icons.arrow_forward),
                ),
                Image.asset(
                  'images/toge.png',
                  height: 270,
                  width: 270,
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(color: Colors.teal),
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    bool emailValid = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                    ).hasMatch(value!);
                    if (value.isEmpty) {
                      return 'Enter Email';
                    } else if (!emailValid) {
                      return 'Enter Valid Email';
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: passController,
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
                      child: Icon(
                          passToggle ? Icons.visibility : Icons.visibility_off),
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
                  onTap: () {
                    if (_formField.currentState!.validate()) {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text(
                            'Welcome',
                            textAlign: TextAlign.center,
                          ),
                          content: const Text(
                            'Welcome Back!',
                            textAlign: TextAlign.center,
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const HiddenDrawer(),
                                ));
                              },
                              child: Container(
                                alignment: Alignment.center,
                                color: Colors.grey[400],
                                padding: const EdgeInsets.all(14),
                                child: const Text(
                                  'Okay',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                      if (rememberMe) {
                        saveLoginCredentials(
                            emailController.text, passController.text);
                      }
                      emailController.clear();
                      passController.clear();
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
                        color: Colors.grey,
                        fontSize: 16,
                      ),
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
    );
  }
}
