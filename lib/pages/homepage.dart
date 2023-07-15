import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

import '../config.dart';
import '../repository/customhelper.dart';
import '../repository/geolocator.dart';

class HomePage extends StatefulWidget {
  final String? employeeid;
  final String? fullname;
  const HomePage({Key? key, required this.employeeid, required this.fullname})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
// Carousel - Slideshow
  final List<String> slideshw = [
    'images/hero.jpg',
    'images/hero1.jpg',
    'images/hero2.jpg',
    'images/hero3.jpg',
    'images/hero4.jpg',
  ];
  late String currentLocation = '';
  late String employeeid = '';
  late String fullname = '';
  late double _latitude;
  late double _longitude;

// Log in/out dialog on button click
  String buttonText = "Log In";
  bool isLoggedIn = false;

  List<Widget> notifications = [];
  bool showNotifications = false;

  @override
  void initState() {
    super.initState();
    // getLocalUserData();
    getCurrentLocation().then((Position position) {
      // Use the position data
      double latitude = position.latitude;
      double longitude = position.longitude;
      // Do something with the latitude and longitude

      setState(() {
        _latitude = latitude;
        _longitude = longitude;
      });

      getGeolocationName(latitude, longitude)
          .then((locationname) => {
                setState(() {
                  currentLocation = locationname;
                })
              })
          .catchError((onError) {
        if (kDebugMode) {
          print(onError);
        }
      });

      if (kDebugMode) {
        print('Latitude: $latitude, Longitude: $longitude');
      }
    }).catchError((e) {
      // Handle error scenarios
      if (kDebugMode) {
        print(e);
      }
    });
  }

  Future<void> getLocalUserData() async {
    await readJsonData().then((jsonData) {
      String id = jsonData['employeeid'];

      if (kDebugMode) {
        print('Retrieved Data: $jsonData');
      }

      setState(() {
        getLogStatus(id);
        employeeid = id;
      });
    });
  }

  void addNotification(Widget notification) {
    setState(() {
      notifications.insert(0, notification);
    });
  }

  void removeNotification(Widget notification) {
    setState(() {
      notifications.remove(notification);
    });
  }

