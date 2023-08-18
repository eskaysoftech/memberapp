import 'dart:convert';

import 'package:memberapp/components/notifypanel.dart';
import 'package:memberapp/functions/app_func.dart';
import 'package:memberapp/localstore/global_var.dart';
import 'package:memberapp/localstore/systemsetup/appsettings.dart';
import 'package:memberapp/pages/dashboard.dart';
import 'package:memberapp/pages/forgotpassword.dart';
import 'package:memberapp/pages/webview.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
import 'components/fonts.dart';
import 'localstore/logindetails.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  late TextEditingController username;
  late FocusNode userfocus;
  late TextEditingController password;
  late FocusNode passwordfocus;
  late bool passwordVisibility;
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

    username = TextEditingController();
    password = TextEditingController();
    getLoginData();
    passwordVisibility = false;
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  double width = 0;
  double height = 0;
  String clublogo = '';
  bool loadscreen = false;
  Future getLoginData() async {
    await Hive.openBox('clublogindetails');
    final suser = Hive.box("clublogindetails");
    if (suser.isNotEmpty) {
      final Map getIp = suser.toMap();
      getIp.forEach((key, value) {
        setState(() {
          username.text = value.username;
          password.text = value.password;
          remPass = true;
        });
      });
    } else {
      username = TextEditingController();
      password = TextEditingController();
    }
    final logoip = Hive.box("clublogo");
    clublogoimg = logoip.get('Logo');
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.selected,
      MaterialState.focused,
      MaterialState.pressed,
    };
    if (states.any(interactiveStates.contains)) {
      return const Color.fromARGB(255, 110, 84, 0);
    }
    return const Color(0XFFEDEDED);
  }

  Future validateUserId(String loginid) async {
    bool out = false;
    if (loginid != '') {
      if (loginid.contains('@')) {
        if (loginid.characters.where((c) => c == '@').length == 1) {
          if (!loginid.contains('/')) {
            out = true;
          } else {
            notifyPanel(context, 'W', '', 'User Name cannot contain "/".', 'OK',
                '', cleardata, cleardata);
          }
        } else {
          notifyPanel(
              context,
              'W',
              '',
              'User Name should contain only one "@".',
              'OK',
              '',
              cleardata,
              cleardata);
        }
      } else {
        notifyPanel(context, 'W', '', 'User Name should contain "@".', 'OK', '',
            cleardata, cleardata);
      }
    } else {
      notifyPanel(
          context, 'W', '', 'Enter Login ID', 'OK', '', cleardata, cleardata);
    }
    return out;
  }

  Future userlogin() async {
    bool out = false;
    Map<String, dynamic> senddata = {
      "username": username.text.trim(),
      "password": password.text,
    };

    String data = json.encode(senddata);
    //print(data);
    String url =
        "https://eskaysoftech.com/CLUB_MEMBER_API/tran files/login.php";

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
    // print(dbody);
    if (dbody['result']) {
      out = true;

      setState(() {
        dbName = dbody['data']['dbname'].toString();
        dbUser = dbody['data']['dbuser'].toString();
        var memberdata = dbody['data']['member'];
        userid = memberdata['memberid'].toString();
        userfullname =
            "${memberdata['membersalutation'].toString()} ${memberdata['membername'].toString()}";
        usermobileno = memberdata['membermobile'].toString();
        userprofileimg = memberdata['profileimage'] != null
            ? memberdata['profileimage'].toString()
            : '';
        flagApplication = dbody['data']['app'][0];
        flagShopDetails = dbody['data']['shop'][0];
        userbirthday = memberdata['birthday'].toString();
        usercategory = memberdata['category'].toString();
        useraddress = memberdata['address'].toString();
        useremail = memberdata['email'].toString();
        alldependantList = dbody['data']['dependent'];
      });
      await Hive.openBox('clublogo');
      final logoip = Hive.box("clublogo");
      logoip.put('Logo', flagShopDetails['logo'].toString());

      if (remPass) {
        final setip = Hive.box("clublogindetails");
        setip.add(Logindetails(username.text.trim(), password.text));
      }
    } else {
      Navigator.pop(context);
      notifyPanel(context, 'W', '', dbody['data'].toString(), 'OK', '',
          cleardata, cleardata);
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
                          child: clublogoimg != null &&
                                  clublogoimg.toString() != '' &&
                                  clublogoimg.toString() != 'null'
                              ? Image.memory(
                                  base64Decode(clublogoimg),
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
                                  'Login',
                                  style: f126,
                                ),
                                // Text(
                                //   'Sign in to Continue',
                                //   style: w7514,
                                // ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 30, 0, 0),
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
                                              15, 0, 10, 0),
                                      child: TextFormField(
                                        controller: username,
                                        autofocus: false,
                                        obscureText: false,
                                        onFieldSubmitted: (value) {
                                          validateUserId(value);
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'Member Id',
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
                                        controller: password,
                                        autofocus: false,
                                        obscureText: !passwordVisibility,
                                        decoration: InputDecoration(
                                          hintText: 'Password',
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
                                              () => passwordVisibility =
                                                  !passwordVisibility,
                                            ),
                                            focusNode:
                                                FocusNode(skipTraversal: true),
                                            child: Icon(
                                                passwordVisibility
                                                    ? Icons.visibility_outlined
                                                    : Icons
                                                        .visibility_off_outlined,
                                                size: 18,
                                                color: Colors.white54),
                                          ),
                                        ),
                                        style: ed14,
                                      ),
                                    ),
                                  ),
                                ),

                                Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            5, 10, 0, 0),
                                    child:
                                        // Wrap(
                                        //     spacing: 10,
                                        //     runSpacing: 10,
                                        //     alignment: WrapAlignment.start,
                                        //     crossAxisAlignment:
                                        //         WrapCrossAlignment.start,
                                        //     direction: Axis.horizontal,
                                        //     runAlignment: WrapAlignment.start,
                                        //     verticalDirection:
                                        //         VerticalDirection.down,
                                        Row(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                          Container(
                                            width: 150,
                                            height: 25,
                                            decoration: const BoxDecoration(),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                          0, 0, 10, 0),
                                                  child: Container(
                                                    width: 10,
                                                    height: double.infinity,
                                                    decoration:
                                                        const BoxDecoration(),
                                                    child: Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                                  getColor),
                                                      value: remPass,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          remPass = value!;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  'Remember Password',
                                                  style: ed11,
                                                ),
                                              ],
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              if (await validateUserId(
                                                  username.text)) {
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    PageTransition(
                                                      type: PageTransitionType
                                                          .leftToRight,
                                                      duration: const Duration(
                                                          milliseconds: 200),
                                                      reverseDuration:
                                                          const Duration(
                                                              milliseconds:
                                                                  200),
                                                      child: ForgotPwd(
                                                          loginid: username.text
                                                              .trim()),
                                                    ),
                                                    ModalRoute.withName(
                                                        "/ForgotPwd"));
                                              }
                                            },
                                            child: Container(
                                              width: 100,
                                              height: 25,
                                              decoration: const BoxDecoration(),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    'Forgot Password ?',
                                                    style: ed11,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ])),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 50, 0, 0),
                                  child: Material(
                                    color: Colors.transparent,
                                    elevation: 16,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Material(
                                      color:
                                          const Color.fromARGB(255, 110, 84, 0),
                                      borderRadius: BorderRadius.circular(5),
                                      child: InkWell(
                                        onTap: () async {
                                          if (await validateUserId(
                                              username.text)) {
                                            if (password.text != '') {
                                              loadingscreen(context);
                                              if (await userlogin()) {
                                                Navigator.pop(context);
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    PageTransition(
                                                      type: PageTransitionType
                                                          .leftToRight,
                                                      duration: const Duration(
                                                          milliseconds: 200),
                                                      reverseDuration:
                                                          const Duration(
                                                              milliseconds:
                                                                  200),
                                                      child: const Dashboard(),
                                                    ),
                                                    ModalRoute.withName(
                                                        "/Home"));
                                              }
                                            } else {
                                              notifyPanel(
                                                  context,
                                                  'W',
                                                  '',
                                                  'Enter Password',
                                                  'Ok',
                                                  '',
                                                  cleardata,
                                                  cleardata);
                                            }
                                          }
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          height: 50,
                                          decoration: const BoxDecoration(),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
                            url: 'https://www.eskaysoftech.com',
                            dash: false,
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
