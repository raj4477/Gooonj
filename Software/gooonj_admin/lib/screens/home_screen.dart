import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gooonj_admin/http_functions.dart';
import 'package:gooonj_admin/screens/user_details_screen.dart';
import 'package:gooonj_admin/screens/user_register_screen.dart';
import 'package:gooonj_admin/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.users, required this.machines})
      : super(key: key);

  final List<dynamic> users;
  final List<dynamic> machines;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<dynamic> users;
  late List<dynamic> machines;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey1 =
  GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey2 =
  GlobalKey<RefreshIndicatorState>();
  void initState() {
    users = widget.users;
    machines = widget.machines;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
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
                          Text(
                            'Good Morning,',
                            style: TextStyle(
                                fontFamily: 'Outfit-Medium',
                                fontSize: size.width * .05),
                          ),
                          SizedBox(
                            height: size.height * .01,
                          ),
                          Text(
                            'Aakash Singh',
                            style: TextStyle(
                                color: mainRed,
                                fontFamily: 'Outfit-Bold',
                                fontSize: size.width * .08),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.store,
                                color: mainRed,
                              ),
                              Text(
                                'Hotspots : ${machines.length}',
                                style: TextStyle(
                                    color: Color(0xff595959),
                                    fontFamily: 'Outfit-Regular',
                                    fontSize: size.width * .035),
                              )
                            ],
                          ),
                          SizedBox(
                            height: size.height * .01,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: mainRed,
                              ),
                              Text(
                                'Users : ${users.length}',
                                style: TextStyle(
                                    color: Color(0xff595959),
                                    fontFamily: 'Outfit-Regular',
                                    fontSize: size.width * .035),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * .025,
                ),
                TabBar(
                    onTap: (int index) async {
                      if (index == 2) {
                        var response = await httpFunGet('users');
                        final userMap =
                            jsonDecode(utf8.decode(response.bodyBytes));
                        setState(() {
                          users = userMap['users'];
                        });
                      }
                    },
                    indicatorColor: mainRed,
                    labelColor: mainRed,
                    labelStyle: TextStyle(
                      fontFamily: 'Outfit-Medium',
                    ),
                    unselectedLabelColor: Colors.black,
                    unselectedLabelStyle: TextStyle(
                      fontFamily: 'Outfit-Medium',
                    ),
                    tabs: [
                      // Text(data),
                      Tab(
                        text: 'Vending Machine Status',
                      ),
                      Tab(
                        text: "User's Q&A Feedback",
                      )
                    ]),
                SizedBox(
                  height: size.height * .02,
                ),
                SizedBox(
                  height: size.height * .6,
                  width: size.width,
                  child: TabBarView(children: [
                    machineStatusList(context, size),
                    qaList(context, size),
                  ]),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: size.height * .05),
          child: FloatingActionButton.extended(
            extendedTextStyle: TextStyle(
              fontFamily: 'Outfit-Bold',
            ),
            label: Text(
              'New Registration',
            ),
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserRegisterScreen(),
                ),
              );
            },
            backgroundColor: floatingAction,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget machineStatusList(context, Size size) {
    return RefreshIndicator(
      key: _refreshIndicatorKey1,
      color: mainRed,
      onRefresh: () {
        return httpFunGet('/machines').then((value) { final machineMap = jsonDecode(utf8.decode(value.bodyBytes)) as Map;
          setState(() => machines = machineMap['machines']);});
      },
      child: ListView.builder(
        itemCount: machines.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) => ListTile(
          leading: Image.asset(
            'assets/png/locationmarker.png',
            height: size.width * .095,
            width: size.width * .095,
          ),
          title: Text(
            machines[index]['name'],
            style: TextStyle(
              fontFamily: 'Outfit-Regular',
              fontSize: size.width * .04,
            ),
          ),
          trailing: Text(
            '${machines[index]['padsCount']}/40',
            style: TextStyle(
                color: getColor(index),
                fontFamily: "Outfit-Bold",
                fontSize: size.width * .04),
          ),
        ),
      ),
    );
  }
  Color getColor(int index){
    if(machines[index]['padsCount']<=10){
      return Colors.red;
    }
    else if(machines[index]['padsCount']>10&&machines[index]['padsCount']<=25){
      return Colors.orange;
    }
    else{
      return Colors.green;
    }
  }
  Widget qaList(
    context,
    Size size,
  ) {
    return RefreshIndicator(
      key: _refreshIndicatorKey2,
      color: mainRed,
      onRefresh: (){
         return httpFunGet('/users').then((value)
         {final something=jsonDecode(utf8.decode(value.bodyBytes)) as Map;
         setState(() =>
            users=something['users']);
         });

      },
      child: ListView.builder(
        itemCount: users.length,
        itemBuilder: (BuildContext context, int index) => SizedBox(
          height: size.height * .18,
          child: Padding(
            padding:
                const EdgeInsets.only(bottom: 10.0, right: 8, left: 8, top: 8),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserDetailsScreen(
                              user: users[index],
                              machines: machines,
                            )));
              },
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: containerDeco,
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name : ${users[index]['name']}',
                            style: TextStyle(
                              fontFamily: 'Outfit-Medium',
                              fontSize: size.width * .055,
                            ),
                          ),
                          Text(
                            'Contact Number : ${users[index]['number']}',
                            style: TextStyle(
                              fontFamily: 'Outfit-Regular',
                              fontSize: size.width * .04,
                            ),
                          ),
                          Spacer(),
                          Text(
                            'Gooonj ID : ${users[index]['gooonjId']}',
                            style: TextStyle(
                              color: mainRed,
                              fontFamily: 'Outfit-Medium',
                              fontSize: size.width * .055,
                            ),
                          ),
                        ]),
                    Spacer(),
                    Center(
                      child: Icon(
                        Icons.arrow_forward,
                        color: mainRed,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
