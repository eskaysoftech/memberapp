import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String datetime(tab, cudate) {
  String out = "";
  DateTime datetime;
  if (cudate != "") {
    DateTime parseDate;
    if (cudate.toString().length > 11) {
      parseDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(cudate!);
    } else {
      parseDate = DateFormat("yyyy-MM-dd").parse(cudate!);
    }
    datetime = DateTime.parse(parseDate.toString());
  } else {
    datetime = DateTime.now();
  }

  switch (tab) {
    case "date":
      out = DateFormat('dd-MM-yyyy').format(datetime);
      break;
    case "datetime":
      out = DateFormat('dd-MM-yyyy HH:mm:ss').format(datetime);
      break;
    case "dbdate":
      out = DateFormat('yyyy-MM-dd').format(datetime);
      break;
    case "dbdatetime":
      out = DateFormat('yyyy-MM-dd HH:mm:ss').format(datetime);
      break;
    case "pass":
      out =
          "eskay${DateFormat('MM').format(datetime)}${DateFormat('E').format(datetime)}";
      break;
    case "time":
      out = DateFormat('HH:mm:ss').format(datetime);
      break;
    case "monthyear":
      out = DateFormat('yyyy').format(datetime);
      break;
    case "day":
      out = DateFormat('dd').format(datetime);
      break;
    case "monthf":
      out = DateFormat('dd MMM yyyy').format(datetime);
      break;
    case "monyr":
      out = DateFormat('MM-yyyy').format(datetime);
      break;
    case "monthnameyr":
      out = DateFormat('MMM yyyy').format(datetime);
      break;
    case "monthdtyear":
      out = DateFormat('yMMMMd').format(datetime);
      break;
  }

  return out;
}

Future loadingscreen(BuildContext context) async {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const Dialog(
            backgroundColor: Colors.transparent,
            child: Center(
                child: CircularProgressIndicator(
              color: Colors.yellow,
            )),
          ));
}
