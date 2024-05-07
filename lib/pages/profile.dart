import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../model/user.dart';
import 'loginPage.dart';


class Profile extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final isLoading = useState(true);
    final auth = FirebaseAuth.instance;

    useEffect(() {
      final authStateSubscription = auth.authStateChanges().listen((user) {
        isLoading.value = false;
      });

      return () {
        authStateSubscription.cancel();
      };
    }, []);

    return Scaffold(
      backgroundColor: Color(0XFF252525),
      appBar: AppBar(
        backgroundColor: Color(0XFF252525),
        title: const Text(
          "Employees",
          style: TextStyle(color: Color(0XFF9DFF30),fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Employee').snapshots(),
              builder: (context, snapshot) {
                // if (snapshot.connectionState == ConnectionState.waiting) {
                //   return _buildLoadingShimmer(); // Show shimmer loading when waiting for data
                // }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No employees found'));
                }
                return ListView(
                  shrinkWrap: true,
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor:Colors.white38,
                        // backgroundImage: NetworkImage(data['photoURL'] ?? ''),
                      ),
                      title: Text(data['name'] ?? '', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                      subtitle: Text('Employee ID: ${document.id ?? ''}', style: TextStyle(color: Color(0XFF9DFF30,),fontWeight: FontWeight.bold)),
                    );
                  }).toList(),
                );
              },
            ),

            SizedBox(height: 50),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1, // Adjusted height
              width: MediaQuery.of(context).size.width * 0.5, // Adjusted width
              child: ElevatedButton(
                style: ButtonStyle(
                  textStyle: MaterialStateProperty.all(
                    TextStyle(
                      color: Color(0XFF9DFF30),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(Color(0XFF9DFF30)),
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
                child: Text('Logout',style: TextStyle(fontWeight: FontWeight.bold,color: Color(0XFF252525)),),
              ),
            ),
          ],
        ),
      ),

    );
  }
}