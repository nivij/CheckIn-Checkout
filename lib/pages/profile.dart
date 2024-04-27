import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
          child: ElevatedButton(
            onPressed: () async {
              // Sign out from Google
              // final GoogleSignIn googleSignIn = GoogleSignIn();
              // await googleSignIn.signOut();
              //
              // // Navigate to the login page
              // Get.offAll(LoginPage());
            },

            child: Text('Logout'),
          ),
        ),
      ],
    );
  }
}
