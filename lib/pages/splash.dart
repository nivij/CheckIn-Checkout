import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import '../model/user.dart';
import '../services/UserData.dart';
import 'Homepage.dart';
import 'loginPage.dart';

class SplashScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useEffect(() {
      // Call methods from UserDataService to fetch location and record data
      final userDataService = UserDataService();
      final location = ValueNotifier<String>("");
      final checkIn = ValueNotifier<String>("");
      final checkOut = ValueNotifier<String>("");

      userDataService.getLocation(location); // Pass location argument
      userDataService.getRecord(checkIn, checkOut); // Pass checkIn and checkOut arguments

      // Delay navigation for 2 seconds
      Future.delayed(Duration(seconds: 2), () {
        navigateUser();
      });
    }, []);

    return Scaffold(
      backgroundColor: Color(0XFF252525),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 190,
              child: Image.asset('assets/codenoralogo.jpeg'),
            ),
            SizedBox(
              width: 100,
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0XFF9DFF30)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigateUser() async {
    // Check if the user is already authenticated
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // If user is already authenticated, navigate to the home page
      String userName = user.displayName ?? "Unknown";
      String userImage = user.photoURL ?? "";
      Users.username = user.displayName ?? "Unknown";

      Get.offAll(() => Homepage(
        userName: userName,
        userImage: userImage,
      ));
    } else {
      // If user is not authenticated, navigate to the login page
      Get.offAll(() => LoginPage());
    }
  }
}
