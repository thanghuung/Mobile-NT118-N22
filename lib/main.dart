import 'package:app/constants/routes.dart';
import 'package:app/firebase_options.dart';
import 'package:app/services/auth/firebase_auth_provider.dart';
import 'package:app/views/home_view.dart';
import 'package:app/views/login_view.dart';
import 'package:app/views/register_view.dart';
import 'package:app/views/verify_email_view.dart';
import 'package:app/views/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseAuthProvider authClass = FirebaseAuthProvider();
  Widget currentPage = Welcome();

  @override
  void initState() {
    super.initState();
    // authClass.signOut();
    checkLogin();
  }

  checkLogin() async {
    String? userID = await authClass.getUserIdFromSharedPreferences();
    print(userID);
    if (userID != null)
      setState(() {
        currentPage = HomePage();
      });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Inter",
      ),
      home: currentPage,
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        homeRoute: (context) => const HomePage(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        welcomeRoute: (context) => const Welcome(),
      },
    );
  }
}
