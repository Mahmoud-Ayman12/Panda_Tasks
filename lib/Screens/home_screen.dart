import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_firebase/Widgets/addTaskFeid2_widget.dart';
import 'package:testing_firebase/Widgets/addTaskFeild_widget.dart';
import 'package:testing_firebase/pages/Notes%20pages/createNotes.dart';
import 'package:testing_firebase/pages/search_Page.dart';
import 'package:testing_firebase/provMoadel/StateProv.dart';
import 'package:testing_firebase/provMoadel/noteProv.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const homerout = "homeBage";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Stateprov>(
      builder: (context, value, child) {
        floatActionFun() {
          switch (value.activScreen) {
            case 0:
              showModalBottomSheet(
                backgroundColor: Colors.blueGrey,
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return AddtaskfeildWidget();
                },
              );
              break;
            case 1:
              showModalBottomSheet(
                backgroundColor: Colors.blueGrey,
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return AddtaskfeildWidget2();
                },
              );
              break;
            case 2:
              Navigator.of(context).pushNamed(Createnotes.CreatenotesRoute);
              break;
            case 3:
              break;
            default:
          }
        }

        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: value.activScreen == 0
              ? Colors.blueGrey[100]
              : value.activScreen == 1
              ? Colors.blueGrey[100]
              : value.activScreen == 2
              ? Colors.blueGrey[200]
              : Colors.white,

          bottomNavigationBar: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: BottomAppBar(
              color: Colors.blueGrey,
              shape: CircularNotchedRectangle(),
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      value.bottomNaviFun(0);
                    },
                    icon: Icon(
                      Icons.list_rounded,
                      color: value.activScreen == 0
                          ? Colors.white
                          : Colors.blueGrey[300],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      value.bottomNaviFun(1);
                    },
                    icon: Icon(
                      Icons.date_range,
                      color: value.activScreen == 1
                          ? Colors.white
                          : Colors.blueGrey[300],
                    ),
                  ),
                  SizedBox(width: 45),
                  IconButton(
                    onPressed: () {
                      value.bottomNaviFun(2);
                    },
                    icon: Icon(
                      Icons.folder_special,
                      color: value.activScreen == 2
                          ? Colors.white
                          : Colors.blueGrey[300],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showSearch(context: context, delegate: SearchPage());
                    },
                    icon: Icon(Icons.search, color: Colors.blueGrey[300]),
                  ),
                ],
              ),
            ),
          ),

          floatingActionButton: FloatingActionButton(
            onPressed: () {
              floatActionFun();
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            backgroundColor: Colors.blueGrey,
            elevation: 20,
            child: Icon(
              value.activScreen == 0
                  ? Icons.add
                  : value.activScreen == 1
                  ? Icons.add
                  : value.activScreen == 2
                  ? Icons.create_new_folder
                  : Icons.search,
              color: Colors.white,
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: value.screens[value.activScreen],
        );
      },
    );
  }
}
