import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_firebase/provMoadel/StateProv.dart';

class TextfeildupdateWidget extends StatelessWidget {
  const TextfeildupdateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Stateprov>(
      builder: (BuildContext context, value, child) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.only(top: 20),
                child: TextField(
                  textDirection: value.isArapicText(value.textTask.text)
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  minLines: 1,
                  maxLines: 8,
                  controller: value.textTask,
                  onChanged: (val) {
                    value.changeTaskText(val);
                  },
                  autofocus: true,
                  decoration: InputDecoration(
                    filled: true,
                    hint: Text(
                      "Update Task",
                      style: TextStyle(color: Colors.blueGrey[100]),
                    ),
                    fillColor: Colors.blueGrey[300],
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
            ],
          ),
        );
      },
    );
  }
}
