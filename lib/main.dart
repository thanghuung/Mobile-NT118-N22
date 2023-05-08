import 'package:app/constants/routes.dart';
import 'package:app/views/login_view.dart';
import 'package:app/views/home_view.dart';
import 'package:app/views/notes_view.dart';
import 'package:app/views/register_view.dart';
import 'package:app/views/verify_email_view.dart';
import 'package:app/views/welcome.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NoteView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        welcomeRoute: (context) => const Welcome(),
      },
    ),
  );
}
