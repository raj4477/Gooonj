import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gooonj_app/Screens/enter_pin_screen.dart';
import 'package:gooonj_app/Screens/scanner_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController gooonjID = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    gooonjID.addListener(() {
      if (gooonjID.text.length == 8) {
        String id=gooonjID.text;
        gooonjID.clear();
        Timer(Duration(milliseconds: 30), () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EnterPinScreen(gooonjID: id,),
            ),
          );
        });
      }
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: size.height,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: size.height * .06,
                ),
                Hero(
                    tag: "login",
                    child: SvgPicture.asset('assets/svg/loginpagegirl.svg')),
                SizedBox(
                  height: size.height * .02,
                ),
                Text(
                  'Login To Gooonj',
                  style: TextStyle(
                    fontFamily: "Outfit-Bold",
                    fontSize: size.width * .07,
                  ),
                ),
                SizedBox(
                  height: size.height * .04,
                ),
                TextField(
                  controller: gooonjID,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      prefixIcon: Image.asset(
                        'assets/png/co_present.png',
                        height: size.width * .02,
                        width: size.width * .02,
                      ),
                      hintText: 'Gooonj ID',
                      hintStyle: TextStyle(
                          fontFamily: "Outfit-Regular",
                          fontSize: size.width * .05,
                          color: Colors.grey),
                      filled: true,
                      border: InputBorder.none,
                      fillColor: Color(0xffF7F7F7),),
                ),
                SizedBox(
                  height: size.height * .04,
                ),
                SvgPicture.asset('assets/svg/or.svg'),
                SizedBox(
                  height: size.height * .025,
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ScannerScreen(),),);
                  },
                  icon: Icon(
                    Icons.qr_code_scanner_outlined,
                    color: Colors.black,
                  ),
                  label: Text(
                    'Scan Gooonj QR',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontFamily: 'Outfit-Regular',
                      color: Colors.black,
                      fontSize: size.width * .05,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
