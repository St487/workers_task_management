import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:worker_task_management/model/task.dart';
import 'package:worker_task_management/model/user.dart';
import 'package:worker_task_management/myconfig.dart';

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
  List<Task> taskList = <Task>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 214, 226, 233),
      appBar: AppBar(
        title: const Text("Task History", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.lightBlue.shade200,
      ),
      body: taskList.isEmpty
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
                  itemCount: taskList.length, // number of tasks
                  itemBuilder: (context, index) {
                    final task = taskList[index]; // get the task at the current index
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                                    Flexible(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "${task.title}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "${task.status}",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            
                              const SizedBox(height: 4),
                              Text(
                                "${task.description}",
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Due: ${task.dueDate}",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ]
                              ),
                            ],
                          ),
                        ),
                      ],
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
    http.post(Uri.parse("${MyConfig.myurl}/worker/php/get_submission.php"), body: {
      "worker_id": widget.user.userId,
    }).then((response) async {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);
        if (jsondata['status'] == 'success') {
          taskList.clear();
          var data = jsondata['data'];

          if (data.isEmpty) {
            setState(() {
              taskList = [];
            });
          } else {
            for (var item in data) {
              taskList.add(Task.fromJson(item));
            }
            setState(() {});
          }
        } else {
          Navigator.of(context).pop();
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
}