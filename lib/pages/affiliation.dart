import 'dart:convert';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../components/fonts.dart';
import '../localstore/systemsetup/appsettings.dart';

class Affiliation extends StatefulWidget {
  const Affiliation({super.key});

  @override
  State<Affiliation> createState() => _AffiliationState();
}

class _AffiliationState extends State<Affiliation> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  TextStyle dcH9 =
      fontWithheight(14, const Color(0xFFDCDCDC), 0, FontWeight.w600);
  TextStyle ed10 = fontFile(10, const Color(0xFFEDEDED), 0, FontWeight.w600);
  TextStyle ed11 =
      fontWithheight(11, const Color(0xFFEDEDED), 1, FontWeight.w600);
  TextStyle ed12 =
      fontWithheight(12, const Color(0xFFEDEDED), 0, FontWeight.w600);
  TextStyle ed14 = fontFile(12, const Color(0xFFA8ABBD), 0, FontWeight.w600);
  TextStyle ed16 = fontFile(16, const Color(0xFFEDEDED), 0, FontWeight.bold);
  TextStyle w18 =
      fontWithheight(18, const Color(0xFFFFFFFF), 0, FontWeight.w800);
  TextStyle w7f13 =
      fontWithheight(13, const Color(0xFF7F7F7F), 1, FontWeight.w800);
  TextStyle w7e13 =
      fontWithheight(13, const Color(0xFFEDEDED), 1, FontWeight.w800);

  late TextEditingController search;

  @override
  void initState() {
    super.initState();
    search = TextEditingController();
    getAffiliatedClubs();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool loadscreen = false;
  List allclubList = [];
  List filterclubs = [];

  Future getAffiliatedClubs() async {
    setState(() {
      allclubList = [];
      filterclubs = [];
      loadscreen = false;
    });
    Map<String, dynamic> senddata = {
      "DBName": dbName,
      "DBUser": dbUser,
    };

    String data = json.encode(senddata);
    // print(data);
    String url =
        "https://eskaysoftech.com/CLUB_MEMBER_API/tran files/affilatedmember.php";

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
    //  print(dbody);
    if (dbody['result']) {
      setState(() {
        allclubList = dbody['data'];
        filterclubs = allclubList;
      });
    }
    setState(() {
      loadscreen = true;
    });
  }

  Future searchdata(String val) async {
    List searchlst = [];
    if (val != '') {
      // filterclubs = [];
      for (var c in allclubList) {
        if (c['membername']
                .toString()
                .toLowerCase()
                .contains(val.toLowerCase()) ||
            c['mobile1'].toString().toLowerCase().contains(val.toLowerCase()) ||
            c['mobile2'].toString().toLowerCase().contains(val.toLowerCase()) ||
            c['address'].toString().toLowerCase().contains(val.toLowerCase()) ||
            c['phone'].toString().toLowerCase().contains(val.toLowerCase())) {
          searchlst.add(c);
        }
      }
      setState(() {
        filterclubs = searchlst;
      });
    } else {
      setState(() {
        filterclubs = allclubList;
      });
    }
  }

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
            padding: const EdgeInsetsDirectional.fromSTEB(15, 35, 15, 15),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            // Navigator.pushAndRemoveUntil(
                            //     context,
                            //     PageTransition(
                            //       type: PageTransitionType.rightToLeft,
                            //       duration: const Duration(milliseconds: 200),
                            //       reverseDuration:
                            //           const Duration(milliseconds: 200),
                            //       child: const Dashboard(),
                            //     ),
                            //     ModalRoute.withName("/Home"));
                          },
                          child: Container(
                              width: 30,
                              child: const Icon(
                                Icons.arrow_back_rounded,
                                color: Color(0xFFEDEDED),
                                size: 25,
                              )),
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(15, 0, 0, 0),
                          child: Text(
                            'Affiliated Clubs',
                            style: ed16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 10),
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF181818),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                      child: TextFormField(
                        controller: search,
                        autofocus: false,
                        obscureText: false,
                        onChanged: (value) => searchdata(value),
                        decoration: InputDecoration(
                          hintText: 'SEARCH CLUBS',
                          hintStyle: w7f13,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          contentPadding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                        ),
                        style: w7e13,
                      ),
                    ),
                  ),
                ),
                loadscreen
                    ? allclubList.isNotEmpty
                        ? Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 0, 0),
                              child: Container(
                                width: double.infinity,
                                height: 100,
                                decoration: const BoxDecoration(),
                                child: ListView(
                                  padding: EdgeInsets.zero,
                                  scrollDirection: Axis.vertical,
                                  children: [
                                    ...filterclubs.map(
                                      (e) => Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 0, 0, 15),
                                        child: Container(
                                          width: double.infinity,
                                          height: 124,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF181818),
                                            borderRadius:
                                                BorderRadius.circular(2),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(15, 15, 15, 15),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    width: 100,
                                                    height: 100,
                                                    decoration:
                                                        const BoxDecoration(),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                              0, 0, 10, 0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            e['membername']
                                                                .toString(), //'THE ALLEPPEY UNITED CLUB',
                                                            style: ed16,
                                                          ),
                                                          Text(
                                                            e['address']
                                                                .toString(), //'Beach Road, Sea-view ALLEPPEY Kerala India',
                                                            style: ed14,
                                                          ),
                                                          if (e['mobile1']
                                                                      .toString() !=
                                                                  '' ||
                                                              e['mobile2']
                                                                      .toString() !=
                                                                  '')
                                                            Expanded(
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Text(
                                                                    e['mobile1']
                                                                        .toString(), //'0477-2243688',
                                                                    style: dcH9,
                                                                  ),
                                                                  if (e['phone']
                                                                          .toString() !=
                                                                      '')
                                                                    Text(
                                                                      ', ',
                                                                      style:
                                                                          dcH9,
                                                                    ),
                                                                  Text(
                                                                    e['phone']
                                                                        .toString(), //'0477-2243688',
                                                                    style: dcH9,
                                                                  ),
                                                                  if (e['mobile2']
                                                                          .toString() !=
                                                                      '')
                                                                    Text(
                                                                      ', ',
                                                                      style:
                                                                          dcH9,
                                                                    ),
                                                                  Text(
                                                                    e['mobile2']
                                                                        .toString(), //'0477-2243688',
                                                                    style: dcH9,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 40,
                                                  height: 100,
                                                  decoration:
                                                      const BoxDecoration(),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        width: 100,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color(
                                                              0xFF545454),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(2),
                                                        ),
                                                        child: const Icon(
                                                          Icons.map_outlined,
                                                          color:
                                                              Color(0xFFE1D9D9),
                                                          size: 24,
                                                        ),
                                                      ),
                                                      InkWell(
                                                          onTap: () async {
                                                            if (e['mobile1']
                                                                        .toString() !=
                                                                    '' &&
                                                                e['mobile1'] !=
                                                                    null) {
                                                              FlutterPhoneDirectCaller
                                                                  .callNumber(e[
                                                                          'mobile1']
                                                                      .toString()
                                                                      .trim());
                                                            } else if (e['mobile2']
                                                                        .toString() !=
                                                                    '' &&
                                                                e['mobile2'] !=
                                                                    null) {
                                                              FlutterPhoneDirectCaller
                                                                  .callNumber(e[
                                                                          'mobile2']
                                                                      .toString()
                                                                      .trim());
                                                            } else if (e['phone']
                                                                        .toString() !=
                                                                    '' &&
                                                                e['phone'] !=
                                                                    null) {
                                                              FlutterPhoneDirectCaller
                                                                  .callNumber(e[
                                                                          'phone']
                                                                      .toString()
                                                                      .trim());
                                                            }
                                                          },
                                                          child: Container(
                                                            width: 100,
                                                            height: 40,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: const Color(
                                                                  0xFF545454),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          2),
                                                            ),
                                                            child: const Icon(
                                                              Icons
                                                                  .local_phone_outlined,
                                                              color: Color(
                                                                  0xFFE1D9D9),
                                                              size: 24,
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Expanded(
                            child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                child: Column(
                                  children: [
                                    Text(
                                      "No Clubs Available",
                                      style: ed16,
                                    )
                                  ],
                                )))
                    : const Expanded(
                        child: Center(
                            child: CircularProgressIndicator(
                        color: Colors.yellow,
                      ))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
