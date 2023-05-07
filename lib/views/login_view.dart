import 'package:app/common.dart';
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
  bool _obscureText = true;
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
      body: SafeArea(
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
                          'Đăng nhập bằng Email',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      )),
                  Container(
                    padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Email',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: TextFormField(
                            controller: _email,
                            enableSuggestions: false,
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email không được để trống!';
                              } else if (!isValidEmail(value)) {
                                return 'Email không đúng định dạng!';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Nhập email',
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mật khẩu',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: TextFormField(
                            controller: _password,
                            obscureText: _obscureText,
                            enableSuggestions: false,
                            autocorrect: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Mật khẩu không được để trống';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Nhập mật khẩu',
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: IconButton(
                                hoverColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                icon: Icon(_obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
                          if (user?.isEmailVerified ?? false) {
                            // user's email is verified
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              notesRoute,
                              (route) => false,
                            );
                          } else {
                            //user's email is not verified
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              verifyEmailRoute,
                              (route) => false,
                            );
                          }
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
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Đăng ký ngay',
                              style: TextStyle(
                                color: AppColors.pinkTertiary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ))),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(15.0),
        child: const Text(
          'Developed by Todoos - 2023',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12.0, color: Colors.black),
        ),
      ),
    );
  }
}
