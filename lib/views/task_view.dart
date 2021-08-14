import 'package:ajocard_sales_kit/model/db_provider.dart';
import 'package:ajocard_sales_kit/model/task_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String date;

  TextEditingController textController = TextEditingController();
  addNewTask(Task newTask) {
    DBProvider.dataBase.addNewTask(newTask);
  }

  String? _validateItemRequired(String? value) {
    return value!.isEmpty ? 'Item Required' : null;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        name = textController.text;
        date = DateTime.now().day.toString();
      });
    }
  }

  getTasks() async {
    final tasks = DBProvider.dataBase.getTask();
    print(tasks);
    return tasks;
  }

  Color bodyColor = Colors.black12;
  Color appBarColor = Colors.black45;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: FutureBuilder<dynamic>(
          future: getTasks(),
          builder: (_, taskData) {
            // if there is no note in db, display you do not have notes
            if (taskData.connectionState == ConnectionState.done &&
                taskData.data == Null) {
              return Center(
                child: Text("You do not have any Task"),
              );
              // if we are still waiting for notes, display a circular progressbar
            } else if (taskData.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Card(
              elevation: 0,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemCount: taskData.data.length,
                    itemBuilder: (context, index) {
                      name = taskData.data[index]["task"];
                      date = DateFormat('MMMMEEEEd').format(DateTime.now());
                      return Dismissible(
                          key: Key(taskData.data[index].toString()),
                          onDismissed: (direction) {
                            setState(() {
                              DBProvider.dataBase
                                  .deleteTask(taskData.data[index]['id']);
                            });
                          },
                          background: Container(
                            color: Colors.red,
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 80,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          child: Card(
                              child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              //border: Border.all(color: Colors.white),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(2, 2),
                                  spreadRadius: 2,
                                  blurRadius: 1,
                                ),
                              ],
                            ),
                            child: InkWell(
                                onTap: () {},
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(8.0),
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Text(
                                        date,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    Expanded(
                                        child: Text(
                                      name,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        //fontWeight: FontWeight.bold
                                      ),
                                    ))
                                  ],
                                )),
                          )));
                    }),
              ),
            );
          },
        )),
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              )),
          child: Row(
            children: [
              Expanded(
                child: Card(
                  child: Form(
                    key: _formKey,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        border: Border.all(color: Colors.white),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(2, 2),
                            spreadRadius: 2,
                            blurRadius: 1,
                          ),
                        ],
                      ),
                      child: TextFormField(
                        validator: _validateItemRequired,
                        controller: textController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white38,
                            hintText: "Type a new Task",
                            focusedBorder: InputBorder.none),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 1.0,
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    _submit();
                    Task newTask = Task(task: name, date: date);
                    addNewTask(newTask);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    shape: StadiumBorder(),
                  ),
                  icon: Icon(
                    Icons.add_task_sharp,
                    color: Colors.black,
                  ),
                  label: Text("add tasks"),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
