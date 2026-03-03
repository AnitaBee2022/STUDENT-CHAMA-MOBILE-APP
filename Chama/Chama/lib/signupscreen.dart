import 'package:chama/helper.dart';
import 'package:chama/homepage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

//
class Signupscreen extends StatelessWidget {
  Signupscreen({super.key});
  AuthServices authServices = AuthServices();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
          title: const Text('Sign Up'),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Sign Up',
              style: TextStyle(
                color: Colors.green,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: authServices.studentId,
                decoration:const InputDecoration(
                  labelText: 'Student ID',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20,),
               TextField(
                controller: authServices.email,
                decoration:const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: authServices.password,
                obscureText: true,
                decoration:const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if(authServices.email !=""&& authServices.password != ""&&authServices.studentId != ""){
                    authServices.RegisterUser(context);
                  }
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("All fields are required")),
                        );
                  }
                  // Handle signup action
                },
                child:Text('Sign Up'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50), // Full width
                ),
              ),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: "Have an account? ",
                      style: TextStyle(color: Colors.black), // Change color as needed
                    ),
                    TextSpan(
                      text: "Login",
                      style: const TextStyle(color: Colors.blue,),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Navigate to Login screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>  Homepage()),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
