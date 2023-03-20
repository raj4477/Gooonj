import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gooonj_app/Screens/bottom_bar_screen.dart';
import 'package:gooonj_app/http_function.dart';
import 'package:gooonj_app/model.dart';
import 'package:gooonj_app/theme.dart';

class EnterPinScreen extends StatefulWidget {
  const EnterPinScreen({Key? key, required this.gooonjID}) : super(key: key);
  final String gooonjID;
  @override
  State<EnterPinScreen> createState() => _EnterPinScreenState();
}

class _EnterPinScreenState extends State<EnterPinScreen> {
  bool isClicked = false;
  TextEditingController pin = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 16, right: 16),
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height - 100,
            child: Column(
              children: [
                Text(
                  'Enter PIN',
                  style: TextStyle(
                      fontFamily: "Outfit-Bold", fontSize: size.width * .07),
                ),
                SizedBox(
                  height: size.height * .03,
                ),
                TextField(
                  controller: pin,
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Colors.grey,
                    ),
                    label: Image.asset('assets/png/vertical_line.png'),
                    filled: true,
                    border: InputBorder.none,
                    fillColor: Color(0xffF7F7F7),
                  ),
                ),
                SizedBox(
                  height: size.height * .03,
                ),
                InkWell(
                  onTap: isClicked ? null : () async {
                    setState(() {
                      isClicked = !isClicked;
                    });
                    final response = await httpFunPost('verifyUser/card', {
                      'gooonjId': '${widget.gooonjID}',
                      'pin': '${pin.text}'
                    });
                    var decodedResponse =
                        jsonDecode(utf8.decode(response.bodyBytes)) as Map;
                    if (response.statusCode == 200) {
                      final userDataRresponser =
                          await httpFunGet('user/${decodedResponse['userId']}');
                      var decodedUserData =
                          jsonDecode(utf8.decode(userDataRresponser.bodyBytes))
                              as Map;
                      final userData = UserData(
                          name: decodedUserData['name'],
                          gooonjId: decodedUserData['gooonjId'],
                          number: decodedUserData['number'],
                          pin: decodedUserData['pin'],
                          address: decodedUserData['address'],
                          id: decodedUserData['_id'],
                          withdraws: decodedUserData['withdraws']);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BottomBarScreen(userData: userData,),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(decodedResponse['message']),
                        backgroundColor: mainRed,
                      ));
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                        top: 16, bottom: 16, left: 48, right: 48),
                    decoration: BoxDecoration(
                        color: floatingAction,
                        borderRadius: BorderRadius.circular(30)),
                    child: isClicked ? CircularProgressIndicator(color: mainRed,) : Text(

                      'Submit',
                      style: TextStyle(
                          fontSize: size.width * .045,
                          fontFamily: "Outfit-Bold",
                          color: Colors.white),
                    ),
                  ),
                ),
                Spacer(),
                Hero(
                    tag: "login",
                    child: SvgPicture.asset('assets/svg/loginpagegirl.svg')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
