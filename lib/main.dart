import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worker_task_management/myconfig.dart';
import 'package:worker_task_management/screen/login.dart';
import 'package:worker_task_management/screen/mainscreen.dart';
import 'package:worker_task_management/model/user.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Future.delayed(const Duration(seconds: 3), () {
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()),
    //);
    //});
    checkLoginStatus();
  }

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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/logoWTMS.png", scale: 2.5),
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: 200,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation(Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
  
  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String? email = prefs.getString('userEmail');
    String? password = prefs.getString('userPassword');

    if (isLoggedIn) {
      // Retrieve stored user data
      if (email != null && password != null){
        http.post(Uri.parse("${MyConfig.myurl}/worker/php/login_worker.php"), body: {
        "email": email,
        "password": password,
      }).then((response) async {
        if (response.statusCode == 200) {
          var jsondata = json.decode(response.body);
          if (jsondata['status'] == 'success') {
            var userdata = jsondata['data'];
            User user = User.fromJson(userdata[0]);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text("Welcome ${user.userName}"),
              backgroundColor: Colors.green,
            ));
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>  MainScreen(user: user,)),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>  LoginScreen()),
            );
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Failed to log in!"),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(16),
            ));
          }
        }
      });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed to log in!"),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        return;
      
      }

    } else {
      // If not logged in, navigate to the login screen
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
    }
  }
}