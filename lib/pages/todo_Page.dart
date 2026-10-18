import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:testing_firebase/Screens/login_screen.dart';
import 'package:testing_firebase/Widgets/taskList.widget.dart';
import 'package:testing_firebase/provMoadel/StateProv.dart';
import 'package:testing_firebase/provMoadel/noteProv.dart';

class TaskToday extends StatelessWidget {
  const TaskToday({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Stateprov>(
      builder: (BuildContext context, value, child) {
        final taskToday = value.taskforDay(value.listTask, DateTime.now());
        double linearProgress = taskToday.isEmpty
            ? 0.0
            : value.getTasksWasChecked() / taskToday.length;
        return Scaffold(
          backgroundColor: Colors.blueGrey[100],

          body: CustomScrollView(
            slivers: [
              SliverAppBar(
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
                    icon: Icon(Icons.logout_rounded),
                  ),
                ],
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final bool isExpanded =
                        constraints.biggest.height > kToolbarHeight + 50;
                    return FlexibleSpaceBar(
                      title: AnimatedOpacity(
                        opacity: isExpanded == true ? 0.0 : 1,
                        duration: Duration(milliseconds: 100),
                        child: Text(
                          "Today Task",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      centerTitle: true,
                      background: Padding(
                        padding: EdgeInsetsGeometry.symmetric(
                          horizontal: 30,
                          vertical: 30,
                        ),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0, end: linearProgress),
                            duration: Duration(milliseconds: 600),
                            curve: Curves.easeOut,
                            builder: (BuildContext context, values, Widget? child) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Today",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "${value.dateNow.day} ${value.months[value.dateNow.month - 1]} ${value.date.year}",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "${value.taskforDay(value.listTask, DateTime.now()).length} Tasks ",
                                    style: TextStyle(color: Colors.white),
                                  ),

                                  SizedBox(height: 20),
                                  Text(
                                    "${(values * 100).toInt()}%",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  LinearProgressIndicator(
                                    minHeight: 8,
                                    value: values,
                                    color: Colors.white,
                                    backgroundColor: Colors.blueGrey[300],
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
                expandedHeight: 200,
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.white,
                pinned: true,
                floating: true,
                centerTitle: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
              ),

              SliverFillRemaining(child: TaskListWidgets()),
            ],
          ),
        );
      },
    );
  }
}
