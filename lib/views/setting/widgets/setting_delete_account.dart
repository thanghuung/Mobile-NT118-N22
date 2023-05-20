import 'package:flutter/material.dart';

class SettingDeleteAccount extends StatelessWidget {
  const SettingDeleteAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: Transform.translate(
          offset: const Offset(-8, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                  onPressed: () {},
                  child: const SizedBox(
                    width: double.infinity,
                    child: Text(
                      "Xóa tài khoản",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w500),
                    ),
                  )),
              const SizedBox(
                height: 2,
              ),
              Transform.translate(
                offset: const Offset(8, 0),
                child: const Text(
                  'Tài khoản của bạn sẽ bị xóa vĩnh viễn. Tất cả dữ liệu sẽ biến mất và bạn không thể lấy lại.',
                  style: TextStyle(fontSize: 11),
                ),
              )
            ],
          )),
    );
  }
}
