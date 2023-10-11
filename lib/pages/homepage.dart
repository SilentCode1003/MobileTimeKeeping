import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geodesy/geodesy.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:mobiletimekeeping/api/geofence.dart';
import 'package:mobiletimekeeping/component/geofencing.dart';
import 'package:mobiletimekeeping/pages/logs.dart';
import 'package:carousel_slider/carousel_slider.dart';
// import 'package:mobiletimekeeping/pages/clockpage.dart';

import '../config.dart';
import '../repository/customhelper.dart';
import '../repository/geolocator.dart';

class HomePage extends StatefulWidget {
  final String? employeeid;
  final String? fullname;
  final String? department;
  const HomePage(
      {Key? key,
      required this.employeeid,
      required this.fullname,
      required this.department})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class ZoomLevel {
  double level;

  ZoomLevel(this.level);
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
  double _latitudeFence = 0;
  double _longitudeFence = 0;
  double _radius = 0;
  String _locationname = '';

  LatLng manuallySelectedLocation = LatLng(14.3390743, 121.0610688);
  MapController mapController = MapController();
  ZoomLevel zoomLevel = ZoomLevel(17.5);
  bool isStatusButtonEnabled = false;

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

    _getGeofence();
  }

  Future<void> _getGeofence() async {
    print(widget.department);
    final results = await GeofenceAPI().getgeofence(widget.department);
    final jsonData = json.encode(results['data']);
    setState(() {
      for (var data in json.decode(jsonData)) {
        int rad = data['radius'];
        _radius = rad.toDouble();
        _longitudeFence = data['longitude'];
        _latitudeFence = data['latitude'];
        _locationname = data['locationname'];
      }
    });
  }

