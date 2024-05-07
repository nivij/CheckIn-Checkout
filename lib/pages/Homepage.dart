import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codenoralabs/pages/CheckScreen.dart';
import 'package:codenoralabs/pages/calendar.dart';
import 'package:codenoralabs/pages/profile.dart';
import 'package:codenoralabs/services/Location_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constant/mediaquery.dart';
import '../model/user.dart';

class Homepage extends StatefulWidget {
  final String userName;
  final String userImage;

  const Homepage({
    Key? key,
    required this.userName,
    required this.userImage,
  }) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int currentIndex = 1;
  String id = "";
  bool isLoading = true; // Flag to manage loading state
  List<IconData> navigationIcons = [
    FontAwesomeIcons.solidCalendarDays,
    FontAwesomeIcons.checkToSlot,
    FontAwesomeIcons.users
  ];
  List<String> navigationText = [
    "Calendar",
    "Attendance",
    "Employees",
  ];

  @override
  void initState() {
    super.initState();
    getId();
    _startLocationService();
  }

  Future<void> getId() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection("Employee")
        .where('name', isEqualTo: Users.username)
        .get();
    if (snap.docs.isNotEmpty) {
      setState(() {
        // print(snap.docs[0].id);
        Users.Id = snap.docs[0].id;
      });
    } else {
      print("No documents found for the given query");
    }
    setState(() {
      isLoading = false; // Set isLoading to false after data is fetched
    });
  }

  void _startLocationService() async {
    LocationService().initialize();
    LocationService().getLongitude().then((value) {
      setState(() {
        Users.long = value!;
      });
    });
    LocationService().getLatitude().then((value) {
      setState(() {
        Users.lat = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF252525),
      body: Stack(
        children: [
          IndexedStack(
            index: currentIndex,
            children: [
              CalendarScreen(),
              CheckScreen(userName: widget.userName, userImage: widget.userImage),
              Profile(),
            ],
          ),
          if (isLoading) // Display loading indicator if isLoading is true
            Positioned(
              // top: 0,
              left: 0, // Align with the left edge
              right: 0,
              bottom: -1,// Align with the right edge
              child: Center(
                child: Container(

                  width: MyMediaQuery.screenWidth(context) * 0.75,
                  color:Colors.transparent,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.grey,
                    borderRadius: BorderRadius.circular(30),
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0XFF9DFF30)),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        height: MyMediaQuery.screenHeight(context) * 0.09,
        margin: EdgeInsets.only(
          left: MyMediaQuery.screenWidth(context) * 0.03,
          right: MyMediaQuery.screenWidth(context) * 0.03,
          bottom: MyMediaQuery.screenHeight(context) * 0.02,
        ),
        decoration: BoxDecoration(
          color: Colors.white38,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < navigationIcons.length; i++)
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentIndex = i;
                      });
                    },
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            navigationIcons[i],
                            color: i == currentIndex ? Color(0XFF9DFF30) : Colors.black,
                            size: i == currentIndex ? MyMediaQuery.screenWidth(context) * 0.07 : MyMediaQuery.screenWidth(context) * 0.05,
                          ),
                          Text(
                            navigationText[i],
                            style: TextStyle(
                              color: i == currentIndex ? Color(0XFF9DFF30) : Colors.black,
                              fontSize: i == currentIndex ? MyMediaQuery.screenWidth(context) * 0.030 : MyMediaQuery.screenWidth(context) * 0.025,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
