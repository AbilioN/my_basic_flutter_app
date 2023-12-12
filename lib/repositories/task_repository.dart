import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/models/task.dart';

class TaskRepository {
  TaskRepository() {
    SharedPreferences.getInstance().then((value) {
      sharedPreferences = value;
      print(sharedPreferences.getString('task_list'));
    });
  }
  late SharedPreferences sharedPreferences;

  void saveTaskList(List<Task> tasks) {
    final jsonString = json.encode(tasks);
    sharedPreferences.setString('task_list', jsonString);
  }

  Future<List<Task>> getTaskList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString('task_list') ?? '[]';
    final List tasks = json.decode(jsonString) as List<dynamic>;
    return tasks.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();
  }
}
