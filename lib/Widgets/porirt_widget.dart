import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_firebase/provMoadel/StateProv.dart';

class PorirtyWidget extends StatelessWidget {
  const PorirtyWidget({
    super.key,
    required this.heighPorirtyFunc,
    required this.mediumPorirtyFunc,
    required this.lowPorirtyFunc,
    required this.noPorirtyFunc,
  });
  final Function() heighPorirtyFunc;
  final Function() mediumPorirtyFunc;
  final Function() lowPorirtyFunc;
  final Function() noPorirtyFunc;

  @override
  Widget build(BuildContext context) {
    return Consumer<Stateprov>(
      builder: (BuildContext context, Stateprov value, Widget? child) {
        return Column(
          children: [
            Container(
              height: 50,
              color: Colors.blueGrey[700],
              child: MaterialButton(
                onPressed: () {
                  heighPorirtyFunc();
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Icon(Icons.flag, color: Colors.red),
                    SizedBox(width: 5),
                    Text("Height Porirty", style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ),
            Container(
              height: 50,
              color: Colors.blueGrey[700],
              child: MaterialButton(
                onPressed: () {
                  mediumPorirtyFunc();
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Icon(Icons.flag, color: Colors.yellowAccent),
                    SizedBox(width: 5),
                    Text(
                      "Medium Porirty",
                      style: TextStyle(color: Colors.yellow),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 50,
              color: Colors.blueGrey[700],
              child: MaterialButton(
                onPressed: () {
                  lowPorirtyFunc();
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Icon(Icons.flag, color: Colors.blueAccent),
                    SizedBox(width: 5),
                    Text("Low Porirty", style: TextStyle(color: Colors.blue)),
                  ],
                ),
              ),
            ),
            Container(
              height: 50,
              color: Colors.blueGrey[700],
              child: MaterialButton(
                onPressed: () {
                  noPorirtyFunc();
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Icon(Icons.flag, color: Colors.grey),
                    SizedBox(width: 5),
                    Text("No Porirty", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
