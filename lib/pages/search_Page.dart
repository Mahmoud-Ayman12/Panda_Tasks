import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_firebase/provMoadel/StateProv.dart';

class SearchPage extends SearchDelegate {
  SearchPage()
    : super(
        searchFieldLabel: "Search Tasks",
        searchFieldStyle: TextStyle(color: Colors.white, fontSize: 15),
      );

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: theme.appBarTheme.copyWith(
        backgroundColor: Colors.blueGrey[700],
        foregroundColor: Colors.blueGrey[300],
      ),
      inputDecorationTheme: theme.inputDecorationTheme.copyWith(
        hintStyle: const TextStyle(color: Colors.white54, fontSize: 16),
        border: OutlineInputBorder(borderSide: BorderSide.none),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.blueGrey[300],
        selectionColor: Colors.blueGrey[300],
        selectionHandleColor: Colors.white,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        color: Colors.green,
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.cancel_sharp, color: Colors.blueGrey[200]),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back_rounded, color: Colors.blueGrey[200]),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text("data");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
      body: Consumer<Stateprov>(
        builder: (BuildContext context, Stateprov value, Widget? child) {
          final unCheckedFilter = value.unCheckedList
              .where((e) => e["Task"].toString().contains(query))
              .toList();
          final checkedFilter = value.checkList
              .where((e) => e["Task"].toString().contains(query))
              .toList();
          if (query.isEmpty) {
            return Container(
              width: double.infinity,
              height: 40,
              margin: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
              decoration: BoxDecoration(
                color: Colors.blueGrey[700],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  "Search For Tasks",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (value.unCheckedList.isNotEmpty)
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(
                        vertical: 5,
                        horizontal: 15,
                      ),
                      child: Text(
                        "Tasks",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                        textDirection: TextDirection.ltr,
                      ),
                    ),
                  Container(
                    margin: EdgeInsets.only(
                      left: 15,
                      right: 15,
                      top: 0,
                      bottom: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[700],
                      borderRadius: BorderRadius.circular(15),
                    ),

                    child: value.unCheckedList.isEmpty
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
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: unCheckedFilter.length,
                            itemBuilder: (context, index) {
                              final unCheckedList = unCheckedFilter[index];
                              final isArabic = value.isArapicText(
                                unCheckedList["Task"],
                              );
                              return ListTile(
                                title: Text(
                                  unCheckedList["Task"],
                                  style: TextStyle(color: Colors.white),
                                  textAlign: isArabic
                                      ? TextAlign.right
                                      : TextAlign.left,
                                  textDirection: isArabic
                                      ? TextDirection.rtl
                                      : TextDirection.ltr,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      value.dateInList(unCheckedList['date']),
                                      style: TextStyle(color: Colors.white),
                                    ),

                                    Text(
                                      '${unCheckedList['Porirty']}',
                                      style: TextStyle(
                                        color:
                                            unCheckedList["Porirty"] ==
                                                "No Porirty"
                                            ? Colors.grey
                                            : unCheckedList["Porirty"] == "Low"
                                            ? Colors.blue
                                            : unCheckedList["Porirty"] ==
                                                  "Medium"
                                            ? Colors.amber
                                            : unCheckedList["Porirty"] ==
                                                  "Height"
                                            ? Colors.red
                                            : Colors.transparent,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Checkbox(
                                  value: unCheckedList['IsChecked'] == true,
                                  side: BorderSide(
                                    color:
                                        unCheckedList["Porirty"] == "No Porirty"
                                        ? Colors.grey
                                        : unCheckedList["Porirty"] == "Low"
                                        ? Colors.blue
                                        : unCheckedList["Porirty"] == "Medium"
                                        ? Colors.amber
                                        : unCheckedList["Porirty"] == "Height"
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
                                    value.updateTask(unCheckedList.id, {
                                      'IsChecked': checked ?? false,
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                  ),

                  if (value.checkList.isNotEmpty)
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(
                        vertical: 5,
                        horizontal: 15,
                      ),
                      child: Text(
                        "Checked",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                        textDirection: TextDirection.ltr,
                      ),
                    ),
                  Container(
                    margin: EdgeInsets.only(
                      left: 15,
                      right: 15,
                      top: 0,
                      bottom: 15,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(15),
                    ),

                    child: value.checkList.isEmpty
                        ? Center(
                            child: Text(
                              "No Checked Tasks",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: checkedFilter.length,
                            itemBuilder: (context, index) {
                              final filterChecked = checkedFilter[index];
                              final isArabic = value.isArapicText(
                                filterChecked["Task"],
                              );
                              return ListTile(
                                title: Text(
                                  filterChecked["Task"],
                                  style: TextStyle(color: Colors.white),
                                  textAlign: isArabic
                                      ? TextAlign.right
                                      : TextAlign.left,
                                  textDirection: isArabic
                                      ? TextDirection.rtl
                                      : TextDirection.ltr,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      value.dateInList(filterChecked['date']),
                                      style: TextStyle(color: Colors.white),
                                    ),

                                    Text(
                                      '${filterChecked['Porirty']}',
                                      style: TextStyle(
                                        color:
                                            filterChecked["Porirty"] ==
                                                "No Porirty"
                                            ? Colors.grey
                                            : filterChecked["Porirty"] == "Low"
                                            ? Colors.blue
                                            : filterChecked["Porirty"] ==
                                                  "Medium"
                                            ? Colors.amber
                                            : filterChecked["Porirty"] ==
                                                  "Height"
                                            ? Colors.red
                                            : Colors.transparent,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Checkbox(
                                  value: filterChecked['IsChecked'] == true,
                                  side: BorderSide(
                                    color: Colors.grey,
                                    width: 2,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.circular(
                                      5,
                                    ),
                                  ),
                                  activeColor: Colors.grey[200],
                                  checkColor: Colors.grey[700],
                                  onChanged: (checked) {
                                    value.updateTask(filterChecked.id, {
                                      'IsChecked': checked ?? false,
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
