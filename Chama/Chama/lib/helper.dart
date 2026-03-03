import 'package:chama/admindashboard.dart';
import 'package:chama/dasboardscreen.dart';
import 'package:chama/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthServices {
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController studentId = TextEditingController();

  void loginuser(BuildContext context) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );

      print("User is Logged in");

      // Check if the user is the admin
      if (email.text == 'admin@gmail.com' && password.text == 'admin123') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  Admindashboard()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>const Dashboardscreen()),
        );
      }
    } catch (e) {
      print(e);
      // Optionally show an error message to the user
    }
  }
  //Verify student ID in Firestore
  Future<bool> verifyStudentId(String studentId)async{
    final studentCollection = FirebaseFirestore.instance.collection('students');
    final querySnapshot = await studentCollection.where('Student_Id',isEqualTo: studentId).get();

    return querySnapshot.docs.isNotEmpty;
  }

  void RegisterUser( BuildContext context) async {
    try {
      bool isStudentValid = await verifyStudentId(studentId.text);
      if(isStudentValid) {
        await auth.createUserWithEmailAndPassword(
          email: email.text,
          password: password.text,
        ).then((value) {
          print("User is Registered");
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content:Text('Regisration Successful')),
          );
          Navigator.push(context,
              MaterialPageRoute(builder: (context)=> Homepage()),
          );
        });

      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content:Text("Student ID does not exist")),
        );
      }
    } catch (e) {
      print(e);
    }
  }
}
//
// // Example Admin Dashboard Screen
// class AdminDashboardScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Admin Dashboard'),
//       ),
//       body: Center(
//         child: Text('Welcome to the Admin Dashboard!'),
//       ),
//     );
//   }
// }
//
// // Example Regular Dashboard Screen
// class DashboardScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Dashboard'),
//       ),
//       body: Center(
//         child: Text('Welcome to the Dashboard!'),
//       ),
//     );
//   }
// }
