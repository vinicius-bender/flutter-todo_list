import 'package:flutter/material.dart';
import 'package:todo_list/repositories/repository.dart';
import 'package:todo_list/widgets/todo_list_item.dart';
import 'package:todo_list/models/todo.dart';

class ToDoListPage extends StatefulWidget{
  
  ToDoListPage({Key? key}) : super(key: key);
  
  @override
  ToDoListPageState createState() => ToDoListPageState();
}

class ToDoListPageState extends State<ToDoListPage>{


  final TextEditingController todosTextController = TextEditingController();
  final ToDoRepository toDosRepository = ToDoRepository();

  List<Todo> todos = [];
  Todo? deletedTodo;
  int? deletedTodoPosition;
  String? errorText;

  @override
  void initState(){
    super.initState();

    toDosRepository.getToDoList().then((value) {
      setState(() {
        todos = value;
      });
    });

  }


  @override
  Widget build (BuildContext context){
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff00d7f3),
          title: Text("To-Do List", style: TextStyle(fontSize: 24),),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.center, //o Widget Center já está centralizando tudo
              children:  [
                //Text("To-Do List", style: TextStyle(fontSize: 24),),
                // SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: todosTextController,
                        decoration: InputDecoration(
                        labelText: "Type your task here :)",
                        errorText: errorText,
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff00d7f3),
                            width: 2,
                          ),
                        ),
                        labelStyle: TextStyle(
                          color: Color(0xff00d7f3),
                        ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: (){
                        String todo = todosTextController.text;
                        if(todo.isEmpty){
                          setState(() {
                            errorText = "Sorry! The task field cannot be empty :)";
                          });
                          return;
                        }
                        Todo newTodo = Todo(title: todo, dateTime: DateTime.now());
                        setState(() {
                          todos.add(newTodo);
                          errorText = null;
                        });
                        todosTextController.clear();
                        toDosRepository.saveToDoList(todos);
                      },
                      style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(13),
                      primary: Color(0xff00d7f3),
                      ), 
                      child: Icon(Icons.add, size: 30),
                    ),
                  ],
                ),
                SizedBox(height: 16,),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Todo todo in todos)
                        ToDoListItem(
                          todo: todo,
                          onDelete: onDelete,
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: Text("You have ${todos.length} pending tasks", style: TextStyle(fontSize: 14),),
                    ),
                    SizedBox(width: 8,),
                    ElevatedButton(onPressed: deleteAllTasksMessage,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(13),
                      primary: Color(0xff00d7f3),
                      ), //Button Style
                    child: Text("Clear all tasks", style: TextStyle(fontSize: 14),),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onDelete (Todo todo){

    deletedTodo = todo;
    deletedTodoPosition = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
    });
    toDosRepository.saveToDoList(todos);


    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Task ${todo.title} was deleted successfully"),
      action: SnackBarAction(label: "Desfazer",
        textColor: Color(0xff00d7f3),
        onPressed: (){
          setState(() {
            todos.insert(deletedTodoPosition!, deletedTodo!);
          });
          toDosRepository.saveToDoList(todos);
          },
        ),
        duration: Duration(seconds: 5),
      ),
    );
  }

  void deleteAllTasksMessage (){
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Text("Delete all?"),
      content: Text("Are you sure you want to delete all tasks?"),
      actions: [
        TextButton(onPressed: (){
          Navigator.of(context).pop();
        },
        style: TextButton.styleFrom(
          primary: Color(0xff00d7f3),
        ), 
        child: Text("Cancel"),),
        TextButton(onPressed: (){
          Navigator.of(context).pop();
          deleteAllTasks();
        }, 
        style: TextButton.styleFrom(
          primary: Color.fromARGB(255, 255, 17, 0),
        ),
        child:  Text("Clear all tasks"),),
      ],
    ),
    );
  }

  void deleteAllTasks (){
    setState(() {
      todos.clear();
    });
    toDosRepository.saveToDoList(todos);
  }
}