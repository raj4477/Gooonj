import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gooonj_admin/http_functions.dart';
import 'package:gooonj_admin/screens/home_screen.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
      const Duration(seconds: 4),
          () async {
        final userResponse = await httpFunGet('/users');
        final userMap = jsonDecode(utf8.decode(userResponse.bodyBytes));
        final machineResponse = await httpFunGet('/machines');
        final machineMap = jsonDecode(utf8.decode(machineResponse.bodyBytes));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(users: userMap['users'], machines: machineMap['machines']),
          ),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Lottie.asset('assets/lottie/Gooonj Splash Animation.json', repeat: false,
              fit: BoxFit.fill),
        ),
      ),
    );
  }
}
