import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:testing_firebase/Screens/login_screen.dart';
import 'package:testing_firebase/pages/Notes%20pages/updateNotes.dart';
import 'package:testing_firebase/provMoadel/StateProv.dart';
import 'package:testing_firebase/provMoadel/noteProv.dart';

class FoldersPage extends StatelessWidget {
  const FoldersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final value = context.watch<NoteProv>();
    final val = context.read<Stateprov>();
    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
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
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          ),
        ),
        elevation: 5,
        shadowColor: Colors.black,
        title: Text(
          "Notes",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: MasonryGridView.count(
          crossAxisCount: 1,
          itemCount: value.notesList.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            final date = value.notesList[index]["Date"];
            final backGround = Color(value.notesList[index]["BackgroundColor"]);
            final textColor = value.getTextColor(backGround);
            final isArabicTitle = value.isArapic(
              value.notesList[index]["NoteTitle"],
            );
            final isArabicDetials = value.isArapic(
              value.notesList[index]["NoteDetils"],
            );

            return InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                value.noteTitle.text = value.notesList[index]["NoteTitle"];
                value.noteDetils.text = value.notesList[index]["NoteDetils"];
                value.activeColor = backGround;

                value.datePick = date.toDate();

                Navigator.pushNamed(
                  context,
                  Updatenotes.updateNotesRoute,
                  arguments: value.notesList[index].id,
                );
              },
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 250),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: backGround,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 1,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: isArabicTitle
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Text(
                                value.notesList[index]["NoteTitle"],
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 18,
                                ),
                                textDirection: isArabicTitle
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,

                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Align(
                              alignment: isArabicTitle
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Text(
                                value.dateInList(date),
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Flexible(
                        child: Text(
                          value.notesList[index]["NoteDetils"],
                          style: TextStyle(
                            color: textColor,
                            overflow: TextOverflow.clip,
                          ),
                          textDirection: isArabicDetials
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          textAlign: isArabicDetials
                              ? TextAlign.right
                              : TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
