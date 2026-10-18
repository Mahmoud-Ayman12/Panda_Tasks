import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_firebase/Widgets/apdateData_widget.dart';
import 'package:testing_firebase/Widgets/deleteAndupdate_widget.dart';
import 'package:testing_firebase/provMoadel/StateProv.dart';
import 'package:popover/popover.dart';

class TaskListWidgets extends StatelessWidget {
  const TaskListWidgets({super.key});
  static const taskRoue = "taskBage";
  @override
  Widget build(BuildContext context) {
    return Consumer<Stateprov>(
      builder: (BuildContext context, value, child) {
        final unCheckedtaskToday = value.taskforDay(
          value.unCheckedList,
          DateTime.now(),
        );
        final checkedtaskToday = value.taskforDay(
          value.checkList,
          DateTime.now(),
        );

        return SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (unCheckedtaskToday.isNotEmpty)
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                    vertical: 5,
                    horizontal: 15,
                  ),
                  child: Text("Tasks", style: TextStyle(fontSize: 18)),
                ),
              ListView.builder(
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: unCheckedtaskToday.length,
                itemBuilder: (context, index) {
                  final task = unCheckedtaskToday[index];
                  final Timestamp? timestamp = task["date"] as Timestamp?;
                  final int? taskDate = timestamp?.toDate().day;
                  final isArabic = value.isArapicText(task["Task"]);

                  return Builder(
                    builder: (BuildContext context) {
                      return InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          value.textTask.text = task["Task"];
                          showModalBottomSheet(
                            backgroundColor: Colors.blueGrey,
                            isScrollControlled: true,
                            useSafeArea: true,
                            context: context,
                            builder: (context) {
                              return ApdateData(
                                task: task,
                                timestamp: timestamp,
                                taskDate: taskDate,
                              );
                            },
                          );
                        },
                        onLongPress: () {
                          value.playSound('sounds/pob.mp3');
                          showPopover(
                            backgroundColor: Colors.transparent,
                            context: context,
                            bodyBuilder: (context) {
                              return deleteAndupdate_widget(task: task);
                            },
                            height: 100,
                            width: 200,
                            direction: PopoverDirection.bottom,
                            transitionDuration: Duration(milliseconds: 150),
                          );
                        },

                        child: Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          elevation: 3,
                          child: ListTile(
                            title: Text(
                              task["Task"],
                              style: TextStyle(overflow: TextOverflow.ellipsis),
                              maxLines: 1,
                              textDirection: isArabic
                                  ? TextDirection.rtl
                                  : TextDirection.rtl,
                              textAlign: isArabic
                                  ? TextAlign.start
                                  : TextAlign.left,
                            ),
                            subtitle: Text(
                              "${taskDate == null
                                  ? "NoData"
                                  : taskDate == DateTime.now().day
                                  ? "Today"
                                  : DateTime.now().day + 1 == taskDate
                                  ? "Tomorow"
                                  : taskDate.toString()}  |   ${task["Time"]}",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                            ),
                            trailing: Checkbox(
                              side: BorderSide(
                                color: task["Porirty"] == "No Porirty"
                                    ? Colors.grey
                                    : task["Porirty"] == "Low"
                                    ? Colors.blue
                                    : task["Porirty"] == "Medium"
                                    ? Colors.amber
                                    : task["Porirty"] == "Height"
                                    ? Colors.red
                                    : Colors.transparent,
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(5),
                              ),
                              value: task["IsChecked"] ?? false,
                              onChanged: (val) {
                                if (val == true) {
                                  value.playSound('sounds/checkSound.mp3');
                                }
                                value.updateTask(task.id, {
                                  "IsChecked": val ?? false,
                                });
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),

              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: checkedtaskToday.length + 1,
                itemBuilder: (context, index) {
                  if (checkedtaskToday.isEmpty) {
                    return SizedBox();
                  }
                  if (index == 0) {
                    return Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
                      child: Text(
                        "Completed",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                  final checkTask = checkedtaskToday[index - 1];
                  final timeStapCheckTask = checkTask["date"] as Timestamp?;
                  final checkdate = timeStapCheckTask?.toDate().day;
                  final isArabic = value.isArapicText(checkTask["Task"]);

                  return InkWell(
                    onTap: () {
                      value.textTask.text = checkTask["Task"];
                      showModalBottomSheet(
                        backgroundColor: Colors.grey[100],
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return ApdateData(
                            task: checkTask,
                            timestamp: timeStapCheckTask,
                            taskDate: checkdate,
                          );
                        },
                      );
                    },
                    child: Builder(
                      builder: (context) {
                        return InkWell(
                          onTap: () {
                            value.textTask.text = checkTask["Task"];
                            showModalBottomSheet(
                              backgroundColor: Colors.blueGrey,
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return ApdateData(
                                  task: checkTask,
                                  timestamp: timeStapCheckTask,
                                  taskDate: checkdate,
                                );
                              },
                            );
                          },
                          onLongPress: () {
                            showPopover(
                              backgroundColor: Colors.transparent,
                              height: 100,
                              width: 200,
                              direction: PopoverDirection.top,
                              context: context,
                              bodyBuilder: (context) {
                                return deleteAndupdate_widget(task: checkTask);
                              },
                            );
                          },
                          child: Card(
                            elevation: 3,
                            color: Colors.grey,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            child: ListTile(
                              title: Text(
                                checkTask["Task"],
                                textDirection: isArabic
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                                textAlign: isArabic
                                    ? TextAlign.start
                                    : TextAlign.left,
                                style: TextStyle(
                                  color: Colors.grey[200],
                                  decoration: TextDecoration.lineThrough,
                                  decorationStyle: TextDecorationStyle.solid,
                                  decorationThickness: 2,
                                  decorationColor: Colors.blueGrey[600],
                                ),
                              ),
                              subtitle: Text(
                                "${checkdate == null
                                    ? "NoData"
                                    : checkdate == DateTime.now().day
                                    ? "Today"
                                    : DateTime.now().day + 1 == checkdate
                                    ? "Tomorow"
                                    : checkdate.toString()}  |   ${checkTask["Time"]}",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 10,
                                ),
                              ),
                              trailing: Checkbox(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    5,
                                  ),
                                ),
                                activeColor: Colors.grey[200],
                                checkColor: Colors.grey,
                                value: checkTask["IsChecked"],
                                onChanged: (val) => value.updateTask(
                                  checkTask.id,
                                  {"IsChecked": val},
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
