import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../components/fonts.dart';
import 'dart:convert';

import '../functions/app_func.dart';
import '../localstore/global_var.dart';
import '../localstore/systemsetup/appsettings.dart';

class Statement extends StatefulWidget {
  const Statement({super.key});

  @override
  State<Statement> createState() => _StatementState();
}

class _StatementState extends State<Statement> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  TextStyle dc9 = fontWithheight(9, Color(0xFFDCDCDC), 0, FontWeight.w600);
  TextStyle ed10 = fontFile(10, Color(0xFFEDEDED), 0, FontWeight.w600);
  TextStyle edH11 = fontWithheight(11, Color(0xFFEDEDED), 1, FontWeight.w600);
  TextStyle edH12red = fontWithheight(13, Color.fromARGB(255, 223, 77, 77), 1,
      FontWeight.w600); // Color.fromARGB(255, 238, 81, 81)
  TextStyle edH12green =
      fontWithheight(13, Color(0xFF35FF00), 1, FontWeight.w600);
  TextStyle ed12 = fontFile(12, Color(0xFFEDEDED), 0, FontWeight.w600);
  TextStyle ed13 = fontFile(13, Color(0xFFEDEDED), 0, FontWeight.w600);
  TextStyle ed14 = fontFile(14, Color(0xFFEDEDED), 0, FontWeight.w600);
  TextStyle ed16 = fontFile(16, Color(0xFFEDEDED), 0, FontWeight.bold);
  TextStyle w18 = fontWithheight(18, Color(0xFFFFFFFF), 0, FontWeight.w800);

  @override
  void initState() {
    super.initState();
    getStatements();
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  List transList = [];
  List alltransList = [];

  double openingbal = 0;
  double closingbal = 0;
  bool loadscreen = false;

  DateTime todt = DateTime.now();
  DateTime fromdt = DateTime(DateTime.now().year, DateTime.now().month, 1);

  Future<void> selectdate(
      BuildContext context, DateTime val, String tab) async {
    final DateTime? picked = await showDatePicker(
        keyboardType: TextInputType.datetime,
        // initialDatePickerMode: DatePickerMode.year,
        context: context,
        initialDate: val,
        firstDate: DateTime(1930, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != val) {
      setState(() {
        tab == 'F' ? fromdt = picked : todt = picked;
      });
    }
  }

  Future getStatements() async {
    setState(() {
      transList = [];
      loadscreen = false;
    });
    Map<String, dynamic> senddata = {
      "DBName": dbName,
      "DBUser": dbUser,
      "memberid": userid,
      "fromdate": '${fromdt.year}-${fromdt.month.toString().padLeft(2, '0')}',
      "todate": '${todt.year}-${todt.month.toString().padLeft(2, '0')}'
    };

    String data = json.encode(senddata);
    // print(data);
    String url =
        "https://eskaysoftech.com/CLUB_MEMBER_API/tran files/loadstatement.php";

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
        openingbal = dbody['data']['opening'][0]['opening'] != null
            ? double.parse(dbody['data']['opening'][0]['opening'].toString())
            : 0.0;
        alltransList = dbody['data']['statementtran'];
      });
    }

    if (alltransList.isNotEmpty) {
      int day = DateTime.parse(flagShopDetails['monthlycycle'].toString())
          .day; //DateTime.parse('2023-06-01')          .day; //
      DateTime trdate = DateTime(fromdt.year, fromdt.month, day);
      // DateTime transtodt = DateTime(todt.year, todt.month + 1, day - 1);
      DateTime startdate =
          DateTime.parse(datetime('dbdate', trdate.toString()));
      DateTime endMonth =
          DateTime(startdate.year, startdate.month + 1, startdate.day - 1);
      int countDay = startdate.difference(endMonth).inDays;
      DateTime firstdate = DateTime.parse(alltransList[0]['trdate'].toString());
      Map trans = {
        'month': datetime('monthnameyr', firstdate.toString()),
        'trans': [],
        'total': '',
        'closingbal': '',
      };
      // double creditamnt = 0;
      // double debitamt = 0;
      double totamt = 0;
      double closingbal = 0;
      double balamt = dbody['data']['opening'][0]['opening'] != null
          ? double.parse(dbody['data']['opening'][0]['opening'].toString())
          : 0.0;
      int countarray = alltransList.length;
      int stoparray = 1;
      for (var dt in alltransList) {
        DateTime itrdate = DateTime.parse(dt['trdate'].toString());
        int countMDay = itrdate.difference(endMonth).inDays;

        if ((countDay - countMDay) < 0) {
          startdate = DateTime(startdate.year, startdate.month,
              startdate.day - (countDay - countMDay));
          // print(day);
          if (day == 1) {
            startdate = DateTime(startdate.year, startdate.month, day);
          } else {
            startdate = double.parse(itrdate.day.toString()).toInt() >= 1
                ? DateTime(startdate.year, startdate.month, day)
                : DateTime(startdate.year, startdate.month - 1, day);
          }
          endMonth =
              DateTime(startdate.year, startdate.month + 1, startdate.day - 1);
          countDay = endMonth.difference(startdate).inDays;
        }
        countMDay = itrdate.difference(endMonth).inDays;

        if (countMDay > 0) {
          trans['closingbal'] = closingbal.toStringAsFixed(2);
          trans['total'] = totamt.toStringAsFixed(2);
          trans['month'] = datetime('monthnameyr', endMonth.toString());
          transList.add(trans);

          startdate =
              DateTime(startdate.year, startdate.month + 1, startdate.day);
          endMonth =
              DateTime(startdate.year, startdate.month + 1, startdate.day - 1);

          totamt = 0;
          //closingbal = 0;
          trans = {
            'month': '',
            'trans': [],
            'total': '',
            'closingbal': '',
          };
          closingbal = (balamt +
              ((double.parse(dt['creditamt'].toString())).roundToDouble() -
                  (double.parse(dt['debitamt'].toString()) > 0
                          ? double.parse(dt['debitamt'].toString())
                          : double.parse(dt['debitamt'].toString()) * -1)
                      .roundToDouble()));

          trans['trans'].add({
            "trdate": datetime('dbdate', dt['trdate'].toString()),
            'invoiceno': dt['invoiceno'].toString(),
            'menuitemname': dt['menuitemname'].toString(),
            'narration': dt['narration'].toString(),
            'debitamt': (double.parse(dt['debitamt'].toString()))
                .roundToDouble()
                .toStringAsFixed(2),
            'creditamt': (double.parse(dt['creditamt'].toString()))
                .roundToDouble()
                .toStringAsFixed(2),
            'balance': closingbal.toStringAsFixed(2),
            'uid': dt['uid'].toString(),
            'edatetime': dt['edatetime'].toString()
          });
          totamt += (double.parse(dt['creditamt'].toString())).roundToDouble() -
              (double.parse(dt['debitamt'].toString()) > 0
                      ? double.parse(dt['debitamt'].toString())
                      : double.parse(dt['debitamt'].toString()) * -1)
                  .roundToDouble();

          balamt = closingbal;

          if (countarray == stoparray) {
            trans['closingbal'] = closingbal.toStringAsFixed(2);
            trans['total'] = totamt.toStringAsFixed(2);
            trans['month'] = datetime('monthnameyr', endMonth.toString());
            transList.add(trans);
          }
        } else {
          closingbal = (balamt +
              ((double.parse(dt['creditamt'].toString())).roundToDouble() -
                  (double.parse(dt['debitamt'].toString()) > 0
                          ? double.parse(dt['debitamt'].toString())
                          : double.parse(dt['debitamt'].toString()) * -1)
                      .roundToDouble()));
          trans['trans'].add({
            "trdate": datetime('dbdate', dt['trdate'].toString()),
            'invoiceno': dt['invoiceno'].toString(),
            'menuitemname': dt['menuitemname'].toString(),
            'narration': dt['narration'].toString(),
            'debitamt': (double.parse(dt['debitamt'].toString()))
                .roundToDouble()
                .toStringAsFixed(2),
            'creditamt': (double.parse(dt['creditamt'].toString()))
                .roundToDouble()
                .toStringAsFixed(2),
            'balance': closingbal.toStringAsFixed(2),
            'uid': dt['uid'].toString(),
            'edatetime': dt['edatetime'].toString()
          });

          totamt += (double.parse(dt['creditamt'].toString())).roundToDouble() -
              (double.parse(dt['debitamt'].toString()) > 0
                      ? double.parse(dt['debitamt'].toString())
                      : double.parse(dt['debitamt'].toString()) * -1)
                  .roundToDouble();

          balamt = closingbal;

          if (countarray == stoparray) {
            trans['closingbal'] = closingbal.toStringAsFixed(2);
            trans['total'] = totamt.toStringAsFixed(2);
            trans['month'] = datetime('monthnameyr', endMonth.toString());
            transList.add(trans);
          }
        }

        stoparray++;
      }
      setState(() {
        transList.length;
      });
    }
    setState(() {
      loadscreen = true;
    });
