import 'package:app/AppColors.dart';
import 'package:app/views/setting/widgets/setting_color.dart';
import 'package:app/views/setting/widgets/setting_delete_account.dart';
import 'package:app/views/setting/widgets/setting_name.dart';
import 'package:app/views/setting/widgets/setting_password.dart';
import 'package:flutter/material.dart';

import '../../constants/routes.dart';
import '../../services/auth/auth_service.dart';
import 'widgets/setting_avata.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16,
              ),
              Text(
                "Tài khoản",
                style: AppFontText.title.copyWith(color: AppColors.pink),
              ),
              const SettingAvatar(),
              const Divider(
                height: 1,
              ),
              const SettingName(),
              const SettingPassword(),
              const Divider(
                height: 1,
              ),
              _buildButtonExit(context),
              const SettingDeleteAccount(),
              const SettingColor()
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_sharp,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      titleSpacing: 0,
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 3,
      title: const Text(
        "Tài khoản và ứng dụng",
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildButtonExit(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Transform.translate(
        offset: const Offset(-8, 0),
        child: TextButton(
            onPressed: () async {
              final shouldLogout = await showLogOutDialog(context);
              if (shouldLogout) {
                await AuthService.firebase().logOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (_) => false,
                );
              }
            },
            child: const SizedBox(
              width: double.infinity,
              child: Text(
                "Đăng xuất",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.w500),
              ),
            )),
      ),
    );
  }

  Future<bool> showLogOutDialog(BuildContext context) {
    return showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Sign out'),
            content: const Text('Are you sure want to sign out?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Logout'),
              ),
            ],
          );
        }).then((value) => value ?? false);
  }
}
