import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:worker_task_management/model/submittedtask.dart';
import 'package:worker_task_management/model/task.dart';
import 'package:worker_task_management/model/user.dart';
import 'package:worker_task_management/myconfig.dart';
import 'package:worker_task_management/screen/historyscreen.dart';

class Submission extends StatefulWidget {
  final Task? task;
  final User user;
  final Submittedtask? submittedTask;
  const Submission({super.key, required this.task, required this.user, required this.submittedTask});

  @override
  State<Submission> createState() => _SubmissionState();
}

class _SubmissionState extends State<Submission> {
  TextEditingController detailsController = TextEditingController();
  bool isEditing = false;
  @override
  void initState() {
    super.initState();
    if (widget.submittedTask != null) {
      isEditing = true;
      detailsController.text = widget.submittedTask!.text ?? "";
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 214, 226, 233),
      appBar: AppBar(
        title: const Text("Submission Details", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.lightBlue.shade200,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Task',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),

            // Displaying the task title in a read-only TextFormField
            // This allows the user to see the task they are submitting work for
            TextFormField(         
              initialValue: isEditing ? widget.submittedTask!.title : widget.task!.title,
              readOnly: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                fillColor: Colors.grey.shade200,
                filled: true,
              ),
            ),

            SizedBox(height: 24),

            Text(
              'Details',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            SizedBox(height: 8),
            // TextField for entering details about the work completed
            TextField(
              controller: detailsController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: isEditing ? null : 'What did you complete?',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.newline,
            ),
            Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submit,
                child: Text('Submit'),
              ),
            )
          ],
        ),
      )
    );
  }

  void submit(){
    // Validate that the details field is not empty before proceeding
    if (detailsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please enter details of your work."),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
      ));
      return;
    }
    // Show confirmation dialog before submitting
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: const Text("Are you sure you want to submit this task?"),
          actions: [
            TextButton(
              child: const Text("Ok"),
              onPressed: () {
                isEditing? edit() :submitState();
                Navigator.of(context).pop();
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

  void submitState() {
    // Show a loading dialog while the submission is being processed  
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

    String details = detailsController.text;
    http.post(Uri.parse("${MyConfig.myurl}/worker/php/submit_work.php"), body: {
      "workerId": widget.user.userId,
      "taskId": widget.task!.id,
      "details": details,
    }).then((response) async {
      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);
        print(response.body);
        if (jsondata['status'] == 'success') {
          Navigator.of(context).pop(); // Close the loading dialog
          Navigator.of(context).pop(); // Go back to TaskListScreen
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Submitted!"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(16),
          ));
        } else {
          Navigator.of(context).pop(); // Close the loading dialog
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Failed to submit work. Please try again."),
          ));
        }
      }
    });
  }

  void edit(){
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

    String details = detailsController.text;
    http.post(Uri.parse("${MyConfig.myurl}/worker/php/edit_submission.php"), body: {
      "submissionId": widget.submittedTask!.id,
      "details": details,
    }).then((response) async {
      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);
        print(response.body);
        if (jsondata['status'] == 'success') {
          Navigator.of(context).pop(); // Close the loading dialog
          Navigator.of(context).pop('updated');
          // Navigator.pushReplacement(context, 
          // MaterialPageRoute(
          //   builder: (context) => HistoryScreen(user: widget.user),
          // ),);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Submitted!"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(16),
          ));
        } else {
          Navigator.of(context).pop(); // Close the loading dialog
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Failed to submit work. Please try again."),
          ));
        }
      }
    });
  }
}