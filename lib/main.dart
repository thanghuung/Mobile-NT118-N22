import 'package:app/firebase_options.dart';
import 'package:app/route_manager/route_manager.dart';
import 'package:app/services/auth/firebase_auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseAuthProvider authClass = FirebaseAuthProvider();
  String currentPage = "";

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await checkLogin();
    });
    super.initState();
    // authClass.signOut();
  }

  Future<void>  checkLogin() async {

    if (FirebaseAuth.instance.currentUser?.uid != null){
      setState(() {
        currentPage = RouteManager.homeRoute;
      });
    }else{
      setState(() {
        currentPage = RouteManager.welcomeRoute;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return MaterialApp(
          builder: EasyLoading.init(),
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: "Inter",
          ),
          onGenerateRoute: RouteManager.onGenerateRoute,
          initialRoute: RouteManager.welcomeRoute,
        );
      }
    );
  }
}