  void clearNotifications() {
    setState(() {
      // showNotifications = false;
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          notifications.clear();
        });
      });
    });
  }

  void showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Log Out'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _timelog(context, 'OUT', _latitude, _longitude, employeeid);
                  isLoggedIn = false;
                  buttonText = 'Log In';
                  addNotification(
                    NotificationCard(
                      message: 'You are logged out!',
                      type: NotificationType.info,
                      onDismiss: () {
                        removeNotification(
                          NotificationCard(
                            message: 'You are logged out!',
                            type: NotificationType.info,
                            onDismiss: () {},
                          ),
                        );
                      },
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('You are logged out!'),
                      duration: const Duration(seconds: 2),
                      action: SnackBarAction(
                        label: 'Dismiss',
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                      ),
                    ),
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _timelog(BuildContext context, String type, double latitude,
      double longitude, String employeeid) async {
    final url = Uri.parse(Config.apiUrl + Config.attendanceTimelogAPI);
    final response = await http.post(url, body: {
      'employeeid': widget.employeeid,
      'latitude': '$latitude',
      'longitude': '$longitude',
      'type': type
    });

    if (kDebugMode) {
      print(response.statusCode);
    }

    if (response.statusCode == 200) {
      // final responseData = json.decode(response.body);
      // if (kDebugMode) {
      //   print(responseData['msg']);
      // }
    }
  }

  Future<void> getLogStatus(String employeeid) async {
    final url = Uri.parse(Config.apiUrl + Config.attendanceGetLogStatusAPI);
    final response = await http.post(url, body: {
      'employeeid': employeeid,
    });

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData["msg"] != 'success') {
        isLoggedIn = false;
        if (kDebugMode) {
          print("not yet login");
        }
      } else {
        isLoggedIn = true;
        buttonText = 'Log Out';
        if (kDebugMode) {
          print("already login");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Mobile Time Keeping',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.notifications,
                color: Color.fromARGB(255, 0, 153, 224),
              ),
              onPressed: () {
                setState(() {
                  showNotifications = true;
                });
              },
            ),
          ],
          backgroundColor: const Color.fromARGB(255, 150, 166, 255),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: SafeArea(
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          padding: const EdgeInsets.all(9),
                          child: Container(
                            padding: EdgeInsets.zero,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white,
                                  blurRadius: 10,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            width: double.infinity,
                            child: Center(
                              child: Column(
                                children: [
                                  const SizedBox(height: 20),
                                  Text(
                                      '${widget.fullname} Sched 08:00 - 06:00'),
                                  Text(
                                    currentLocation,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: isLoggedIn
                                            ? [
                                                const Color.fromARGB(
                                                    255, 194, 13, 0),
                                                const Color.fromARGB(
                                                    255, 255, 68, 0),
                                              ]
                                            : [
                                                Colors.green,
                                                const Color.fromARGB(
                                                    255, 143, 251, 20),
                                              ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          offset: const Offset(0, 3),
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        foregroundColor: Colors.white,
                                        shape: const CircleBorder(),
                                        elevation: 0,
                                        padding: EdgeInsets.zero,
                                        // minimumSize: Size,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        visualDensity: VisualDensity.compact,
                                      ),
                                      onPressed: () {
                                        if (isLoggedIn) {
                                          showLogoutDialog();
                                        } else {
                                          _timelog(context, 'IN', _latitude,
                                              _longitude, employeeid);
                                          setState(() {
                                            isLoggedIn = true;
                                            buttonText = 'Log Out';
                                            addNotification(
                                              NotificationCard(
                                                message: 'You are logged in!',
                                                type: NotificationType.success,
                                                onDismiss: () {
                                                  removeNotification(
                                                    NotificationCard(
                                                      message:
                                                          'You are logged in!',
                                                      type: NotificationType
                                                          .success,
                                                      onDismiss: () {},
                                                    ),
                                                  );
                                                },
                                              ),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: const Text(
                                                    'You are logged in!'),
                                                duration:
                                                    const Duration(seconds: 2),
                                                action: SnackBarAction(
                                                  label: 'Dismiss',
                                                  onPressed: () {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .hideCurrentSnackBar();
                                                  },
                                                ),
                                              ),
                                            );
                                          });
                                        }
                                      },
                                      child: Text(
                                        buttonText,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Divider(height: 50),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: CarouselSlider(
                                      items: slideshw
                                          .map(
                                            (item) => Center(
                                              child: Image.asset(
                                                item,
                                                fit: BoxFit.cover,
                                                width: 1000,
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      options: CarouselOptions(
                                        autoPlay: true,
                                        aspectRatio: 2.0,
                                        enlargeCenterPage: true,
                                      ),
                                    ),
                                  ),
                                  const Divider(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (showNotifications)
              AnimatedOpacity(
                opacity: showNotifications ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      showNotifications = false;
                    });
                  },
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.clear_all),
                                  onPressed: clearNotifications,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            Expanded(
                              child: Container(
                                width: 300,
                                child: ListView.builder(
                                  itemCount: notifications.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: notifications[index],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

enum NotificationType { success, info }

class NotificationCard extends StatelessWidget {
  final String message;
  final NotificationType type;
  final VoidCallback onDismiss;

  const NotificationCard({
    Key? key,
    required this.message,
    required this.type,
    required this.onDismiss,
  }) : super(key: key);

  Color getNotificationColor() {
    switch (type) {
      case NotificationType.success:
        return Colors.green[100]!;
      case NotificationType.info:
        return Colors.blue[100]!;
    }
  }

  Icon getNotificationIcon() {
    switch (type) {
      case NotificationType.success:
        return const Icon(Icons.check, color: Colors.green);
      case NotificationType.info:
        return const Icon(Icons.info, color: Colors.blue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: getNotificationColor(),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          getNotificationIcon(),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: onDismiss,
          ),
        ],
      ),
    );
  }
}
