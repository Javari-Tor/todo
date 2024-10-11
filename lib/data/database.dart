import 'package:hive_flutter/hive_flutter.dart';

class ToDoDatabase {
  // our list of tasks
  List toDoList = [];

  // reference hive box
  final _myBox = Hive.box('mybox');

  // run this if its the first time ever opening the app
  void createInitialData() {
    toDoList = [
      ['Learn Flutter', false],
      ['Play Soccer', false]
    ];
  }

//load data from database
  void loadData() {
    toDoList = _myBox.get('TODOLIST');
  }
//update database
  void updateData() {
    _myBox.put('TODOLIST', toDoList);
  }
}
