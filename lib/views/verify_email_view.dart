import 'package:app/constants/routes.dart';
import 'package:app/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app/AppColors.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 50),
            child: RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 24.0),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Todo',
                    style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppColors.pink),
                  ),
                  TextSpan(
                    text: 'os',
                    style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppColors.purple),
                  ),
                ],
              ),
            ),
          ),
          Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: const Center(
                child: Text(
                  'Xác thực tài khoản',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              )),
          Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 32),
              child: const Center(
                child: Text(
                    "Chúng tôi đã gửi cho bạn một email để xác thực tài khoản. Vui lòng kiểm tra để xác thực nhé! Nhấn vào nút bên dưới để gửi lại xác thực."),
              )),
          Container(
            padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
            child: TextButton(
              onPressed: () async {
                await AuthService.firebase().sendEmailVerification();
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor:
                    MaterialStateProperty.all<Color>(AppColors.pink),
                minimumSize: MaterialStateProperty.all<Size>(
                    const Size(double.infinity, 60)),
              ),
              child:
                  const Text('Gửi lại Email', style: TextStyle(fontSize: 18)),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
            child: TextButton(
              onPressed: () async {
                await AuthService.firebase().logOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                  (route) => false,
                );
              },
              child: const Text('Quay lại'),
            ),
          )
        ],
      ),
    );
  }
}
