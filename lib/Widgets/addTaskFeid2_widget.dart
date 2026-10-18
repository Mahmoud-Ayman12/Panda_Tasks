import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:testing_firebase/Widgets/porirt_widget.dart';
import 'package:testing_firebase/provMoadel/StateProv.dart';

class AddtaskfeildWidget2 extends StatelessWidget {
  const AddtaskfeildWidget2({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Stateprov>(
      builder: (BuildContext context, value, child) {
        return AnimatedPadding(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  textAlign: value.isArapicText(value.textTask.text)
                      ? TextAlign.right
                      : TextAlign.left,
                  textAlignVertical: TextAlignVertical.bottom,
                  minLines: 1,
                  maxLines: 8,
                  textDirection: value.isArapicText(value.textTask.text)
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  onChanged: (val) {
                    value.changeTaskText(val);
                  },

                  autofocus: false,
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.blueGrey[700],
                  decoration: InputDecoration(
                    hint: Text(
                      "What Whould You Like ToDo?",
                      style: TextStyle(color: Colors.blueGrey[200]),
                    ),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 5, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            firstDate: DateTime(2010),
                            currentDate: value.selectedDays,
                            lastDate: DateTime(2050),
                          ).then((val) {
                            if (val != null) {
                              value.changeDate(val);
                            }
                          });
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.date_range_outlined,
                              color: Colors.blueGrey[800],
                            ),
                            Text(
                              value.dateNow.day == value.selectedDays!.day
                                  ? "Today"
                                  : value.dateNow.day + 1 ==
                                        value.selectedDays!.day
                                  ? "Tomorwo"
                                  : value.selectedDays!.day.toString(),
                              style: TextStyle(
                                color: Colors.blueGrey[800],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),

                      IconButton(
                        onPressed: () async {
                          final selectTime = await showTimePicker(
                            context: context,
                            initialTime: value.timeOfDay,
                          );

                          if (selectTime != null) {
                            value.changeTime(selectTime);
                          }
                        },
                        icon: Icon(
                          Icons.timer_sharp,
                          color: Colors.blueGrey[300],
                        ),
                      ),
                      Builder(
                        builder: (context) {
                          return IconButton(
                            onPressed: () {
                              showPopover(
                                height: 200,
                                width: 200,
                                backgroundColor: Colors.transparent,
                                direction: PopoverDirection.top,
                                context: context,
                                bodyBuilder: (context) {
                                  return PorirtyWidget(
                                    heighPorirtyFunc: () {
                                      value.porirty = "Height";
                                    },
                                    mediumPorirtyFunc: () {
                                      value.porirty = "Medium";
                                    },
                                    lowPorirtyFunc: () {
                                      value.porirty = "Low";
                                    },
                                    noPorirtyFunc: () {
                                      value.porirty = "No Porirty";
                                    },
                                  );
                                },
                              );
                            },
                            icon: Icon(
                              Icons.flag,
                              color: value.porirty == "No Porirty"
                                  ? Colors.grey
                                  : value.porirty == "Low"
                                  ? Colors.blue
                                  : value.porirty == "Medium"
                                  ? Colors.yellow
                                  : value.porirty == "Height"
                                  ? Colors.red
                                  : Colors.transparent,
                            ),
                          );
                        },
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                          value.textTask.clear();
                        },
                        icon: Icon(
                          Icons.cancel_sharp,
                          color: Colors.blueGrey[300],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          value.addTaskFun({
                            "Task": value.textTask.text.trim(),
                            "date": Timestamp.fromDate(value.selectedDays!),
                            "Time": value.timeOfDay.format(context),
                            "IsChecked": value.checkVal,
                            "Porirty": value.porirty,
                            "CreateAt": FieldValue.serverTimestamp(),
                          });
                          Navigator.pop(context);
                          value.porirty = "No Porirty";
                        },
                        icon: Icon(
                          Icons.send_rounded,
                          color: value.textTask.text.trim().isEmpty
                              ? Colors.blueGrey[300]
                              : Colors.blueGrey[800],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
