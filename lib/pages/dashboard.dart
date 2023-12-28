import 'dart:convert';
import 'package:memberapp/functions/app_func.dart';
import 'package:memberapp/functions/globaldata_fn.dart';
import 'package:memberapp/localstore/global_var.dart';
import 'package:memberapp/login.dart';
import 'package:memberapp/pages/activities.dart';
import 'package:memberapp/pages/affiliation.dart';
import 'package:memberapp/pages/bills.dart';
import 'package:memberapp/pages/eventpage.dart';
import 'package:memberapp/pages/payments.dart';
import 'package:memberapp/pages/profile.dart';
import 'package:memberapp/pages/statement.dart';
import 'package:memberapp/pages/webview.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

import '../components/fonts.dart';
import '../localstore/systemsetup/appsettings.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  TextStyle ed12 = fontFile(12, const Color(0xFFEDEDED), 0, FontWeight.w600);
  TextStyle edH12 =
      fontWithheight(12, const Color(0xFFEDEDED), 0, FontWeight.w600);
  TextStyle ed18 = fontFile(18, const Color(0xFFEDEDED), 0, FontWeight.w600);
  TextStyle w14 = fontFile(14, const Color(0xFFFFFFFF), 0, FontWeight.w800);
  TextStyle w16 = fontFile(16, const Color(0xFFFFFFFF), 0, FontWeight.w800);
  TextStyle w18 = fontFile(18, const Color(0xFFFFFFFF), 0, FontWeight.w800);
  TextStyle e7511 =
      fontWithheight(11, const Color(0xFF757575), 0, FontWeight.bold);
  TextStyle w7514 = fontFile(14, const Color(0xFF757575), 0, FontWeight.bold);
  TextStyle logo = cmlogo(16, const Color(0xFFFFFFFF));
  TextStyle wC614 = fontFile(14, const Color(0xFFC6C6C6), 0, FontWeight.bold);
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Morning';
    }
    if (hour < 17) {
      return 'Afternoon';
    }
    return 'Evening';
  }

  late DateTime lastDayOfCurMonth, fromdt;
  bool loadscreen = false;
  List calendardata = [];
  Future getData() async {
    DateTime now = DateTime.now();
    lastDayOfCurMonth = DateTime(now.year, now.month + 1, 0);
    fromdt = DateTime(now.year, now.month, 1);

    calendardata = await getActivities(datetime('dbdate', fromdt.toString()),
        datetime('dbdate', lastDayOfCurMonth.toString()));

    setState(() {
      loadscreen = true;
    });

    // print(calendardata);
  }

  //
  bool displayProfile = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.black,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Color(0xFF171717)],
              stops: [0, 1],
              begin: AlignmentDirectional(0, -1),
              end: AlignmentDirectional(0, 1),
            ),
          ),
          child: Padding(
            padding:
                EdgeInsetsDirectional.fromSTEB(15, topMargin, 15, bottomMargin),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Good ${greeting()}',
                        style: w14,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                PageTransition(
                                  type: PageTransitionType.leftToRight,
                                  duration: const Duration(milliseconds: 200),
                                  reverseDuration:
                                      const Duration(milliseconds: 200),
                                  child: const Login(),
                                ),
                                ModalRoute.withName("/Login"));
                          },
                          child: Text(
                            'Logout',
                            style: w14,
                          )),
                    ],
                  ),

                  /*   Text(
                    userfullname, //'Mr. Prakash Rana',
                    style: w18,
                  ), */
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 20),
                    child: Container(
                      width: double.infinity,
                      height: 255,
                      child: Stack(clipBehavior: Clip.none, children: [
                        Material(
                          color: Colors.transparent,
                          elevation: 16,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF121212), Color(0xFF2B2B2B)],
                                stops: [0, 1],
                                begin: AlignmentDirectional(-1, -0.98),
                                end: AlignmentDirectional(1, 0.98),
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  10, 5, 10, 10),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  flagShopDetails['logo'] != null &&
                                          flagShopDetails['logo'].toString() !=
                                              ''
                                      ? Image.memory(
                                          base64Decode(flagShopDetails['logo']
                                              .toString()),
                                          gaplessPlayback: true,
                                          width: 100,
                                          height: 100,
                                        )
                                      : Image.asset(
                                          'media/logo.png',
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.contain,
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: -0,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Material(
                                color: Colors.transparent,
                                elevation: 16,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: InkWell(
                                  onTap: () => setState(() {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.leftToRight,
                                        duration:
                                            const Duration(milliseconds: 200),
                                        reverseDuration:
                                            const Duration(milliseconds: 200),
                                        child: const Profile(),
                                      ),
                                    );
                                  }),
                                  child: Container(
                                    width: 130,
                                    height: 140,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2B2B2B),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              10, 10, 10, 10),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: userprofileimg != ''
                                            ? Image.memory(
                                                base64Decode(userprofileimg),
                                                gaplessPlayback: true,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.95,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.95,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.asset(
                                                'media/user.png',
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.95,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.95,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                        child: Column(children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        child: Text(
                          userfullname,
                          style: w18,
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                        child: Text(
                          '$userid $usercategory',
                          style: wC614,
                        ),
                      )
                    ])),
                  ]),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                    child: Material(
                      color: const Color(0xFF181818),
                      borderRadius: BorderRadius.circular(5),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.leftToRight,
                              duration: const Duration(milliseconds: 200),
                              reverseDuration:
                                  const Duration(milliseconds: 200),
                              child: const Bills(),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 100,
                          decoration: const BoxDecoration(),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                15, 15, 15, 15),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Image.asset(
                                  'media/bill.png',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.contain,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            15, 0, 0, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Bills',
                                          style: ed18,
                                        ),
                                        Text(
                                          'Monthly bills',
                                          style: w7514,
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                    child: Material(
                      color: const Color(0xFF181818),
                      borderRadius: BorderRadius.circular(5),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.leftToRight,
                              duration: const Duration(milliseconds: 200),
                              reverseDuration:
                                  const Duration(milliseconds: 200),
                              child: const Payments(),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFF181818),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                15, 15, 15, 15),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Image.asset(
                                  'media/payment.png',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.contain,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            15, 0, 0, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Payments',
                                          style: ed18,
                                        ),
                                        Text(
                                          'Balance & daily transaction',
                                          style: w7514,
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                    child: Material(
                      color: const Color(0xFF181818),
                      borderRadius: BorderRadius.circular(5),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.leftToRight,
                              duration: const Duration(milliseconds: 200),
                              reverseDuration:
                                  const Duration(milliseconds: 200),
                              child: const Statement(),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFF181818),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                15, 15, 15, 15),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Image.asset(
                                  'media/transaction.png',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.contain,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            15, 0, 0, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Statement',
                                          style: ed18,
                                        ),
                                        Text(
                                          'Debit & Credit transaction details',
                                          style: w7514,
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                    child: Material(
                      color: const Color(0xFF181818),
                      borderRadius: BorderRadius.circular(5),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.leftToRight,
                              duration: const Duration(milliseconds: 200),
                              reverseDuration:
                                  const Duration(milliseconds: 200),
                              child: Activities(
                                logdate: datetime(
                                    'dbdate', DateTime.now().toString()),
                                fromdash: 'N',
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFF181818),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                15, 15, 15, 15),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Image.asset(
                                  'media/activities.png',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.contain,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            15, 0, 0, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Daily Activities',
                                          style: ed18,
                                        ),
                                        Text(
                                          'Track your activities',
                                          style: w7514,
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                    child: Material(
                      color: const Color(0xFF181818),
                      borderRadius: BorderRadius.circular(5),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.leftToRight,
                              duration: const Duration(milliseconds: 200),
                              reverseDuration:
                                  const Duration(milliseconds: 200),
                              child: const Affiliation(),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFF181818),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                15, 15, 15, 15),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Image.asset(
                                  'media/partnership.png',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.contain,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            15, 0, 0, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Affiliated Clubs',
                                          style: ed18,
                                        ),
                                        Text(
                                          'Track your activities',
                                          style: w7514,
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                    child: Material(
                      color: const Color(0xFF181818),
                      borderRadius: BorderRadius.circular(5),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.leftToRight,
                              duration: const Duration(milliseconds: 200),
                              reverseDuration:
                                  const Duration(milliseconds: 200),
                              child: const EventPage(),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFF181818),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                15, 15, 15, 15),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Image.asset(
                                  'media/planner.png',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.contain,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            15, 0, 0, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Events',
                                          style: ed18,
                                        ),
                                        Text(
                                          'Upcoming events details',
                                          style: w7514,
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                    child: Material(
                      color: const Color(0xFF181818),
                      borderRadius: BorderRadius.circular(5),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.leftToRight,
                              duration: const Duration(milliseconds: 200),
                              reverseDuration:
                                  const Duration(milliseconds: 200),
                              child: const Webview(
                                title: 'Belgaum Club',
                                url: 'https://www.belgaumclub.in/',
                                dash: true,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFF181818),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                15, 15, 15, 15),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Image.asset(
                                  'media/web.png',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.contain,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            15, 0, 0, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Website',
                                          style: ed18,
                                        ),
                                        Text(
                                          'Club Website',
                                          style: w7514,
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
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                  //   child: Container(
                  //     width: double.infinity,
                  //     height: 400,
                  //     decoration: BoxDecoration(
                  //       color: Color(0xFF181818),
                  //       borderRadius: BorderRadius.circular(5),
                  //     ),
                  //     child: Padding(
                  //       padding: EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
                  //       child: Column(
                  //         mainAxisSize: MainAxisSize.max,
                  //         children: [
                  //           loadscreen
                  //               ? Expanded(
                  //                   child: Container(
                  //                       width: double.infinity,
                  //                       height: double.infinity,
                  //                       decoration: BoxDecoration(),
                  //                       child: Wrap(
                  //                         spacing: 10,
                  //                         runSpacing: 10,
                  //                         alignment: WrapAlignment.start,
                  //                         crossAxisAlignment:
                  //                             WrapCrossAlignment.start,
                  //                         direction: Axis.horizontal,
                  //                         runAlignment: WrapAlignment.start,
                  //                         verticalDirection:
                  //                             VerticalDirection.down,
                  //                         clipBehavior: Clip.none,
                  //                         children: dayWid(),
                  //                       )),
                  //                 )
                  //               : Expanded(
                  //                   child: Center(
                  //                       child: CircularProgressIndicator(
                  //                   color: Colors.yellow,
                  //                 ))),
                  //           Padding(
                  //             padding:
                  //                 EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                  //             child: Row(
                  //               mainAxisSize: MainAxisSize.max,
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: [
                  //                 Padding(
                  //                   padding: EdgeInsetsDirectional.fromSTEB(
                  //                       0, 0, 10, 0),
                  //                   child: Container(
                  //                     width: 14,
                  //                     height: 14,
                  //                     decoration: BoxDecoration(
                  //                       color: Color(0xFF91FA00),
                  //                       shape: BoxShape.circle,
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 Text(
                  //                   'Visited',
                  //                   style: edH12,
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF181818),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            15, 15, 15, 15),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              alignment: WrapAlignment.start,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              direction: Axis.horizontal,
                              runAlignment: WrapAlignment.start,
                              verticalDirection: VerticalDirection.down,
                              clipBehavior: Clip.none,
                              children: dayWid(),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 15, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 10, 0),
                                    child: Container(
                                      width: 14,
                                      height: 14,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF91FA00),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Visited',
                                    style: edH12,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.leftToRight,
                          duration: const Duration(milliseconds: 200),
                          reverseDuration: const Duration(milliseconds: 200),
                          child: const Webview(
                            title: 'Eskay Softech',
                            url: 'https://eskaysoftech.com',
                            dash: true,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 45,
                      decoration: const BoxDecoration(),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Powered By',
                              style: e7511,
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  10, 0, 0, 0),
                              child: Text(
                                'eskaySOFTECH',
                                style: logo,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> dayWid() {
    return List.generate(lastDayOfCurMonth.day, (index) {
      final currDt = fromdt.add(Duration(days: index));
      bool datayn = calendardata.any((c) =>
          c['memberlogdate'].toString() ==
          datetime('dbdate', currDt.toString()));
      //  print(currDt);
      return StatefulBuilder(
          builder: (context, setState) => InkWell(
              onTap: datayn
                  ? () async {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.leftToRight,
                          duration: const Duration(milliseconds: 200),
                          reverseDuration: const Duration(milliseconds: 200),
                          child: Activities(
                            logdate: datetime('dbdate', currDt.toString()),
                            fromdash: 'Y',
                          ),
                        ),
                      );
                    }
                  : null,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: datayn
                      ? const Color(0x3991FA00)
                      : const Color(0x31515151),
                ),
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${index + 1}",
                        style: w16,
                      ),
                      () {
                        final currentDate = fromdt.add(Duration(days: index));

                        final dateName = DateFormat('E').format(currentDate);

                        return Text(
                          dateName,
                          style: e7511,
                        );
                      }(),
                    ]),
              )));
    });
  }
}
