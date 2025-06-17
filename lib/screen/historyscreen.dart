import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:worker_task_management/model/submittedtask.dart';
import 'package:worker_task_management/model/user.dart';
import 'package:worker_task_management/myconfig.dart';
import 'package:worker_task_management/screen/submission.dart';

class HistoryScreen extends StatefulWidget {
  final User user;
  const HistoryScreen({super.key, required this.user});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    loadTasks(); // Load tasks when the screen is initialized
  }
  List<Submittedtask> submissionList = <Submittedtask>[];
  bool isLoading = false;
  int? tappedIndex; // To track which item is tapped
  // This will be used to show the details of the task when tapped

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 214, 226, 233),
      appBar: AppBar(
        title: const Text("Submission History", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.lightBlue.shade200,
      ),
      body: isLoading 
      // If the data is still loading, show a loading indicator
      ? const Center(child: CircularProgressIndicator())
      // If there are no tasks, show a message indicating that
      : submissionList.isEmpty
        ? const Center(
            child: Text(
              "No task available.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
        // else show the list of tasks         
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                  itemCount: submissionList.length,
                  itemBuilder: (context, index) {
                    final task = submissionList[index];
                    final isTapped = tappedIndex == index;
                    // Check if the current item is tapped to change its appearance  
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          tappedIndex = index;
                        });
                        Future.delayed(const Duration(milliseconds: 100), () {
                          if (mounted) {
                            setState(() {
                              tappedIndex = null; // Reset tapped index after a short delay
                            });
                          }
                        });
                        showDetails(task);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isTapped ? Colors.grey.shade200 : Colors.white, // Change background color if tapped
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "${task.title}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                              
                                  const SizedBox(height: 4),
                                  Text(
                                    task.text ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Submission Date: ${task.date != null ? DateFormat('yyyy-MM-dd').format(DateTime.parse(task.date!)) : "N/A"}",
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ]
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ]
          ),
        ),
      );
  }
  void loadTasks() { 
    setState(() {
      isLoading = true;
    });

    http.post(Uri.parse("${MyConfig.myurl}/worker/php/get_submission.php"), body: {
      "worker_id": widget.user.userId,
    }).then((response) async {
      setState(() {
        isLoading = false;
      });
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);
        if (jsondata['status'] == 'success' && jsondata['data'] != 'no task') {
          submissionList.clear();
          var data = jsondata['data'];

          // Check if data is empty 
          if (data.isEmpty) {
            setState(() {
              submissionList = []; // Clear the list if no tasks are found
            });
            return;
          // If data is not empty, parse the tasks
          } else {
            for (var item in data) {
              submissionList.add(Submittedtask.fromJson(item));
            }
            setState(() {});
          }
        // If the response indicates no tasks, clear the list and show no tasks available message
        } else if (jsondata['status'] == 'success' && jsondata['data'] == 'no task') {
          setState(() {
            submissionList = [];
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Failed!"),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(16),
          ));
        }
      }
    });
  }
  
  // Function to show details of the submitted task
  void showDetails(Submittedtask task) {
    // Parse due date
    DateTime? dueDate;
    if (task.dueDate != null) {
      try {
        dueDate = DateTime.parse(task.dueDate!);
      } catch (e) {
        dueDate = null;
      }
    }

    // Check if the current date is before the due date
    // If dueDate is null, we assume the task can be edited
    bool canEdit = dueDate == null || 
    DateTime.now().toLocal().isBefore(
      DateTime(dueDate.year, dueDate.month, dueDate.day).add(const Duration(days: 1))
    );

    // Show the dialog with task details
    showDialog(context: context, builder: (context) {
      return Dialog(
        shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Row(
                  children: [
                    const Icon(Icons.bookmark, color: Colors.blueAccent),
                    const SizedBox(width: 8,),
                    Expanded(
                      child: Text(
                        task.title ?? "No Title",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Submission Text
                Row(
                  children: [
                    Icon(Icons.note, size: 18),
                    const SizedBox(width: 4),
                    const Text(
                      "Submission Text",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                    
                  ),
                  child: Text(
                    task.text ?? "No Text Submitted",
                  ),
                ),
                const SizedBox(height: 16),

                // Submission Date
                Row(
                  children: [
                    const Icon(Icons.calendar_month, size: 18),
                    const SizedBox(width: 4),
                    const Text(
                      "Submitted on ",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  task.date != null
                      ? DateFormat('yyyy-MM-dd').format(DateTime.parse(task.date!))
                      : "N/A",
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    const Icon(Icons.access_time,size: 18),
                    const SizedBox(width: 4,),
                    const Text("Due date ",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  task.date != null
                      ? DateFormat('yyyy-MM-dd').format(DateTime.parse(task.dueDate!))
                      : "N/A",
                ),
                const SizedBox(height: 12),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Close Button
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Close"),
                    ),
                    const SizedBox(width: 8),
                    
                    canEdit?
                    // Edit Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop(); // Close dialog

                        // Now navigate to edit page and wait for result
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Submission(
                              task: null,
                              user: widget.user,
                              submittedTask: task,
                            ),
                          ),
                        );

                        // After returning from edit screen
                        if (result == 'updated') {
                          setState(() {
                            loadTasks(); // Reload data
                          });
                        }
                      },
                      child: const Text("Edit", style: TextStyle(color: Colors.white),),
                    )
                    : SizedBox(),
                  ],
                )
                ],
              ),
            )
          )
      );
    });
  }
}