import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list/models/todo.dart';
import 'package:intl/intl.dart';

class ToDoListItem extends StatelessWidget {
  const ToDoListItem({Key? key, required this.todo, required this.onDelete,}) : super(key: key);

  final Todo todo;
  final Function(Todo) onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Slidable(
        child: Container(
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.grey[200],
          ),
          padding: EdgeInsets.all(16),
          child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, 
          children: [
            Text(DateFormat("MM/dd/yyyy - HH:mm - EE").format(todo.dateTime), style: TextStyle(fontSize: 12),),
            Text(todo.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
            ],
          ),
        ),
        actionExtentRatio: 0.20,
        actionPane: SlidableDrawerActionPane(),
        secondaryActions: [
          IconSlideAction(
            color: Color.fromARGB(255, 255, 17, 0),
            icon: Icons.delete,
            caption: "Delete",
            onTap: (){
              onDelete(todo);
            },
          ),
          // IconSlideAction(
          //   color: Colors.blue,
          //   icon: Icons.edit,
          //   caption: "Edit",
          //   onTap: (){

          //   },
          // ),
        ],
      ),
    );
  }
}
