import 'package:flutter/material.dart';
import 'package:todo_list/models/task.dart';
import 'package:todo_list/repositories/task_repository.dart';
import 'package:todo_list/widgets/task_list_item.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();
  final TaskRepository taskRepository = TaskRepository();

  List<Task> tasks = [];
  Task? deletedTask;
  int? deletedTaskPos;

  String? errorText;

  @override
  void initState() {
    super.initState();
    taskRepository
        .getTaskList()
        .then((value) => {setState(() => tasks = value)});
  }

  void clear() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Limpar tudo?'),
        content: Text('Voce tem certeza que deseja apagar todas as tarefas? '),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'cancelar',
              // style: TextStyle(color: Colors.blue)
            ),
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
            ),
            onPressed: () {
              setState(() {
                tasks = [];
                emailController.clear();
                Navigator.of(context).pop();
              });
            },
            child: Text('limpar tudo'),
          ),
        ],
      ),
    );
  }

  void onDelete(Task task) {
    deletedTask = task;
    deletedTaskPos = tasks.indexOf(task);
    setState(() {
      tasks.remove(task);
      taskRepository.saveTaskList(tasks);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.maybeOf(context)!.showSnackBar(SnackBar(
      content: Text('Tarefa ${task.title} deletada com sucesso'),
      backgroundColor: Colors.green,
      action: SnackBarAction(
        label: 'Desfazer',
        onPressed: () {
          setState(() {
            tasks.insert(deletedTaskPos!, deletedTask!);
          });
        },
      ),
    ));
  }

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: todoController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Adicione uma tarefa',
                          errorText: errorText,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        String text = todoController.text;

                        if (text.isEmpty) {
                          setState(() {
                            errorText = 'O titulo nao pode ser vazio';
                          });
                          return;
                        }
                        setState(() {
                          Task newTask = Task(text, DateTime.now());
                          tasks.add(newTask);
                          taskRepository.saveTaskList(tasks);
                          errorText = null;
                        });

                        todoController.clear();
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                        fixedSize:
                            MaterialStateProperty.all<Size>(Size(65, 65)),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.zero,
                        ),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8.0), // Ajuste o raio conforme necessário
                          ),
                        ),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 30,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Task task in tasks) TaskListItem(task, onDelete),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                            'Você possui ${tasks.length} tarefas pendentes')),
                    SizedBox(
                      width: 60,
                    ),
                    ElevatedButton(
                      onPressed: clear,
                      child: Text('Limpar tudo'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                        fixedSize:
                            MaterialStateProperty.all<Size>(Size(100, 40)),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.all(4),
                        ),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8.0), // Ajuste o raio conforme necessário
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
