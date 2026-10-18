import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:testing_firebase/Screens/home_screen.dart';
import 'package:testing_firebase/Screens/login_screen.dart';
import 'package:testing_firebase/Screens/rijecter_screen.dart';
import 'package:testing_firebase/Widgets/taskList.widget.dart';
import 'package:testing_firebase/checkSingIn.dart';
import 'package:testing_firebase/pages/Notes%20pages/createNotes.dart';
import 'package:testing_firebase/pages/Notes%20pages/updateNotes.dart';
import 'package:testing_firebase/provMoadel/StateProv.dart';
import 'package:testing_firebase/provMoadel/noteProv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  if (FirebaseAuth.instance.currentUser != null) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await Hive.openBox("NoteImage$uid");
  }
  await GoogleSignIn.instance.initialize(
    serverClientId:
        '47686845823-0ndc70fv2a6kbfaiv02fm7d80306hbrb.apps.googleusercontent.com',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Stateprov()),
        ChangeNotifierProvider(create: (_) => NoteProv()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        RejicterScreen.RejicterRout: (ctx) => RejicterScreen(),
        HomeScreen.homerout: (ctx) => HomeScreen(),
        SingInScreen.singInRout: (ctx) => SingInScreen(),
        TaskListWidgets.taskRoue: (ctx) => TaskListWidgets(),
        Createnotes.CreatenotesRoute: (ctx) => Createnotes(),
        Updatenotes.updateNotesRoute: (ctx) => Updatenotes(),
      },
      home: Checksingin(),
    );
  }
}
