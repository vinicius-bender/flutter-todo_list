import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/models/todo.dart';


const toDoListKey = "todo_list";

class ToDoRepository {

  late SharedPreferences sharedPreferences;

  Future<List<Todo>> getToDoList() async{
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(toDoListKey) ?? "[]";
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e) => Todo.fromJson(e)).toList();

  }


  void saveToDoList (List<Todo> todos){
    final String jsonString = json.encode(todos);
    sharedPreferences.setString(toDoListKey, jsonString);
  }

}