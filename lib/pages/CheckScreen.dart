import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../model/user.dart';
import '../services/Location_service.dart';

class CheckScreen extends StatefulWidget {
  final String userName;
  final String userImage;

  const CheckScreen({
    Key? key,
    required this.userName,
    required this.userImage,
  }) : super(key: key);
  @override
  State<CheckScreen> createState() => _CheckScreenState();
}

class _CheckScreenState extends State<CheckScreen> {

  String checkIn = "--/--";
  String checkOut = "--/--";
  String location =" ";

  @override
  void initState() {
    super.initState();
    _getLocation();
    _getRecord();
  }
  void _getLocation() async {
    await LocationService().initialize(); // Create an instance and call initialize
    double? latitude = await LocationService().getLatitude(); // Call getLatitude on the instance
    double? longitude = await LocationService().getLongitude(); // Call getLongitude on the instance
    if (latitude != null && longitude != null) {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      String locationString = "";

      if (placemarks[0].street != null) {
        locationString += "${placemarks[0].street}, ";
      }

      if (placemarks[0].administrativeArea != null) {
        locationString += "${placemarks[0].administrativeArea}, ";
      }

      if (placemarks[0].locality != null) {
        locationString += "${placemarks[0].locality}, ";
      }

      locationString += "${placemarks[0].postalCode ?? ""}, ${placemarks[0].country}";

      setState(() {
        location = locationString;
      });
    } else {
      // Handle case where location retrieval fails
      print("Failed to get location");
    }
  }

