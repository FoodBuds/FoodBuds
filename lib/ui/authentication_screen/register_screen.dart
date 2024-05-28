import 'package:flutter/material.dart';
import 'package:foodbuds0_1/repositories/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodbuds0_1/ui/profile_creation/profile_creation.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String? errorMessage = " ";

  bool isPasswordCompliant(String password, [int minLength = 8]) {
      if (password.isEmpty) return false;
      bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
      bool hasLowercase = password.contains(RegExp(r'[a-z]'));
      bool hasDigits = password.contains(RegExp(r'[0-9]'));
      // Genişletilmiş özel karakterler listesi
      bool hasSpecialCharacters = password.contains(RegExp(r'[!@#$%^&*()_+{}|:"<>?,./;\\\[\]`~=]'));
      return password.length >= minLength && hasUppercase && hasLowercase && hasDigits && hasSpecialCharacters;
  }

  Future<void> createUserWithEmailAndPassword() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        errorMessage = "Passwords do not match.";
      });
      return;
    }

    if (!isPasswordCompliant(_passwordController.text)) {
      setState(() {
        errorMessage = "Password must be at least 8 characters long and include uppercase, lowercase letters, numbers, and special characters.";
      });
      return;
    }

    try {
      await AuthenticationRepository().createUserWithEmailandPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => StartCreate(),
      ));
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'REGISTER NEW ACCOUNT',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow),
                  ),
                ),
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow),
                  ),
                ),
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow),
                  ),
                ),
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              SizedBox(height: 10),
              Text(
                errorMessage == " " ? " " : "$errorMessage",
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: createUserWithEmailAndPassword,
                child: Text(
                  'REGISTER',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
