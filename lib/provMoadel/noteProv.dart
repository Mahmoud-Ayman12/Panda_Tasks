import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NoteProv extends ChangeNotifier {
  TextEditingController noteTitle = TextEditingController();
  TextEditingController noteDetils = TextEditingController();
  String? get uid => FirebaseAuth.instance.currentUser?.uid;
  final dateNow = DateTime.now();
  DateTime datePick = DateTime.now();
  List<QueryDocumentSnapshot> notesList = [];

  var currentId;

  Color? activeColor = Colors.blueGrey[400];
  List<Color> colorsBackground = [
    Color(0xFF093C5D),
    Color(0xFF22396F),
    Colors.blueGrey,
    Color(0xFF3B7597),
    Color(0xFF6FD1D7),
    Colors.green,
    Colors.teal,
    Colors.blueAccent,
    Colors.brown,
    const Color(0xFF7D0A0A),
    const Color(0xFFAA1C41),
    const Color(0xFF2E4540),
    const Color(0xFF273338),
    const Color(0xFF2B5748),
    const Color(0xFF618764),
    const Color(0xFF9CB080),
    Colors.black,
    Colors.black38,
    Color(0xFF758A93),
    Colors.grey,
  ];

  Object? get userNameController => null;

  getIdNote(int index) async {
    currentId = notesList[index].id;

    notifyListeners();
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
    return "${realDate.day}-${realDate.month}-${realDate.year}";
  }

  clearNoteFun() {
    noteTitle.clear();
    noteDetils.clear();
    datePick = DateTime.now();
    currentId = null;
    activeColor = Colors.blueGrey[400];
    notifyListeners();
  }

  Color getTextColor(Color backgroundColor) {
    final brigtness = ThemeData.estimateBrightnessForColor(backgroundColor);
    return brigtness == Brightness.dark ? Colors.white : Colors.black;
  }

  isArapic(String text) {
    return text.trim().isNotEmpty &&
        RegExp(r'[\u0600-\u06FF]').hasMatch(text[0]);
  }

  void clearData() {
    notesList = [];
    notifyListeners();
  }

  addNoteFun() async {
    if (noteTitle.text.trim().isEmpty || noteDetils.text.trim().isEmpty) {
      return;
    }

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("Notes")
        .add({
          "NoteTitle": noteTitle.text,
          "NoteDetils": noteDetils.text,
          "Createby": FieldValue.serverTimestamp(),
          "Date": Timestamp.fromDate(datePick),
          "BackgroundColor": (activeColor ?? Colors.blueGrey[400])?.toARGB32(),
        });

    notifyListeners();
  }

  readNoteFun() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("Notes")
        .orderBy("Createby", descending: false)
        .snapshots()
        .listen(
          (data) {
            notesList = data.docs;
            notifyListeners();
          },
          onError: (error) {
            print("Error Is $error ");
          },
        );
    notifyListeners();
  }

  deleteNoteFun(id) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("Notes")
        .doc(id)
        .delete();
    notifyListeners();
  }

  updateNoteFun(id, data) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("Notes")
        .doc(id)
        .update(data);
    notifyListeners();
  }
}
