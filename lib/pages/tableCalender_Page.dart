import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:testing_firebase/Screens/login_screen.dart';
import 'package:testing_firebase/Widgets/apdateData_widget.dart';
import 'package:testing_firebase/provMoadel/StateProv.dart';
import 'package:testing_firebase/provMoadel/noteProv.dart';

class TablecalenderPage extends StatefulWidget {
  const TablecalenderPage({super.key});

  @override
  State<TablecalenderPage> createState() => _TablecalenderPageState();
}

class _TablecalenderPageState extends State<TablecalenderPage> {
  DateTime? getTaskDate(dynamic date) {
    if (date is Timestamp) {
      return date.toDate();
    }

    if (date is DateTime) {
      return date;
    }

    if (date is String) {
      // لو التاريخ بصيغة مثل 2026-09-27
      final parsedDate = DateTime.tryParse(date.trim());

      if (parsedDate != null) {
        return parsedDate;
      }

      // لو التاريخ بصيغة يوم/شهر/سنة مثل 27/09/2026
      final parts = date.trim().split('/');

      if (parts.length == 3) {
        final day = int.tryParse(parts[0]);
        final month = int.tryParse(parts[1]);
        final year = int.tryParse(parts[2]);

        if (day != null && month != null && year != null) {
          final parsed = DateTime(year, month, day);

          if (parsed.year == year &&
              parsed.month == month &&
              parsed.day == day) {
            return parsed;
          }
        }
      }
    }

    return null;
  }

  DateTime focusedDays = DateTime.now();
  CalendarFormat calendarFormat = CalendarFormat.week;

  List<QueryDocumentSnapshot> taskforDay(
    List<QueryDocumentSnapshot> task,
    DateTime day,
  ) {
    return task.where((task) {
      final taskDate = getTaskDate(task['date']);

      if (taskDate == null) {
        return false;
      }

      return isSameDay(taskDate, day);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Stateprov>(
      builder: (BuildContext context, value, Widget? child) {
        final dayToShow = value.selectedDays ?? focusedDays;
        final task = taskforDay(value.listTask, dayToShow);
        final checkTask = taskforDay(value.checkList, dayToShow);
        final unCheckTask = taskforDay(value.unCheckedList, dayToShow);

        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  final stateProv = context.read<Stateprov>();
                  final noteProv = context.read<NoteProv>();
                  stateProv.clearData();
                  noteProv.clearData();

                  await GoogleSignIn.instance.signOut();
                  await FirebaseAuth.instance.signOut();

                  navigator.pushReplacementNamed(SingInScreen.singInRout);
                },
                icon: Icon(Icons.logout_rounded, color: Colors.white),
              ),
            ],
            backgroundColor: Colors.blueGrey,
            title: Text(
              value.months[focusedDays.month - 1],
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          backgroundColor: Colors.blueGrey[100],
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                    color: Colors.blueGrey,
                  ),
                  child: TableCalendar(
                    focusedDay: focusedDays,
                    firstDay: DateTime(2000),
                    lastDay: DateTime(2050),
                    headerVisible: false,

                    calendarFormat: calendarFormat,

                    onFormatChanged: (format) {
                      setState(() {
                        calendarFormat = format;
                      });
                    },

                    selectedDayPredicate: (day) {
                      return isSameDay(value.selectedDays, day);
                    },
                    eventLoader: (day) {
                      return taskforDay(value.unCheckedList, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        value.selectedDays = selectedDay;
                        focusedDays = focusedDay;
                      });
                    },
                    onPageChanged: (focusedDay) {
                      setState(() {
                        focusedDays = focusedDay;
                      });
                    },
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(color: Colors.white70),
                      weekendStyle: TextStyle(color: Colors.white70),
                    ),
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.orange[400],
                        shape: BoxShape.circle,
                      ),
                      todayTextStyle: TextStyle(color: Colors.black),
                      selectedDecoration: BoxDecoration(
                        color: Colors.blueGrey[900],
                        shape: BoxShape.circle,
                      ),
                      outsideDaysVisible: true,
                      outsideTextStyle: TextStyle(color: Colors.grey[400]),

