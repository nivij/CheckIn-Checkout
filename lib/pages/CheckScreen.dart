import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../services/UserData.dart';

class CheckScreen extends HookWidget {
  final String userName;
  final String userImage;

  const CheckScreen({
    Key? key,
    required this.userName,
    required this.userImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final checkIn = useState("--/--");
    final checkOut = useState("--/--");
    final location = useState("");

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    useEffect(() {
      final userDataService = UserDataService();
      userDataService.getLocation(location);
      userDataService.getRecord(checkIn, checkOut);

      return null;
    }, []);

    return Scaffold(
      backgroundColor: Color(0XFF252525),
      appBar: AppBar(
        backgroundColor: Color(0XFF252525),
        title: Text(
          "CodenoraLabs",
          style: TextStyle(
            color: Color(0XFF9DFF30),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
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
                  backgroundImage: NetworkImage(userImage),
                ),
                SizedBox(
                  width: 20 * 2,
                ),
                Text(
                  " $userName!",
                  style: TextStyle(
                    color: Color(0XFF9DFF30),
                    fontSize: 20,
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
                    offset: Offset(2, 2),
                  )
                ],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "checkIN",
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            checkIn.value,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "checkOUT",
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            checkOut.value,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 1)),
              builder: (context, snapshot) {
                return Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    DateFormat('hh:mm:ss a').format(DateTime.now()),
                    style: TextStyle(
                      color: Color(0XFF9DFF30),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                DateFormat("d MMMM yyyy").format(DateTime.now()),
                style: TextStyle(
                  color: Color(0XFF9DFF30),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            checkOut.value == '--/--'
                ? Container(
              margin: EdgeInsets.only(top: 24),
              child: Builder(builder: (context) {
                return SlideAction(
                  innerColor: Color(0XFF252525),
                  outerColor: Color(0XFF9DFF30),
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  text: checkIn.value == '--/--'
                      ? 'Slide to check In'
                      : 'Slide to check out',
                  onSubmit: () async {
                    final userDataService = UserDataService();
                    if (userDataService.latitude != 0) {
                      userDataService.updateCheckOut(location, checkIn, checkOut);
                    } else {
                      Timer(Duration(seconds: 1), () async {
                        userDataService.updateCheckOut(location, checkIn, checkOut);
                      });
                    }
                  },
                );
              }),
            )
                : Container(
              margin: EdgeInsets.only(top: 25, bottom: 20),
              child: Center(
                child: Text(
                  "you have completed this day!!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 28),
            location.value != ""
                ? Text(
              "Location :  " + location.value,
              style: TextStyle(
                color: Color(0XFF9DFF30),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}