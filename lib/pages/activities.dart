import 'package:flutter/material.dart';
import '../components/fonts.dart';
import '../functions/app_func.dart';
import '../functions/globaldata_fn.dart';

class Activities extends StatefulWidget {
  final String fromdash;
  final String logdate;
  const Activities({super.key, required this.logdate, required this.fromdash});

  @override
  State<Activities> createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  TextStyle dcH9 =
      fontWithheight(9, const Color(0xFFDCDCDC), 0, FontWeight.w600);
  TextStyle ed10 = fontFile(10, const Color(0xFFEDEDED), 0, FontWeight.w600);
  TextStyle ed11 =
      fontWithheight(11, const Color(0xFFEDEDED), 1, FontWeight.w600);
  TextStyle ed12 =
      fontWithheight(12, const Color(0xFFEDEDED), 0, FontWeight.w600);
  TextStyle ed14 = fontFile(14, const Color(0xFFEDEDED), 0, FontWeight.w600);
  TextStyle ed16 = fontFile(16, const Color(0xFFEDEDED), 0, FontWeight.bold);
  TextStyle w18 =
      fontWithheight(18, const Color(0xFFFFFFFF), 0, FontWeight.w800);
  TextStyle w11 =
      fontWithheight(11, const Color(0xFFFFFFFF), 1, FontWeight.w800);

  @override
  void initState() {
    super.initState();
    if (widget.fromdash == 'Y') {
      fromdt = DateTime.parse(widget.logdate);
      todt = DateTime.parse(widget.logdate);
    }
    loadactivities();
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  List activitiesList = [];
  List allactivities = [];
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
        helpText: 'SELECT DATE',
        firstDate: DateTime(1930, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != val) {
      setState(() {
        tab == 'F' ? fromdt = picked : todt = picked;
      });
    }
  }

  Future loadactivities() async {
    setState(() {
      loadscreen = false;
    });
    List data = await getActivities(datetime('dbdate', fromdt.toString()),
        datetime('dbdate', todt.toString()));

    allactivities = data;
    setState(() {
      loadscreen = true;
    });
    if (allactivities.isNotEmpty) {
      activitiesList = [];
      var logday =
          DateTime.parse(allactivities[0]['memberlogdate'].toString()).day;
      Map trans = {
        'day': datetime('monthf', allactivities[0]['memberlogdate'].toString()),
        'activities': [],
      };
      for (var e in allactivities) {
        int currday = DateTime.parse(e['memberlogdate'].toString()).day;
        String currentdate = e['memberlogdate'].toString();

        if (logday != currday) {
          activitiesList.add(trans);

          trans = {
            'day': '',
            'activities': [],
          };

          trans['day'] = datetime('monthf', currentdate);
          logday = currday;
        }
        trans['activities'].add(e);
      }
      activitiesList.add(trans);
      setState(() {
        activitiesList.length;
      });
    }
    //print(activitiesList);
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
                        child: const Icon(Icons.arrow_back_rounded,
                            color: Color(0xFFEDEDED), size: 25),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(15, 0, 0, 0),
                      child: Text(
                        'Activites',
                        style: ed16,
                      ),
                    ),
                  ],
                ),
                loadscreen
                    ? activitiesList.isNotEmpty
                        ? Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 20, 0, 0),
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  final file = activitiesList[index];
                                  return activityWid(file);
                                },
                                itemCount: activitiesList.length,
                              ),
                            ),
                          )
                        : Expanded(
                            child: Center(
                                child: Text(
                            'No Activities',
                            style: ed16,
                          )))
                    : const Expanded(
                        child: Center(
                            child: CircularProgressIndicator(
                        color: Colors.yellow,
                      ))),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Container(
                    width: double.infinity,
                    height: 35,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B2B2B),
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
                                decoration: const BoxDecoration(),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              5, 0, 0, 0),
                                      child: Text(
                                        datetime('monthf', fromdt.toString()),
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
                          decoration: const BoxDecoration(),
                          child: const Icon(
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
                            decoration: const BoxDecoration(),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      5, 0, 0, 0),
                                  child: Text(
                                    datetime('monthf',
                                        todt.toString()), //'05 Mar 2023',
                                    style: ed16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                        InkWell(
                            onTap: () async {
                              await loadactivities();
                            },
                            child: Container(
                              width: 40,
                              height: double.infinity,
                              decoration: const BoxDecoration(),
                              child: const Icon(
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

  Widget activityWid(var file) {
    return Container(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
          child: Container(
            width: double.infinity,
            height: 22,
            decoration: BoxDecoration(
              color: const Color(0xFF181818),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    file['day'].toString(), //'02 Mar 2023',
                    style: ed10,
                  ),
                  Text(
                    'Guest',
                    style: ed10,
                  ),
                ],
              ),
            ),
          ),
        ),
        ...file['activities'].map(
          (e) => Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 10),
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
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 2),
                      child: Text(
                        e['menuitemname'].toString(),
                        style: w11,
                      ),
                    ),
                    Text(
                      datetime('time', e['checkin'].toString()),
                      //'11:19:58 - 11:30:26',
                      style: dcH9,
                    ),
                  ],
                ),
                Text(
                  e['noofguest'].toString(),
                  style: ed12,
                ),
              ],
            ),
          ),
        ),
        /*  Padding(
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
                      style: ed11,
                    ),
                  ),
                  Text(
                    '11:19:58 - 11:30:26',
                    style: dcH9,
                  ),
                ],
              ),
              Text(
                '0',
                style: ed12,
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
                      style: ed11,
                    ),
                  ),
                  Text(
                    '11:19:58 - 11:30:26',
                    style: dcH9,
                  ),
                ],
              ),
              Text(
                '5',
                style: ed12,
              ),
            ],
          ),
        ),
        /* Padding(
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '03 Mar 2023',
                          style: ed10,
                        ),
                        Text(
                          'Guest',
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
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 2),
                              child: Text(
                                'Badminton',
                                style: ed11,
                              ),
                            ),
                            Text(
                              '11:19:58 - 11:30:26',
                              style: dcH9,
                            ),
                          ],
                        ),
                        Text(
                          '3',
                          style: ed12,
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
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 2),
                              child: Text(
                                'Card Room',
                                style: ed11,
                              ),
                            ),
                            Text(
                              '11:19:58 - 11:30:26',
                              style: dcH9,
                            ),
                          ],
                        ),
                        Text(
                          '0',
                          style: ed12,
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
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 2),
                              child: Text(
                                'Payment',
                                style: ed11,
                              ),
                            ),
                            Text(
                              '11:19:58 - 11:30:26',
                              style: dcH9,
                            ),
                          ],
                        ),
                        Text(
                          '0',
                          style: ed12,
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
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 2),
                              child: Text(
                                'Gym',
                                style: ed11,
                              ),
                            ),
                            Text(
                              '11:19:58 - 11:30:26',
                              style: dcH9,
                            ),
                          ],
                        ),
                        Text(
                          '4',
                          style: ed12,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
       */
       */
      ],
    ));
  }
}
