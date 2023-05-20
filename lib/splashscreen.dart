// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:barterit2/myconfig.dart';
import 'package:barterit2/views/screens/mainscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'models/user.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkAndLogin();
    //loadPref();
    // Timer(
    //     const Duration(seconds: 3),
    //     () => Navigator.pushReplacement(context,
    //         MaterialPageRoute(builder: (content) =>  MainScreen())));
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/splash.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center, // Add this line
            children: const [
              Text(
        "BARTER IT",
        style: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'Times New Roman',
          shadows: [
            Shadow(
              color: Colors.black,
              offset: Offset(0, 0),
              blurRadius: 3,
            ),
          ],
        ),
      ),
      CircularProgressIndicator(),
      Text(
        "Version 1.0",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'Times New Roman',
          shadows: [
            Shadow(
              color: Colors.black,
              offset: Offset(0, 0),
              blurRadius: 2,
            ),
    ],
  ),
),

            ],
          ),
        ),
      ],
    ),
  );
}

  checkAndLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    bool ischeck = (prefs.getBool('checkbox')) ?? false;
    late User user;
    if (ischeck) {
      try {
        http.post(
            Uri.parse("${MyConfig().SERVER}/mynelayan/php/login_user.php"),
            body: {"email": email, "password": password}).then((response) {
          if (response.statusCode == 200) {
            var jsondata = jsonDecode(response.body);
            if (jsondata.containsKey('data') && jsondata['data'] != null) {
              user = User.fromJson(jsondata['data']);
            } else {
              user = User(
                id: "",
                name: "",
                email: "",
                phone: "",
                datereg: "",
                password: "",
                otp: "",
              );
            }
            Timer(
                const Duration(seconds: 3),
                () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => MainScreen(user: user))));
          }
        }).timeout(const Duration(seconds: 5), onTimeout: () {
        });
      } on TimeoutException catch (_) {
        print("Time out");
      }
    } else {
      user = User(
          id: "",
          name: "",
          email: "",
          phone: "",
          datereg: "",
          password: "",
          otp: "");
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (content) => MainScreen(user: user))));
    }
  }
}