import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/data/database.dart';

import '../util/dialog_box.dart';
import '../util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // reference the hive box
  final _myBox = Hive.box('mybox');
  final _controller = TextEditingController();
  // reference the database
final ToDoDatabase _db = ToDoDatabase();
@override
  void initState() {
  // if its the first time the user is opening the app
  if (_myBox.get('TODOLIST')== null){
    _db.createInitialData();
  }else{
    //there already exist data
    _db.loadData();
  }
    super.initState();
  }
  // whether our task is checked on not
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      _db.toDoList[index][1] = !_db.toDoList[index][1];
    });
    _db.updateData();
  }
  //save our new task
  void saveNewTask(){
    setState(() {
      _db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    _db.updateData();
  }
// create new task
  void createNewTask() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: _controller,
            onSave:saveNewTask,
            onCancel: () {
              Navigator.of(context).pop();
            },
          );
        });
  }
  // delete a task
  void deleteTask (int index){
    setState(() {
      _db.toDoList.removeAt(index);
    });
    _db.updateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: const Text('TO DO'),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        backgroundColor: Colors.yellow,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: _db.toDoList.length,
        itemBuilder: (BuildContext context, int index) {
          return ToDoTile(
            taskName: _db.toDoList[index][0],
            taskCompleted: _db.toDoList[index][1],
            onChanged: (value) {
              checkBoxChanged(value, index);
            }, deleteFunction: (context ) {deleteTask(index);},
          );
        },
      ),
    );
  }
}
