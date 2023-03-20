import 'package:flutter/material.dart';
import 'package:gooonj_admin/screens/medical_report_screen.dart';
import 'package:intl/intl.dart';

import '../theme.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen(
      {Key? key, required this.user, required this.machines})
      : super(key: key);
  final Map<dynamic, dynamic> user;
  final List<dynamic> machines;

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: size.height * .045,
                  bottom: size.height * .045,
                  right: size.width * .06,
                  left: size.width * .07),
              decoration: containerDeco,
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            color: textgrey,
                          ),
                          SizedBox(
                            width: size.width * .02,
                          ),
                          Text(
                            'User Name',
                            style: TextStyle(
                                fontFamily: 'Outfit-Medium',
                                color: textgrey,
                                fontSize: size.width * .05),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * .01,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.badge_outlined,
                            color: textgrey,
                          ),
                          SizedBox(
                            width: size.width * .02,
                          ),
                          Text(
                            'Gooonj ID',
                            style: TextStyle(
                                color: textgrey,
                                fontFamily: 'Outfit-Regular',
                                fontSize: size.width * .045),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.user['name'],
                        style: TextStyle(
                            color: mainRed,
                            fontFamily: 'Outfit-Bold',
                            fontSize: size.width * .05),
                      ),
                      SizedBox(
                        height: size.height * .01,
                      ),
                      Text(
                        widget.user['gooonjId'].toUpperCase(),
                        style: TextStyle(
                            color: mainRed,
                            fontFamily: 'Outfit-Regular',
                            fontSize: size.width * .05),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * .02,
            ),
            SizedBox(
              height: size.height * .66,
              child: ListView.builder(
                itemCount: widget.user['withdraws'].length,
                itemBuilder: (BuildContext context, int index) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Material(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.white,
                    elevation: 1,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MedicalReportScreen(
                              username: widget.user['name'],
                              gooonjId: widget.user['gooonjId'],
                              withdraw: widget.user['withdraws'][index],
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(
                          'Date : ${DateFormat('d/M/y').format(DateTime.parse(widget.user['withdraws'][index]['time']))}',
                          style: TextStyle(
                            fontFamily: 'Outfit-Regular',
                            fontSize: size.width * .04,
                          ),
                        ),
                        subtitle: Text(
                          getLocationName(
                              widget.user['withdraws'][index]['machineId']),
                          style: TextStyle(
                            fontSize: size.width * .03,
                            fontFamily: 'Outfit-Regular',
                            color: Colors.grey,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward,
                          color: mainRed,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getLocationName(machineId) {
    final machine =
        widget.machines.firstWhere((element) => element['_id'] == machineId,orElse: () => null);

    return machine == null ? 'TIDES Business Incubator' : '${machine['name']}, ${machine['area']}';
  }
}
