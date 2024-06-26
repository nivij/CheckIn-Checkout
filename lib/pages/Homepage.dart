import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codenoralabs/pages/CheckScreen.dart';
import 'package:codenoralabs/pages/calendar.dart';
import 'package:codenoralabs/pages/profile.dart';
import 'package:codenoralabs/services/Location_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  String id="";
  List<IconData> navigationIcons = [
    FontAwesomeIcons.calendarAlt,
    FontAwesomeIcons.check,
    FontAwesomeIcons.userAlt
  ];
@override
  void initState() {
    super.initState();
  getId();
    _startLocationService();
  }

  Future<void> getId() async {
    QuerySnapshot snap = await FirebaseFirestore.instance.collection("Employee").where('name', isEqualTo: Users.username).get();
    if (snap.docs.isNotEmpty) {
      setState(() {
        print(snap.docs[0].id);
        Users.Id = snap.docs[0].id;
      });
    } else {
      print("No documents found for the given query");
    }
  }

// Check if the field exists before accessing it
//   String getCheckOut(DocumentSnapshot doc) {
//     if (doc.containsKey("checkOut")) {
//       return doc["checkOut"];
//     } else {
//       return ""; // or handle it as you need
//     }
//   }




  void _startLocationService() async{
    LocationService().initialize();
    LocationService().getLongitude().then((value) {
      setState(() {
        Users.long= value!;
      });
    });
    LocationService().getLatitude().then((value) {
      setState(() {
        Users.lat= value!;
      });
    });
  }

  double screenHeight = 0;
  double screenWidth = 0;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
backgroundColor: Color(0XFF252525),
      body: IndexedStack(
        index: currentIndex,
        children: [
          CalendarScreen(),
          CheckScreen(userName: widget.userName, userImage: widget.userImage),
          Profile(),

        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        margin: EdgeInsets.only(left: 12, right: 12, bottom: 24),
        decoration: BoxDecoration(
            color:Colors.white38,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26, blurRadius: 10, offset: Offset(2, 2))
            ]),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < navigationIcons.length; i++) ...<Expanded>{
                Expanded(
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          currentIndex=i;
                        });
                      },
                        child: Center(
                  child: Icon(navigationIcons[i],
                 color: i== currentIndex? Color(0XFF9DFF30) :Colors.black,
                    size: i== currentIndex? 30 :25,
                  ),
                )))
              }
            ],
          ),
        ),
      ),
    );
  }
}
