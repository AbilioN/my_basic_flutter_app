import 'package:flutter/material.dart';
import 'package:todo_list/pages/imc_page.dart';
import 'pages/todo_list_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.home),
                ),
                Tab(
                  icon: Icon(Icons.sports_gymnastics),
                ),
              ],
            ),
          ),
          body: TabBarView(children: [TodoListPage(), ImcPage()]),
        ),
      ),
      routes: {
        '/tasks': (context) => TodoListPage(),
        '/imc': (context) => ImcPage()
      },
    );
  }
}
