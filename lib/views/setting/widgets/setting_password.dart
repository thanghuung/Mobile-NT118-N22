import 'package:flutter/material.dart';

class SettingPassword extends StatelessWidget {
  const SettingPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Transform.translate(
        offset: const Offset(-8,0),
        child: TextButton(
            onPressed: () {

            },
            child: const SizedBox(
              width: double.infinity,
              child: Text(
                "Mật khẩu",
                style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w500),
              ),
            )),
      ),
    );
  }
}
