import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:testing_firebase/Widgets/TextfeildupdateOnTap_Widget.dart';
import 'package:testing_firebase/Widgets/porirt_widget.dart';
import 'package:testing_firebase/provMoadel/StateProv.dart';

class ApdateData extends StatefulWidget {
  const ApdateData({
    super.key,
    required this.task,
    required this.timestamp,
    required this.taskDate,
  });

  final QueryDocumentSnapshot<Object?> task;
  final Timestamp? timestamp;
  final int? taskDate;

  @override
  State<ApdateData> createState() => _ApdateDataState();
}

class _ApdateDataState extends State<ApdateData> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.task["IsChecked"] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Stateprov>(
      builder: (BuildContext context, value, child) {
        return AnimatedPadding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          duration: Duration(milliseconds: 220),
          curve: Curves.easeOut,
          child: Container(
            height: 250,
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 15, left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            side: BorderSide(
                              color: widget.task["Porirty"] == "No Porirty"
                                  ? Colors.grey
                                  : widget.task["Porirty"] == "Low"
                                  ? Colors.blue
                                  : widget.task["Porirty"] == "Medium"
                                  ? Colors.amber
                                  : widget.task["Porirty"] == "Height"
                                  ? Colors.red
                                  : Colors.transparent,
                              width: 2,
                            ),
                            checkColor: Colors.grey[200],
                            activeColor: Colors.grey[700],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            value: isChecked,
                            onChanged: (val) {
                              setState(() {
                                isChecked = val ?? false;
                              });
                              value.updateTask(widget.task.id, {
                                "IsChecked": isChecked,
                              });
                            },
                          ),
                          InkWell(
                            onTap: () async {
                              final upDateTimeDate = await showDatePicker(
                                context: context,
                                firstDate: DateTime(2010),
                                initialDate: widget.timestamp?.toDate(),
                                lastDate: DateTime(2050),
                              );
                              if (upDateTimeDate == null) {
                                return;
                              } else {
                                value.updateTask(widget.task.id, {
                                  "date": upDateTimeDate,
                                });
                              }

                              Navigator.pop(context);
                            },
                            child: Text(
                              "${widget.taskDate == DateTime.now().day
                                  ? "Today"
                                  : widget.taskDate == DateTime.now().day + 1
                                  ? "Tomorow"
                                  : widget.taskDate}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          SizedBox(width: 2),
                          InkWell(
                            onTap: () async {
                              final newTime = await showTimePicker(
                                context: context,
                                initialTime: value.timeOfDay,
                              );
                              if (newTime == null) {
                                return;
                              }
                              value.updateTask(widget.task.id, {
                                "Time": newTime.format(context),
                              });
                              Navigator.pop(context);
                            },
                            child: Text(
                              "${widget.task["Time"]}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),

                      MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          Navigator.pop(context);
                          value.playSound('sounds/deletedSound.mp3');
                          value.deleteTaskFun(widget.task.id);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.blueGrey[800]),
                            SizedBox(width: 5),
                            Text(
                              "Delete",
                              style: TextStyle(color: Colors.blueGrey[800]),
                            ),
                          ],
                        ),
                      ),
                      Builder(
                        builder: (context) {
                          return IconButton(
                            onPressed: () async {
                              showPopover(
                                height: 200,
                                width: 200,
                                backgroundColor: Colors.transparent,
                                context: context,
                                bodyBuilder: (context) {
                                  return PorirtyWidget(
                                    heighPorirtyFunc: () async {
                                      setState(() {
                                        value.updateTask(widget.task.id, {
                                          "Porirty": "Height",
                                        });
                                        Navigator.pop(context);
                                      });
                                    },
                                    mediumPorirtyFunc: () async {
                                      setState(() {
                                        value.updateTask(widget.task.id, {
                                          "Porirty": "Medium",
                                        });
                                        Navigator.pop(context);
                                      });
                                    },
                                    lowPorirtyFunc: () async {
                                      setState(() {
                                        value.updateTask(widget.task.id, {
                                          "Porirty": "Low",
                                        });
                                        Navigator.pop(context);
                                      });
                                    },
                                    noPorirtyFunc: () async {
                                      setState(() {
                                        value.updateTask(widget.task.id, {
                                          "Porirty": "No Porirty",
                                        });
                                        Navigator.pop(context);
                                      });
                                    },
                                  );
                                },
                              );
                            },
                            icon: Icon(
                              Icons.flag,
                              size: 25,
                              color: widget.task["Porirty"] == "No Porirty"
                                  ? Colors.grey
                                  : widget.task["Porirty"] == "Low"
                                  ? Colors.blue
                                  : widget.task["Porirty"] == "Medium"
                                  ? Colors.amber
                                  : widget.task["Porirty"] == "Height"
                                  ? Colors.red
                                  : Colors.transparent,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                TextfeildupdateontapWidget(id: widget.task.id),
              ],
            ),
          ),
        );
      },
    );
  }
}
