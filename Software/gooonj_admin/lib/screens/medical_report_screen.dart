import 'package:flutter/material.dart';
import 'package:gooonj_admin/theme.dart';
import 'package:intl/intl.dart';

class MedicalReportScreen extends StatefulWidget {
  const MedicalReportScreen(
      {Key? key,
      required this.username,
      required this.gooonjId,
      required this.withdraw})
      : super(key: key);
  final String username;
  final String gooonjId;
  final Map<String, dynamic> withdraw;

  @override
  State<MedicalReportScreen> createState() => _MedicalReportScreenState();
}

class _MedicalReportScreenState extends State<MedicalReportScreen> {
  @override
  Widget build(BuildContext context) {
    print(widget.withdraw);
    final DateTime time = DateTime.parse(widget.withdraw['time']).toLocal();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: 16.0, left: 16, right: 16, top: 3),
        child: Container(
          decoration: containerDeco,
          child: Padding(
            padding: const EdgeInsets.only(top: 25.0, left: 16, right: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Gooonj',
                      style: TextStyle(
                          fontFamily: 'Outfit-Medium',
                          color: mainRed,
                          fontSize: size.width * .05),
                    ),
                    Spacer(),
                    Text(
                      'Medical Report Screen',
                      style: TextStyle(
                          fontFamily: 'Outfit-Regular',
                          color: textgrey,
                          fontSize: size.width * .05),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * .015,
                ),
                Divider(
                  color: mainRed,
                  thickness: 2,
                ),
                SizedBox(
                  height: size.height * .04,
                ),
                Row(
                  children: [
                    Text(
                      'Name : ',
                      style: TextStyle(
                        fontFamily: 'Outfit-Regular',
                        fontSize: size.width * .04,
                      ),
                    ),
                    Text(
                      widget.username,
                      style: TextStyle(
                        fontFamily: 'Outfit-Regular',
                        color: mainRed,
                        fontSize: size.width * .04,
                      ),
                    ),
                    Spacer(),
                    Text(
                      'GooonjID : ',
                      style: TextStyle(
                        fontFamily: 'Outfit-Regular',
                        fontSize: size.width * .04,
                      ),
                    ),
                    Text(
                      widget.gooonjId.toUpperCase(),
                      style: TextStyle(
                        fontFamily: 'Outfit-Regular',
                        color: mainRed,
                        fontSize: size.width * .04,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * .015,
                ),
                Row(
                  children: [
                    Text(
                      'Date : ',
                      style: TextStyle(
                        fontFamily: 'Outfit-Regular',
                        fontSize: size.width * .04,
                      ),
                    ),
                    Text(
                      DateFormat('d/M/y').format(time),
                      style: TextStyle(
                        fontFamily: 'Outfit-Regular',
                        color: mainRed,
                        fontSize: size.width * .04,
                      ),
                    ),
                    Spacer(),
                    Text(
                      'Time : ',
                      style: TextStyle(
                        fontFamily: 'Outfit-Regular',
                        fontSize: size.width * .04,
                      ),
                    ),
                    Text(
                      DateFormat.jm().format(time),
                      style: TextStyle(
                        fontFamily: 'Outfit-Regular',
                        color: mainRed,
                        fontSize: size.width * .04,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * .04,
                ),
                widget.withdraw['questions'].isEmpty
                    ? Expanded(
                        child: Center(
                          child: Text(
                            'Internal Server Error Occurred.\nPlease come back later.',
                            style: TextStyle(fontSize: size.width * 0.06),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : SizedBox(
                        height: size.height * .5,
                        child: ListView.builder(
                          itemCount: widget.withdraw['questions'].length,
                          itemBuilder: (BuildContext context, int index) =>
                              ListTile(
                            title: Text(
                              '${index + 1}. ${widget.withdraw['questions'][index]['question']}',
                              softWrap: true,
                              style: TextStyle(
                                fontFamily: 'Outfit-Regular',
                                fontSize: size.width * .04,
                              ),
                            ),
                            trailing: Text(
                              widget.withdraw['questions'][index]['answer']
                                  ? 'Yes'
                                  : 'No',
                              style: TextStyle(
                                  fontFamily: 'Outfit-Bold',
                                  fontSize: size.width * .04,
                                  color: widget.withdraw['questions'][index]['answer']?Colors.red:Colors.green),
                            ),
                          ),
                        ),
                      ),
                SizedBox(
                  height: size.height * .03,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: size.height * .02),
                  child: Container(
                    width: size.width,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: mainRed,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Medical Status',
                          style: TextStyle(
                              fontFamily: 'Outfit-Bold',
                              fontSize: size.width * .04,
                              color: Colors.white),
                        ),
                        Spacer(),
                        Text(
                          'Good',
                          style: TextStyle(
                              fontFamily: 'Outfit-Bold',
                              fontSize: size.width * .04,
                              color: Colors.white),
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
    );
  }
}
