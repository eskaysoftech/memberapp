import 'package:flutter/material.dart';
import 'package:memberapp/components/fonts.dart';

class MonthSelect extends StatefulWidget {
  final Function completefn;
  final String year;
  final String month;
  const MonthSelect({super.key, required this.completefn, required this.year, required this.month});

  @override
  State<MonthSelect> createState() => _MonthSelectState();
}

class _MonthSelectState extends State<MonthSelect> {
  final _unfocusNode = FocusNode();
  TextStyle ow16 = fontFileOW(18, Color(0xFF252525), 1, FontWeight.bold);
  TextStyle ow14 = fontFileOW(16, Color(0xFF252525), 1, FontWeight.bold);
  TextStyle bB12 = fontFile(14, Color(0xFF252525), 0, FontWeight.bold);
  TextStyle fF12 = fontFile(14, Color(0xFFFFFFFF), 0, FontWeight.bold);
  TextStyle w16 = fontWithheight(16, Color(0xFFFFFFFF), 0, FontWeight.w800);
  TextStyle chbt = fontFile(18, Color(0xFF000000), 1, FontWeight.bold);

  var selMapYear = {};
  String selYear = '';
  String selMonth = '';
  Map yearList = {};

  Future loadYears() async {
    for (var i = 2000; i < 2200; i++) {
      yearList[i.toString()] = i.toString();
    }
    setState(() {
      yearList.length;
      selMapYear = yearList[widget.year];
    });
    print(yearList);
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
                        padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: DropdownButtonHideUnderline(
                  child:  DropdownButtonHideUnderline(
                                child:
                                    DropdownButton<
                                        String>(
                                  items:
                                      yearList
                                          .map((description,
                                              value) {
                                            return MapEntry(
                                                description,
                                                DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(description, style: ow16),
                                                ));
                                          })
                                          .values
                                          .toList(),
                                  // value: _frequencyValue,
                                  value: selYear,
                                  onChanged: (String?
                                      newValue) {
                                    if (newValue !=
                                        null) {
                                      setState(() {
                                        // _frequencyValue = newValue;
                                        selYear =
                                            newValue;
                                      });
                                    }
                                  },
                                ),
                              ),)
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
                          decoration: BoxDecoration(
                            color: Colors.white
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'Sep',
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
                      Container(
                        width: 80,
                        height: 100,
                        decoration: BoxDecoration(),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: TextButton(onPressed: (){
                                int tempmonth = double.parse(selYear).toInt() - 1;
                                setState(() {
                                  selYear = tempmonth.toString();
                                });
                              }, 
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.black,
                                padding: EdgeInsets.zero,

                              ),
                              child: 
                              Container(
                                width: 25,
                                height: 100,
                                decoration: BoxDecoration(),
                                child: Icon(
                                  Icons.arrow_back_ios_new,
                                  color: Color(0xFF252525),
                                  size: 22,
                                ),
                              ),),
                            ),
                            Expanded(
                              child: TextButton(onPressed: (){
                                int tempmonth = double.parse(selYear).toInt() + 1;
                                setState(() {
                                  selYear = tempmonth.toString();
                                });}, 
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.black,
                                padding: EdgeInsets.zero,

                              ),
                              child: 
                              Container(
                                width: 25,
                                height: 100,
                                decoration: BoxDecoration(),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Color(0xFF252525),
                                  size: 22,
                                ),
                              ),),
                            ),
                          ],
                        ),
                      ),
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
                          monthBox('Jan', '01'),
                          monthBox('Feb', '02'),
                          monthBox('Mar', '03'),
                          monthBox('Apr', '04'),
                          monthBox('May', '05'),
                          monthBox('Jun', '06'),
                          monthBox('Jul', '07'),
                          monthBox('Aug', '08'),
                          monthBox('Sep', '09'),
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
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                          child: TextButton(onPressed: (){
                            Navigator.pop(context);}, 
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: Color(0xFF545454),
                              foregroundColor: Colors.black,
                            ),
                            child:
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Close',
                                  style: w16,
                                ),
                              ],
                            ),
                          ),),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Color(0xFF252525),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Search',
                                style: w16,
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
      ),
    ),
  ],
),
      ),
    );
  }

  Widget monthBox(String day, String month) {
    return TextButton(onPressed: (){
      setState(() {
        selMonth = month;  
      });
    }, 
    style: TextButton.styleFrom(
      elevation: selMonth == month ? 16 : 0,
      backgroundColor: selMonth == month ? Color(0xFF252525) : Color(0xFFEDEDED),
      foregroundColor: Colors.black,
      padding: EdgeInsets.zero,
      minimumSize: Size(75, 30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
    ),
    child: 
    Container(
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
    ),);
  }
}