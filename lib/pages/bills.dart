import 'dart:convert';
import 'package:memberapp/components/notifypanel.dart';
import 'package:memberapp/functions/bill_fn.dart';
import 'package:memberapp/pages/sales_bill_pdf.dart';
import 'package:memberapp/pages/view_bill.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
import 'package:printing/printing.dart';
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
  TextStyle ebd14 = fontFile(14, Color(0xFFEDEDED), 0, FontWeight.bold);
  TextStyle ed13 = fontFile(13, Color(0xFFEDEDED), 0, FontWeight.w600);
  TextStyle ed16 = fontFile(16, Color(0xFFEDEDED), 0, FontWeight.bold);
  TextStyle w18 = fontWithheight(18, Color(0xFFFFFFFF), 0, FontWeight.w800);
  TextStyle chbt = fontFile(14, Color(0xFF000000), 1, FontWeight.bold);
  bool clubbillis = true;
  DateTime todaydate = DateTime.now();
  String monthdisp = '';
  String month = '';
  String year = '';

  Future getOtherBillDetails(Map file) async {
    Map printMap = {
      "trdate": file['trdate'],
      "orderno": file['orderno'],
      "sectioncode": file['sectioncode'],
      "outletcode": file['outletcode'],
      "tableno": file['tableno'],
      "tablekey": "MEM NO",
      "transactiontype": file['transactiontype'],
      "waiterkey": "Waiter",
      "waitername": "",
      "total": file['amount'],
      "round": file['rounduprupee'],
      "edatetime": file['edatetime'],
      "contactid": file['contactid'],
      "contactname": file['contactname'],
      "contactadd": file['contactadd'],
      "contactgst": file['contactgst'],
      "contactmobile": file['contactmobile'],
      "barbillno": file['barbillno'],
      "foodbillno": file['foodbillno'],
      "paymentmode1": file['paymentmode1'],
      "paymentmode2": file['paymentmode2'],
      "payment1": file['paymentamt1'],
      "payment2": file['paymentamt2'],
      "seperatebillnoforbarfood": file['seperatebillnoforbarfood'],
      "paymentqrcodelink": "",
      "foodbilldata": {},
    };

    String kotQty = "SELECT menuitemcode, menuitemname, ";
    kotQty += "mlquantity, mlqty, containername, itemdescription, ";
    kotQty +=
        "itemtype, sum(bottlequantity) AS 'bottlequantity', sum(quantity) AS 'quantity', ";
    kotQty += "rate, sum(amount) AS 'amount', ";
    kotQty += "sum(discountamt) AS 'discountamt', ";
    kotQty += "servicetaxpercentage, sum(servicetaxamt) AS 'servicetaxamt', ";
    kotQty += "hsncode, withintaxyn, taxtype, taxpercentage, ";
    kotQty +=
        "sum(taxamount) AS 'taxamount', cesspercentage, sum(cessamt) AS 'cessamt' ";
    kotQty += "FROM runningtable WHERE ";
    kotQty += "sectioncode = '${printMap["sectioncode"]}' AND ";
    kotQty += "outletcode = '${printMap["outletcode"]}' AND ";
    kotQty += "tableno = '${printMap["tableno"]}' ";
    kotQty += "AND orderno = ${printMap["orderno"]} ";
    kotQty +=
        "AND trdate = '${datetime('dbdate', printMap["trdate"].toString())}' ";
    kotQty += "AND isactive = '0' ";
    kotQty += "AND syncno IN(SELECT MAX(syncno) from ";
    kotQty +=
        "runningtable WHERE sectioncode = '${printMap["sectioncode"]}' AND ";
    kotQty +=
        "outletcode = '${printMap["outletcode"]}' AND tableno = '${printMap["tableno"]}' AND ";
    kotQty +=
        "orderno = ${printMap["orderno"]} AND trdate = '${datetime('dbdate', printMap["trdate"].toString())}' AND ";
    kotQty += "isactive = '0' group by menuitemcode, mlqty, ";
    kotQty +=
        "containername, waitercode, rate, itemdescription, tableno, kotno, slno)";
    kotQty += "group by menuitemcode, mlqty, containername, waitercode, rate, ";
    kotQty += "itemdescription having amount > 0 order by slno";

    String waiterQry = "";
    waiterQry += "SELECT u.userfullname ";
    waiterQry += "FROM transactions t, userdetails u ";
    waiterQry += "WHERE t.waitercode = u.userid AND ";
    waiterQry += "u.isactive = '1' AND u.userlevel = '4' ";
    waiterQry += "AND t.isactive = '1' AND t.orderno = ${printMap["orderno"]} ";
    waiterQry +=
        "AND t.trdate = '${datetime('dbdate', printMap["trdate"].toString())}' ";
    waiterQry += "AND t.transactiontype IN('I','XI','N') ";
    waiterQry +=
        "AND t.outletcode = '${printMap["outletcode"]}' AND t.sectioncode = '${printMap["sectioncode"]}' ";
    waiterQry += "AND t.syncno in (select max(syncno) from ";
    waiterQry += "transactions where isactive = '1' AND ";
    waiterQry +=
        "orderno = ${printMap["orderno"]} AND trdate = '${datetime('dbdate', printMap["trdate"].toString())}' ";
    waiterQry += "AND transactiontype IN('I','XI','N') ";
    waiterQry +=
        "AND outletcode = '${printMap["outletcode"]}' AND sectioncode = '${printMap["sectioncode"]}' ";
    waiterQry += "GROUP BY orderno, trdate,outletcode) ";
    waiterQry += "AND u.syncno in (select max(syncno) ";
    waiterQry += "from userdetails where isactive = '1' ";
    waiterQry += "AND userlevel = '4' GROUP BY userid) ";
    waiterQry += " GROUP BY t.orderno, t.trdate ORDER BY ";
    waiterQry += "t.trdate LIMIT 1";

    String headerQry = "SELECT lineno, texttoprint,";
    headerQry += " font_size, boldyn,textalign";
    headerQry += " FROM billformat";
    headerQry +=
        " WHERE header_footer = 'H' and outletcode='${printMap["outletcode"]}' AND isactive = '1' AND ";
    headerQry += "syncno IN(SELECT MAX(syncno) FROM billformat WHERE ";
    headerQry +=
        " header_footer = 'H' and outletcode='${printMap["outletcode"]}' AND isactive = '1' ";
    headerQry += " GROUP BY lineno)";
    headerQry += " ORDER BY lineno";

    String footerQry = "SELECT lineno, texttoprint,";
    footerQry += " font_size, boldyn,textalign";
    footerQry += " FROM billformat";
    footerQry +=
        " WHERE header_footer = 'F'  and outletcode='${printMap["outletcode"]}' AND isactive = '1' AND ";
    footerQry += "syncno IN(SELECT MAX(syncno) FROM billformat WHERE ";
    footerQry +=
        " header_footer = 'F' and outletcode='${printMap["outletcode"]}' AND isactive = '1' ";
    footerQry += " GROUP BY lineno) ";
    footerQry += " ORDER BY lineno";

    Map<String, dynamic> senddata = {
      "DBName": dbName,
      "DBUser": dbUser,
      "listdata": [
        {"qrykey": "itemlist", "qry": kotQty},
        {"qrykey": "waiter", "qry": waiterQry},
        {"qrykey": "header", "qry": headerQry},
        {"qrykey": "footer", "qry": footerQry},
      ]
    };

    String data = json.encode(senddata);
    // print(data);
    String url =
        "https://eskaysoftech.com/CLUB_MEMBER_API/tran files/fnapi/mapapi.php";

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

    Map tranMap = {
      "printMap": {},
      "header": {"result": false, "data": ""},
      "footer": {"result": false, "data": ""}
    };
    if (dbody['result']) {
      List itemList = dbody['data']['itemlist'];

      List baritem = [];
      List fooditem = [];
      if (printMap["seperatebillnoforbarfood"] == 'Y') {
        baritem =
            itemList.where((element) => element['itemtype'] == 'L').toList();
        fooditem =
            itemList.where((element) => element['itemtype'] != 'L').toList();
      } else {
        fooditem = itemList;
      }
      if (baritem.isNotEmpty) {
        printMap['barbilldata'] = {
          "billno": printMap['barbillno'],
          "billitems": baritem
        };
      }
      if (fooditem.isNotEmpty) {
        printMap['foodbilldata'] = {
          "billno": printMap['foodbillno'],
          "billitems": fooditem
        };
      }
      printMap['waitername'] = dbody['data']['waiter'][0]['userfullname'];
      tranMap = {
        "printMap": printMap,
        "header": dbody['data']['header'] == null
            ? {"result": false, "data": ""}
            : {"result": true, "data": dbody['data']['header']},
        "footer": dbody['data']['footer'] == null
            ? {"result": false, "data": ""}
            : {"result": true, "data": dbody['data']['footer']}
      };
    }
    return tranMap;
  }

  @override
  void initState() {
    super.initState();
    getBills();

    monthdisp = datetime('onlymonth', todaydate.toString());
    month = todaydate.month.toString();
    year = todaydate.year.toString();
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

  List otherbilllist = [];
  Future getOtherBills() async {
    setState(() {
      billsList = [];
      loadscreen = false;
    });
    Map<String, dynamic> senddata = {
      "DBName": dbName,
      "DBUser": dbUser,
      "ftdate": "$year-$month-1",
      "ttdate": "$year-$month-31",
      "contactid": userid,
      "outletyn": flagApplication['outlet']
    };

    String data = json.encode(senddata);
    // print(data);
    String url =
        "https://eskaysoftech.com/CLUB_MEMBER_API/tran files/getotherbilldetails.php";

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
    if (dbody['result']) {
      setState(() {
        otherbilllist = dbody['data'];
      });
    }
    print(otherbilllist);
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
                            // 'All Previous Bills',
                            '',
                            style: ed16,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                        onTap: () {
                          clubbillis
                              ? selectyear()
                              : callMonthSelect(context,
                                  (yearr, monthr, monthdispr) {
                                  Navigator.pop(context);
                                  setState(() {
                                    year = yearr;
                                    month = monthr;
                                    monthdisp = monthdispr;
                                  });
                                  getOtherBills();
                                }, year, month, monthdisp, 'Search');
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
                              child: Text(
                                  clubbillis
                                      ? selyear.year.toString()
                                      : '$monthdisp $year',
                                  style: ed16),
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
                              itemCount: clubbillis
                                  ? billsList.length
                                  : otherbilllist.length,
                              itemBuilder: (context, index) {
                                final file = clubbillis
                                    ? billsList[index]
                                    : otherbilllist[index];
                                return clubbillis
                                    ? billWid(file, index)
                                    : otherBillBox(file, index);
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
                Padding(
                  padding: EdgeInsetsDirectional.only(bottom: 10),
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(),
                    child: Row(
                      children: [
                        Expanded(
                            child: Padding(
                                padding: EdgeInsetsDirectional.only(end: 15),
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      clubbillis = true;
                                    });
                                    getBills();
                                  },
                                  style: TextButton.styleFrom(
                                      backgroundColor: clubbillis
                                          ? Colors.grey
                                          : Color(0xFF3C3C3C),
                                      foregroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      elevation: 16,
                                      padding: EdgeInsets.zero),
                                  child: Container(
                                    height: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'CLUB BILLS',
                                          style: chbt,
                                        )
                                      ],
                                    ),
                                  ),
                                ))),
                        Expanded(
                            child: Padding(
                                padding: EdgeInsetsDirectional.only(end: 15),
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      clubbillis = false;
                                    });
                                    getOtherBills();
                                  },
                                  style: TextButton.styleFrom(
                                      backgroundColor: !clubbillis
                                          ? Colors.grey
                                          : Color(0xFF3C3C3C),
                                      foregroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      elevation: 16,
                                      padding: EdgeInsets.zero),
                                  child: Container(
                                    height: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'OTHER BILLS',
                                          style: chbt,
                                        )
                                      ],
                                    ),
                                  ),
                                ))),
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

  Widget otherBillBox(var file, int index) {
    String billno = file['barbillno'].toString() == '0' &&
            file['foodbillno'].toString() == '0'
        ? file['orderno']
        : "";
    billno +=
        file['barbillno'].toString() == '0' ? "" : file['barbillno'].toString();
    billno += file['foodbillno'].toString() == '0'
        ? ""
        : file['foodbillno'].toString();
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
              Expanded(
                child: Text(
                  file['outletname'], //'25 Mar 2023 - 24 Apr 2023',
                  style: ebd14,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.only(bottom: 10),
                child: Text(
                  "${datetime('date', file['trdate'].toString())} | $billno", //'25 Mar 2023 - 24 Apr 2023',
                  style: ed13,
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹ ${double.parse(file['amount'].toString()).toStringAsFixed(2)}', //2000.00
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
                            // InkWell(
                            //     onTap: () async {
                            //       // await loadingscreen(context);
                            //       // print(file);

                            //       await loadingscreen(context);
                            //       Map printMap =
                            //           await getOtherBillDetails(file);
                            //       Navigator.pop(context);
                            //       print(printMap['footer']);
                            //     },
                            //     child: Padding(
                            //       padding: EdgeInsetsDirectional.fromSTEB(
                            //           10, 0, 0, 0),
                            //       child: Container(
                            //           width: 30,
                            //           height: 30,
                            //           decoration: BoxDecoration(
                            //             color: Color(0xFF262626),
                            //             borderRadius: BorderRadius.circular(5),
                            //           ),
                            //           child: Icon(
                            //             Icons.download_outlined,
                            //             color: Color(0xFFA0A0A0),
                            //             size: 18,
                            //           )),
                            //     )),
                            InkWell(
                              onTap: () async {
                                await loadingscreen(context);
                                Map printMap = await getOtherBillDetails(file);
                                Navigator.pop(context);
                                // ignore: use_build_context_synchronously
                                showDialog(
                                  context: context,
                                  builder: (context) => Scaffold(
                                    appBar: AppBar(
                                      title: const Text('SALES BILL'),
                                    ),
                                    body: PdfPreview(
                                        build: (format) async =>
                                            (await salesBillPdf(
                                                printMap['printMap'],
                                                printMap['header'],
                                                printMap['footer']))),
                                  ),
                                );
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
