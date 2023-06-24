import 'package:app/views/category/category_screen.dart';
import 'package:app/views/countdown/count_down_timer.dart';
import 'package:app/views/detail_groupTask/blocs/detail_group_task_bloc.dart';
import 'package:app/views/detail_groupTask/screens/detail_group_task_setting_screen.dart';
import 'package:app/views/detail_task/screens/detail_task_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../views/category/blocs/category_cubit.dart';
import '../views/detail_groupTask/screens/detail_group_task_screen.dart';
import '../views/detail_task/blocs/detail_task_bloc.dart';
import '../views/detail_task/screens/detail_task_setting.dart';
import '../views/home_view.dart';
import '../views/login_view.dart';
import '../views/register_view.dart';
import '../views/setting/setting_page.dart';
import '../views/verify_email_view.dart';
import '../views/welcome.dart';

class RouteManager {
  static const String loginRoute = '/login/';
  static const String registerRoute = '/register/';
  static const String homeRoute = '/home/';
  static const String verifyEmailRoute = '/verify-email/';
  static const String welcomeRoute = '/welcome/';
  static const String settingPageRoute = "/settingPage";
  static const String categoryScreen = "/categoryScreen";
  static const String detailTaskScreen = "/detailTaskScreen";
  static const String groupTaskScreen = "/detailGroupTaskScreen";
  static const String settingGroupTaskScreen = "/settingGroupTaskScreen";
  static const String time = "/time";
  static const String settingDetailTask = "/settingDetailTask";

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case settingDetailTask:
        return MaterialPageRoute(builder: (_) {
          final string = settings.arguments as String?;
          return DetailTaskSetting(
            categoryID: string??"",
          );
        });
      case loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case settingGroupTaskScreen:
        return MaterialPageRoute(builder: (_) {
          final string = settings.arguments as String?;
          return DetailGroupTaskSettingScreen(
            groupID: string ?? "",
          );
        });
      case welcomeRoute:
        return MaterialPageRoute(builder: (_) => const Welcome());
      case registerRoute:
        return MaterialPageRoute(builder: (_) => const RegisterView());
      case homeRoute:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case verifyEmailRoute:
        return MaterialPageRoute(builder: (_) => const VerifyEmailView());
      case settingPageRoute:
        return MaterialPageRoute(builder: (_) => const SettingPage());
      case categoryScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => CategoryCubit()..getData(),
            child: const CategoryScreen(),
          ),
        );
      case detailTaskScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) {
              final string = settings.arguments as String?;
              return DetailTaskBloc(string)..add(OnGetData());
            },
            child: const DetailTaskScreen(),
          ),
        );
      case groupTaskScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) {
              final string = settings.arguments as String?;
              return DetailGroupTaskBloc(string)..add(OnGetDataGroup());
            },
            child: const DetailGroupTaskScreen(),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(
              title: const Text("Route not found"),
            ),
          ),
        );
    }
  }
}
