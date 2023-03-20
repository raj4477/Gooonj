import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gooonj_app/theme.dart';

class DispenseOTPScreen extends StatefulWidget {
  const DispenseOTPScreen({Key? key,required this.otp,required this.refId}) : super(key: key);
  final String refId;
  final String otp;
  @override
  State<DispenseOTPScreen> createState() => _DispenseOTPScreenState();
}

class _DispenseOTPScreenState extends State<DispenseOTPScreen> {

  @override

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16),
        child: Column(
          children: [
            SizedBox(
              height: size.height * .03,
            ),
            Center(
              child: SvgPicture.asset('assets/svg/dispenceotp.svg'),
            ),
            SizedBox(
              height: size.height * .015,
            ),
            Text(
              'Gooonj Dispense',
              style: TextStyle(
                fontSize: size.width * .07,
                fontFamily: "Outfit-Bold",
              ),
            ),
            SizedBox(
              height: size.height * .015,
            ),
            Text(
              'Enter the Reference ID & OTP into the Vending Machine',
              style: TextStyle(
                fontFamily: "Outfit-Regular",
                fontSize: size.width * .05,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: size.height * .04,
            ),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: mainRed,
              ),
              child: Row(
                children: [
                  SvgPicture.asset('assets/svg/co_present.svg'),
                  SizedBox(
                    width: size.width * .03,
                  ),
                  Text(
                    'Reference ID',
                    style: TextStyle(
                        fontSize: size.width * .05,
                        fontFamily: "Outfit-Regular",
                        color: Colors.white),
                  ),
                  Spacer(),
                  Text(
                    widget.refId,
                    style: TextStyle(
                        fontSize: size.width * .05,
                        fontFamily: "Outfit-Bold",
                        color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * .04,
            ),
            Container(
              color: mainRed,
              padding: EdgeInsets.all(15),
              child: Row(
                children: [
                  SvgPicture.asset('assets/svg/enhanced_encryption.svg'),
                  SizedBox(
                    width: size.width * .03,
                  ),
                  Text(
                    'OTP',
                    style: TextStyle(
                        fontFamily: "Outfit-Regular",
                        fontSize: size.width * .05,color: Colors.white),
                  ),
                  Spacer(),Text(
                    widget.otp,
                    style: TextStyle(
                        fontFamily: "Outfit-Regular",
                        fontSize: size.width * .05,color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * .06,
            ),
          ],
        ),
      ),
    );
  }
}
