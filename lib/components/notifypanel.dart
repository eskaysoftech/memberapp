import 'package:memberapp/components/fonts.dart';
import 'package:flutter/material.dart';
import 'package:memberapp/components/monthselect.dart';

Future notifyPanel(BuildContext context, String type, String title, String msg,
    String btn1, String btn2, Function fbt1, Function fbtn2,
    {bool fix = true}) {
  TextStyle black14 = fontFile(14, const Color(0xFF000000), 0, FontWeight.bold);
  TextStyle black12 = fontFile(12, const Color(0xFF000000), 0, FontWeight.w600);
  TextStyle white14BO =
      fontFile(14, const Color(0xFFCCFF00), 0, FontWeight.w500);
  final width = MediaQuery.of(context).size.width;
  return showDialog(
      context: context,
      barrierColor: Colors.black38,
      barrierDismissible: fix,
      builder: (BuildContext context) {
        return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                child: Material(
                  color: Colors.transparent,
                  elevation: 16,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width *
                        (width > 1024 ? 0.3 : 0.7),
                    height: btn2 == "" ? 80 : 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCCFF00),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(5, 0, 10, 0),
                            child: Icon(
                              Icons.warning,
                              color: Colors.black,
                              size: 32,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: const BoxDecoration(),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10, 0, 10, 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: black14,
                                    ),
                                    Text(
                                      msg,
                                      style: black12,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 70,
                            height: double.infinity,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                if (btn1 != "")
                                  Material(
                                      color: Colors.black,
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 0, 0, 0),
                                        child: InkWell(
                                            onTap: () {
                                              fbt1();
                                            },
                                            child: Container(
                                                width: double.infinity,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(1),
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      btn1,
                                                      style: white14BO,
                                                    ),
                                                  ],
                                                ))),
                                      )),
                                if (btn2 != "")
                                  Material(
                                      color: Colors.black,
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 0, 0, 0),
                                        child: InkWell(
                                            onTap: () {
                                              fbtn2();
                                            },
                                            child: Container(
                                                width: double.infinity,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(1),
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      btn2,
                                                      style: white14BO,
                                                    ),
                                                  ],
                                                ))),
                                      )),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ]);
      });
}

Future callMonthSelect(BuildContext context, Function completefn, String year, String month) {
  return showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MonthSelect(completefn: completefn,year: year, month: month,)
          ],
        );
      });;
}
