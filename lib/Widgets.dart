import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import 'package:to_love/DbHelper.dart';

import 'Screens/Addtakspage.dart';

class TaskCardWidget extends StatelessWidget {
  final String title;
  final String desc;
  final DateTime date;
  final DateFormat _dateFormater = DateFormat('MM/dd/yyyy');
  final String pirority;
  final bool status;
  final int taskid;
  Function refresh;
  Function toogleswitch;
  TaskCardWidget(
      {this.title,
      this.desc,
      this.date,
      this.pirority,
      this.status,
      this.taskid,
      this.refresh,
      this.toogleswitch});
  DbHelper _dbHelper = new DbHelper();
  SlidableController slideController = new SlidableController();

  @override
  Widget build(BuildContext context) {
    return Slidable(
      controller: slideController,
      actionPane: SlidableBehindActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: [
        GestureDetector(
          onTap: () {
            print("Tapped");
            _dbHelper.deleteTask(taskid, "task_table");
            refresh();
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 20, right: 10),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Icon(
                Icons.delete,
                color: Colors.white,
                size: 35,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            print("Tapped");
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Addtask(
                        addorupdate: true,
                        idtoupdate: taskid,
                      )),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 20, right: 10),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Icon(
                Icons.edit,
                color: Colors.pink,
                size: 35,
              ),
            ),
          ),
        )
      ],
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: 32.0,
          horizontal: 24.0,
        ),
        margin: EdgeInsets.only(
          bottom: 20.0,
        ),
        decoration: BoxDecoration(
          color: status ? Colors.white : Colors.pink[400],
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title ?? "(Unnamed Task)",
                    style: TextStyle(
                      color: status ? Colors.pink : Colors.white,
                      fontSize: 22.0,
                      decoration: status == false
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      decorationColor: Colors.pink[400],
                      decorationStyle: TextDecorationStyle.double,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Switch(
                  value: status,
                  onChanged: toogleswitch,
                  activeColor: Colors.pink,
                  activeTrackColor: Colors.pink[50],
                  inactiveTrackColor: Color(0xFFF6F6F6),
                  dragStartBehavior: DragStartBehavior.down,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    _dateFormater.format(date),
                    style: TextStyle(
                      color: Color(0xFF211551),
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Medium",
                    style: TextStyle(
                      color: status ? Colors.black : Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 10.0,
              ),
              child: Text(
                status ? desc ?? "No Description Added" : "Task Completed",
                style: TextStyle(
                  fontSize: 16.0,
                  color: status ? Color(0xFF86829D) : Colors.white,
                  height: 1.5,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TodoWidget extends StatelessWidget {
  final String text;
  final bool isDone;
  final Function updateCheck;
  final Function delete;

  TodoWidget({
    @required this.text,
    @required this.isDone,
    @required this.updateCheck,
    @required this.delete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 8.0,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        child: Row(
          children: [
            Checkbox(value: isDone, onChanged: updateCheck),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    text ?? "(Unnamed Todo)",
                    style: TextStyle(
                        color: isDone ? Color(0xFF211551) : Color(0xFF86829D),
                        fontSize: 16.0,
                        fontWeight: isDone ? FontWeight.bold : FontWeight.w500,
                        decoration: isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red[300],
                      ),
                      onPressed: delete)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
