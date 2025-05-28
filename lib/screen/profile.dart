import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worker_task_management/screen/login.dart';
import 'package:worker_task_management/model/user.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.lightBlue.shade200
      ),
      body: SingleChildScrollView(
        child: Container(
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
              children: [
                SizedBox(height: 20,),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("assets/images/person.jpg"),
                  ),
                ),
                SizedBox(height: 10,),
          
                SizedBox(
                  width: 300,
                  child: Text(
                    "ID", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                SizedBox(height: 5,),
                Container(
                  width: 300,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                    color: Colors.grey.shade200,
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
          
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${widget.user.userId}'),
                  ),
                ),
                SizedBox(height: 20,),
          
                SizedBox(
                  width: 300,
                  child: Text(
                    "Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                SizedBox(height: 5,),
                Container(
                  width: 300,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                    color: Colors.grey.shade200,
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
          
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${widget.user.userName}'),
                  ),
                ),
                SizedBox(height: 20,),
          
                SizedBox(
                  width: 300,
                  child: Text(
                    "Email", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                SizedBox(height: 5,),
                Container(
                  width: 300,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                    color: Colors.grey.shade200,
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
          
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${widget.user.userEmail}'),
                  ),
                ),
                SizedBox(height: 20,),
          
                SizedBox(
                  width: 300,
                  child: Text(
                    "Phone Number", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                SizedBox(height: 5,),
                Container(
                  width: 300,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                    color: Colors.grey.shade200,
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
          
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${widget.user.userPhone}'),
                  ),
                ),
                SizedBox(height: 20,),
          
                SizedBox(
                  width: 300,
                  child: Text(
                    "Address", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                SizedBox(height: 5,),
                Container(
                  width: 300,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                    color: Colors.grey.shade200,
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
          
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${widget.user.userAddress}'),
                  ),
                ),
                SizedBox(height: 30,),
          
                ElevatedButton(
                  onPressed: (){
                    logout(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade300,
                    foregroundColor: Colors.white,
                  ), 
                  child: Text("Log Out"),
                ),
                SizedBox(height: 30,)
          
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear(); // Clear all stored data

  Navigator.pop(context);
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const LoginScreen()),
  );
}
}