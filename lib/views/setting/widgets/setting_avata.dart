import 'package:flutter/material.dart';

import '../../../AppColors.dart';

class SettingAvatar extends StatelessWidget {
  const SettingAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Chọn ảnh đại diện",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                'ảnh sẽ được hiển thị khi bạn dùng không gian làm việc',
                style: TextStyle(fontSize: 11),
              )
            ],
          ),
          Container(
            alignment: Alignment.center,
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
                color: AppColors.pink, borderRadius: BorderRadius.all(Radius.circular(30))),
            child: const Text(
              "T",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
