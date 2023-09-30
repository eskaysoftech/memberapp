import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:memberapp/components/notifypanel.dart';
import 'package:memberapp/functions/bill_fn.dart';
import 'package:memberapp/pages/view_bill.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
import '../components/fonts.dart';
import '../functions/app_func.dart';
import '../localstore/global_var.dart';
import '../localstore/systemsetup/appsettings.dart';

class Bills extends StatefulWidget {
  const Bills({super.key});

  @override
  State<Bills> createState() => _BillsState();
}

class _BillsState extends State<Bills> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  TextStyle ed14 = fontFile(14, Color(0xFFEDEDED), 0, FontWeight.w600);
  TextStyle ed16 = fontFile(16, Color(0xFFEDEDED), 0, FontWeight.bold);
  TextStyle w18 = fontWithheight(18, Color(0xFFFFFFFF), 0, FontWeight.w800);
  TextStyle chbt = fontFile(18, Color(0xFF000000), 1, FontWeight.bold);
  bool clubbillis = true;

  @override
  void initState() {
    super.initState();
    getBills();
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  DateTime selyear = DateTime.now();
  bool loadscreen = false;
  List yearList = [];
  Future<void> selectyear() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Year'),
          actions: [
            SizedBox(
                width: 300,
                height: 300,
                child: YearPicker(
                  firstDate: DateTime(1960, 8),
                  lastDate: DateTime(2050),
                  selectedDate: selyear,
                  onChanged: (value) async {
                    setState(() {
                      selyear = value;
                      // print(selyear);
                    });
                    Navigator.pop(context);
                    await getBills();
                  },
                ))
          ],
        );
      },
    );
  }

  Future getBills() async {
    setState(() {
      billsList = [];
      loadscreen = false;
    });
    Map<String, dynamic> senddata = {
      "DBName": dbName,
      "DBUser": dbUser,
      "year": selyear.year,
      "memberid": userid
    };

    String data = json.encode(senddata);
    // print(data);
    String url =
        "https://eskaysoftech.com/CLUB_MEMBER_API/tran files/memberbilldetails.php";

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
        billsList = dbody['data'];
      });
    }
    setState(() {
      loadscreen = true;
    });
  }

  List billsList = [];
  bool downloadyn = true;

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
                            // 'All Previous Bills',
                            '',
                            style: ed16,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                        onTap: () {
                          clubbillis ?
                          selectyear() : callMonthSelect(context, (){}, '2023', '09');
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.arrow_drop_down_sharp,
                              color: Color(0xFFEDEDED),
                              size: 20,
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                              child: Text(selyear.year.toString(), style: ed16),
                            ),
                          ],
                        )),
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
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.vertical,
                              itemCount: billsList.length,
                              itemBuilder: (context, index) {
                                final file = billsList[index];
                                return billWid(file, index);
                              },
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: Center(
                            child: CircularProgressIndicator(
                        color: Colors.yellow,
                      ))),
                      Padding(padding: EdgeInsetsDirectional.only(bottom: 10),child: 
                      Container(
                        width:double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                          
                        ),
                        child: Row(
                          children: [
                            Expanded(child: Padding(padding: EdgeInsetsDirectional.only(end: 10),child:TextButton(
                               onPressed: (){
                                setState(() {
                                  clubbillis = true;
                                });
                               },
                               style: TextButton.styleFrom(
                                backgroundColor: clubbillis ? Colors.grey : Color(0xFF3C3C3C),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                elevation: 16,
                                padding: EdgeInsets.zero
                               ),
                              child: Container(
                                height: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('CLUB BILLS',style: chbt,)
                                  ],
                                ),
                              ),
                            ))),
                            Expanded(child: Padding(padding: EdgeInsetsDirectional.only(end: 10),child:TextButton(
                               onPressed: (){
                                setState(() {
                                  clubbillis = false;
                                });},
                               style: TextButton.styleFrom(
                                backgroundColor: !clubbillis ? Colors.grey : Color(0xFF3C3C3C),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                elevation: 16,
                                padding: EdgeInsets.zero
                               ),
                              child: Container(
                                height: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('OTHER BILLS',style: chbt,)
                                  ],
                                ),
                              ),
                            ))),
                          ],
                        ),
                      ),),
                      
              ],
            ),
          ),
        ),
      ),
    );
  }

  int selindex = -1;
  Widget billWid(var file, int index) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
      child: Container(
        width: double.infinity,
        height: 90,
        decoration: BoxDecoration(
          color: Color(0xFF181818),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${datetime('monthf', file['start'].toString())} - ${datetime('monthf', file['end'].toString())}", //'25 Mar 2023 - 24 Apr 2023',
                style: ed14,
              ),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹ ${file['amount'].toString()}', //2000.00
                      style: w18,
                    ),
                    Expanded(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            InkWell(
                                onTap: () async {
                                  await loadingscreen(context);
                                  var saved = await downloadbill(file);
                                  if (saved != null) {
                                    Navigator.pop(context);
                                    notifyPanel(
                                        context,
                                        'S',
                                        '',
                                        'Downloaded Succesfully.',
                                        'OK',
                                        '', () {
                                      Navigator.pop(context);
                                    }, () {});
                                  } else {
                                    Navigator.pop(context);
                                    notifyPanel(
                                        context,
                                        'W',
                                        '',
                                        'Unable to Download File.',
                                        'OK',
                                        '', () {
                                      Navigator.pop(context);
                                    }, () {});
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      10, 0, 0, 0),
                                  child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF262626),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Icon(
                                        Icons.download_outlined,
                                        color: Color(0xFFA0A0A0),
                                        size: 18,
                                      )),
                                )),
                            InkWell(
                              onTap: () async {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      duration: Duration(milliseconds: 200),
                                      reverseDuration:
                                          Duration(milliseconds: 200),
                                      child: ViewStatement(
                                        data: file,
                                      ),
                                    ));
                              },
                              child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      10, 0, 0, 0),
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF262626),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Icon(
                                      Icons.remove_red_eye_outlined,
                                      color: Color(0xFFA0A0A0),
                                      size: 18,
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
