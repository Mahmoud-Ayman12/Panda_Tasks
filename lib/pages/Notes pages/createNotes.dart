import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_firebase/provMoadel/noteProv.dart';

class Createnotes extends StatefulWidget {
  const Createnotes({super.key});
  static const CreatenotesRoute = "CreateNotesPage";

  @override
  State<Createnotes> createState() => _CreatenotesState();
}

class _CreatenotesState extends State<Createnotes> {
  // late NoteProv _noteCreateprove;

  @override
  void initState() {
    // _noteCreateprove = context.read<NoteProv>();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final value = context.read<NoteProv>();
    final textColor = value.getTextColor(value.activeColor!);
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) => value.clearNoteFun(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: value.activeColor,
        appBar: AppBar(
          backgroundColor: value.activeColor,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              value.datePick = DateTime.now();
              value.noteDetils.clear();
              value.noteTitle.clear();
            },
            icon: Icon(Icons.arrow_back_rounded, color: textColor),
          ),

          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 10,
              ),
              child: InkWell(
                onTap: () async {
                  final pickDate = (await showDatePicker(
                    context: context,
                    firstDate: DateTime(2010),
                    currentDate: value.datePick,
                    lastDate: DateTime(2050),
                  ));
                  if (pickDate != null) {
                    value.datePick = pickDate;
                  }
                },
                child: Text(
                  "${value.datePick.day.toString()}-${value.datePick.month}-${value.datePick.year}",
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Selector<NoteProv, bool>(
              builder: (BuildContext context, bool isEmpty, Widget? child) {
                return InkWell(
                  onTap: () {
                    value.addNoteFun();
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
        body: Column(
          children: [
            TextField(
              controller: value.noteTitle,
              onChanged: (val) {
                value.notifyListeners();
              },
              textDirection: value.isArapic(value.noteTitle.text)
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              textAlign: value.isArapic(value.noteTitle.text)
                  ? TextAlign.right
                  : TextAlign.left,
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
              child: TextField(
                controller: value.noteDetils,
                onChanged: (val) {
                  value.notifyListeners();
                },
                cursorColor: Colors.blueGrey,
                cursorWidth: 2,
                cursorRadius: Radius.circular(10),
                textDirection: value.isArapic(value.noteDetils.text)
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                textAlign: value.isArapic(value.noteDetils.text)
                    ? TextAlign.right
                    : TextAlign.left,

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
