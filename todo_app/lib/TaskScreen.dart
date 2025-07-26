import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TaskScreen extends StatefulWidget {
  final String title;
  TaskScreen({required this.title});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<Map<String, dynamic>> tasks = [];
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final storedTasks = prefs.getString('tasks_${widget.title}');
    if (storedTasks != null) {
      List decoded = json.decode(storedTasks);
      setState(() {
        tasks = decoded.map<Map<String, dynamic>>((e) {
          return {
            'title': e['title'],
            'completed': e['completed'] ?? false,
          };
        }).toList();
      });
    }
  }

  void saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tasks_${widget.title}', json.encode(tasks));
  }

  void addTask(String taskTitle) {
    if (taskTitle.trim().isEmpty) return;
    setState(() {
      tasks.add({'title': taskTitle, 'completed': false});
    });
    controller.clear();
    saveTasks();
  }

  void toggleTask(int index) {
    setState(() {
      tasks[index]['completed'] = !(tasks[index]['completed'] ?? false);
    });
    saveTasks();
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
    saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    int completedCount = tasks.where((t) => t['completed'] == true).length;
    return Scaffold(
      backgroundColor: Color(0xffa0e6ef), // Background color changed here
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Add new task',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => addTask(controller.text),
                  child: Text("Add"),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total: ${tasks.length}'),
                Text('Completed: $completedCount'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (_, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(
                    task['title'],
                    style: TextStyle(
                      decoration: task['completed'] == true
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: task['completed'] ?? false,
                        onChanged: (_) => toggleTask(index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteTask(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