/* 
    if (alltransList.isNotEmpty) {
      DateTime currdate = DateTime.parse(alltransList[0]['trdate'].toString());
      Map data = {"header": currdate, "list": [], "total": ''};
      double creditamnt = 0;
      double debitamt = 0;
      double totamt = 0;
      double balamt = openingbal;
      for (var e in alltransList) {
        creditamnt = double.parse(e['creditamt'].toString());
        if (double.parse(e['debitamt'].toString()) > 0) {
          debitamt = -(double.parse(e['debitamt'].toString()));
        } else {
          debitamt = double.parse(e['debitamt'].toString());
        }
        if (DateTime.parse(e['trdate'].toString()).month != currdate.month) {
          data['total'] = totamt;
          transList.add(data);

          currdate = DateTime.parse(e['trdate'].toString());
          totamt = 0;

          data = {"header": currdate, "list": [], "total": ''};
        }
        totamt += (creditamnt + debitamt);
        balamt += (creditamnt + debitamt);
        // print(balamt);
        data['total'] = totamt;
        data['list'].add(e);
      }
      transList.add(data);

      setState(() {
        closingbal = openingbal - (balamt);
        transList.length;
      });
      print(transList);
    } */
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
                            //       duration: Duration(milliseconds: 200),
                            //       reverseDuration: Duration(milliseconds: 200),
                            //       child: Dashboard(),
                            //     ),
                            //     ModalRoute.withName("/Home"));
                          },
                          child: Container(
                              width: 30,
                              child: Icon(
                                Icons.arrow_back_rounded,
                                color: Color(0xFFEDEDED),
                                size: 25,
                              )),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(15, 0, 0, 0),
                          child: Text(
                            'Statement',
                            style: ed16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                loadscreen
                    ? Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                          child: Container(
                            width: double.infinity,
                            height: 100,
                            decoration: BoxDecoration(),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 15),
                                  child: Container(
                                    width: double.infinity,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF181818),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          15, 0, 15, 0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Opening Balance',
                                            style: ed14,
                                          ),
                                          Text(
                                              " ${openingbal >= 0 ? '+' : ''} ${openingbal.toStringAsFixed(2)}", // '+ 12541.00',
                                              style: ed14),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) {
                                      final file = transList[index];
                                      return statementWid(file);
                                    },
                                    itemCount: transList.length,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: Center(
                            child: CircularProgressIndicator(
                        color: Colors.yellow,
                      ))),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Container(
                    width: double.infinity,
                    height: 35,
                    decoration: BoxDecoration(
                      color: Color(0xFF2B2B2B),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: InkWell(
                              onTap: () {
                                selectdate(context, fromdt, 'F');
                              },
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          5, 0, 0, 0),
                                      child: Text(
                                        datetime(
                                            'monthnameyr', fromdt.toString()),
                                        style: ed16,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        Container(
                          width: 35,
                          height: double.infinity,
                          decoration: BoxDecoration(),
                          child: Icon(
                            Icons.linear_scale_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              selectdate(context, todt, 'T');
                            },
                            child: Container(
                                width: 35,
                                height: double.infinity,
                                decoration: BoxDecoration(),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          5, 0, 0, 0),
                                      child: Text(
                                        datetime(
                                            'monthnameyr', todt.toString()),
                                        style: ed16,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                        InkWell(
                            onTap: () async {
                              await getStatements();
                            },
                            child: Container(
                              width: 40,
                              height: double.infinity,
                              decoration: BoxDecoration(),
                              child: Icon(
                                Icons.search_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            )),
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

  Widget statementWid(var file) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
            child: Container(
              width: double.infinity,
              height: 22,
              decoration: BoxDecoration(
                color: Color(0xFF181818),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Transaction for the Month ${file['month'].toString()}',
                      style: ed10,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              ...file['trans'].map(
                (e) => Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(15, 0, 15, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 2),
                            child: Text(
                              e['menuitemname'].toString(),
                              style: edH11,
                            ),
                          ),
                          Text(
                            datetime('date', e['trdate'].toString()),
                            style: dc9,
                          ),
                        ],
                      ),
                      Text(
                        double.parse(e['creditamt'].toString()) > 0
                            ? e['creditamt'].toString()
                            : "- ${e['debitamt'].toString()}", //'- 350.00',
                        style: double.parse(e['debitamt'].toString()) > 0
                            ? edH12red
                            : edH12green,
                      ),
                    ],
                  ),
                ),
              ),
              /*   Padding(
                padding: EdgeInsetsDirectional.fromSTEB(15, 0, 15, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 2),
                          child: Text(
                            'Card Room',
                            style: edH11,
                          ),
                        ),
                        Text(
                          '13-03-2023',
                          style: dc9,
                        ),
                      ],
                    ),
                    Text(
                      '- 200.00',
                      style: edH12red,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(15, 0, 15, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 2),
                          child: Text(
                            'Payment',
                            style: edH11,
                          ),
                        ),
                        Text(
                          '15-03-2023',
                          style: dc9,
                        ),
                      ],
                    ),
                    Text(
                      '+ 2000.00',
                      style: edH12green,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(15, 0, 15, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 2),
                          child: Text(
                            'Gym',
                            style: edH11,
                          ),
                        ),
                        Text(
                          '16-03-2023',
                          style: dc9,
                        ),
                      ],
                    ),
                    Text(
                      '- 350.00',
                      style: edH12red,
                    ),
                  ],
                ),
              ),
             */
            ],
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
            child: Container(
              width: double.infinity,
              height: 25,
              decoration: BoxDecoration(
                color: Color(0xFF181818),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TOTAL',
                      style: ed12,
                    ),
                    Text(
                      "${double.parse(file['total'].toString()) >= 0 ? '+' : ''} ${file['total'].toString()}",
                      style: ed13,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 25,
            decoration: BoxDecoration(
              color: Color(0xFF181818),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CLOSING BALANCE',
                    style: ed12,
                  ),
                  Text(
                      "${double.parse(file['closingbal'].toString()) >= 0 ? '+' : ''} ${double.parse(file['closingbal'].toString()).toStringAsFixed(2)}",
                      //'+ 11441.00',
                      style: ed14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
