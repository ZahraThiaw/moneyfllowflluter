import 'package:flutter/material.dart';
import 'package:moneyflow/pages/home/home.page.dart';
import 'package:moneyflow/pages/login/login.page.dart';
import 'package:moneyflow/pages/signup/signup.page.dart';


class AppRoutes {
  static const String loginRoute = '/login';
  static const String signupRoute = '/signup';
  static const String homeRoute = '/home';

  static Map<String, Widget Function(BuildContext)> get routes => {
        loginRoute: (_) => const LoginPage(),
        signupRoute: (_) => const SignupPage(),
        homeRoute: (_) => const HomePage(),
      };
}