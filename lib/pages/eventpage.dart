// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_is_empty

import 'dart:convert';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:memberapp/functions/app_func.dart';
import 'package:memberapp/pages/webview.dart';
import 'package:page_transition/page_transition.dart';
import '../components/fonts.dart';
import '../localstore/systemsetup/appsettings.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
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
  TextStyle b22 =
      fontWithheight(26, const Color(0xFF6528F7), 1, FontWeight.bold);
  TextStyle b18 =
      fontWithheight(18, const Color(0xFF252525), 1, FontWeight.w800);
  TextStyle bb18 = fontFile(22, const Color(0xFF000000), 1, FontWeight.bold);
  TextStyle b5416 =
      fontFile(13, Color.fromARGB(255, 147, 147, 147), 0, FontWeight.w800);
  TextStyle da5h12 = fontFile(14, Color(0xFF545454), 0, FontWeight.w600);

  late TextEditingController search;

  @override
  void initState() {
    super.initState();
    search = TextEditingController();
    getEventsList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool loadscreen = false;
  List eventList = [];
  List filterclubs = [];

  Future getEventsList() async {
    setState(() {
      eventList = [];
      filterclubs = [];
      loadscreen = false;
    });
    Map<String, dynamic> senddata = {
      "DBName": dbName,
      "DBUser": dbUser,
      "cdate": datetime('dbdate', DateTime.now().toString())
    };

    String data = json.encode(senddata);
    String url =
        "https://eskaysoftech.com/CLUB_MEMBER_API/tran files/event.php";

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
        eventList = dbody['data'];
        filterclubs = eventList;
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
      for (var c in eventList) {
        if (c['title'].toString().toLowerCase().contains(val.toLowerCase()) ||
            c['eventdate']
                .toString()
                .toLowerCase()
                .contains(val.toLowerCase())) {
          searchlst.add(c);
        }
      }
      setState(() {
        filterclubs = searchlst;
      });
    } else {
      setState(() {
        filterclubs = eventList;
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
            padding:
                EdgeInsetsDirectional.fromSTEB(15, topMargin, 15, bottomMargin),
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
                            'Upcoming Events',
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
                          hintText: 'SEARCH EVENT',
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
                    ? eventList.isNotEmpty
                        ? Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  5, 10, 5, 10),
                              child: Container(
                                width: double.infinity,
                                height: 100,
                                decoration: const BoxDecoration(),
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  scrollDirection: Axis.vertical,
                                  itemCount: filterclubs.length,
                                  itemBuilder: (context, index) =>
                                      eventBox(filterclubs[index], index),
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

  Widget eventBox(Map file, int index) {
    var imagefile;
    imagefile =
        (file['displayimage'] != null && file['displayimage'].toString() != '')
            ? base64Decode(file['displayimage'].toString())
            : null;
    return Padding(
      padding: EdgeInsetsDirectional.only(
          bottom: 30, top: imagefile == null ? 50 : 0),
      child: Column(
        children: [
          if (imagefile != null)
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              child: Image.memory(
                imagefile,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
            ),
          Material(
            elevation: 16,
            color: Color(0xFFEDEDED),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(imagefile != null ? 0 : 10),
                topRight: Radius.circular(imagefile != null ? 0 : 10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            child: Container(
              width: double.infinity,
              height: file['flag'] == 'Y'
                  ? 320
                  : file['description'].toString().length > 0
                      ? 170
                      : 150,
              decoration: BoxDecoration(),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(15, 30, 15, 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              file['title'],
                              style: bb18,
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.only(top: 5, bottom: 5),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.map_outlined,
                                    color: Color(0xFF545454),
                                    size: 16,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsetsDirectional.only(start: 5),
                                    child: Text(
                                      file['eventlocation'],
                                      style: b5416,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.only(top: 5, bottom: 5),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    color: Color(0xFF545454),
                                    size: 16,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsetsDirectional.only(start: 5),
                                    child: Text(
                                      file['eventtime'],
                                      style: b5416,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            if (file['flag'] == 'Y')
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 10, 0, 5),
                                child: Container(
                                    width: double.infinity,
                                    height: 140,
                                    // color: Colors.red,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Text(
                                            file['description'].toString(),
                                            style: da5h12,
                                            textAlign: TextAlign.start,
                                          )
                                        ],
                                      ),
                                    )),
                              ),
                            if (file['description'].toString().length > 0)
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.only(
                                      top: 5, bottom: 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.only(
                                            start: 5),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              file['flag'] = file['flag'] == 'Y'
                                                  ? 'N'
                                                  : 'Y';
                                            });
                                          },
                                          child: Text(
                                            file['flag'] == 'Y'
                                                ? 'See Less'
                                                : 'See More',
                                            style: b5416,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        file['flag'] == 'Y'
                                            ? Icons.arrow_upward_rounded
                                            : Icons.arrow_downward_rounded,
                                        color: Color(0xFF545454),
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      )),
                  Positioned(
                    top: -40,
                    left: 25,
                    width: 80,
                    height: 60,
                    child: Material(
                      elevation: 8,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              datetime('odate', file['eventdate'].toString()),
                              style: b22,
                            ),
                            Text(
                              datetime(
                                  'onlymonth', file['eventdate'].toString()),
                              style: b18,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (file['eventlink'] != '')
                    Positioned(
                      bottom: 20,
                      right: 20,
                      width: 60,
                      height: 60,
                      child: Material(
                        elevation: 5,
                        color: Color(0xFF252525),
                        borderRadius: BorderRadius.circular(50),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.leftToRight,
                                duration: const Duration(milliseconds: 200),
                                reverseDuration:
                                    const Duration(milliseconds: 200),
                                child: Webview(
                                  title: file['title'],
                                  url: file['eventlink'],
                                  dash: true,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
