import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_firebase/Screens/home_screen.dart';
import 'package:testing_firebase/Screens/rijecter_screen.dart';
import 'package:testing_firebase/Widgets/Bottom_widget.dart';
import 'package:testing_firebase/Widgets/TextFeild_widget.dart';
import 'package:testing_firebase/Widgets/imageSingin_widget.dart';
import 'package:testing_firebase/provMoadel/StateProv.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SingInScreen extends StatefulWidget {
  SingInScreen({super.key});
  static const singInRout = "singInPage";

  @override
  State<SingInScreen> createState() => _SingInScreenState();
}

class _SingInScreenState extends State<SingInScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  Future<UserCredential?> singInWithGoogel() async {
    try {
      final googleUser = await GoogleSignIn.instance.authenticate();
      final googleAuth = googleUser.authentication;
      final createAccont = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(createAccont);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Stateprov>(
      builder: (context, value, child) {
        bool isload = value.isLoad;

        return Scaffold(
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
                        "Login",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Login to continue using the app",
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 10),
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
                        "password",
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
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 5,
                        ),
                        width: double.infinity,
                        child: Container(
                          margin: EdgeInsets.only(left: 165),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15),
                            onTap: () async {
                              final scaffold = ScaffoldMessenger.of(context);
                              if (emailController.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Please Input Your Email!"),
                                  ),
                                );
                              } else {
                                try {
                                  await FirebaseAuth.instance
                                      .sendPasswordResetEmail(
                                        email: emailController.text,
                                      );
                                  scaffold.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "If this email is registered, you will receive a password reset email.",
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  scaffold.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "check the email address is correct? ",
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                            child: Text(
                              "forgot password?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ),
                      ),
                      isload == true
                          ? Container(
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.blueGrey,
                                ),
                              ),
                            )
                          : BottomWidget(
                              text: 'Login',
                              click: () async {
                                final masseger = ScaffoldMessenger.of(context);
                                final navigator = Navigator.of(context);
                                value.loadval(true);
                                try {
                                  final userSing = await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                        email: emailController.text.trim(),
                                        password: passwordController.text
                                            .trim(),
                                      );
                                  final user = userSing.user;
                                  user?.reload();
                                  if (!context.mounted) return;
                                  if (user != null &&
                                      user.emailVerified == true) {
                                    navigator.pushReplacementNamed(
                                      HomeScreen.homerout,
                                    );
                                  } else {
                                    masseger.showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Please verify your email!",
                                        ),
                                      ),
                                    );
                                    value.loadval(false);
                                  }
                                  value.loadval(false);
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found' ||
                                      e.code == 'wrong-password' ||
                                      e.code == 'invalid-credential') {
                                    masseger.showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "email or password is not valid!",
                                        ),
                                      ),
                                    );
                                    value.loadval(false);
                                  } else if (e.code == 'invalid-email') {
                                    masseger.showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Youser email is not found.",
                                        ),
                                      ),
                                    );
                                    value.loadval(false);
                                  } else if (e.code == 'channel-error') {
                                    masseger.showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Please input your email and password!",
                                        ),
                                      ),
                                    );
                                    value.loadval(false);
                                  }
                                } catch (e) {
                                  masseger.showSnackBar(
                                    SnackBar(content: Text(e.toString())),
                                  );
                                  value.loadval(false);
                                }
                              },
                            ),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        child: Text(
                          "Or Login With",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: () async {
                              final navigator = Navigator.of(context);
                              final scaffold = ScaffoldMessenger.of(context);
                              final singIn = await singInWithGoogel();
                              if (singIn != null) {
                                navigator.pushReplacementNamed(
                                  HomeScreen.homerout,
                                );
                              } else {
                                scaffold.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "There is error please check your Email google?",
                                    ),
                                  ),
                                );
                              }
                            },
                            child: ImageSinginWidget(url: "images/google.png"),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an accon't?"),
                          SizedBox(width: 5),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                RejicterScreen.RejicterRout,
                              );
                            },
                            child: Text(
                              "Rejecter",
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
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