  void _getRecord() {
    FirebaseFirestore.instance
        .collection("Employee")
        .where("name", isEqualTo: Users.username)
        .get()
        .then((QuerySnapshot snap) {
      if (snap.docs.isNotEmpty) {
        FirebaseFirestore.instance
            .collection("Employee")
            .doc(snap.docs[0].id)
            .collection("Record")
            .doc(DateFormat("d MMMM yyyy").format(DateTime.now()))
            .snapshots()
            .listen((DocumentSnapshot snap2) {
          setState(() {
            checkIn = snap2['checkIn'] ?? '--/--';
            checkOut = snap2['checkOut'] ?? '--/--';
          });
        });
      }
    }).catchError((error) {
      print("Error fetching document: $error");
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

      appBar: AppBar(
        backgroundColor: Color(0XFF252525),

        title: Text("CodenoraLabs", style: GoogleFonts.quicksand(
    textStyle: TextStyle(
    color: Color(0XFF9DFF30),
    fontSize: 20 ,
    fontWeight: FontWeight.bold,
    ),),
      ),),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(widget.userImage),
                ),
                SizedBox(width: 20*2,),
                Text(
                  " ${widget.userName}!",
                  style: TextStyle(
                    color: Color(0XFF9DFF30),
                    fontSize: 20 ,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(top: 12, bottom: 30),
              height: 150,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Color(0XFF9DFF30),
                        blurRadius: 10,
                        offset: Offset(2, 2))
                  ],
                  borderRadius: BorderRadius.circular(30)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [Text("checkIN",style:  TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 20 ,
                            fontWeight: FontWeight.bold,
                          ),), Text(checkIn,style:  TextStyle(
                            color: Colors.black87,
                            fontSize: 20 ,
                            fontWeight: FontWeight.bold,
                          ),)],
                        ),
                      )),
                  Expanded(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [Text("checkOUT",style:  TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 20 ,
                            fontWeight: FontWeight.bold,
                          ),), Text(checkOut,style:  TextStyle(
                            color: Colors.black87,
                            fontSize: 20 ,
                            fontWeight: FontWeight.bold,
                          ),)],
                        ),
                      )),
                ],
              ),
            ),
            StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (context, snapshot) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    child:
                    Text(DateFormat('hh:mm:ss a').format(DateTime.now()),style:  TextStyle(
                      color: Color(0XFF9DFF30),
                      fontSize: 18 ,
                      fontWeight: FontWeight.bold,
                    ),),
                  );
                }),
            SizedBox(height: 10,),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(DateFormat("d MMMM yyyy").format(DateTime.now()),style: TextStyle(
                color: Color(0XFF9DFF30),
                fontSize: 18 ,
                fontWeight: FontWeight.bold,
              ),),
            ),
            checkOut == '--/--'
                ? Container(
              margin: EdgeInsets.only(top: 24),
              child: Builder(builder: (context) {
                return SlideAction(
                  innerColor:     Color(0XFF252525),
                outerColor: Color(0XFF9DFF30),
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18 ,
                      fontWeight: FontWeight.bold,
                    ),
                    text: checkIn == '--/--'
                        ? 'Slide to check In'
                        : 'Slide to check out',
                    onSubmit: () async {
                      if(Users.lat!=0){
                        _getLocation();

                      // Timer(Duration(seconds: 1), () {
                      //   // key.currentState!.reset();
                      // });

                      print(DateFormat('hh:mm').format(DateTime.now()));

                      QuerySnapshot snap = await FirebaseFirestore
                          .instance
                          .collection("Employee")
                          .where("name", isEqualTo: Users.username)
                          .get();

                      DocumentSnapshot snap2 = await FirebaseFirestore
                          .instance
                          .collection("Employee")
                          .doc(snap.docs[0].id)
                          .collection("Record")
                          .doc(DateFormat("d MMMM yyyy")
                          .format(DateTime.now()))
                          .get();

                      try {
                        String checkIn = snap2['checkIn'];
                        await FirebaseFirestore.instance
                            .collection("Employee")
                            .doc(snap.docs[0].id)
                            .collection("Record")
                            .doc(DateFormat("d MMMM yyyy")
                            .format(DateTime.now()))
                            .update({
                          'checkIn': checkIn,
                          'checkOut':
                          DateFormat('hh:mm a').format(DateTime.now()),
                          'checkInlocation': location

                        });

                        // Update the state to reflect the changes
                        setState(() {
                          checkIn = checkIn;
                          checkOut =
                              DateFormat('hh:mm a').format(DateTime.now());
                        });
                      } catch (e) {
                        await FirebaseFirestore.instance
                            .collection("Employee")
                            .doc(snap.docs[0].id)
                            .collection("Record")
                            .doc(DateFormat("d MMMM yyyy")
                            .format(DateTime.now()))
                            .set({
                          'date':Timestamp.now(),
                          'checkIn':
                          DateFormat('hh:mm a').format(DateTime.now()),
                          'checkOutlocation': location
                        });

                        // Update the state to reflect the changes
                        setState(() {
                          checkIn =
                              DateFormat('hh:mm a').format(DateTime.now());
                          checkOut = "--/--";
                        }

                        );
                      }
                    }else{
                        Timer(Duration(seconds: 1), () async {
                          _getLocation();

                          // Timer(Duration(seconds: 1), () {
                          //   // key.currentState!.reset();
                          // });

                          print(DateFormat('hh:mm').format(DateTime.now()));

                          QuerySnapshot snap = await FirebaseFirestore
                              .instance
                              .collection("Employee")
                              .where("name", isEqualTo: Users.username)
                              .get();

                          DocumentSnapshot snap2 = await FirebaseFirestore
                              .instance
                              .collection("Employee")
                              .doc(snap.docs[0].id)
                              .collection("Record")
                              .doc(DateFormat("d MMMM yyyy")
                              .format(DateTime.now()))
                              .get();

                          try {
                            String checkIn = snap2['checkIn'];
                            await FirebaseFirestore.instance
                                .collection("Employee")
                                .doc(snap.docs[0].id)
                                .collection("Record")
                                .doc(DateFormat("d MMMM yyyy")
                                .format(DateTime.now()))
                                .update({
                              'checkIn': checkIn,
                              'checkOut':
                              DateFormat('hh:mm a').format(DateTime.now()),
                              'location': location

                            });

                            // Update the state to reflect the changes
                            setState(() {
                              checkIn = checkIn;
                              checkOut =
                                  DateFormat('hh:mm').format(DateTime.now());
                            });
                          } catch (e) {
                            await FirebaseFirestore.instance
                                .collection("Employee")
                                .doc(snap.docs[0].id)
                                .collection("Record")
                                .doc(DateFormat("d MMMM yyyy")
                                .format(DateTime.now()))
                                .set({
                              'date':Timestamp.now(),
                              'checkIn':
                              DateFormat('hh:mm a').format(DateTime.now()),
                              'location': location
                            });

                            // Update the state to reflect the changes
                            setState(() {
                              checkIn =
                                  DateFormat('hh:mm a').format(DateTime.now());
                              checkOut = "--/--";

                            }

                            );
                          }

                        });
                      }

                    });

              }),
            )
                : Container(
              margin: EdgeInsets.only(top: 25,bottom: 20),
              child: Center(child: Text("you have completed this day!!",style: TextStyle(
                color: Colors.white,
                fontSize: 20 ,
                fontWeight: FontWeight.bold,
              ),)),
            ),
           SizedBox(height: 28,),
           location != ""?Text("Location :  " +location,style: TextStyle(
             color: Color(0XFF9DFF30),
             fontSize: 18 ,
             fontWeight: FontWeight.bold,
           ),):const SizedBox()
          ],
        ),
      ),

    );
  }
}
