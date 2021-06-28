import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:to_love/DbHelper.dart';
import 'package:to_love/Screens/Homepage.dart';
import 'package:to_love/models/TaskModel.dart';

class Addtask extends StatefulWidget {
  final bool addorupdate; //- DIFFRENCIATE BETWEEN ADD ND UPGRADE BUTTON
  final int idtoupdate; //- USE THIS ID TO UPDATE THE TASKS

  const Addtask({Key key, this.addorupdate, this.idtoupdate}) : super(key: key);
  @override
  _AddtaskState createState() => _AddtaskState();
}

class _AddtaskState extends State<Addtask> {
  final _validatekey = GlobalKey<FormState>();

  String _title = "";
  String _desc = "";

  DateTime _date = DateTime.now();
  final DateFormat _dateFormater = DateFormat('MM/dd/yyyy');
  final TextEditingController _datecontroller = TextEditingController();
  final List _pioriteslist = ["Low", "Medium", "High"];

  String _pirority;
  TaskModel _taskModel;

  DbHelper _dbHelper = new DbHelper();

  @override
  void initState() {
    super.initState();
    _datecontroller.text =
        _dateFormater.format(_date); //? To initilize date when the screen opens
  }

  @override
  Widget build(BuildContext context) {
    double widthofscreen = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFF6F6F6),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.pink,
              size: 25,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              widget.addorupdate == false ? "Add Love" : "Update Love",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20.0,
              ),
              child: Form(
                key: _validatekey,
                child: Column(
                  children: [
                    // FOR TITLE
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: widthofscreen / 1,
                        padding: EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 10.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: TextFormField(
                          style: TextStyle(fontSize: 18),
                          cursorColor: Colors.pink,
                          decoration: InputDecoration(
                              hintText: "Title",
                              hintStyle: TextStyle(color: Colors.pink),
                              labelStyle: TextStyle(fontSize: 18),
                              border: InputBorder.none),
                          validator: (input) => input.trim().isEmpty
                              ? "Please enter a love title"
                              : null,
                          onSaved: (input) => _title = input,
                          initialValue: _title,
                        ),
                      ),
                    ),
                    // FOR DESC
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: widthofscreen / 1,
                        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: TextFormField(
                          maxLength: 100,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          minLines: 1,
                          maxLines: 3,
                          style: TextStyle(fontSize: 18),
                          cursorColor: Colors.pink,
                          decoration: InputDecoration(
                              hintText: "Description",
                              hintStyle: TextStyle(color: Colors.pink),
                              labelStyle: TextStyle(fontSize: 18),
                              border: InputBorder.none),
                          validator: (input) => input.trim().isEmpty
                              ? "Please enter a short Desciption"
                              : null,
                          onSaved: (input) => _desc = input,
                        ),
                      ),
                    ),
                    // FOR DATE
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                          width: widthofscreen / 1,
                          padding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 10.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: TextFormField(
                            controller: _datecontroller,
                            onTap: _handleDatePicker,
                            style: TextStyle(fontSize: 18),
                            cursorColor: Colors.pink,
                            decoration: InputDecoration(
                                // hintText: "Month/Date/Year",
                                labelText: 'Month/Date/Year',
                                labelStyle:
                                    TextStyle(fontSize: 18, color: Colors.pink),
                                border: InputBorder.none),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 10.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: DropdownButtonFormField(
                          hint: Text("Select Pirority"),
                          onChanged: (selectedvalue) {
                            _pirority = selectedvalue;
                          },
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.pink,
                            size: 35,
                          ),
                          items: _pioriteslist
                              .map<DropdownMenuItem<String>>((selectdpirority) {
                            return DropdownMenuItem(
                              child: Text(
                                selectdpirority,
                                style: TextStyle(color: Colors.black87),
                              ),
                              value: selectdpirority,
                            );
                          }).toList(),
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                              hintStyle: TextStyle(color: Colors.pink),
                              labelStyle: TextStyle(fontSize: 18),
                              border: InputBorder.none),
                          validator: (input) => _pirority == null
                              ? "Please select the pirority leval"
                              : null,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                          width: widthofscreen / 1,
                          padding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 10.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.pink,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: TextButton(
                              onPressed: _validateAndSubmit, //? SUBMIT ACTION
                              child: Text(
                                widget.addorupdate == false ? 'Add' : 'Update',
                                style: TextStyle(color: Colors.white),
                              ))),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _validateAndSubmit() {
    if (_validatekey.currentState.validate()) {
      _validatekey.currentState.save();

      if (_taskModel == null) {
        //? AS SQL DOSENT SUPPORT DATETIME SO WE HAVE TO CONVERT IT IN STING AND THEN STORE IN DATABASE
        //? SQL DOSENT SUPPORT BOOLEAN AS WELL SO WE HAVE TO USE INT AND USE 0 FOR FALSE AND 1 FOR TRUE
        String newdate = _date.toString();
        TaskModel task = new TaskModel(
            title: _title,
            desc: _desc,
            date: newdate,
            pirority: _pirority,
            status: 1);
        if (widget.addorupdate == false) {
          _dbHelper.addTask(task.toMap());
        } else {
          _dbHelper.updateTasks(task, widget.idtoupdate);
        }

        Navigator.of(context).pushReplacementNamed('/home').then((value) {
          setState(() {});
        });
      }
    }
  }

  _handleDatePicker() async {
    final DateTime date = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2010),
        lastDate: DateTime(2050));
    if (date != null) {
      setState(() {
        _date = date;
      });
      _datecontroller.text = _dateFormater.format(_date);
    }
  }
}
