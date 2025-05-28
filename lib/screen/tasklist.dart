import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:worker_task_management/model/task.dart';
import 'package:worker_task_management/model/user.dart';
import 'package:worker_task_management/myconfig.dart';
import 'package:worker_task_management/screen/submission.dart';

class TaskListScreen extends StatefulWidget {
  final User user;
  const TaskListScreen({super.key, required this.user});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  void initState() {
    super.initState();
    loadTasks();
  }
  List<Task> taskList = <Task>[];
  bool isLoading = false;
  bool isMyTaskSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 214, 226, 233),
      appBar: AppBar(
        title: const Text("Task List", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.lightBlue.shade200,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Good Evening!",
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                    Text(widget.user.userName.toString(),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
      
            const SizedBox(height: 30),
      
            // Tabs
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isMyTaskSelected = true;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        color: isMyTaskSelected ? Colors.teal : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "My Tasks",
                        style: TextStyle(
                          color: isMyTaskSelected ? Colors.white : Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isMyTaskSelected = false;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      margin: const EdgeInsets.only(left: 6),
                      decoration: BoxDecoration(
                        color: isMyTaskSelected ? Colors.white : Colors.teal,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Completed",
                        style: TextStyle(
                          color: isMyTaskSelected ? Colors.black54 : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
      
            const SizedBox(height: 20),
      
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Today Tasks",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
      
            const SizedBox(height: 10),

            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredTasks().isEmpty
                      ? const Center(
                          child: Text(
                            "No task available.",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredTasks().length,
                          itemBuilder: (context, index) {
                            final task = filteredTasks()[index];
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
                                                    color: task.status == 'completed'
                                                        ? Colors.green
                                                        : Colors.red,
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
                                            task.status != 'completed'
                                            ? ElevatedButton(
                                                onPressed: () async{
                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => Submission(
                                                        task: task,
                                                        user: widget.user,
                                                      ),
                                                    ),
                                                  );
                                                  loadTasks();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                ),
                                                child: const Text("Done"),
                                              )
                                            : const SizedBox(), // empty space for completed tasks

                                          ],
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

          ],
        ),
      ),
    );
  }
  
  void loadTasks() {
    setState(() {
      isLoading = true;
    });

    http.post(Uri.parse("${MyConfig.myurl}/worker/php/get_works.php"), body: {
      "userId": widget.user.userId,
    }).then((response) async {
      setState(() {
        isLoading = false;
      });
      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);
        if (jsondata['status'] == 'success') {
          taskList.clear();
          for (var item in jsondata['data']) {
            taskList.add(Task.fromJson(item));
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

  List<Task> filteredTasks() {
  if (isMyTaskSelected) {
    // Show only pending tasks
    return taskList.where((task) => task.status == 'pending').toList();
  } else {
    // Show only completed tasks
    return taskList.where((task) => task.status == 'completed').toList();
  }
}
}