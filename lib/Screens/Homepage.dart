import 'package:flutter/material.dart';
import 'package:to_love/DbHelper.dart';
import 'package:to_love/Screens/Addtakspage.dart';
import 'package:to_love/Screens/Taskpage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_love/models/TaskModel.dart';

import '../Widgets.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List tasks = [];
  DbHelper _dbHelper = new DbHelper();
  bool addorupdate; // ? TO DIFFRENCIATE BETWEEN ADD BUTTON AND UPDATE BUTTON

  @override
  void initState() {
    super.initState();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          color: Color(0xFFF6F6F6),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.only(
                        top: 32.0,
                        bottom: 32.0,
                      ),
                      child: Text("To Love",
                          style: GoogleFonts.lobsterTwo(
                              fontSize: 30, color: Colors.pink))),
                  Expanded(
                      child: FutureBuilder(
                          future: _dbHelper.queryAll(),
                          builder: (context, snapshot) {
                            tasks = snapshot.data;

                            return snapshot.data == null
                                ? Center(
                                    child: Container(
                                      child: Text("No Data"),
                                    ),
                                  )
                                : Container(
                                    child: ListView.builder(
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (context, index) {
                                        TaskModel singletask = tasks[index];
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Taskpage(
                                                            title: singletask
                                                                .title,
                                                            desc: singletask
                                                                .desc)));
                                          },
                                          child: TaskCardWidget(
                                            title: singletask.title,
                                            desc: singletask.desc,
                                            date: DateTime.parse(singletask
                                                .date), //?  CONVERT STRING DATE TIME IN TO DATETME
                                            pirority: singletask.pirority,
                                            status: singletask.status == 1
                                                ? true
                                                : false,
                                            taskid: singletask.id,
                                            refresh: refresh,
                                            toogleswitch: (bool value) {
                                              //? CALL BACK FUNCTION IN TASK WIDGET CLASS TO UPDATE SWITCH  STATE
                                              setState(() {
                                                value == true
                                                    ? _dbHelper.updateStatus(
                                                        singletask.id,
                                                        1,
                                                        "task_table")
                                                    : _dbHelper.updateStatus(
                                                        singletask.id,
                                                        0,
                                                        "task_table");
                                              });
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  );
                          }))
                ],
              ),
              Positioned(
                bottom: 24.0,
                right: 0.0,
                child: Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: Colors.pink[300],
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Addtask(
                                      addorupdate: false,
                                    )),
                          );
                        })),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
