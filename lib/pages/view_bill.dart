import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import '../components/fonts.dart';
import '../functions/app_func.dart';
import '../localstore/global_var.dart';

class ViewStatement extends StatefulWidget {
  final data;
  const ViewStatement({required this.data, super.key});

  @override
  State<ViewStatement> createState() => _ViewStatementState();
}

class _ViewStatementState extends State<ViewStatement> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  TextStyle dc9 = fontWithheight(9, Color(0xFFDCDCDC), 0, FontWeight.w600);
  TextStyle ed10 = fontFile(10, Color(0xFFEDEDED), 0, FontWeight.w600);
  TextStyle edH11 = fontWithheight(11, Color(0xFFEDEDED), 1, FontWeight.w600);
  TextStyle edH12red =
      fontWithheight(12, Color(0xFFFF0000), 1, FontWeight.w600);
  TextStyle edH12green =
      fontWithheight(12, Color(0xFF35FF00), 1, FontWeight.w600);
  TextStyle ed12 = fontFile(12, Color(0xFFEDEDED), 0, FontWeight.w600);
  TextStyle ed14 = fontFile(14, Color(0xFFEDEDED), 0, FontWeight.w600);
  TextStyle ed16 = fontFile(16, Color(0xFFEDEDED), 0, FontWeight.bold);
  TextStyle w18 = fontWithheight(18, Color(0xFFFFFFFF), 0, FontWeight.w800);

  TextStyle ED18 =
      fontWithheight(18, const Color(0xFFEDEDED), 1, FontWeight.bold);
  TextStyle FF12 = fontFile(12, const Color(0xFFFFFFFF), 0, FontWeight.w600);
  TextStyle FFH12 =
      fontWithheight(12, const Color(0xFFFFFFFF), 0, FontWeight.w600);
  TextStyle FF16 = fontFile(16, const Color(0xFFFFFFFF), 1, FontWeight.w600);
  TextStyle OO16 = fontFile(16, const Color(0xFF000000), 1, FontWeight.bold);
  TextStyle AA8F12 = fontFile(12, const Color(0xAA8F8F8F), 1, FontWeight.w600);
  TextStyle FF18 = fontFile(18, const Color(0xFFEDEDED), 1, FontWeight.bold);
  TextStyle F5C18 =
      fontFile(14, Color.fromARGB(255, 172, 172, 172), 0, FontWeight.bold);
  TextStyle FF5C18 = fontFile(14, const Color(0xFFEDEDED), 0, FontWeight.bold);
  TextStyle ED14 =
      fontWithheight(14, const Color(0xFFEDEDED), 1, FontWeight.bold);
  TextStyle ED16 =
      fontWithheight(16, const Color(0xFFEDEDED), 1, FontWeight.bold);
  TextStyle W8F14 =
      fontWithheight(14, const Color(0xFF8F8F8F), 1, FontWeight.bold);

  TextStyle black24 = fontFile(18, const Color(0xFF000000), 0, FontWeight.bold);
  TextStyle whiteED20 =
      fontWithheight(18, const Color(0xFFEDEDED), 1, FontWeight.bold);
  TextStyle bc18 = fontFile(18, const Color(0xFF000000), 0, FontWeight.bold);
  TextStyle b2512 =
      fontWithheight(10, const Color(0xFF252525), 0, FontWeight.bold);
  TextStyle ff12 =
      fontWithheight(10, const Color(0xFFffffff), 0, FontWeight.bold);
  TextStyle ff13 =
      fontWithheight(11, const Color(0xFF000000), 0, FontWeight.bold);
  TextStyle ff14 =
      fontWithheight(11, const Color(0xFFffffff), 0, FontWeight.bold);
  TextStyle dblack18 =
      fontWithheight(12, Color(0xFF000000), 0, FontWeight.w600);
  TextStyle ddblack18 =
      fontWithheight(14, Color(0xFF000000), 0, FontWeight.w600);
  TextStyle dwh14 = fontWithheight(12, Color(0xFFEDEDED), 0, FontWeight.w600);
  TextStyle dwh16 = fontWithheight(15, Color(0xFFEDEDED), 0, FontWeight.w600);
  TextStyle da5h16 = fontWithheight(14, Color(0xFFA5A5A5), 0, FontWeight.w600);

  var bill;
  double disrate = 0;
  double distax = 0;
  double disamount = 0;

  @override
  void initState() {
    super.initState();
    bill = widget.data;
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  double pagewidth = 0;
  double pageheight = 0;
  @override
  Widget build(BuildContext context) {
    pagewidth = MediaQuery.of(context).size.width;
    pageheight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
        backgroundColor: Colors.black,
        /*    floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat, */
        appBar: AppBar(
          toolbarHeight: 30,
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
                // Navigator.push(
                //   context,
                //   PageTransition(
                //     type: PageTransitionType.rightToLeft,
                //     duration: Duration(milliseconds: 200),
                //     reverseDuration: Duration(milliseconds: 200),
                //     child: Bills(),
                //   ),
                // );
              },
              child: Container(
                  width: 20,
                  height: double.infinity,
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ))),
          title: Text(
            "Bill ${datetime('monthf', bill['start'].toString())} - ${datetime('monthf', bill['end'].toString())}",
            style: ed16,
          ),
        ),
        /*  floatingActionButton: FloatingActionButton(
          mini: true,
          child: Container(
              //margin: EdgeInsets.only(right: 15),
              child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          )),
          backgroundColor: Colors.black,
          onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 200),
                reverseDuration: Duration(milliseconds: 200),
                child: Bills(),
              ),
              ModalRoute.withName("/Bills")),
        ), */
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(),
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /*   Container(
                    width: double.infinity,
                    height: 35,
                    child: Row(children: [
                      InkWell(
                          onTap: () {
                            //Navigator.pop(context);
                            Navigator.pushAndRemoveUntil(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  duration: Duration(milliseconds: 200),
                                  reverseDuration: Duration(milliseconds: 200),
                                  child: Bills(),
                                ),
                                ModalRoute.withName("/Bills"));
                          },
                          child: Container(
                              margin: EdgeInsets.only(right: 15),
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ))),
                      Expanded(
                          child: Text(
                        "Bill ${datetime('monthf', bill['start'].toString())} - ${datetime('monthf', bill['end'].toString())}",
                        style: ED18,
                      ))
                    ])), */
                Expanded(
                    child: Material(
                  color: Colors.transparent,
                  elevation: 16,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Container(
                    width: pagewidth > 1024 ? pagewidth * 0.50 : pagewidth,
                    height: pageheight ,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Padding(
                      padding: pagewidth > 1024
                          ? EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20)
                          : EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          flagShopDetails['logo'] != null &&
                                  flagShopDetails['logo'].toString() != ''
                              ? Image.memory(
                                  base64Decode(
                                      flagShopDetails['logo'].toString()),
                                  gaplessPlayback: true,
                                  width: 150,
                                  height: 120,
                                )
                              : Image.asset(
                                  'media/logo.png',
                                  width: 150,
                                  height: 120,
                                  fit: BoxFit.contain,
                                ),
                          // Padding(
                          //   padding: EdgeInsetsDirectional.fromSTEB(
                          //       10, 0, 0, 0),
                          //   child: Text(
                          //     'BELGAUM CLUB',
                          //     style: bc18,
                          //   ),
                          // ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                            child: Container(
                              width: double.infinity,
                              height: 35,
                              decoration: BoxDecoration(
                                color: Color(0xFFEDEDED),
                              ),
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      flagShopDetails['address']
                                          .toString(), //'Club Road, Belagavi - 590001 Tel : 0831-2420532',
                                      style: b2512,
                                    ),
                                    Text(
                                      flagShopDetails['address1']
                                          .toString(), //' Email : info@belgaumclub.in GST No. 29AAAAB5928M1ZD',
                                      style: b2512,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                            child: Container(
                              width: double.infinity,
                              height: 25,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(0, 237, 237, 237),
                              ),
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Bill Details : ${datetime('monthf', bill['start'].toString())} - ${datetime('monthf', bill['end'].toString())}',
                                      style: b2512,
                                    ),
                                    Text(
                                      '${bill["memberid"]} | ${bill["membername"]}',
                                      style: b2512,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                              width: pagewidth > 1024
                                  ? pagewidth * 0.50
                                  : pagewidth,
                              height: pageheight - (Platform.isIOS ? 330 : 280),
                              child: Column(children: [
                                Expanded(
                                    child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                      Container(
                                          width: pagewidth > 1024 ? 640 : 600,
                                          height: double.infinity,
                                          child: Column(children: [
                                            Container(
                                              width: double.infinity,
                                              height: 23,
                                              decoration: BoxDecoration(
                                                color: Color(0xFFC92C6D),
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Container(
                                                    width: 80,
                                                    height: 100,
                                                    decoration: BoxDecoration(),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'INVOICE',
                                                          style: ff12,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 70,
                                                    height: 100,
                                                    decoration: BoxDecoration(),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'DATE',
                                                          style: ff12,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      width: 100,
                                                      height: 100,
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    5, 0, 5, 0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'DETAILS',
                                                              style: ff12,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 80,
                                                    height: 100,
                                                    decoration: BoxDecoration(),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  5, 0, 5, 0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            'RATE',
                                                            style: ff12,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 50,
                                                    height: 100,
                                                    decoration: BoxDecoration(),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  5, 0, 5, 0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            'TAX',
                                                            style: ff12,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 65,
                                                    height: 100,
                                                    decoration: BoxDecoration(),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  5, 0, 5, 0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            'TAX (Rs)',
                                                            style: ff12,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 90,
                                                    height: 100,
                                                    decoration: BoxDecoration(),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  5, 0, 5, 0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            'AMOUNT',
                                                            style: ff12,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 10, 0, 10),
                                                child: Container(
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  decoration: BoxDecoration(),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: listBilldata(
                                                            bill[
                                                                'list']) //'file'),
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              height: 25,
                                              decoration: BoxDecoration(
                                                color: Color(0xFFC92C6D),
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Container(
                                                    width: 80,
                                                    height: 100,
                                                    decoration: BoxDecoration(),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'TOTAL',
                                                          style: ff14,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 70,
                                                    height: 100,
                                                    decoration: BoxDecoration(),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      width: 100,
                                                      height: 100,
                                                      decoration:
                                                          BoxDecoration(),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 80,
                                                    height: 100,
                                                    decoration: BoxDecoration(),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  5, 0, 5, 0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            disrate
                                                                .toStringAsFixed(
                                                                    2),
                                                            style: ff14,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 50,
                                                    height: 100,
                                                    decoration: BoxDecoration(),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  5, 0, 5, 0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            '',
                                                            style: ff14,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 65,
                                                    height: 100,
                                                    decoration: BoxDecoration(),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  5, 0, 5, 0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            distax
                                                                .toStringAsFixed(
                                                                    2),
                                                            style: ff14,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 90,
                                                    height: 100,
                                                    decoration: BoxDecoration(),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  5, 0, 5, 0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            disamount
                                                                .toStringAsFixed(
                                                                    2),
                                                            style: ff14,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ]))
                                    ]))
                              ]))
                        ],
                      ),
                    ),
                  ),
                ))
              ]),
        ),
      ),
    );
  }

  List<Container> listBilldata(List data) {
    List<Container> file = [];
    // totalMember = 0;
    disrate = 0;
    distax = 0;
    disamount = 0;
    int fileindex = 1;
    for (var e in data) {
      double rate = double.parse(e['rate'].toString());
      double tax = double.parse(e['taxamt'].toString());
      rate = e['withintaxyn'].toString() == "Y" ? (rate - tax) : rate;
      double amount = double.parse(e['amount'].toString());

      disrate += rate;
      distax += tax;
      disamount += amount;
      Color filecolr =
          fileindex.isEven ? Color(0xFFEDEDED) : Colors.transparent;
      file.add(Container(
        width: double.infinity,
        height: 23,
        decoration: BoxDecoration(color: filecolr),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 80,
              height: 100,
              decoration: BoxDecoration(),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    e['invoiceno'].toString(),
                    style: ff13,
                  ),
                ],
              ),
            ),
            Container(
              width: 70,
              height: 100,
              decoration: BoxDecoration(),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    datetime('date', e['trdate'].toString()),
                    style: ff13,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        e['menuitemname'].toString(),
                        overflow: TextOverflow.ellipsis,
                        style: ff13,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: 80,
              height: 100,
              decoration: BoxDecoration(),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      rate.toStringAsFixed(2),
                      style: ff13,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 50,
              height: 100,
              decoration: BoxDecoration(),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${e['tax']} %',
                      style: ff13,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 65,
              height: 100,
              decoration: BoxDecoration(),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      tax.toStringAsFixed(2),
                      style: ff13,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 90,
              height: 100,
              decoration: BoxDecoration(),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      amount.toStringAsFixed(2),
                      style: ff13,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ));
      fileindex++;
    }
    return file;
  }
}
