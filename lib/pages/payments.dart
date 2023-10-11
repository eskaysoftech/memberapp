import 'dart:convert';
import 'package:memberapp/functions/app_func.dart';
import 'package:memberapp/localstore/systemsetup/appsettings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../components/fonts.dart';
import '../components/notifypanel.dart';
import '../localstore/global_var.dart';

class Payments extends StatefulWidget {
  const Payments({super.key});

  @override
  State<Payments> createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  TextStyle ed13 = fontFile(13, Color(0xFFEDEDED), 0, FontWeight.w600);
  TextStyle ed14 = fontFile(14, Color(0xFFEDEDED), 0, FontWeight.w600);
  TextStyle ed16 = fontFile(16, Color(0xFFEDEDED), 0, FontWeight.bold);
  TextStyle w24 = fontWithheight(24, Color(0xFFFFFFFF), 0, FontWeight.w800);
  TextStyle c412 = fontWithheight(12, Color(0xFFC4C4C4), 0, FontWeight.w800);

  TextStyle dc18 = fontFile(18, Color(0xFFDCDCDC), 0, FontWeight.w600);
  TextStyle ed32 = fontFile(32, Color(0xFFEDEDED), 0, FontWeight.w600);

  DateTime todaydate = DateTime.now();

  DateTime selmonth = DateTime.now();
  bool dtchange = false;
  bool loadscreen = false;
  Future<void> selectdate(BuildContext context, DateTime val) async {
    final DateTime? picked = await showDatePicker(
        keyboardType: TextInputType.datetime,
        context: context,
        initialDate: val,
        helpText: 'SELECT MONTH',
        firstDate: DateTime(1930, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != val) {
      setState(() {
        selmonth = picked;
        dtchange = true;
      });
      await getPayments();
    }
  }

  Future getPayments() async {
    setState(() {
      paymentList = [];
      loadscreen = false;
    });
    Map<String, dynamic> senddata = {
      "DBName": dbName,
      "DBUser": dbUser,
      "fromdate": dtchange
          ? '${selmonth.year}-${selmonth.month.toString().padLeft(2, '0')}'
          : '',
      "todate": dtchange
          ? '${selmonth.year}-${selmonth.month.toString().padLeft(2, '0')}'
          : '',
      "memberid": userid
    };

    String data = json.encode(senddata);
    // print(data);
    String url =
        "https://eskaysoftech.com/CLUB_MEMBER_API/tran files/loadpaymentdetails.php";

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
        paymentList = dbody['data'];
      });
    }
    setState(() {
      loadscreen = true;
    });
  }

  List paymentList = [];
  @override
  void initState() {
    super.initState();
    getPayments();
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.black,
        /*   floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            print('FloatingActionButton pressed ...');
          },
          backgroundColor: Colors.black,
          elevation: 8,
          label: Text(
            'Payment',
            style: ed16,
          ),
        ), */
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
                            'Payment History',
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
                                Material(
                                  color: Colors.transparent,
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF121212),
                                          Color(0xFF2B2B2B)
                                        ],
                                        stops: [0, 1],
                                        begin: AlignmentDirectional(-1, -0.98),
                                        end: AlignmentDirectional(1, 0.98),
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 30, 0, 0),
                                          child: Container(
                                            width: double.infinity,
                                            height: 45,
                                            decoration: BoxDecoration(
                                              color: Color(0x6B000000),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(15, 0, 15, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    'Your Balance',
                                                    style: dc18,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            width: double.infinity,
                                            height: 100,
                                            decoration: BoxDecoration(),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(15, 0, 15, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 100,
                                                    height: double.infinity,
                                                    decoration: BoxDecoration(),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.blur_on,
                                                          color:
                                                              Color(0xFF856F04),
                                                          size: 60,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    paymentList.isNotEmpty
                                                        ? '₹ ${double.parse(paymentList[0]['balanceamt'].toString()).toStringAsFixed(2)}'
                                                        : '₹ 0.0',
                                                    style: ed32,
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
                                InkWell(
                                    onTap: () {
                                      String monthdisp = datetime(
                                          'onlymonth', selmonth.toString());
                                      String month = selmonth.month.toString();
                                      String year = selmonth.year.toString();
                                      callMonthSelect(context,
                                          (yearr, monthr, monthdispr) async {
                                        Navigator.pop(context);
                                        setState(() {
                                          selmonth = DateTime(
                                              double.parse(yearr).toInt(),
                                              double.parse(monthr).toInt(),
                                              1);
                                          dtchange = true;
                                        });
                                        getPayments();
                                      }, year, month, monthdisp, 'Search');
                                    },
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 10, 0, 10),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Icon(
                                            Icons.arrow_drop_down_sharp,
                                            color: Color(0xFFEDEDED),
                                            size: 20,
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    5, 0, 0, 0),
                                            child: Text(
                                              datetime('monthnameyr',
                                                  selmonth.toString()),
                                              style: ed16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                paymentList.isNotEmpty
                                    ? Expanded(
                                        child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          itemCount: paymentList.length,
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: (context, index) {
                                            final file = paymentList[index];
                                            return paymentWid(file);
                                          },
                                        ),
                                      )
                                    : Expanded(
                                        child: Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            child: Column(
                                              children: [
                                                Text(
                                                  "No Payment History",
                                                  style: ed16,
                                                )
                                              ],
                                            )))
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget paymentWid(var file) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
      child: Container(
        width: double.infinity,
        height: 110,
        decoration: BoxDecoration(
          color: Color(0xFF181818),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                file['menuitemname'].toString(), //'Monthly Subscription',
                style: ed13,
              ),
              Text(
                " ₹ ${double.parse(file['amount'].toString()).toStringAsFixed(2)}", //' 2000.00',
                style: w24,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                    child: Text(
                      datetime('monthdtyear',
                          file['trdate'].toString()), //'Mar 22 2023',
                      style: c412,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                    child: Text(
                      file['debitcredit'].toString(), //'CREDIT',
                      style: c412,
                    ),
                  ),
                  Icon(
                    Icons.check_circle_rounded,
                    color:
                        file['debitcredit'].toString().toLowerCase() == 'credit'
                            ? Color(0xFF1B7001)
                            : Color(0xFFE43D3D),
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
