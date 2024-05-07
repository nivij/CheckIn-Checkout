import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Homepage.dart';
import '../model/user.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF252525),
      appBar: AppBar(
        backgroundColor: Color(0XFF252525),
        title: const Text("Login"),
      ),
      body: _isLoading ? _loadingIndicator() : (_user != null ? _userInfo() : _googleSignInButton()),
    );
  }

  Widget _googleSignInButton() {
    return Column(
      children: [
        Image.asset("assets/codenoralogo.jpeg"),
        Center(
          child: SizedBox(
            height: 50,
            child: SignInButton(
              Buttons.google,
              text: "Sign up with Google",
              onPressed: _handleGoogleSignIn,
            ),
          ),
        ),
      ],
    );
  }

  Widget _userInfo() {
    String userName = _user!.displayName ?? "Unknown";
    String userImage = _user!.photoURL ?? "";
    Users.username = _user!.displayName ?? "";

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

    return SizedBox();
  }

  Widget _loadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        color: Color(0XFF9DFF30),
      ),
    );
  }

  void _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential userCredential = await _auth.signInWithCredential(credential);

        String userName = userCredential.user!.displayName ?? "";
        String userImage = userCredential.user!.photoURL ?? "";
        Users.username = userCredential.user!.displayName ?? "";

        await FirebaseFirestore.instance.collection("Employee").doc(userCredential.user!.uid).set({
          "id": userCredential.user!.uid,
          "name": userName,
        });

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
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
