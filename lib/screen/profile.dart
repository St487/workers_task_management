import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worker_task_management/myconfig.dart';
import 'package:worker_task_management/screen/login.dart';
import 'package:worker_task_management/model/user.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var genderOption = [
    'Not specified',
    'Female',
    'Male',
  ];
  TextEditingController confirmPasswordController = TextEditingController();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController genderController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  TextEditingController passwordController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    getProfile(); 
  }

  bool isLoading = false;
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.lightBlue.shade200,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 30,
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit Profile'),
              onTap: () {
                Navigator.pop(context); // close drawer
                setState(() {
                  isEditing = true;
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text('Change Password'),
              onTap: () {
                if (isEditing) {
                  showCustomSnackBar("Please save or cancel your edits first.");
                  Navigator.pop(context); 
                  return;
                }
                Navigator.pop(context); // close drawer
                changePassword();
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                if (isEditing) {
                  showCustomSnackBar("Please save or cancel your edits first.");
                  Navigator.pop(context); 
                  return;
                }
                Navigator.pop(context);
                logout(context);
              },
            ),
          ],
        ),
      ),
        
      body: isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
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
                  height: 40,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                    color: Colors.grey.shade300,
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
          
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                    initialValue: '${widget.user.userId}',
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                      ),
                    ),
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
                  height: 40,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                    color: isEditing ? Colors.white : Colors.grey.shade300,
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: nameController,
                      readOnly: !isEditing,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),

                SizedBox(
                  width: 300,
                  child: Text(
                    "Gender", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                SizedBox(height: 5,),
                Container(
                  width: 300,
                  height: 40,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                    color: isEditing ? Colors.white : Colors.grey.shade300,
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: isEditing
                      ? DropdownButton(
                          itemHeight: 60,
                          value: genderController.text.isEmpty ? "Not Specified" : genderController.text,
                          underline: const SizedBox(),
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: genderOption.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            String gender = newValue!;
                            setState(() {genderController.text = gender;});
                          },
                        )
                      : Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            genderController.text.isEmpty ? "Not specified" : genderController.text,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
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
                  height: 40,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                    color: isEditing ? Colors.white : Colors.grey.shade300,
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
          
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: emailController,
                      readOnly: !isEditing,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                      ),
                    ),
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
                  height: 40,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                    color: isEditing ? Colors.white : Colors.grey.shade300,
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
          
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: phoneController,
                      readOnly: !isEditing,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                      ),
                    ),
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
                  height: 40,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                    color: isEditing ? Colors.white : Colors.grey.shade300,
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
          
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: addressController,
                      readOnly: !isEditing,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30,),

                isEditing
                  ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isEditing = false;
                            getProfile();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade300,
                          foregroundColor: Colors.white,
                        ),
                        child: Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          updateProfile();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade300,
                          foregroundColor: Colors.white,
                        ),
                        child: Text("Save"),
                      ),
                    ],
                  )
                  : SizedBox(),
                SizedBox(height: 30,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              child: const Text("Yes"),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear(); // Clear all stored data
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }  

  void updateProfile() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty) {
      showCustomSnackBar("Please fill all fields");
      return;
    }

    // if (password != confirmPassword) {
    //   showCustomSnackBar("Passwords do not match");
    //   return;
    // }

    bool isValidEmail = RegExp(
        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
      .hasMatch(emailController.text);

    if (!isValidEmail) {
      showCustomSnackBar("Please enter a valid email");
      return;
    }

    // if (password.length < 6) {
    //   showCustomSnackBar("Password must be at least 6 characters");
    //   return;
    // }

    if (phoneController.text.length < 10 || phoneController.text.length > 15 || !RegExp(r'^[0-9]+$').hasMatch(phoneController.text)) {
      showCustomSnackBar("Please enter a valid phone number");
      return;
    }

    if (addressController.text.length < 5) {
      showCustomSnackBar("Address must be at least 5 characters");
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: const Text("Are you sure you want to update profile?"),
          actions: [
            TextButton(
              child: const Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
                saveProfile();
              },
            ),
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }

  void saveProfile() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Submitting..."),
            ],
          ),
        );
      },
    );

    http.post(Uri.parse("${MyConfig.myurl}/worker/php/update_profile.php"), body: {
      "userId": widget.user.userId,
      "name": nameController.text,
      "gender": genderController.text,
      "email": emailController.text,
      "phone": phoneController.text,
      "address": addressController.text,
      "password": passwordController.text,
    }).then((response) async {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);
        if (jsondata['status'] == 'success') {
          // Update the user object with new values
          widget.user.userName = nameController.text;
          widget.user.userGender = genderController.text;
          widget.user.userEmail = emailController.text;
          widget.user.userPhone = phoneController.text;
          widget.user.userAddress = addressController.text;
          widget.user.userPassword = passwordController.text;
          Navigator.of(context).pop(); // Close the loading dialog
          setState(() {
            isEditing = false; // Exit editing mode
          });
          showCustomSnackBar("Updated!");
        } else if (jsondata['status'] == 'failed' && jsondata['data'] == 'email exists') {
          Navigator.of(context).pop(); 
          showCustomSnackBar("Email already exists!");
        } else {
          Navigator.of(context).pop(); 
          showCustomSnackBar("Failed to update profile!");
        }
      }
    });
  }

    void showCustomSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
  
  void getProfile() {
    setState(() {
      isLoading = true;
    });

    http.post(Uri.parse("${MyConfig.myurl}/worker/php/get_profile.php"), body: {
      "userId": widget.user.userId,
    }).then((response) async {
      setState(() {
        isLoading = false;
      });
      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);
        if (jsondata['status'] == 'success') {
          nameController = TextEditingController(text: widget.user.userName);
          emailController = TextEditingController(text: widget.user.userEmail);
          genderController = TextEditingController(
            text: (widget.user.userGender?.isEmpty ?? true) ? "Not specified" : widget.user.userGender!
          );
          phoneController = TextEditingController(text: widget.user.userPhone);
          addressController = TextEditingController(text: widget.user.userAddress);
        } else {
          showCustomSnackBar("Failed to get data!");
        }
      }
    });
  }
  
  void changePassword() {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Change Password"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "New Password"),
              ),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Confirm New Password"),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  passwordController.clear();
                  confirmPasswordController.clear();
                });
              },
            ),
            TextButton(
              child: const Text("Change"),
              onPressed: () {
                Navigator.of(context).pop();
                if (passwordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
                  showCustomSnackBar("Please fill all fields");
                  return;
                }
                if (passwordController.text != confirmPasswordController.text) {
                  setState(() {
                    passwordController.clear();
                    confirmPasswordController.clear();
                  });
                  showCustomSnackBar("Passwords do not match");
                  return;
                }
                if (passwordController.text.length < 6) {
                  setState(() {
                    passwordController.clear();
                    confirmPasswordController.clear();
                  });
                  showCustomSnackBar("Password must be at least 6 characters");
                  return;
                }
                saveProfile();
                setState(() {
                  passwordController.clear();
                  confirmPasswordController.clear();
                });
              },
            ),
          ],
        );
      }
    );
  }
}