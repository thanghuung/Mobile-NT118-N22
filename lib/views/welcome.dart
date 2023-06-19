import 'package:app/AppColors.dart';
import 'package:app/constants/routes.dart';
import 'package:app/fire_base/auth_controller.dart';
import 'package:app/route_manager/route_manager.dart';
import 'package:app/services/auth/firebase_auth_provider.dart';
import 'package:app/views/register_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      String? userID = await FirebaseAuthProvider().getUserIdFromSharedPreferences();
      if (userID != null) {
        Navigator.pushNamed(context, RouteManager.homeRoute);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 50),
              child: const Center(
                child: Text(
                  'Xin chào!',
                  style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10),
              child: RichText(
                  text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Đăng nhập vào ',
                    style:
                        TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: 'Todo',
                    style:
                        TextStyle(color: AppColors.pink, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: 'os',
                    style: TextStyle(
                        color: AppColors.purple, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              )),
            ),
            const SizedBox(height: 20), // Khoảng cách giữa chữ và hình
            Image.asset(
              'assets/images/login.png', // Đường dẫn đến bức hình
              width: 300, // Chiều rộng của hình
              height: 300, // Chiều cao của hình
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
              child: TextButton.icon(
                onPressed: () async {
                  await AuthController.SignInWithGG();
                },
                icon: const Icon(
                  Icons.login,
                  color: AppColors.orange,
                ),
                label: const Text('Đăng nhập với Google',
                    style: TextStyle(
                      color: AppColors.orange, // Màu chữ
                      fontSize: 18, // Kích thước font
                    )),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all<Color>(AppColors.orangeSecond),
                  minimumSize: MaterialStateProperty.all<Size>(const Size(double.infinity, 60)),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
              child: TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
                },
                icon: const Icon(
                  Icons.email,
                  color: AppColors.pink,
                ),
                label: const Text('Đăng nhập bằng Email',
                    style: TextStyle(
                      color: AppColors.pink, // Màu chữ
                      fontSize: 18, // Kích thước font
                    )),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all<Color>(AppColors.pinkSecond),
                  minimumSize: MaterialStateProperty.all<Size>(const Size(double.infinity, 60)),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(15.0),
          child: const Text(
            'Developed by Todoos - 2023',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.0, color: Colors.black),
          ),
        ));
  }
}
