import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gooonj_app/Screens/dispence_otp_screen.dart';
import 'package:gooonj_app/Screens/user_detail_screen.dart';
import 'package:gooonj_app/http_function.dart';
import 'package:gooonj_app/model.dart';
import 'package:intl/intl.dart';

import '../theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.userData}) : super(key: key);
  final UserData userData;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late UserData innerUserData;
  @override
  void initState() {
    innerUserData = widget.userData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16,
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 24),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UserDetailScreen(userData: widget.userData)));
                  },
                  child: Container(
                    // color: Colors.amber,
                    height: height * 0.25,
                    width: width * 0.95,
                    child: Stack(
                      children: [
                        SizedBox(
                          height: height * 0.25,
                          width: width * 0.95,
                          child: Image.asset(
                            'assets/png/Digital Card Gooonj.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.userData.gooonjId.toUpperCase(),
                                  style: TextStyle(
                                      fontFamily: "Outfit-Bold",
                                      fontSize: width * .06,
                                      color: Colors.white),
                                ),
                                Text(
                                  widget.userData.name,
                                  style: TextStyle(
                                    fontFamily: "Outfit-Regular",
                                    fontSize: width * .06,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Gooonj',
                                  style: TextStyle(
                                    fontFamily: "Outfit-Regular",
                                    fontSize: width * .07,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Tap for user details',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontFamily: "Outfit-Regular",
                                    fontSize: width * .04,
                                    color: Colors.white,
                                    textBaseline: TextBaseline.alphabetic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * .03,
              ),
              Row(
                children: [
                  Text(
                    'Sanitary Pads Withdrawls',
                    style: TextStyle(
                        fontFamily: "Outfit-SemiBold", fontSize: width * .06),
                  ),
                ],
              ),
              SizedBox(
                height: height * .015,
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshUser,
                  color: mainRed,
                  key: _refreshIndicatorKey,
                  child: ListView.builder(
                    itemCount: innerUserData.withdraws.length,
                    itemBuilder: (BuildContext context, int index) => ListTile(
                      // tileColor:Colors.amber,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        // userData.withdraws[index]['machineId'],
                        'University Rajasthan College, JLN Marg',
                        style: TextStyle(
                            fontFamily: "Outfit-Regular",
                            fontSize: width * .06),
                      ),
                      subtitle: Text(
                        convertDate(innerUserData.withdraws[index]['time']),
                        style: TextStyle(
                            fontFamily: "Outfit-Regular",
                            fontSize: width * .04),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: mainRed,
                        child: Center(
                          child: Icon(
                            Icons.location_on,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // trailing: Text(
                      //   '-2 Packets',
                      //   style: TextStyle(
                      //       fontFamily: "Outfit-Regular", fontSize: width * .05),
                      // ),
                    ),

                    // shrinkWrap: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: height * .02),
        child: FloatingActionButton.extended(
          extendedTextStyle: buttonTextStyle,
          label: Text(
            'Get your pads',
          ),
          icon: Icon(Icons.health_and_safety_outlined),
          onPressed: () async {
            var response = await httpFunPost(
                'createCardless', {'userId': widget.userData.id});
            final decoded = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DispenseOTPScreen(
                    otp: decoded['otp'], refId: decoded['refId']),
              ),
            );
          },
          backgroundColor: floatingAction,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<Null> _refreshUser() {
    return httpFunGet('user/${innerUserData.id}').then((value) {
      var decodedUserData = jsonDecode(utf8.decode(value.bodyBytes)) as Map;
      final userData = UserData(
          name: decodedUserData['name'],
          gooonjId: decodedUserData['gooonjId'],
          number: decodedUserData['number'],
          pin: decodedUserData['pin'],
          address: decodedUserData['address'],
          id: decodedUserData['_id'],
          withdraws: decodedUserData['withdraws']);
      setState(() => innerUserData = userData);
    });
  }

  String convertDate(String datetime) {
    DateTime time = DateTime.parse(datetime);
    DateTime convertedTime = time.toLocal();
    return DateFormat('d MMM,').add_jm().format(convertedTime);
  }
}