  Future<void> _getCurrentLocation() async {
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

  Future<void> _timelog(
      BuildContext context, type, latitude, longitude, employeeid) async {
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

  Future<void> getLogStatus(employeeid) async {
    final url = Uri.parse(Config.apiUrl + Config.attendanceGetLogStatusAPI);
    final response = await http.post(url, body: {
      'employeeid': employeeid,
    });

    if (kDebugMode) {
      print(employeeid);
    }

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

  Stream<String> currentTimeStream =
      Stream.periodic(const Duration(seconds: 1), (int _) {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
  });

  void _selectLocation(LatLng location) {
    setState(() {
      manuallySelectedLocation = location;
      // _updateLocationText(location);
    });
  }

  void _centerMapToDefaultLocation() {
    LatLng activelocation = LatLng(_latitude, _longitude);
    LatLng targetLocation = activelocation;
    mapController.move(targetLocation, zoomLevel.level);
    setState(() {
      manuallySelectedLocation = targetLocation;
    });
  }

  Future<void> _verifyLocation() async {
    await _getCurrentLocation();
    await _getGeofence();

    LatLng activelocation = LatLng(_latitude, _longitude);
    LatLng circledomain = LatLng(_latitudeFence, _longitudeFence);
    final distanceToDomain =
        const Distance().as(LengthUnit.Meter, circledomain, activelocation);

    print(circledomain);

    if (distanceToDomain <= _radius) {
      // Enable the "Status" button
      setState(() {
        print('true');
        isStatusButtonEnabled = true;
      });
    } else {
      // Disable the "Status" button
      setState(() {
        print('false');
        isStatusButtonEnabled = false;
      });
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Verify Location'),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  center: activelocation,
                  zoom: zoomLevel.level,
                  onTap: (point, activelocation) {
                    // _selectLocation(latLng);

                    // Check if the selected location is inside circledomain, circledomaintwo, or thirdcircle
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: activelocation,
                        builder: (ctx) => const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 40.0,
                        ),
                      ),
                    ],
                  ),
                  CircleLayer(
                    circles: [
                      CircleMarker(
                        point: circledomain,
                        color: Colors.green.withOpacity(0.5), // Fill color
                        borderColor: Colors.blue, // Border color
                        borderStrokeWidth: 2, // Border width
                        useRadiusInMeter: true,
                        radius: _radius, // Radius in meters
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: isStatusButtonEnabled
                      ? () {
                          if (isLoggedIn) {
                            showLogoutDialog();
                          } else {
                            _timelog(context, 'IN', _latitude, _longitude,
                                employeeid);
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
                                        message: 'You are logged in!',
                                        type: NotificationType.success,
                                        onDismiss: () {},
                                      ),
                                    );
                                  },
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('You are logged in!'),
                                  duration: const Duration(seconds: 2),
                                  action: SnackBarAction(
                                    label: 'Dismiss',
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                    },
                                  ),
                                ),
                              );
                            });

                            Navigator.of(context).pop();
                          }
                        }
                      : null,
                  child: const Text('Confirm')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final employeeid = widget.employeeid;
    final fullname = widget.fullname;
    getLogStatus(employeeid);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: SafeArea(
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          padding: const EdgeInsets.all(6),
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
                              /////////////////////////////////////////////////
                              child: Column(
                                children: [
                                  StreamBuilder<String>(
                                    stream: currentTimeStream,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        final now = DateTime.now();
                                        final formattedTime =
                                            DateFormat('h:mm:ss a').format(now);
                                        return Column(
                                          children: [
                                            Text(
                                              formattedTime,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(
                                              '$fullname',
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return const Text(
                                          'Loading...',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  /////////////////////////////////////////////
                                  const Text(
                                    'Sched 08:00 - 06:00',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    currentLocation,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                    textAlign: TextAlign.center,
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
                                                    255, 157, 69, 69),
                                                const Color.fromARGB(
                                                    255, 255, 68, 0),
                                              ]
                                            : [
                                                const Color.fromARGB(
                                                    255, 70, 157, 69),
                                                const Color.fromARGB(
                                                    255, 143, 251, 20),
                                              ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        // BoxShadow(
                                        //     offset: Offset(10, 10),
                                        //     color: Color.fromARGB(150,255,255,255),
                                        //     blurRadius: 10),
                                        // BoxShadow(
                                        //     offset: Offset(-5, -5),
                                        //     color: Color.fromARGB(80,0,0,0),
                                        //     blurRadius: 10),
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          offset: const Offset(0, 5),
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
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //       builder: (context) =>
                                          //           const Geofencing()),
                                          // );

                                          _verifyLocation();
                                          // showLogoutDialog();
                                        } else {
                                          _verifyLocation();
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //       builder: (context) =>
                                          //           const Geofencing()),
                                          // );
                                          // _timelog(context, 'IN', _latitude,
                                          //     _longitude, employeeid);
                                          // setState(() {
                                          //   isLoggedIn = true;
                                          //   buttonText = 'Log Out';
                                          //   addNotification(
                                          //     NotificationCard(
                                          //       message: 'You are logged in!',
                                          //       type: NotificationType.success,
                                          //       onDismiss: () {
                                          //         removeNotification(
                                          //           NotificationCard(
                                          //             message:
                                          //                 'You are logged in!',
                                          //             type: NotificationType
                                          //                 .success,
                                          //             onDismiss: () {},
                                          //           ),
                                          //         );
                                          //       },
                                          //     ),
                                          //   );
                                          //   ScaffoldMessenger.of(context)
                                          //       .showSnackBar(
                                          //     SnackBar(
                                          //       content: const Text(
                                          //           'You are logged in!'),
                                          //       duration:
                                          //           const Duration(seconds: 2),
                                          //       action: SnackBarAction(
                                          //         label: 'Dismiss',
                                          //         onPressed: () {
                                          //           ScaffoldMessenger.of(
                                          //                   context)
                                          //               .hideCurrentSnackBar();
                                          //         },
                                          //       ),
                                          //     ),
                                          //   );
                                          // });
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
                                  // const Divider(
                                  //   height: 10,
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Divider(height: 10),
                      GridView.count(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        padding: const EdgeInsets.only(
                            top: 10, left: 20, right: 20, bottom: 10),
                        shrinkWrap: true,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 12, 70, 106),
                              shadowColor: Colors.black,
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            child: const Text(
                              'Payslip',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Logs(employeeid: employeeid),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 12, 70, 106),
                              shadowColor: Colors.black,
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            child: const Text(
                              'Attendance',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 12, 70, 106),
                              shadowColor: Colors.black,
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            child: const Text(
                              'My Requests',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      )
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
                              child: SizedBox(
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

// class _ClocktimeState extends State<Clocktime> {
//   String getTime() {
//     final now = DateTime.now();
//     return "${now.hour.toString().padLeft(2, '0')} : ${now.minute.toString().padLeft(2, '0')} : ${now.second.toString().padLeft(2, '0')}";
//   }

//   @override
//   void initState() {
//     super.initState();
//     Timer.periodic(const Duration(seconds: 1), (Timer timer) {
//       if (mounted) {
//         setState(() {});
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         backgroundColor: Colors.white,
//         body: Center(
//           child: Text(
//             getTime(),
//             style: const TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
