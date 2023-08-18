import 'dart:convert';

import 'package:memberapp/components/notifypanel.dart';
import 'package:memberapp/functions/app_func.dart';
import 'package:memberapp/localstore/global_var.dart';
import 'package:memberapp/login.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
import '../components/fonts.dart';
import '../localstore/systemsetup/appsettings.dart';

class ChangePwd extends StatefulWidget {
  final String type;
  final String loginid;

  const ChangePwd({required this.type, required this.loginid, super.key});

  @override
  State<ChangePwd> createState() => _ChangePwdState();
}

class _ChangePwdState extends State<ChangePwd> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  late TextEditingController oldpwd;
  late FocusNode userfocus;
  late TextEditingController newpassword;
  late TextEditingController confirmpwd;
  late FocusNode newpasswordfocus;
  late bool newpasswordVisibility;
  bool remPass = false;

  TextStyle f126 = fontFile(18, const Color(0xFFF1EEE9), 2, FontWeight.bold);
  TextStyle w7514 = fontFile(11, const Color(0xFF757575), 0, FontWeight.bold);
  TextStyle ed14 = fontFile(
      13, const Color.fromARGB(255, 170, 170, 170), 1, FontWeight.w600);
  TextStyle ee14 = fontFile(
      13, const Color.fromARGB(255, 170, 170, 170), 1, FontWeight.w600);
  TextStyle ed11 =
      fontWithheight(10, const Color(0xFFEDEDED), 0, FontWeight.bold);
  TextStyle e7512 =
      fontWithheight(11, const Color(0xFF757575), 0, FontWeight.bold);
  TextStyle w16 = fontFile(14, const Color(0xFFFFFFFF), 1, FontWeight.w800);
  TextStyle logo = cmlogo(16, const Color(0xFFFFFFFF));
  @override
  void initState() {
    super.initState();

    oldpwd = TextEditingController();
    newpassword = TextEditingController();
    confirmpwd = TextEditingController();
    newpasswordVisibility = false;
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  double width = 0;
  double height = 0;

  Future changepwd(String oldpwd, String newpwd, String confirm) async {
    bool out = false;
    if (widget.type == 'new' || (widget.type == 'change' && oldpwd != '')) {
      if (newpwd != '' && confirm != '') {
        if (newpwd == confirm) {
          Map<String, dynamic> senddata = {
            "DBName": dbName,
            "DBUser": dbUser,
            "type": widget.type.toString(),
            "memberid": widget.loginid,
            "oldpassword": oldpwd,
            "newpassword": newpwd
          };

          String data = json.encode(senddata);
          //print(data);
          String url =
              "https://eskaysoftech.com/CLUB_MEMBER_API/tran files/updatepassword.php";

          final response = await http.post(Uri.parse(url),
              headers: {
                "Access-Control-Allow-Origin":
                    "*", // Required for CORS support to work
                "Access-Control-Allow-Credentials":
                    "true", // Required for cookies, authorization headers with HTTPS
                "Access-Control-Allow-Headers":
                    "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
                "Access-Control-Allow-Methods": "POST, OPTIONS"
              },
              body: data);

          final dbody = json.decode(response.body);
          //print(dbody);
          if (dbody['result']) {
            out = true;
            Navigator.pop(context);
            notifyPanel(context, 'S', '', dbody['data'].toString(), 'OK', '',
                cleardata, cleardata);
          } else {
            Navigator.pop(context);
            notifyPanel(context, 'W', '', dbody['data'].toString(), 'OK', '',
                cleardata, cleardata);
          }
        } else {
          Navigator.pop(context);
          notifyPanel(
              context,
              'W',
              '',
              'New and Confirm Password does not match.',
              'OK',
              '',
              cleardata,
              cleardata);
        }
      } else {
        Navigator.pop(context);
        notifyPanel(context, 'W', '', 'Enter Passwords.', 'OK', '', cleardata,
            cleardata);
      }
    } else {
      Navigator.pop(context);
      notifyPanel(context, 'W', '', 'Enter Old Password.', 'OK', '', cleardata,
          cleardata);
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
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
            padding: const EdgeInsetsDirectional.fromSTEB(0, 35, 0, 15),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: double.infinity,
                    height: (height - (45 + 15 + 35)),
                    decoration: const BoxDecoration(),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0, 20, 0, 50),
                          child: flagShopDetails['logo'] != null &&
                                  flagShopDetails['logo'].toString() != ''
                              ? Image.memory(
                                  base64Decode(
                                      flagShopDetails['logo'].toString()),
                                  gaplessPlayback: true,
                                  width: 220,
                                  height: 90,
                                )
                              : Image.asset(
                                  'media/logo.png',
                                  width: 220,
                                  height: 90,
                                  fit: BoxFit.contain,
                                ),
                        ),
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            height: 100,
                            decoration: const BoxDecoration(),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Text(
                                //   'Welcome back,',
                                //   style: f126,
                                // ),
                                Text(
                                  'Change Password',
                                  style: f126,
                                ),
                                // Text(
                                //   'Sign in to Continue',
                                //   style: w7514,
                                // ),
                                if (widget.type.toLowerCase() == 'change')
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 30, 0, 0),
                                    child: Container(
                                      width: double.infinity,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        color: const Color(0x5F2D2D2D),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(15, 0, 10, 0),
                                        child: TextFormField(
                                          controller: oldpwd,
                                          autofocus: false,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            hintText: 'Old Password',
                                            hintStyle: ee14,
                                            enabledBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1,
                                              ),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(4.0),
                                                topRight: Radius.circular(4.0),
                                              ),
                                            ),
                                            focusedBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1,
                                              ),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(4.0),
                                                topRight: Radius.circular(4.0),
                                              ),
                                            ),
                                            errorBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1,
                                              ),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(4.0),
                                                topRight: Radius.circular(4.0),
                                              ),
                                            ),
                                            focusedErrorBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1,
                                              ),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(4.0),
                                                topRight: Radius.circular(4.0),
                                              ),
                                            ),
                                            contentPadding:
                                                const EdgeInsetsDirectional
                                                    .fromSTEB(0, 0, 0, 7),
                                          ),
                                          style: ed14,
                                          textInputAction: TextInputAction.next,
                                        ),
                                      ),
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 15, 0, 0),
                                  child: Container(
                                    width: double.infinity,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      color: const Color(0x5F2D2D2D),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              15, 0, 0, 0),
                                      child: TextFormField(
                                        controller: newpassword,
                                        autofocus: false,
                                        obscureText: !newpasswordVisibility,
                                        decoration: InputDecoration(
                                          hintText: 'New Password',
                                          hintStyle: ee14,
                                          enabledBorder:
                                              const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(4.0),
                                              topRight: Radius.circular(4.0),
                                            ),
                                          ),
                                          focusedBorder:
                                              const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(4.0),
                                              topRight: Radius.circular(4.0),
                                            ),
                                          ),
                                          errorBorder:
                                              const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(4.0),
                                              topRight: Radius.circular(4.0),
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(4.0),
                                              topRight: Radius.circular(4.0),
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsetsDirectional
                                                  .fromSTEB(0, 12, 0, 0),
                                          suffixIcon: InkWell(
                                            onTap: () => setState(
                                              () => newpasswordVisibility =
                                                  !newpasswordVisibility,
                                            ),
                                            focusNode:
                                                FocusNode(skipTraversal: true),
                                            child: Icon(
                                              newpasswordVisibility
                                                  ? Icons.visibility_outlined
                                                  : Icons
                                                      .visibility_off_outlined,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                        style: ed14,
                                        textInputAction: TextInputAction.next,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 15, 0, 0),
                                  child: Container(
                                    width: double.infinity,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      color: const Color(0x5F2D2D2D),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              15, 0, 0, 0),
                                      child: TextFormField(
                                        controller: confirmpwd,
                                        autofocus: false,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          hintText: 'Confirm Password',
                                          hintStyle: ee14,
                                          enabledBorder:
                                              const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(4.0),
                                              topRight: Radius.circular(4.0),
                                            ),
                                          ),
                                          focusedBorder:
                                              const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(4.0),
                                              topRight: Radius.circular(4.0),
                                            ),
                                          ),
                                          errorBorder:
                                              const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(4.0),
                                              topRight: Radius.circular(4.0),
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(4.0),
                                              topRight: Radius.circular(4.0),
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsetsDirectional
                                                  .fromSTEB(0, 0, 0, 0),
                                        ),
                                        style: ed14,
                                        textInputAction: TextInputAction.done,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 50, 0, 0),
                                    child: Row(children: [
                                      Expanded(
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 5),
                                              child: Material(
                                                color: Colors.transparent,
                                                elevation: 16,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Material(
                                                  color: const Color.fromARGB(
                                                      255, 110, 84, 0),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  child: InkWell(
                                                    onTap: () async {
                                                      await loadingscreen(
                                                          context);
                                                      if (await changepwd(
                                                          oldpwd.text,
                                                          newpassword.text,
                                                          confirmpwd.text)) {
                                                        if (widget.type
                                                                .toLowerCase() ==
                                                            'new') {
                                                          Navigator
                                                              .pushAndRemoveUntil(
                                                                  context,
                                                                  PageTransition(
                                                                    type: PageTransitionType
                                                                        .leftToRight,
                                                                    duration: const Duration(
                                                                        milliseconds:
                                                                            200),
                                                                    reverseDuration:
                                                                        const Duration(
                                                                            milliseconds:
                                                                                200),
                                                                    child:
                                                                        const Login(),
                                                                  ),
                                                                  ModalRoute
                                                                      .withName(
                                                                          "/Login"));
                                                        } else {
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          // Navigator
                                                          //     .pushAndRemoveUntil(
                                                          //         context,
                                                          //         PageTransition(
                                                          //           type: PageTransitionType
                                                          //               .leftToRight,
                                                          //           duration: const Duration(
                                                          //               milliseconds:
                                                          //                   200),
                                                          //           reverseDuration:
                                                          //               const Duration(
                                                          //                   milliseconds:
                                                          //                       200),
                                                          //           child:
                                                          //               const Profile(),
                                                          //         ),
                                                          //         ModalRoute
                                                          //             .withName(
                                                          //                 "/Profile"));
                                                        }
                                                      }
                                                    },
                                                    child: Container(
                                                      width: double.infinity,
                                                      height: 50,
                                                      decoration:
                                                          const BoxDecoration(),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            'Continue',
                                                            style: w16,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ))),
                                      Expanded(
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              child: Material(
                                                color: Colors.transparent,
                                                elevation: 16,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Material(
                                                  color: Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  child: InkWell(
                                                    onTap: () async {
                                                      if (widget.type
                                                              .toLowerCase() ==
                                                          'new') {
                                                        Navigator
                                                            .pushAndRemoveUntil(
                                                                context,
                                                                PageTransition(
                                                                  type: PageTransitionType
                                                                      .leftToRight,
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          200),
                                                                  reverseDuration:
                                                                      const Duration(
                                                                          milliseconds:
                                                                              200),
                                                                  child:
                                                                      const Login(),
                                                                ),
                                                                ModalRoute
                                                                    .withName(
                                                                        "/Login"));
                                                      } else {
                                                        Navigator.pop(context);
                                                        // Navigator
                                                        //     .pushAndRemoveUntil(
                                                        //         context,
                                                        //         PageTransition(
                                                        //           type: PageTransitionType
                                                        //               .leftToRight,
                                                        //           duration: const Duration(
                                                        //               milliseconds:
                                                        //                   200),
                                                        //           reverseDuration:
                                                        //               const Duration(
                                                        //                   milliseconds:
                                                        //                       200),
                                                        //           child:
                                                        //               const Profile(),
                                                        //         ),
                                                        //         ModalRoute.withName(
                                                        //             "/Profile"));
                                                      }
                                                    },
                                                    child: Container(
                                                      width: double.infinity,
                                                      height: 50,
                                                      decoration:
                                                          const BoxDecoration(),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            'Cancel',
                                                            style: w16,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ))),
                                    ])),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
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
                            style: e7512,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  cleardata() {
    Navigator.pop(context);
  }
}
