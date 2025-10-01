import "package:flutter/material.dart";
import "package:todo_app/model/task.dart";
import "package:todo_app/widget/task_tile.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:'TODO',
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.teal,
        )
      ),debugShowCheckedModeBanner: false,
      home: const Todolistscreen(),
    );
  }
}

class Todolistscreen extends StatefulWidget {
  const Todolistscreen({super.key});

  @override
  State<Todolistscreen> createState() => _Todolistscreen();
  }
  
  class _Todolistscreen extends State<Todolistscreen>{

    final List<Task> _task = [];
    Future<void> _save() async{
      final prefs = await SharedPreferences.getInstance();
      List<String>   taskAsString = _task.map((task) => jsonEncode(task.toJson())).toList();
      await prefs.setStringList("task", taskAsString);
    }
    Future<void> _load() async{
      final prefs = await SharedPreferences.getInstance();
      List<String>? taskAsString = prefs.getStringList('task');
      if(taskAsString!=null){
        setState(() {
          _task.clear();
          _task.addAll(
            taskAsString.map((task) => Task.fromJson(json.decode(task)))
          );
        });
      }
    }
    void _showAddTask(){
      final TextEditingController textEditingController= TextEditingController();
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text("Add new task"),
            content: TextField(
              controller: textEditingController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: "add new task"
              ),
              
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(), 
                child: Text('cancel')
              ),
              TextButton(
                onPressed: () {
                  final String taskTitle = textEditingController.text;
                  if(taskTitle.isNotEmpty){
                    setState(() {
                      _task.add(Task(title: taskTitle));

                    });
                    Navigator.of(context).pop();
                  }
                }, 
                child: Text("add")
                )
            ],
          );
        }
        );    
      }
      void _toggle(Task task){
        setState(() {
          task.isDone = !task.isDone;
        });
      }
      void _delete(Task task){
        setState(() {
          _task.remove(task);
        });
        _save();
      }
    @override
    void _initState(){
      super.initState();
      _load();
    }
    @override
    Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _task.length,
        itemBuilder: (context , index){
        final task = _task[index];
        return TaskTile(
          task: task,
          onToggle: (newValue) => _toggle(task),
          onDelete:() => _delete(task),
          );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTask,
        tooltip: "add task",
        child: const Icon(Icons.add),
      ),
    );
  }

  }