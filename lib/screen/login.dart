import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worker_task_management/screen/mainscreen.dart';
import 'package:worker_task_management/myconfig.dart';
import 'package:worker_task_management/screen/register.dart';
import 'package:worker_task_management/model/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isChecked = false;
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.lightBlue.shade300, // Light blue
                Colors.pink.shade300,      // Soft pink
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
            ),
          ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 80,
            ),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                "Hello!", 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40, color: Colors.white),
              )
            ),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                "Welcome to Worker Task Management System",
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
            SizedBox(height: 30),
            Container(
              height: 430,
              width: 600,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                color: Colors.grey.shade50,
                boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
              ),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  SizedBox(
                    width: 280,
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      obscureText: true,
                    ),
                  ),
                  SizedBox(height: 5),
                  SizedBox(
                    width: 290,
                    child: Row(
                      children: [
                        const Text("Remember Me"),
                        Checkbox(
                            value: isChecked,
                            onChanged: (value) {
                              setState(() {
                                isChecked = value!;
                              });
                              String email = emailController.text;
                              String password = passwordController.text;
                              if (isChecked) {
                                if (email.isEmpty && password.isEmpty) {
                                  showCustomSnackBar("Please fill all fields", "black");
                                  isChecked = false;
                                  return;
                                } else {
                                  // Store credentials if checkbox is checked
                                  storeCredentials(email, password, isChecked);
                                }
                              }
                            }),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade300, // Background color
                          foregroundColor: Colors.white, // Text color
                        ),
                      child: Text("Login")
                    )
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?"),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterScreen()),
                          );
                          setState(() {
                            emailController.clear();
                            passwordController.clear();
                          });
                        },
                        child: Text(
                          " Register",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void login() {
    String email = emailController.text;
    String password = passwordController.text;

    setState(() {
      isLoading = true;
    });

    showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text("Logging..."),
          ],
        ),
      );
    },
    );

    if (email.isEmpty && password.isEmpty) {
      showCustomSnackBar("Please fill in all fields", "black");
      return;
    }

    http.post(Uri.parse("${MyConfig.myurl}/worker/php/login_worker.php"), body: {
      "email": email,
      "password": password,
    }).then((response) async {
      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);
        if (jsondata['status'] == 'success') {
          var userdata = jsondata['data'];
          User user = User.fromJson(userdata[0]);

          Navigator.of(context).pop(); // Close loading dialog

          showCustomSnackBar("Welcome ${user.userName}", "green");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  MainScreen(user: user,)),
          );
        } else {
          Navigator.of(context).pop(); // Close the loading dialog
          showCustomSnackBar("Failed!", "black");
        }
      }
    });
  }
  
  Future<void> storeCredentials(String email, String password, bool isChecked) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isChecked) {
      await prefs.setString('userEmail', email);
      await prefs.setString('userPassword', password);
      await prefs.setBool('isLoggedIn', isChecked);
    } else {
      await prefs.remove('userEmail');
      await prefs.remove('userPassword');
      await prefs.setBool('isLoggedIn', false);
    }
  }

  void showCustomSnackBar(String message, String color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color == "green" ? Colors.green : Colors.black,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}