import 'dart:convert';
import 'package:memberapp/functions/app_func.dart';
import 'package:memberapp/localstore/global_var.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../components/fonts.dart';
import '../localstore/systemsetup/appsettings.dart';
import 'changepassword.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  TextStyle ed12 = fontFile(12, Color(0xFFEDEDED), 0, FontWeight.w600);
  TextStyle e7a12 = fontFile(12, Color(0xFF7A8894), 0, FontWeight.w600);
  TextStyle edH12 = fontWithheight(
      12, Color.fromARGB(255, 218, 218, 218), 0, FontWeight.w600);
  TextStyle ed18 = fontFile(18, Color(0xFFEDEDED), 0, FontWeight.w600);
  TextStyle w14 = fontFile(14, Color(0xFFFFFFFF), 0, FontWeight.w800);
  TextStyle w16 = fontFile(16, Color(0xFFFFFFFF), 0, FontWeight.w800);
  TextStyle wb16 =
      fontFile(14, Color.fromARGB(255, 233, 233, 233), 0, FontWeight.w500);
  TextStyle w18 = fontFile(18, Color(0xFFFFFFFF), 0, FontWeight.w800);
  TextStyle e7511 = fontWithheight(11, Color(0xFF757575), 0, FontWeight.bold);
  TextStyle e10 = fontWithheight(10, Color(0xFF757575), 0, FontWeight.bold);
  TextStyle w7514 = fontFile(14, Color(0xFF757575), 0, FontWeight.bold);
  TextStyle wC614 = fontFile(14, Color(0xFFC6C6C6), 0, FontWeight.bold);
  TextStyle logo = cmlogo(16, Color(0xFFFFFFFF));

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

  Future getData() async {
    dependantList = [];

    for (var e in alldependantList) {
      if (!dependantList.contains(e)) dependantList.add(e);
    }
    setState(() {
      dependantList.length;
    });

    //  dependantList.add(currMemdata);
  }

  Map currMemdata = {
    'memberid': userid,
    'membername': userfullname,
    'email': useremail,
    'mobile': usermobileno,
    'address': useraddress,
    'category': usercategory,
    'birthday': userbirthday,
    'profileimage': userprofileimg
  };

  List dependantList = [];
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
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Color(0xFF171717)],
              stops: [0, 1],
              begin: AlignmentDirectional(0, -1),
              end: AlignmentDirectional(0, 1),
            ),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(15, topMargin, 15, bottomMargin),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
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
                              gradient: LinearGradient(
                                colors: [Color(0xFF121212), Color(0xFF2B2B2B)],
                                stops: [0, 1],
                                begin: AlignmentDirectional(-1, -0.98),
                                end: AlignmentDirectional(1, 0.98),
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(10, 5, 10, 10),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.only(top: 5),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                              onTap: () {
                                                // Navigator.pushAndRemoveUntil(
                                                //     context,
                                                //     PageTransition(
                                                //       type: PageTransitionType
                                                //           .rightToLeft,
                                                //       duration: Duration(
                                                //           milliseconds: 200),
                                                //       reverseDuration: Duration(
                                                //           milliseconds: 200),
                                                //       child: Dashboard(),
                                                //     ),
                                                //     ModalRoute.withName(
                                                //         "/Home"));
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                width: 30,
                                                child: Icon(
                                                  Icons.arrow_back_rounded,
                                                  color: Color(0xFF7A8894),
                                                  size: 25,
                                                ),
                                              )),
                                        ),
                                        InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                PageTransition(
                                                  type: PageTransitionType
                                                      .leftToRight,
                                                  duration: Duration(
                                                      milliseconds: 200),
                                                  reverseDuration: Duration(
                                                      milliseconds: 200),
                                                  child: ChangePwd(
                                                      type: 'change',
                                                      loginid:
                                                          userid.toString()),
                                                ),
                                              );
                                            },
                                            child: Container(
                                                width: 28,
                                                child: Icon(
                                                  Icons.lock_outline_rounded,
                                                  color: Color(0xFF7A8894),
                                                  size: 22,
                                                ))),
                                      ],
                                    ),
                                  ),
                                  flagShopDetails['logo'] != null &&
                                          flagShopDetails['logo'].toString() !=
                                              ''
                                      ? Image.memory(
                                          base64Decode(flagShopDetails['logo']
                                              .toString()),
                                          gaplessPlayback: true,
                                          width: 80,
                                          height: 80,
                                        )
                                      : Image.asset(
                                          'media/logo.png',
                                          width: 80,
                                          height: 80,
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
                                child: Container(
                                  width: 130,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF2B2B2B),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        10, 10, 10, 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: currMemdata['profileimage'] !=
                                                  '' &&
                                              currMemdata['profileimage'] !=
                                                  null
                                          ? Image.memory(
                                              base64Decode(
                                                  currMemdata['profileimage']
                                                      .toString()),
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
                            ],
                          ),
                        )
                      ]),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    child: Text(
                      currMemdata['membername'].toString(), // userfullname,
                      style: w18,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                    child: Text(
                      "${currMemdata['memberid']} ${currMemdata['category']}", //'F-115 Permanent Member',
                      style: wC614,
                    ),
                  ),
                  // Generated code for this Container Widget...
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(15, 0, 15, 15),
                    child: Container(
                      width: double.infinity,
                      // height: 300,
                      decoration: BoxDecoration(
                        color: Color(0x12575757),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            if (currMemdata['mobile'] != null &&
                                currMemdata['mobile'].toString() != '')
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                                child: Container(
                                  width: double.infinity,
                                  height: 40,
                                  decoration: BoxDecoration(),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.phone_outlined,
                                        color: Color(0xFF7A8894),
                                        size: 24,
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            15, 0, 15, 0),
                                        child: Container(
                                          width: 2,
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Color(0xFF7A8894),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Mobile No',
                                              style: e7a12,
                                            ),
                                            Text(
                                              currMemdata['mobile'].toString(),
                                              style: wb16,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            if (currMemdata['email'] != null &&
                                currMemdata['email'].toString() != '')
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                                child: Container(
                                  width: double.infinity,
                                  height: 40,
                                  decoration: BoxDecoration(),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.mail_outline,
                                        color: Color(0xFF7A8894),
                                        size: 24,
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            15, 0, 15, 0),
                                        child: Container(
                                          width: 2,
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Color(0xFF7A8894),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Email Id',
                                              style: e7a12,
                                            ),
                                            Text(
                                              currMemdata['email']
                                                  .toString(), // 'prakashrana@gmail.com',
                                              style: wb16,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            if (currMemdata['birthday'] != null &&
                                currMemdata['birthday'].toString() != '')
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                                child: Container(
                                  width: double.infinity,
                                  height: 40,
                                  decoration: BoxDecoration(),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.cake_outlined,
                                        color: Color(0xFF7A8894),
                                        size: 24,
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            15, 0, 15, 0),
                                        child: Container(
                                          width: 2,
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Color(0xFF7A8894),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Birthday',
                                              style: e7a12,
                                            ),
                                            Text(
                                              datetime(
                                                  'date',
                                                  currMemdata['birthday']
                                                      .toString()), //'15-05-2000',
                                              style: wb16,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            if (currMemdata['address'] != null &&
                                currMemdata['address'].toString() != '')
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                                child: Container(
                                  width: double.infinity,
                                  height: 120,
                                  decoration: BoxDecoration(),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 8, 0, 0),
                                        child: Icon(
                                          Icons.location_city_rounded,
                                          color: Color(0xFF7A8894),
                                          size: 24,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            15, 0, 15, 0),
                                        child: Container(
                                          width: 2,
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Color(0xFF7A8894),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Address',
                                              style: e7a12,
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    currMemdata['address']
                                                        .toString()
                                                        .trim(), //  '1472/D+B+C Bailwad Complex Baswan Galli, near Laxmi Temple, Belagavi, Karnataka 590001',
                                                    style: wb16,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
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
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Dependent ',
                          style: wC614,
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 20,
                    thickness: 1,
                    indent: 15,
                    endIndent: 15,
                    color: Color(0xFFC6C6C6),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(15, 0, 15, 20),
                    child: Container(
                      width: double.infinity,
                      height: 90,
                      decoration: BoxDecoration(),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            ...dependantList.map((e) => InkWell(
                                onTap: () => setState(() {
                                      dependantList.remove(e);
                                      dependantList.add(currMemdata);
                                      currMemdata = e;
                                      // print(dependantList);
                                    }),
                                child: Container(
                                    width: 70,
                                    height: double.infinity,
                                    child: (Column(children: [
                                      Container(
                                          width: 80,
                                          height: 70,
                                          margin:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  5, 0, 5, 0),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF2B2B2B),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: e['profileimage'] !=
                                                          null &&
                                                      e['profileimage']
                                                              .toString() !=
                                                          ''
                                                  ? Image.memory(
                                                      base64Decode(
                                                          e['profileimage']
                                                              .toString()),
                                                      fit: BoxFit.fill,
                                                      gaplessPlayback: true,
                                                    )
                                                  : Image.asset(
                                                      'media/user.png',
                                                      fit: BoxFit.contain,
                                                    ))),
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 5, 0, 0),
                                          child: Text(
                                            e['memberid'].toString(),
                                            style: e10,
                                          ))
                                    ]))))),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
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
                            padding:
                                EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                            child: Text(
                              'eskaySOFTECH',
                              style: logo,
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
      ),
    );
  }
}
