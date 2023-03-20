import 'package:flutter/material.dart';
import 'package:gooonj_admin/theme.dart';

class CongratulationScreen extends StatelessWidget {
  const CongratulationScreen({Key? key,required this.reponse}) : super(key: key);
  final Map<dynamic,dynamic> reponse;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(reponse);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Image.asset('assets/png/confirmation.png')),
            SizedBox(height: 16),
            Text(
              'Registration Successful',
              style: TextStyle(
                  fontFamily: 'Outfit-Regular', fontSize: size.width * .07),
            ),
            SizedBox(height: 38),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 21),
              decoration: containerDeco,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text.rich(
                        TextSpan(
                          text: 'Name : ',
                          style: TextStyle(
                            fontSize: size.width * .055,
                            fontFamily: 'Outfit-Regular',
                          ),
                          children: [
                            TextSpan(
                              text: reponse['name'],
                              style: TextStyle(color: mainRed),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Text.rich(
                        TextSpan(
                          text: 'Gooonj ID : ',
                          style: TextStyle(
                            fontSize: size.width * .045,
                            fontFamily: 'Outfit-Regular',
                          ),
                          children: [
                            TextSpan(
                              text: reponse['gooonjId'],
                              style: TextStyle(color: mainRed),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 16),
                  Text.rich(
                    TextSpan(
                      text: 'Contact Number : ',
                      style: TextStyle(
                        fontSize: size.width * .045,
                        fontFamily: 'Outfit-Regular',
                      ),
                      children: [
                        TextSpan(
                          text: reponse['number'],
                          style: TextStyle(color: mainRed),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 60),
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Text(
                'Back to Home',
                style: TextStyle(
                  fontSize: size.width * .055,
                  fontFamily: 'Outfit-Regular',
                  color: mainRed,
                  decoration: TextDecoration.underline,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
