import 'package:flutter/material.dart';

class SettingName extends StatelessWidget {
  const SettingName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Tên hiển thị",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
          ),
          SizedBox(
            height: 2,
          ),
          Text(
            'nguyendinhtrai',
            style: TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }
}
