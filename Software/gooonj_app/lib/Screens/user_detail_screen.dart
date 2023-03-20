import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gooonj_app/model.dart';

import '../theme.dart';

class UserDetailScreen extends StatefulWidget {
  const UserDetailScreen({Key? key, required this.userData}) : super(key: key);
  final UserData userData;

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController phno = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController gooonjID = TextEditingController();

  @override
  void initState() {
    super.initState();
    name.text = widget.userData.name;
    phno.text = widget.userData.number;
    address.text = widget.userData.address;
    gooonjID.text = widget.userData.gooonjId.toUpperCase();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    TextStyle headingstyle = TextStyle(
        fontFamily: 'Outfit-Regular',
        color: textgrey,
        fontSize: size.width * .055);

    TextStyle hintstyle = TextStyle(
        fontFamily: 'Outfit-Regular',
        fontSize: size.width * .04,
        color: textgrey);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'User Details',
                style: TextStyle(
                    fontFamily: 'Outfit-Bold', fontSize: size.width * .07),
              ),
              SizedBox(
                height: size.height * .02,
              ),
              Container(
                padding: EdgeInsets.only(
                    top: size.height * .02,
                    left: size.width * .05,
                    right: size.width * .05,
                    bottom: size.width * .05),
                color: Color(0xffF7F7F7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personal Details',
                      style: headingstyle,
                    ),
                    SizedBox(
                      height: size.height * .01,
                    ),
                    Divider(color: Colors.grey),
                    SizedBox(
                      height: size.height * .007,
                    ),
                    TextField(
                      controller: name,
                      readOnly: true,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Name',
                          hintStyle: hintstyle,
                          prefixIcon: Icon(Icons.person_outline),
                          prefixIconColor: textgrey),
                    ),
                    SizedBox(
                      height: size.height * .02,
                    ),
                    TextField(
                      controller: phno,
                      readOnly: true,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Contact Number',
                          hintStyle: hintstyle,
                          prefixIcon: Icon(Icons.phone),
                          prefixIconColor: textgrey),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: size.height * .02,
              ),
              Container(
                padding: EdgeInsets.only(
                    top: size.height * .02,
                    left: size.width * .05,
                    right: size.width * .05,
                    bottom: size.width * .05),
                color: Color(0xffF7F7F7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Address Details',
                      style: headingstyle,
                    ),
                    SizedBox(
                      height: size.height * .01,
                    ),
                    Divider(color: Colors.grey),
                    SizedBox(
                      height: size.height * .007,
                    ),
                    TextField(
                      controller: address,
                      readOnly: true,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Address',
                          hintStyle: hintstyle,
                          prefixIcon: Icon(Icons.location_on_outlined),
                          prefixIconColor: textgrey),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height * .02,
              ),
              Container(
                padding: EdgeInsets.only(
                    top: size.height * .02,
                    left: size.width * .05,
                    right: size.width * .05,
                    bottom: size.width * .05),
                color: Color(0xffF7F7F7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gooonj Details',
                      style: headingstyle,
                    ),
                    SizedBox(
                      height: size.height * .01,
                    ),
                    Divider(color: Colors.grey),
                    SizedBox(
                      height: size.height * .007,
                    ),
                    TextField(
                      readOnly: true,
                      controller: gooonjID,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Gooonj ID',
                          hintStyle: hintstyle,
                          prefixIcon: Icon(Icons.badge_outlined),
                          prefixIconColor: textgrey),
                    ),
                    SizedBox(
                      height: size.height * .007,
                    ),
                    // TextField(
                    //   controller: gooonjPIN,
                    //   decoration: InputDecoration(
                    //       border: InputBorder.none,
                    //       filled: true,
                    //       fillColor: Colors.white,
                    //       hintText: 'Gooonj PIN',
                    //       hintStyle: hintstyle,
                    //       prefixIcon: Icon(Icons.lock_outline),
                    //       prefixIconColor: textgrey),
                    // ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height * .035,
              ),
              // Align(
              //   alignment: Alignment.center,
              //   child: InkWell(
              //     onTap: () async{
              //       final response=await httpFunPost('createUser', {
              //         'gooonjId': gooonjID.text,
              //         'name': name.text,
              //         'number': phno.text,
              //         'pin': gooonjPIN.text,
              //         'address': address.text
              //       });
              //       Map<dynamic,dynamic> decoded=jsonDecode(utf8.decode(response.bodyBytes))as Map;
              //       Navigator.pushReplacement(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => CongratulationScreen(reponse: decoded),
              //         ),
              //       );
              //     },
              //     child: Container(
              //       padding: EdgeInsets.only(
              //           top: 16, bottom: 16, left: 48, right: 48),
              //       decoration: BoxDecoration(
              //           color: floatingAction,
              //           borderRadius: BorderRadius.circular(30)),
              //       child: Text(
              //         'Register',
              //         style: TextStyle(
              //             fontSize: size.width * .045,
              //             fontFamily: "Outfit-Bold",
              //             color: Colors.white),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
