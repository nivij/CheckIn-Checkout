import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

import '../model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

import '../model/user.dart';
class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = const Color(0xffeef444c);

  String _month = DateFormat('MMMM').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 32),
              child: Text(
                "My Attendance",
                style: TextStyle(
                  fontFamily: "NexaBold",
                  fontSize: screenWidth / 18,
                ),
              ),
            ),
            Stack(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 32),
                  child: Text(
                    _month,
                    style: TextStyle(
                      fontFamily: "NexaBold",
                      fontSize: screenWidth / 18,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.only(top: 32),
                  child: GestureDetector(
                    onTap: () async {
                      final month = await showMonthYearPicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2022),
                        lastDate: DateTime(2099),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: primary,
                                secondary: primary,
                                onSecondary: Colors.white,
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(),
                              ),
                              textTheme: const TextTheme(
                                headline4: TextStyle(
                                  fontFamily: "NexaBold",
                                ),
                                overline: TextStyle(
                                  fontFamily: "NexaBold",
                                ),
                                button: TextStyle(
                                  fontFamily: "NexaBold",
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (month != null) {
                        setState(() {
                          _month = DateFormat('MMMM').format(month);
                        });
                      }
                    },
                    child: Text(
                      "Pick a Month",
                      style: TextStyle(
                        fontFamily: "NexaBold",
                        fontSize: screenWidth / 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight / 1.45,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collectionGroup("Record")
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    final snap = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: snap.length,
                      itemBuilder: (context, index) {
                        final record = snap[index].data() as Map<String, dynamic>; // Explicitly cast record to Map<String, dynamic>
                        final recordDate = record['date'].toDate();
                        final recordMonth = DateFormat('MMMM').format(recordDate);

                        if (recordMonth == _month) {
                          return Container(
                            margin: EdgeInsets.only(top: index > 0 ? 12 : 0, left: 6, right: 6),
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(2, 2),
                                ),
                              ],
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(),
                                    decoration: BoxDecoration(
                                      color: primary,
                                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        DateFormat('EE\ndd').format(recordDate),
                                        style: TextStyle(
                                          fontFamily: "NexaBold",
                                          fontSize: screenWidth / 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Check In",
                                        style: TextStyle(
                                          fontFamily: "NexaRegular",
                                          fontSize: screenWidth / 20,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      Text(
                                        record['checkIn'],
                                        style: TextStyle(
                                          fontFamily: "NexaBold",
                                          fontSize: screenWidth / 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Check Out",
                                        style: TextStyle(
                                          fontFamily: "NexaRegular",
                                          fontSize: screenWidth / 20,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      Text(
                                        record['checkOut'],
                                        style: TextStyle(
                                          fontFamily: "NexaBold",
                                          fontSize: screenWidth / 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return SizedBox();
                        }
                      },
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
