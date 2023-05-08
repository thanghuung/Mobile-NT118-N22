import 'package:app/constants/routes.dart';
// import 'package:app/services/auth/firebase_auth_provider.dart';
import 'package:app/views/login_view.dart';
// import 'package:app/views/home_view.dart';
import 'package:app/firebase_options.dart';
import 'package:app/views/notes_view.dart';
import 'package:app/views/register_view.dart';
import 'package:app/views/verify_email_view.dart';
import 'package:app/views/welcome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:app/services/auth/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
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
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NoteView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   // FirebaseAuthProvider authClass = FirebaseAuthProvider();
//   // Widget currentPage = Welcome();

//   @override
//   void initState() {
//     super.initState();
//     // authClass.signOut();
//     // checkLogin();
//   }

//   // checkLogin() async {
//   //   String? userID = await authClass.getUserIdFromSharedPreferences();
//   //   print("tokne");
//   //   if (userID != null)
//   //     setState(() {
//   //       currentPage = HomePage();
//   //     });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const HomePage(),
//       routes: {
//         loginRoute: (context) => const LoginView(),
//         registerRoute: (context) => const RegisterView(),
//         notesRoute: (context) => const NoteView(),
//         verifyEmailRoute: (context) => const VerifyEmailView(),
//         welcomeRoute: (context) => const Welcome(),
//       },
//     );
//   }
// }
