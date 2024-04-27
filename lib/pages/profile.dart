import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../model/user.dart';
import 'loginPage.dart';
class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Placeholder for profile information
        // Add your profile UI here

        // Logout button
        Center(
          child: SizedBox(height: 80,
            width: 200,
            child: ElevatedButton(

              style: ButtonStyle(
            textStyle: MaterialStatePropertyAll(TextStyle(
               color: Color(0XFF9DFF30),
              fontSize: 18 ,
             fontWeight: FontWeight.bold,
               )),
                backgroundColor: MaterialStatePropertyAll(Color(0XFF9DFF30)),
              ),
              onPressed: () async {
                final GoogleSignIn googleSignIn = GoogleSignIn();
                await googleSignIn.signOut();
                await FirebaseAuth.instance.signOut(); // Sign out from Firebase

                // Clear user information if using state management
                Users.username = ""; // Or use appropriate state management methods

                // Navigate to LoginPage using GetX
                Get.offAll(LoginPage());
              },


              child: Text('Logout'),
            ),
          ),
        ),
      ],
    );
  }
}