                      markerDecoration: BoxDecoration(
                        color: Colors.blueGrey[900],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      defaultTextStyle: TextStyle(color: Colors.white),
                      weekendTextStyle: TextStyle(color: Colors.white70),
                      canMarkersOverflow: true,
                      markersMaxCount: 4,
                    ),
                  ),
                ),

                if (unCheckTask.isNotEmpty)
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(
                      vertical: 5,
                      horizontal: 15,
                    ),
                    child: Text(
                      "Tasks",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.start,
                      textDirection: TextDirection.ltr,
                    ),
                  ),

                task.isEmpty
                    ? Center(
                        child: Text(
                          "No Tasks",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: unCheckTask.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          final tasks = unCheckTask[index];
                          final isArabic = value.isArapicText(tasks["Task"]);
                          final DateTime? dateTime = getTaskDate(tasks['date']);

                          final Timestamp? timestamp = dateTime == null
                              ? null
                              : Timestamp.fromDate(dateTime);

                          final int? taskDate = dateTime?.day;

                          return InkWell(
                            onTap: () {
                              value.textTask.text = tasks["Task"];
                              showModalBottomSheet(
                                backgroundColor: Colors.blueGrey,
                                isScrollControlled: true,
                                useSafeArea: true,
                                context: context,
                                builder: (context) {
                                  return ApdateData(
                                    task: tasks,
                                    timestamp: timestamp,
                                    taskDate: taskDate,
                                  );
                                },
                              );
                            },
                            child: Card(
                              elevation: 3,
                              child: ListTile(
                                title: Text(
                                  tasks['Task']?.toString() ?? '',
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  textAlign: isArabic
                                      ? TextAlign.start
                                      : TextAlign.end,
                                  textDirection: isArabic
                                      ? TextDirection.rtl
                                      : TextDirection.ltr,
                                  maxLines: 1,
                                ),

                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${tasks['Time']}'),
                                    Text(
                                      '${tasks['Porirty']}',
                                      style: TextStyle(
                                        color: tasks["Porirty"] == "No Porirty"
                                            ? Colors.grey
                                            : tasks["Porirty"] == "Low"
                                            ? Colors.blue
                                            : tasks["Porirty"] == "Medium"
                                            ? Colors.amber
                                            : tasks["Porirty"] == "Height"
                                            ? Colors.red
                                            : Colors.transparent,
                                      ),
                                    ),
                                  ],
                                ),

                                trailing: Checkbox(
                                  value: tasks['IsChecked'] == true,
                                  side: BorderSide(
                                    color: tasks["Porirty"] == "No Porirty"
                                        ? Colors.grey
                                        : tasks["Porirty"] == "Low"
                                        ? Colors.blue
                                        : tasks["Porirty"] == "Medium"
                                        ? Colors.amber
                                        : tasks["Porirty"] == "Height"
                                        ? Colors.red
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.circular(
                                      5,
                                    ),
                                  ),
                                  onChanged: (checked) {
                                    if (checked == true) {
                                      value.playSound('sounds/checkSound.mp3');
                                    }
                                    value.updateTask(tasks.id, {
                                      'IsChecked': checked ?? false,
                                    });
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                if (checkTask.isNotEmpty)
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(
                      vertical: 5,
                      horizontal: 15,
                    ),
                    child: Text(
                      "Checked",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: checkTask.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final tasks = checkTask[index];
                    final isArabic = value.isArapicText(tasks["Task"]);
                    final DateTime? dateTime = getTaskDate(tasks['date']);

                    final Timestamp? timestamp = dateTime == null
                        ? null
                        : Timestamp.fromDate(dateTime);

                    final int? taskDate = dateTime?.day;
                    return InkWell(
                      onTap: () {
                        value.textTask.text = tasks["Task"];
                        showModalBottomSheet(
                          backgroundColor: Colors.blueGrey,
                          isScrollControlled: true,
                          useSafeArea: true,
                          context: context,
                          builder: (context) {
                            return ApdateData(
                              task: tasks,
                              timestamp: timestamp,
                              taskDate: taskDate,
                            );
                          },
                        );
                      },
                      child: Card(
                        color: Colors.grey,
                        elevation: 3,
                        child: ListTile(
                          title: Text(
                            tasks['Task']?.toString() ?? '',
                            style: TextStyle(
                              color: Colors.grey[100],
                              decoration: TextDecoration.lineThrough,
                              decorationStyle: TextDecorationStyle.solid,
                              decorationThickness: 2,
                              decorationColor: Colors.blueGrey[600],
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                            textAlign: isArabic
                                ? TextAlign.start
                                : TextAlign.end,
                            textDirection: isArabic
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${tasks['Time']}',
                                style: TextStyle(color: Colors.grey[200]),
                              ),
                              Text(
                                '${tasks['Porirty']}',
                                style: TextStyle(color: Colors.grey[200]),
                              ),
                            ],
                          ),

                          trailing: Checkbox(
                            value: tasks['IsChecked'] == true,
                            side: BorderSide(color: Colors.grey, width: 2),
                            activeColor: Colors.grey[200],
                            checkColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(5),
                            ),
                            onChanged: (checked) {
                              value.updateTask(tasks.id, {
                                'IsChecked': checked ?? false,
                              });
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
