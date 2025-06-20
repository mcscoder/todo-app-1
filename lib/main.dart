import 'package:flutter/material.dart';
import 'package:todo_app_1/screens/home_screen.dart';
import 'package:todo_app_1/utils/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My Tasks App",
      // debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        scaffoldBackgroundColor: AppColors.backgroundColor,
        fontFamily: "Poppins",
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.cardColor,
          elevation: 0,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
