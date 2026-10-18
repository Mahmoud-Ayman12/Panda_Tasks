import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_firebase/provMoadel/StateProv.dart';

class TextfeildupdateontapWidget extends StatelessWidget {
  const TextfeildupdateontapWidget({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context) {
    return Consumer<Stateprov>(
      builder: (BuildContext context, value, child) {
        final isArabic = value.isArapicText(value.textTask.text);
        return SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              style: TextStyle(color: Colors.white),
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              textAlign: isArabic ? TextAlign.start : TextAlign.left,
              minLines: 1,
              maxLines: 8,
              controller: value.textTask,
              onChanged: (val) {
                value.changeTaskText(val);
                value.updateTask(id, {"Task": value.textTask.text});
              },
              autofocus: false,
              decoration: InputDecoration(
                filled: false,
                hint: Text(
                  "Update Task",
                  style: TextStyle(color: Colors.blueGrey[100]),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(25),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
