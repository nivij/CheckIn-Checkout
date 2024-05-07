import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../constant/mediaquery.dart';
import '../model/user.dart';

class CalendarScreen extends HookWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _month = useState(DateFormat('MMMM').format(DateTime.now()));

    return Scaffold(
      backgroundColor: Color(0XFF252525),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,

                child: Text(
                  "My Attendance",
                  style: TextStyle(
                    color: Color(0XFF9DFF30),
                    fontFamily: "NexaBold",
                    fontWeight: FontWeight.bold,
                    fontSize: MyMediaQuery.screenWidth(context) / 18,
                  ),
                ),
              ),
              Stack(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(top: MyMediaQuery.screenHeight(context) * 0.04),
                    child: Text(
                      _month.value,
                      style: TextStyle(
                        color: Color(0XFF9DFF30),
                        fontFamily: "NexaBold",
                        fontWeight: FontWeight.bold,
                        fontSize: MyMediaQuery.screenWidth(context) / 18,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(top: MyMediaQuery.screenHeight(context) * 0.04),
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
        
                                  primary: Color(0XFF9DFF30),
                                  secondary: Color(0XFF9DFF30),
                                  onSecondary: Color(0XFF252525),
                                ),
                                textButtonTheme: TextButtonThemeData(
        
                                  style: TextButton.styleFrom(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0XFF252525),
                                    ),
                                    foregroundColor: Color(0XFF252525),
                                  ),
                                ),
                                textTheme: const TextTheme(
                                  headline4: TextStyle(
                                    color: Color(0XFF252525),
                                    fontFamily: "NexaBold",
                                  ),
                                  overline: TextStyle(
                                    color: Colors.red,
                                    fontFamily: "NexaBold",
                                  ),
                                  button: TextStyle(
                                    color: Color(0XFF252525),
                                    fontFamily: "NexaBold",
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
        
                        if (month != null) {
                          _month.value = DateFormat('MMMM').format(month);
                        }
                      },
                      child: Text(
                        "Pick a Month",
                        style: TextStyle(
                          color: Color(0XFF9DFF30),
                          fontFamily: "NexaBold",
                          fontWeight: FontWeight.bold,
                          fontSize: MyMediaQuery.screenWidth(context) / 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MyMediaQuery.screenHeight(context) / 1.20,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Employee")
                      .doc(Users.Id)
                      .collection("Record")
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      final snap = snapshot.data!.docs.reversed.toList();
                      return ListView.builder(
                        itemCount: snap.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final data =
                          snap[index].data() as Map<String, dynamic>;
        
                          // Check if 'checkOut' field exists and is not equal to '--/--'
                          if (data.containsKey('checkOut') &&
                              data['checkOut'] != "--/--") {
                            return DateFormat('MMMM')
                                .format(data['date'].toDate()) ==
                                _month.value
                                ? Container(
                              margin: EdgeInsets.only(
                                bottom: 20,
                                  // top: index > 2 ? 20 : 0,
                                  left: 6,
                                  right: 6),
                              height: 150,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0XFF9DFF30),
                                    blurRadius: 15,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                                borderRadius:
                                BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin:
                                      const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        color: Color(0XFF9DFF30),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      child: Center(
                                        child: Text(
                                          DateFormat('EE\ndd').format(
                                              data['date'].toDate()),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "NexaBold",
                                            fontSize: MyMediaQuery.screenWidth(context) / 19,
                                            color: Color(0XFF252525),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Check In",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "NexaRegular",
                                            fontSize: MyMediaQuery.screenWidth(context) / 22,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Text(
                                          data['checkIn'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "NexaBold",
                                            fontSize: MyMediaQuery.screenWidth(context) / 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Check Out",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "NexaRegular",
                                            fontSize: MyMediaQuery.screenWidth(context) / 22,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Text(
                                          data['checkOut'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "NexaBold",
                                            fontSize: MyMediaQuery.screenWidth(context) / 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                                : const SizedBox();
                          } else {
                            // Handle case where 'checkOut' field doesn't exist or is '--/--'
                            return DateFormat('MMMM')
                                .format(data['date'].toDate()) ==
                                _month.value
                                ? Container(
                              margin: EdgeInsets.only(
                                  bottom: 20,
        
                                  // top: index > 1 ? 20 : 0,
                                  left: 6,
                                  right: 6),
                              height: 150,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0XFF9DFF30),
                                    blurRadius: 15,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                                borderRadius:
                                BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(),
                                      decoration: BoxDecoration(
                                        color: Color(0XFF9DFF30),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      child: Center(
                                        child: Text(
                                          DateFormat('EE\ndd').format(
                                              data['date'].toDate()),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "NexaBold",
                                            fontSize: MyMediaQuery.screenWidth(context) / 19,
                                            color: Color(0XFF252525),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Check In",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "NexaRegular",
                                            fontSize: MyMediaQuery.screenWidth(context) / 22,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Text(
                                          data['checkIn'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "NexaBold",
                                            fontSize: MyMediaQuery.screenWidth(context) / 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Check Out",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "NexaRegular",
                                            fontSize: MyMediaQuery.screenWidth(context) / 22,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Text(
                                          "--/--",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "NexaBold",
                                            fontSize: MyMediaQuery.screenWidth(context) / 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                                : const SizedBox();
                          }
                        },
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
