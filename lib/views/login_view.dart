import 'package:app/common.dart';
import 'package:app/component/FormGroup.dart';
import 'package:app/component/show_error_Dialog.dart';
import 'package:app/constants/routes.dart';
import 'package:app/services/auth/auth_exceptions.dart';
import 'package:app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:app/AppColors.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
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
      body: SingleChildScrollView(
        child: SafeArea(
            child: Form(
                key: _formKey,
                child: Column(
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
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.pink),
                            ),
                            TextSpan(
                              text: 'os',
                              style: TextStyle(
                                  fontSize: 48,
                                  fontFamily: 'Inter',
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
                            'Đăng nhập bằng Email',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        )),
                    FormGroup(
                      padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
                      controller: _email,
                      hintText: "Nhập email",
                      label: "Email",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email không được để trống!';
                        } else if (!isValidEmail(value)) {
                          return 'Email không đúng định dạng!';
                        }
                        return null;
                      },
                      isPassword: false,
                    ),
                    FormGroup(
                      padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
                      controller: _password,
                      hintText: "Nhập mật khẩu",
                      label: "Mật khâu",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Mật khẩu không được để trống!';
                        }
                        return null;
                      },
                      isPassword: true,
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
                      child: TextButton(
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                          } else {
                            return;
                          }
                          try {
                            await AuthService.firebase().logIn(
                              email: email,
                              password: password,
                            );

                            final user = AuthService.firebase().currentUser;
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              homeRoute,
                              (route) => false,
                            );
                            // if (user?.isEmailVerified ?? false) {
                            //   // user's email is verified
                            //   Navigator.of(context).pushNamedAndRemoveUntil(
                            //     notesRoute,
                            //     (route) => false,
                            //   );
                            // } else {
                            //   //user's email is not verified
                            //   Navigator.of(context).pushNamedAndRemoveUntil(
                            //     verifyEmailRoute,
                            //     (route) => false,
                            //   );
                            // }
                          } on UserNotFoundAuthException {
                            // await showErrorDialog(
                            //   context,
                            //   'Không tìm thấy người dùng!',
                            // );
                            showToast('Không tìm thấy người dùng!');
                          } on WrongPasswordAuthException {
                            // await showErrorDialog(
                            //   context,
                            //   'Sai mật khẩu',
                            // );
                            showToast('Sai mật khẩu');
                          } on GenericAuthException {
                            // await showErrorDialog(
                            //   context,
                            //   'Lỗi xác thực',
                            // );
                            showToast('Lỗi xác thực');
                          }
                        },
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(AppColors.pink),
                          minimumSize: MaterialStateProperty.all<Size>(
                              const Size(double.infinity, 60)),
                        ),
                        child: const Text('Đăng nhập',
                            style: TextStyle(fontSize: 18)),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              registerRoute, (route) => false);
                        },
                        child: RichText(
                          text: const TextSpan(
                            text: 'Chưa có tài khoản? ',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontFamily: 'Inter',
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Đăng ký ngay',
                                style: TextStyle(
                                  color: AppColors.pinkTertiary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ))),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(15.0),
        child: const Text(
          'Developed by Todoos - 2023',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.black,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }
}
