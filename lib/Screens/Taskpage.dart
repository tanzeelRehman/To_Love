import 'package:flutter/material.dart';
import 'package:to_love/DbHelper.dart';
import 'package:to_love/Widgets.dart';

class Taskpage extends StatefulWidget {
  final String title;
  final String desc;

  Taskpage({@required this.title, @required this.desc});

  @override
  _TaskpageState createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {
  TextEditingController taskcontroller = new TextEditingController();
  DbHelper _dbHelper = new DbHelper();

  List todos = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 24.0,
                      bottom: 6.0,
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Icon(Icons.arrow_back),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            widget.title ?? "(Unnamed Task)",
                            style: TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF211551),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 15.0),
                    child: Text(
                      widget.desc ?? "(Unnamed Task)",
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Color(0xFF211551),
                      ),
                    ),
                  ),
                  Expanded(
                      child: FutureBuilder(
                    future: _dbHelper.queryallTodo(),
                    builder: (context, snapshot) {
                      todos = snapshot.data;
                      return snapshot.data == null
                          ? Center(
                              child: Container(
                                child: Text("Loaing..."),
                              ),
                            )
                          : Container(
                              child: ListView.builder(
                                  itemCount: todos.length,
                                  itemBuilder: (context, index) {
                                    return TodoWidget(
                                      //? SQL DOSENT SUPPORT BOOLEAN AS WELL SO WE HAVE TO USE INT AND USE 0 FOR FALSE AND 1 FOR TRUE
                                      text: todos[index]['title'],
                                      isDone: todos[index]['status'] == 0
                                          ? false
                                          : true,
                                      updateCheck: (bool value) {
                                        //? CALL BACK FUNCTION IN TODOWIDGET WHICH UPFATE THE STATUS OF TASK EITHER COMPLEYED OR NOT
                                        setState(() {
                                          int id = todos[index]['id'];
                                          value == true
                                              ? _dbHelper.updateStatus(
                                                  id, 1, "todo_table")
                                              : _dbHelper.updateStatus(
                                                  id, 0, "todo_table");
                                        });
                                      },
                                      delete: () {
                                        int id = todos[index]['id'];
                                        _dbHelper.deleteTask(id, "todo_table");
                                        setState(() {});
                                      },
                                    );
                                  }),
                            );
                    },
                  )),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.0,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 20.0,
                          height: 20.0,
                          margin: EdgeInsets.only(
                            right: 12.0,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(6.0),
                              border: Border.all(
                                  color: Color(0xFF86829D), width: 1.5)),
                        ),
                        Expanded(
                          child: TextField(
                            controller: taskcontroller,
                            decoration: InputDecoration(
                              hintText: "Enter Todo item...",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Positioned(
                bottom: 24.0,
                right: 24.0,
                child: GestureDetector(
                  onTap: () async {},
                  child: Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: Color(0xFFFE3577),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: IconButton(
                          icon: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 35,
                          ),
                          onPressed: () {
                            if (taskcontroller.text != "") {
                              Map<String, dynamic> row = {
                                "title": taskcontroller.text,
                                "status": 0
                              };
                              print(taskcontroller.text);
                              _dbHelper.addTodoTask(row).then((value) {
                                print(value);
                                taskcontroller.clear();
                              });
                              setState(() {});
                            }
                          })),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
