import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:testing_firebase/Widgets/TextFeildUpdate_widget.dart';
import 'package:testing_firebase/Widgets/porirt_widget.dart';
import 'package:testing_firebase/provMoadel/StateProv.dart';

class deleteAndupdate_widget extends StatelessWidget {
  const deleteAndupdate_widget({super.key, required this.task});

  final QueryDocumentSnapshot task;

  @override
  Widget build(BuildContext context) {
    return Consumer<Stateprov>(
      builder: (BuildContext context, Stateprov value, Widget? child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 50,
                color: Colors.blueGrey[300],

                child: MaterialButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    value.playSound('sounds/deletedSound.mp3');
                    value.deleteTaskFun(task.id);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.white),
                      SizedBox(width: 5),
                      Text(
                        "Delete Task",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 50,
                color: Colors.blueGrey[300],

                child: MaterialButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    value.textTask.text = task["Task"];
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.blueGrey,
                          actions: [
                            TextfeildupdateWidget(),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Builder(
                                  builder: (context) {
                                    return IconButton(
                                      onPressed: () {
                                        showPopover(
                                          height: 200,
                                          width: 200,

                                          direction: PopoverDirection.top,
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          bodyBuilder: (context) {
                                            return PorirtyWidget(
                                              heighPorirtyFunc: () async {
                                                Navigator.pop(context);
                                                await value.updateTask(
                                                  task.id,
                                                  {"Porirty": "Height"},
                                                );
                                              },
                                              mediumPorirtyFunc: () async {
                                                Navigator.pop(context);
                                                await value.updateTask(
                                                  task.id,
                                                  {"Porirty": "Medium"},
                                                );
                                              },
                                              lowPorirtyFunc: () async {
                                                Navigator.pop(context);
                                                await value.updateTask(
                                                  task.id,
                                                  {"Porirty": "Low"},
                                                );
                                              },
                                              noPorirtyFunc: () async {
                                                Navigator.pop(context);
                                                await value.updateTask(
                                                  task.id,
                                                  {"Porirty": "No Porirty"},
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                                      icon: Icon(
                                        Icons.flag,
                                        color: task["Porirty"] == "No Porirty"
                                            ? Colors.grey
                                            : task["Porirty"] == "Low"
                                            ? Colors.blue
                                            : task["Porirty"] == "Medium"
                                            ? Colors.amber
                                            : task["Porirty"] == "Height"
                                            ? Colors.red
                                            : Colors.transparent,
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  onPressed: () async {
                                    DateTime? upDagradDate =
                                        await showDatePicker(
                                          context: context,
                                          firstDate: DateTime(2010),
                                          initialDate: value.date,
                                          lastDate: DateTime(2050),
                                        );

                                    if (upDagradDate != null) {
                                      value.updateTask(task.id, {
                                        "date": Timestamp.fromDate(
                                          upDagradDate,
                                        ),
                                      });
                                    }
                                  },
                                  icon: Icon(Icons.calendar_month),
                                  color: Colors.blueGrey[800],
                                ),
                                IconButton(
                                  onPressed: () async {
                                    TimeOfDay? upDagradTime =
                                        await showTimePicker(
                                          context: context,
                                          initialTime: value.timeOfDay,
                                        );

                                    if (upDagradTime != null) {
                                      value.updateTask(task.id, {
                                        "Time": upDagradTime.format(context),
                                      });
                                    }
                                  },
                                  icon: Icon(Icons.timer),
                                  color: Colors.blueGrey[300],
                                ),
                                IconButton(
                                  onPressed: () {
                                    value.updateTask(task.id, {
                                      "Task": value.textTask.text.trim(),
                                    });
                                    Navigator.pop(context);
                                    value.textTask.clear();
                                  },
                                  icon: Icon(Icons.send),
                                  color: Colors.blueGrey[800],
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: Colors.white),
                      SizedBox(width: 5),
                      Text(
                        "Update Task",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
