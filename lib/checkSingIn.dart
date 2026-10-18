import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_firebase/Screens/home_screen.dart';
import 'package:testing_firebase/Screens/login_screen.dart';
import 'package:testing_firebase/provMoadel/StateProv.dart';
import 'package:testing_firebase/provMoadel/noteProv.dart';

class Checksingin extends StatelessWidget {
  const Checksingin({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            FirebaseAuth.instance.currentUser!.emailVerified) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            (context).read<Stateprov>().readTaskFun();
            (context).read<NoteProv>().readNoteFun();
          });
          return HomeScreen();
        } else {
          return SingInScreen();
        }
      },
    );
  }
}
