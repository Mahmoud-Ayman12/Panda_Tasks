import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Source;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:testing_firebase/pages/Notes%20pages/folders_Page.dart';
import 'package:testing_firebase/pages/tableCalender_Page.dart';
import 'package:testing_firebase/pages/todo_Page.dart';

class Stateprov extends ChangeNotifier {
  bool changeIcon = true;
  bool changeIcon2 = true;
  String userName = '';
  late TextEditingController userNameController;
  bool isLoad = false;
  List<QueryDocumentSnapshot> listTask = [];
  int activScreen = 0;
  TextEditingController textTask = TextEditingController();
  TextEditingController updateTasktext = TextEditingController();
  User? get user => FirebaseAuth.instance.currentUser;
  String? get uid => FirebaseAuth.instance.currentUser?.uid;
  StreamSubscription? streamSubscription;
  bool checkVal = false;
  DateTime date = DateTime.now();
  DateTime dateNow = DateTime.now();
  TimeOfDay timeOfDay = TimeOfDay.now();
  List<QueryDocumentSnapshot> get checkList =>
      listTask.where((element) => element["IsChecked"] == true).toList();
  List<QueryDocumentSnapshot> get unCheckedList =>
      listTask.where((task) => task["IsChecked"] != true).toList();
  String porirty = "No Porirty";
  DateTime? selectedDays = DateTime.now();
  AudioPlayer player = AudioPlayer();

  List<QueryDocumentSnapshot> taskforDay(
    List<QueryDocumentSnapshot> task,
    DateTime day,
  ) {
    return task.where((task) {
      final taskDate = task["date"];
      if (taskDate is! Timestamp) {
        return false;
      }

      return isSameDay(taskDate.toDate(), day);
    }).toList();
  }

  final months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  List<Widget> screens = [
    const TaskToday(),
    const TablecalenderPage(),
    const FoldersPage(),
  ];

  Future<void> playSound(pathSound) async {
    try {
      await player.stop();
      Source path = AssetSource(pathSound);
      await player.play(path);
    } catch (e) {
      print("Error is  $e");
    }
  }

  bool isArapicText(String text) {
    return text.trim().isNotEmpty &&
        RegExp(r'[\u0600-\u06FF]').hasMatch(text[0]);
  }

  String dateInList(dynamic timeStap) {
    DateTime realDate;
    if (timeStap is Timestamp) {
      realDate = timeStap.toDate();
    } else if (timeStap is DateTime) {
      realDate = timeStap;
    } else {
      return "";
    }
    return "${months[realDate.month].substring(0, 3)} ${realDate.day}";
  }

  changeIconFun() {
    changeIcon = !changeIcon;
    notifyListeners();
  }

  changeIconFun2() {
    changeIcon2 = !changeIcon2;
    notifyListeners();
  }

  changeCheck(val) {
    checkVal = val;
    notifyListeners();
  }

  setUserName(name) {
    userName = name;
    notifyListeners();
  }

  loadval(bool val) {
    isLoad = val;
    notifyListeners();
  }

  bottomNaviFun(int newActiv) {
    activScreen = newActiv;
    notifyListeners();
  }

  changeTaskText(val) {
    textTask.text = val;
    notifyListeners();
  }

  void clearData() {
    streamSubscription?.cancel();
    streamSubscription = null;
    listTask = [];
    notifyListeners();
  }

  updateTask(String id, Map<String, dynamic?> data) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("Tasks")
        .doc(id)
        .update(data);
    textTask.dispose;
    notifyListeners();
  }

  addTaskFun(Map<String, dynamic> addDate) async {
    if (user == null) {
      return;
    }
    final task = textTask.text.trim();
    if (task.isEmpty) {
      return;
    }

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("Tasks")
        .add(addDate);
    textTask.clear();
    timeOfDay = TimeOfDay.now();
    date = DateTime.now();
    porirty = "No Porirty";
    readTaskFun();
    notifyListeners();
  }

  readTaskFun() async {
    streamSubscription?.cancel();
    streamSubscription = await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("Tasks")
        .orderBy("CreateAt", descending: true)
        .snapshots()
        .listen((data) {
          listTask = data.docs;
          notifyListeners();
        });
    notifyListeners();
  }

  deleteTaskFun(String taskId) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("Tasks")
        .doc(taskId)
        .delete();
    readTaskFun();
    notifyListeners();
  }

  changeDate(DateTime newDate) {
    date = newDate;
    notifyListeners();
  }

  changeTime(TimeOfDay newTime) {
    timeOfDay = newTime;
    notifyListeners();
  }

  getTasksWasChecked() {
    return taskforDay(
      checkList,
      DateTime.now(),
    ).where((element) => element["IsChecked"] == true).toList().length;
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    textTask.dispose();
    super.dispose();
  }
}
