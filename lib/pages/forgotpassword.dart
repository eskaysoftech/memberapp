import 'dart:async';
import 'dart:convert';
import 'package:memberapp/components/notifypanel.dart';
import 'package:memberapp/login.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
import '../components/fonts.dart';
import '../localstore/global_var.dart';
import '../localstore/systemsetup/appsettings.dart';
import 'changepassword.dart';

class ForgotPwd extends StatefulWidget {
  final String loginid;
  const ForgotPwd({required this.loginid, super.key});

  @override
  State<ForgotPwd> createState() => _ForgotPwdState();
}

class _ForgotPwdState extends State<ForgotPwd> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  late TextEditingController otp;
  late FocusNode otpfocus;

  TextStyle f126 = fontFile(18, Color(0xFFF1EEE9), 2, FontWeight.bold);
  TextStyle w7514 = fontFile(11, Color(0xFF757575), 0, FontWeight.bold);
  TextStyle ed14 =
      fontFile(13, Color.fromARGB(255, 170, 170, 170), 1, FontWeight.w600);
  TextStyle ee14 =
      fontFile(13, Color.fromARGB(255, 170, 170, 170), 1, FontWeight.w600);
  TextStyle ed11 = fontWithheight(10, Color(0xFFEDEDED), 0, FontWeight.bold);
  TextStyle e7512 = fontWithheight(11, Color(0xFF757575), 0, FontWeight.bold);
  TextStyle w16 = fontFile(14, Color(0xFFFFFFFF), 1, FontWeight.w800);
  TextStyle logo = cmlogo(16, Color(0xFFFFFFFF));
  @override
  void initState() {
    super.initState();
    otp = TextEditingController();
    getOTP();
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
    if (timer.isActive) {
      timer.cancel();
    }
  }

  double width = 0;
  double height = 0;
  String generatedOtp = '';
  String mobileno = '';
  String memberid = '';
  bool showresend = false;
  String smsresponse = '';
  int starttimer = 1;
  Timer timer = Timer(Duration(seconds: 0), () {});
  bool loadscreen = false;
  String smsurl = "";

  Future getOTP() async {
    Map<String, dynamic> senddata = {
      "username": widget.loginid.toString(),
    };

    String data = json.encode(senddata);
    // print(data);
    String url =
        "https://eskaysoftech.com/CLUB_MEMBER_API/tran files/generateotp.php";

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
      setState(() {
        generatedOtp = dbody['data']['otpno'].toString();
        memberid = dbody['data']['memberid'].toString();
        loadscreen = true;
      });
      mobileno = dbody['data']['membermobile'].toString();
      dbName = dbody['data']['dbname'].toString();
      dbUser = dbody['data']['dbuser'].toString();
      smsurl = dbody['data']['sms'][0]['templateapi'].toString();
    }
    if (mobileno == '' || mobileno.length != 10) {
      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            type: PageTransitionType.leftToRight,
            duration: Duration(milliseconds: 200),
            reverseDuration: Duration(milliseconds: 200),
            child: Login(),
          ),
          ModalRoute.withName("/Login"));
      notifyPanel(
          context,
          'W',
          '',
          'Please register your mobile number through Club Office.',
          '',
          '',
          cleardata,
          cleardata);
    }
  }

  Future sendOTP() async {
    if (smsurl.isNotEmpty) {
      showresend = false;
      timer = Timer(const Duration(seconds: 40), () {
        setState(() {
          showresend = true;
          timer.cancel();
        });
      });

      String url = smsurl.replaceAll('#mobile#', mobileno);
      url = url.replaceAll('#otp#', generatedOtp);
      /*  String url =
        // "https://api.msg91.com/api/sendhttp.php?authkey=230416A7pXsPjE5b695c05&sender=BGMCLB&mobiles=8217345256&route=4&message=Dear Mr.1234, Your Credit balance for the month of 12341234 is Rs.1234. This is for your information. Belgaum Club&DLT_TE_ID=1307162581367019307";
        //"https://api.msg91.com/api/sendhttp.php?authkey=230416A7pXsPjE5b695c05&sender=BGMCLB&mobiles=9448920928&route=4&message=Dear member, use this One Time Password 1234(OTP) to log in to your BELGAUM CLUB member account.&DLT_TE_ID=1307169158491286407";
    //  */
      print(url);

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Credentials":
              "true", // Required for cookies, authorization headers with HTTPS
          "Access-Control-Allow-Headers":
              "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
          "Access-Control-Allow-Methods": "POST, OPTIONS"
        },
      );
      final dbody = response.body;
      //print(dbody);
      setState(() {
        smsresponse = dbody.toString();
      });
    } else {
      notifyPanel(
          context,
          'W',
          '',
          'SMS Service Unavailable in App. Please Contact Belgaum Club.',
          'OK',
          '',
          cleardata,
          cleardata);
    }
  }

  Future validateOTP(String value) async {
    bool out = false;
    if (value != '') {
      if (value == generatedOtp) {
        Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
              type: PageTransitionType.leftToRight,
              duration: Duration(milliseconds: 200),
              reverseDuration: Duration(milliseconds: 200),
              child: ChangePwd(type: 'new', loginid: memberid.toString()),
            ),
            ModalRoute.withName("/ChangePwd"));
      } else {
        notifyPanel(context, 'W', '', 'OTP does not match', 'OK', '', cleardata,
            cleardata);
      }
    } else {
      notifyPanel(
          context, 'W', '', 'Enter OTP', 'OK', '', cleardata, cleardata);
    }

    return out;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return loadscreen
        ? GestureDetector(
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
                  padding: EdgeInsetsDirectional.fromSTEB(0, topMargin, 0, bottomMargin),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: double.infinity,
                          height: (height - (45 + 15 + 35)),
                          decoration: BoxDecoration(),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                  height: 100,
                                  decoration: BoxDecoration(),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // Text(
                                      //   'Welcome back,',
                                      //   style: f126,
                                      // ),
                                      Text(
                                        'Forgot Password',
                                        style: f126,
                                      ),
                                      // Text(
                                      //   'Sign in to Continue',
                                      //   style: w7514,
                                      // ),
                                      Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 50, 0, 0),
                                          child: Column(
                                            children: [
                                              Text(
                                                mobileno != ''
                                                    ? "OTP will be sent to your registered mobile number ${mobileno.replaceRange(0, 6, 'XXXXXX')} "
                                                    : '',
                                                style: ed14,
                                              )
                                            ],
                                          )),
                                      if (smsresponse == '')
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 50, 0, 0),
                                          child: Material(
                                            color: Colors.transparent,
                                            elevation: 16,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Row(children: [
                                              Expanded(
                                                  child: Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 5),
                                                      child: Material(
                                                        color: Color.fromARGB(
                                                            255, 110, 84, 0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        child: InkWell(
                                                          onTap: () async {
                                                            await sendOTP();
                                                          },
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            height: 50,
                                                            decoration:
                                                                BoxDecoration(),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                smsresponse ==
                                                                        ''
                                                                    ? Text(
                                                                        'Send OTP',
                                                                        style:
                                                                            w16,
                                                                      )
                                                                    : CircularProgressIndicator(
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ))),
                                              Expanded(
                                                  child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 5),
                                                      child: Material(
                                                        color: Colors.grey,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        child: InkWell(
                                                          onTap: () async {
                                                            Navigator
                                                                .pushAndRemoveUntil(
                                                                    context,
                                                                    PageTransition(
                                                                      type: PageTransitionType
                                                                          .leftToRight,
                                                                      duration: Duration(
                                                                          milliseconds:
                                                                              200),
                                                                      reverseDuration:
                                                                          Duration(
                                                                              milliseconds: 200),
                                                                      child:
                                                                          Login(),
                                                                    ),
                                                                    ModalRoute
                                                                        .withName(
                                                                            "/Login"));
                                                          },
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            height: 50,
                                                            decoration:
                                                                BoxDecoration(),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
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
                                                      )))
                                            ]),
                                          ),
                                        ),
                                      if (smsresponse != '')
                                        Expanded(
                                            child: Padding(
                                                padding:
                                                    EdgeInsetsDirectional.fromSTEB(
                                                        0, 50, 0, 0),
                                                child: Container(
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    child: Wrap(
                                                        spacing: 10,
                                                        runSpacing: 10,
                                                        alignment: WrapAlignment
                                                            .center,
                                                        crossAxisAlignment:
                                                            WrapCrossAlignment
                                                                .start,
                                                        direction:
                                                            Axis.horizontal,
                                                        runAlignment:
                                                            WrapAlignment.start,
                                                        verticalDirection:
                                                            VerticalDirection
                                                                .down,
                                                        children: [
                                                          Container(
                                                            width: showresend
                                                                ? 120
                                                                : 250,
                                                            height: 40,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  0x5F2D2D2D),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          15,
                                                                          0,
                                                                          10,
                                                                          0),
                                                              child:
                                                                  TextFormField(
                                                                controller: otp,
                                                                autofocus:
                                                                    false,
                                                                obscureText:
                                                                    false,
                                                                onFieldSubmitted:
                                                                    (value) {
                                                                  validateOTP(
                                                                      value);
                                                                },
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      'Enter OTP',
                                                                  hintStyle:
                                                                      ee14,
                                                                  enabledBorder:
                                                                      UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Color(
                                                                          0x00000000),
                                                                      width: 1,
                                                                    ),
                                                                    borderRadius:
                                                                        const BorderRadius
                                                                            .only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              4.0),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              4.0),
                                                                    ),
                                                                  ),
                                                                  focusedBorder:
                                                                      UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Color(
                                                                          0x00000000),
                                                                      width: 1,
                                                                    ),
                                                                    borderRadius:
                                                                        const BorderRadius
                                                                            .only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              4.0),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              4.0),
                                                                    ),
                                                                  ),
                                                                  errorBorder:
                                                                      UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Color(
                                                                          0x00000000),
                                                                      width: 1,
                                                                    ),
                                                                    borderRadius:
                                                                        const BorderRadius
                                                                            .only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              4.0),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              4.0),
                                                                    ),
                                                                  ),
                                                                  focusedErrorBorder:
                                                                      UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Color(
                                                                          0x00000000),
                                                                      width: 1,
                                                                    ),
                                                                    borderRadius:
                                                                        const BorderRadius
                                                                            .only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              4.0),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              4.0),
                                                                    ),
                                                                  ),
                                                                  contentPadding:
                                                                      EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              7),
                                                                ),
                                                                style: ed14,
                                                                textInputAction:
                                                                    TextInputAction
                                                                        .next,
                                                              ),
                                                            ),
                                                          ),
                                                          if (showresend)
                                                            InkWell(
                                                              onTap: () async {
                                                                await getOTP();
                                                                await sendOTP();
                                                              },
                                                              child: Container(
                                                                width: 120,
                                                                height: 40,
                                                                decoration:
                                                                    BoxDecoration(),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                        'Resend OTP',
                                                                        style: TextStyle(
                                                                            color: Color.fromARGB(
                                                                              255,
                                                                              110,
                                                                              84,
                                                                              0,
                                                                            ),
                                                                            overflow: TextOverflow.ellipsis)),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          Material(
                                                              color: Colors
                                                                  .transparent,
                                                              elevation: 16,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              child: Material(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        110,
                                                                        84,
                                                                        0),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                child: InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    validateOTP(
                                                                        otp.text);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    width: 120,
                                                                    height: 40,
                                                                    decoration:
                                                                        BoxDecoration(),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          'Submit',
                                                                          style:
                                                                              w16,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              )),
                                                          Material(
                                                            color: Colors.grey,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            child: InkWell(
                                                              onTap: () async {
                                                                Navigator
                                                                    .pushAndRemoveUntil(
                                                                        context,
                                                                        PageTransition(
                                                                          type:
                                                                              PageTransitionType.leftToRight,
                                                                          duration:
                                                                              Duration(milliseconds: 200),
                                                                          reverseDuration:
                                                                              Duration(milliseconds: 200),
                                                                          child:
                                                                              Login(),
                                                                        ),
                                                                        ModalRoute.withName(
                                                                            "/Login"));
                                                              },
                                                              child: Container(
                                                                width: 120,
                                                                height: 40,
                                                                decoration:
                                                                    BoxDecoration(),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      'Cancel',
                                                                      style:
                                                                          w16,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ]))))
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
                          decoration: BoxDecoration(),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
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
                                  padding: EdgeInsetsDirectional.fromSTEB(
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
          )
        : Container(
            child: Center(
                child: CircularProgressIndicator(
              color: Colors.yellow,
            )),
          );
  }

  cleardata() {
    Navigator.pop(context);
  }
}
