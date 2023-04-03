import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> slideshw = [
    'images/hero.jpg',
    'images/hero1.jpg',
    'images/hero2.jpg',
    'images/hero3.jpg',
    'images/hero4.jpg',
  ];
  String buttonText = "Login";
 void _handleLogin() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Success!'),
        content: Text('You are now logged ${buttonText == 'Log In' ? 'in' : 'out'}.'),
        actions: [
          ElevatedButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                buttonText = buttonText == 'Log In' ? 'Log Out' : 'Log In';
              });
            },
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
              child: Center(
            child: Column(children: [
              Container(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        padding: EdgeInsets.zero,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.white,
                                  blurRadius: 10,
                                  spreadRadius: 10)
                            ]),
                        width: double.infinity,
                        child: Center(
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              const Text('Sched 08:00 - 06:00'),
                              const Text(
                                'Current Location',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: buttonText == 'Log In'
                                      ? Colors.green
                                      : const Color.fromARGB(255, 249, 19, 3),
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(60),
                                  elevation: 10,
                                ),
                                onPressed: _handleLogin,
                                child: Text(
                                  buttonText,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                              const Divider(height: 50),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: CarouselSlider(
                                  items: slideshw
                                      .map((item) => Center(
                                            child: Image.asset(
                                              item,
                                              fit: BoxFit.cover,
                                              width: 1000,
                                            ),
                                          ))
                                      .toList(),
                                  options: CarouselOptions(
                                      autoPlay: true,
                                      aspectRatio: 2.0,
                                      enlargeCenterPage: true),
                                ),
                              ),
                              const Divider(height: 20),
                            ],
                          ),
                        ),
                      ))),
            ]),
          )),
        ),
      ),
    );
  }
}
