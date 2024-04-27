import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../model/user.dart';
import 'Homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {

      setState(() {
        _user=event;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF252525),
appBar: AppBar(
  backgroundColor: Color(0XFF252525),

  title: const Text("Login",),
  ),
   body: _user !=null ? _userInfo() : _googleSignInButton(),
    );
  }
  Widget _googleSignInButton(){
    return Column(
      children: [
        Image.asset("assets/codenoralogo.jpeg"),
        Center(
          child: SizedBox(
            height: 50,
            child: SignInButton(

              Buttons.google,

              text: "Sign up with google",

              onPressed: _handleGoogleSignIn
            ),
          ),
        ),
      ],
    );
  }
  Widget _userInfo() {
    // Retrieve user information
    String userName = _user!.displayName ?? "Unknown";
    String userImage = _user!.photoURL ?? "";
    Users.username=_user!.displayName ?? "Unknown";

    // Navigate to the homepage with user information
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Homepage(
            userName: userName,
            userImage: userImage,
          ),
        ),
      );
    });

    // Return a placeholder widget until navigation occurs
    return SizedBox();
  }
  void _handleGoogleSignIn() async {
    try {
      // Trigger the Google sign-in flow
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        // Obtain the GoogleSignInAuthentication object
        final GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;

        // Create a GoogleAuthProvider credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase with the Google credential
        UserCredential userCredential = await _auth.signInWithCredential(credential);

        // Retrieve user information
        String userName = userCredential.user!.displayName ?? "";
        String userImage = userCredential.user!.photoURL ?? "";
        Users.username = userCredential.user!.displayName ?? "";

        // Save user's name to Cloud Firestore
        await FirebaseFirestore.instance.collection("Employee").doc(userCredential.user!.uid).set({
          "id": userCredential.user!.uid,
          "name": userName,
          // Add other user data if needed
        });

        // Navigate to the homepage with user information
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Homepage(
              userName: userName,
              userImage: userImage,
            ),
          ),
        );
      }
    } catch (error) {
      print(error);
    }
  }
}
