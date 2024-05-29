import 'package:flutter/material.dart';
import "package:foodbuds0_1/ui/authentication_screen/login_screen.dart";
import "package:foodbuds0_1/ui/authentication_screen/register_screen.dart";

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<FirstScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 150),
              Image.asset("images/g45.png"),
              const SizedBox(height: 20),
              const Text("Welcome to FoodbuD",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    )
                  ),
              const SizedBox(height: 80),
              const Text(
                "By clicking Log In or Register, you agree with our Terms. Learn how we process your data in our Privacy Policy and Cookies Policy.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Image.asset("images/mailbox.png",
                    width: 22, height: 22), // Mailbox icon for Mail Login
                label: const Text('Login with Mail',
                    style: TextStyle(fontSize: 16, color: Colors.black)),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Background color
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
              const SizedBox(height: 20), // Spacing between the buttons
              ElevatedButton.icon(
                icon: Image.asset("images/mailbox.png",
                    width: 22, height: 22), // Mailbox icon for Mail Register
                label: const Text('Register with Mail',
                    style: TextStyle(fontSize: 16, color: Colors.black)),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RegisterPage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Background color
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
