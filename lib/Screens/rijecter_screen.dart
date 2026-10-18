import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_firebase/Screens/login_screen.dart';
import 'package:testing_firebase/Widgets/Bottom_widget.dart';
import 'package:testing_firebase/Widgets/TextFeild_widget.dart';
import 'package:testing_firebase/provMoadel/StateProv.dart';

class RejicterScreen extends StatefulWidget {
  RejicterScreen({super.key});
  static const RejicterRout = 'RejicterBage';

  @override
  State<RejicterScreen> createState() => _RejicterScreenState();
}

class _RejicterScreenState extends State<RejicterScreen> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Stateprov>(
      builder: (context, value, child) {
        final isload = value.isLoad;
        return Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
          floatingActionButton: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            width: 50,
            height: 65,
            child: FloatingActionButton(
              elevation: .2,
              backgroundColor: Colors.grey[100],
              onPressed: () => Navigator.pop(context),
              child: Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            ),
          ),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.asset(
                          "images/panda.png",
                          width: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        "Rejister",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Enter your personal information",
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Username",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      TextFieldWidgets(
                        keyboardType: TextInputType.emailAddress,
                        hint: 'Enter your name',
                        obscureText: false,

                        icon: null,
                        controller: usernameController,
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      TextFieldWidgets(
                        keyboardType: TextInputType.emailAddress,
                        hint: 'Enter your email',
                        obscureText: false,
                        icon: null,
                        controller: emailController,
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFieldWidgets(
                        keyboardType: TextInputType.multiline,
                        hint: 'Enter your password',
                        obscureText: value.changeIcon ? true : false,

                        icon: IconButton(
                          onPressed: () => value.changeIconFun(),
                          icon: Icon(
                            value.changeIcon
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                        controller: passwordController,
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Comfirm password",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFieldWidgets(
                        keyboardType: TextInputType.multiline,
                        hint: 'Enter Comfirm password',
                        obscureText: value.changeIcon2 ? true : false,

                        icon: IconButton(
                          onPressed: () => value.changeIconFun2(),
                          icon: Icon(
                            value.changeIcon2
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                        controller: confirmPasswordController,
                      ),
                      SizedBox(height: 20),
                      isload == true
                          ? Center(
                              child: CircularProgressIndicator(
                                color: Colors.blueGrey,
                              ),
                            )
                          : BottomWidget(
                              text: 'Rejister',
                              click: () async {
                                final messenger = ScaffoldMessenger.of(context);
                                final navigator = Navigator.of(context);

                                if (passwordController.text !=
                                    confirmPasswordController.text) {
                                  messenger.showSnackBar(
                                    const SnackBar(
                                      content: Text("Password Don't Matching"),
                                    ),
                                  );
                                  return;
                                }

                                value.loadval(true);
                                try {
                                  value.setUserName(
                                    usernameController.text.trim(),
                                  );
                                  await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                        email: emailController.text.trim(),
                                        password: passwordController.text
                                            .trim(),
                                      );
                                  await FirebaseAuth.instance.currentUser
                                      ?.sendEmailVerification();
                                  navigator.pushReplacementNamed(
                                    SingInScreen.singInRout,
                                  );
                                } on FirebaseAuthException catch (e) {
                                  final msg = e.code == 'weak-password'
                                      ? "password provided is too weak."
                                      : e.code == 'email-already-in-use'
                                      ? "The account already exists for that email."
                                      : (e.message ?? "Something went wrong.");
                                  messenger.showSnackBar(
                                    SnackBar(content: Text(msg)),
                                  );
                                } catch (e) {
                                  messenger.showSnackBar(
                                    SnackBar(
                                      content: Text(e.toString()),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                } finally {
                                  value.loadval(false);
                                }
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
