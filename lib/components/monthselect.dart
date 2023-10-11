import 'package:flutter/material.dart';
import 'package:memberapp/components/fonts.dart';

import '../functions/app_func.dart';

class MonthSelect extends StatefulWidget {
  final Function completefn;
  final String year;
  final String month;
  final String monthdisp;
  final String buttonname;
  const MonthSelect(
      {super.key,
      required this.completefn,
      required this.year,
      required this.monthdisp,
      required this.buttonname,
      required this.month});

  @override
  State<MonthSelect> createState() => _MonthSelectState();
}

class _MonthSelectState extends State<MonthSelect> {
  final _unfocusNode = FocusNode();
  TextStyle ow16 = fontFile(18, Color(0xFF3A3A3A), 1, FontWeight.bold);
  TextStyle ow14 = fontFile(14, Color(0xFF3A3A3A), 0, FontWeight.w600);
  TextStyle bB12 = fontFile(14, Color(0xFF3A3A3A), 0, FontWeight.bold);
  TextStyle fF12 = fontFile(14, Color(0xFFFFFFFF), 0, FontWeight.bold);
  TextStyle w16 = fontFile(14, Color(0xFFFFFFFF), 0, FontWeight.w600);
  TextStyle chbt = fontFile(18, Color(0xFF000000), 1, FontWeight.bold);

  var selMapYear = {};
  String selYear = '';
  String selMonth = '';
  String selMonthDis = '';
  Map yearList = {};

  Future loadYears() async {
    for (var i = 2021; i <= DateTime.now().year; i++) {
      yearList[i.toString()] = i.toString();
    }
    setState(() {
      yearList.length;
      print(widget.year);
      print(widget.month);
      print(widget.monthdisp);
      selYear = widget.year;
      selMonth = widget.month;
      selMonthDis = widget.monthdisp;
    });
  }

  @override
  void initState() {
    super.initState();
    selYear = widget.year;
    selMonth = widget.month;
    loadYears();
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 280,
        height: 400,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
              child: Material(
                color: Colors.transparent,
                elevation: 16,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: 40,
                        height: 100,
                        decoration: BoxDecoration(),
                        child: Icon(
                          Icons.date_range_sharp,
                          color: Color(0xFF252525),
                          size: 24,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      10, 0, 0, 0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        items: yearList
                                            .map((description, value) {
                                              return MapEntry(
                                                  description,
                                                  DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Text(description,
                                                        style: ow16),
                                                  ));
                                            })
                                            .values
                                            .toList(),
                                        // value: _frequencyValue,
                                        value: selYear,
                                        onChanged: (String? newValue) {
                                          if (newValue != null) {
                                            setState(() {
                                              // _frequencyValue = newValue;
                                              selYear = newValue;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  )
                                  // Text(
                                  //   '2023',
                                  //   style: ow16,
                                  // ),
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
            Expanded(
              child: Material(
                color: Colors.transparent,
                elevation: 16,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 35,
                          decoration: BoxDecoration(),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        selMonthDis,
                                        style: ow14,
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            3, 0, 0, 0),
                                        child: Text(
                                          selYear,
                                          style: ow14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Container(
                              //   width: 80,
                              //   height: 100,
                              //   decoration: BoxDecoration(),
                              //   child: Row(
                              //     mainAxisSize: MainAxisSize.max,
                              //     children: [
                              //       Expanded(
                              //         child: TextButton(
                              //           onPressed: () {
                              //             int tempmonth =
                              //                 double.parse(selYear).toInt() - 1;
                              //             setState(() {
                              //               selYear = tempmonth.toString();
                              //             });
                              //           },
                              //           style: TextButton.styleFrom(
                              //             backgroundColor: Colors.transparent,
                              //             foregroundColor: Colors.black,
                              //             padding: EdgeInsets.zero,
                              //           ),
                              //           child: Container(
                              //             width: 25,
                              //             height: 100,
                              //             decoration: BoxDecoration(),
                              //             child: Icon(
                              //               Icons.arrow_back_ios_new,
                              //               color: Color(0xFF252525),
                              //               size: 22,
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //       Expanded(
                              //         child: TextButton(
                              //           onPressed: () {
                              //             int tempmonth =
                              //                 double.parse(selYear).toInt() + 1;
                              //             setState(() {
                              //               selYear = tempmonth.toString();
                              //             });
                              //           },
                              //           style: TextButton.styleFrom(
                              //             backgroundColor: Colors.transparent,
                              //             foregroundColor: Colors.black,
                              //             padding: EdgeInsets.zero,
                              //           ),
                              //           child: Container(
                              //             width: 25,
                              //             height: 100,
                              //             decoration: BoxDecoration(),
                              //             child: Icon(
                              //               Icons.arrow_forward_ios,
                              //               color: Color(0xFF252525),
                              //               size: 22,
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                            child: Container(
                              width: double.infinity,
                              height: 100,
                              decoration: BoxDecoration(),
                              child: Wrap(
                                spacing: 10,
                                runSpacing: 0,
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                direction: Axis.horizontal,
                                runAlignment: WrapAlignment.center,
                                verticalDirection: VerticalDirection.down,
                                clipBehavior: Clip.none,
                                children: [
                                  monthBox('Jan', '1'),
                                  monthBox('Feb', '2'),
                                  monthBox('Mar', '3'),
                                  monthBox('Apr', '4'),
                                  monthBox('May', '5'),
                                  monthBox('Jun', '6'),
                                  monthBox('Jul', '7'),
                                  monthBox('Aug', '8'),
                                  monthBox('Sep', '9'),
                                  monthBox('Oct', '10'),
                                  monthBox('Nov', '11'),
                                  monthBox('Dec', '12'),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 33,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 5, 0),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      backgroundColor:
                                          Color.fromARGB(255, 99, 99, 99),
                                      foregroundColor: Colors.black,
                                    ),
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Close',
                                            style: w16,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 5, 0),
                                  child: TextButton(
                                    onPressed: () {
                                      widget.completefn(
                                          selYear, selMonth, selMonthDis);
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      backgroundColor: Color(0xFF000000),
                                      foregroundColor: Colors.black,
                                    ),
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            widget.buttonname,
                                            style: w16,
                                          ),
                                        ],
                                      ),
                                    ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget monthBox(String day, String month) {
    return TextButton(
      onPressed: () {
        setState(() {
          selMonth = month;
          selMonthDis = day;
        });
      },
      style: TextButton.styleFrom(
        // elevation: selMonth == month ? 16 : 0,
        backgroundColor: selMonth == month
            ? Color.fromARGB(255, 55, 128, 237)
            : Color.fromARGB(255, 252, 252, 252),
        foregroundColor: Colors.black,
        padding: EdgeInsets.zero,
        minimumSize: Size(75, 33),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      child: Container(
        width: 60,
        height: 25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day,
              style: selMonth == month ? fF12 : bB12,
            ),
          ],
        ),
      ),
    );
  }
}
