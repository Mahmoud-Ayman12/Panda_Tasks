import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_firebase/provMoadel/noteProv.dart';

class Updatenotes extends StatefulWidget {
  const Updatenotes({super.key});
  static const updateNotesRoute = "updateNotesPage";

  @override
  State<Updatenotes> createState() => _UpdatenotesState();
}

class _UpdatenotesState extends State<Updatenotes> {
  // late NoteProv _noteprove;

  @override
  void initState() {
    // _noteprove = context.read<NoteProv>();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final value = context.read<NoteProv>();
    final idCurrnt = ModalRoute.of(context)!.settings.arguments as String;
    final textColor = value.getTextColor(value.activeColor!);
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        value.clearNoteFun();
      },
      child: Scaffold(
        backgroundColor: value.activeColor,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: value.activeColor,
          leading: IconButton(
            onPressed: () {
              value.datePick = DateTime.now();
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: textColor),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 10,
                  ),
                  child: Consumer<NoteProv>(
                    builder:
                        (BuildContext context, NoteProv val, Widget? child) {
                          return InkWell(
                            onTap: () async {
                              final pickDate = (await showDatePicker(
                                context: context,
                                firstDate: DateTime(2010),

                                currentDate: val.datePick,
                                lastDate: DateTime(2050),
                              ));
                              if (pickDate != null) {
                                val.datePick = pickDate;
                                val.notifyListeners();
                              }
                            },
                            child: Text(
                              val.dateInList(val.datePick),
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    value.deleteNoteFun(idCurrnt);
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.delete, color: textColor),
                ),
                Selector<NoteProv, bool>(
                  builder: (BuildContext context, bool isEmpty, Widget? child) {
                    return InkWell(
                      onTap: () {
                        value.updateNoteFun(idCurrnt, {
                          "NoteTitle": value.noteTitle.text.trim(),
                          "NoteDetils": value.noteDetils.text.trim(),
                          "Date": Timestamp.fromDate(value.datePick),
                          "BackgroundColor": value.activeColor?.toARGB32(),
                        });
                        Navigator.pop(context);
                        value.readNoteFun();
                        value.datePick = DateTime.now();
                      },
                      child: isEmpty
                          ? SizedBox(width: 0, height: 0)
                          : Container(
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              width: 50,
                              height: 30,
                              child: Icon(Icons.send_rounded, color: textColor),
                            ),
                    );
                  },
                  selector: (BuildContext context, NoteProv valu) =>
                      valu.noteTitle.text.trim().isEmpty &&
                      valu.noteDetils.text.trim().isEmpty,
                ),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            TextField(
              controller: value.noteTitle,
              onChanged: (val) {
                value.notifyListeners();
              },
              cursorWidth: 4,
              cursorColor: Colors.blueGrey,
              cursorRadius: Radius.circular(10),
              buildCounter:
                  (
                    context, {
                    required currentLength,
                    required isFocused,
                    required maxLength,
                  }) {
                    return;
                  },
              style: TextStyle(fontSize: 23, color: textColor),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 15,
                ),
                isDense: true,
                border: OutlineInputBorder(borderSide: BorderSide.none),
                counterStyle: TextStyle(color: Colors.transparent),
                hint: Text(
                  "Title",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              maxLength: 50,
            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: SafeArea(
                  minimum: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: TextField(
                    controller: value.noteDetils,
                    onChanged: (val) {
                      value.notifyListeners();
                    },
                    cursorColor: Colors.blueGrey,
                    cursorWidth: 2,
                    cursorRadius: Radius.circular(10),

                    buildCounter:
                        (
                          context, {
                          required currentLength,
                          required isFocused,
                          required maxLength,
                        }) {
                          return;
                        },
                    style: TextStyle(fontSize: 15, color: textColor),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 15,
                      ),

                      isDense: true,
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      counterStyle: TextStyle(color: Colors.transparent),
                      hint: Text(
                        "Write Here Your Notes",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                    maxLines: 50,
                    minLines: 3,
                  ),
                ),
              ),
            ),
            AnimatedPadding(
              padding: EdgeInsetsGeometry.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              duration: Duration(milliseconds: 190),
              curve: Curves.easeOut,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.blueGrey[300],
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.only(
                                topRight: Radius.circular(14),
                                topLeft: Radius.circular(14),
                              ),
                            ),
                            backgroundColor: Colors.grey[800],
                            context: context,
                            builder: (context) {
                              return Container(
                                height: 340,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        15,
                                        7,
                                        15,
                                        0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Colors Background",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: Icon(
                                              Icons.cancel,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 2,
                                      width: 287,
                                      color: const Color(0xFF333333),
                                    ),
                                    SizedBox(height: 10),

                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0,
                                          vertical: 10,
                                        ),
                                        child: GridView.builder(
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                crossAxisSpacing: 10,
                                                childAspectRatio: 1,
                                                mainAxisSpacing: 10,
                                              ),
                                          itemCount:
                                              value.colorsBackground.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                value.activeColor = value
                                                    .colorsBackground[index];
                                                value.notifyListeners();
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: value
                                                      .colorsBackground[index],
                                                  border:
                                                      value.activeColor ==
                                                          value
                                                              .colorsBackground[index]
                                                      ? Border.all(
                                                          width: 2,
                                                          color:
                                                              Colors.limeAccent,
                                                        )
                                                      : Border.all(width: 0),
                                                ),
                                                child:
                                                    value.activeColor ==
                                                        value
                                                            .colorsBackground[index]
                                                    ? Center(
                                                        child: Text(
                                                          "Active",
                                                          style: TextStyle(
                                                            color: Colors
                                                                .limeAccent,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      )
                                                    : SizedBox(),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Padding(
                          padding: EdgeInsetsGeometry.all(8),
                          child: Icon(
                            Icons.color_lens_outlined,
                            color: textColor,
                            size: 35,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
