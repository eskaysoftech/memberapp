import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

double getMl(container) {
  Map calMl = {
    "30": 0.5,
    30: 0.5,
    "60": 1.0,
    60: 1.0,
    "90": 1.5,
    90: 1.5,
    "180": 3.0,
    180: 3.0,
  };
  return calMl[container] ?? 1.0;
}

double getMlQ(container, double qty) {
  return (qty / getMl(container));
}

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
    case "onlymonth":
      out = DateFormat('MMM').format(datetime);
      break;
    case "onlymonthword":
      out = DateFormat('MM').format(datetime);
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



// Future billPrinterMap(Map billdata, BuildContext context) async {
//   final printerdata = Hive.box('printerdetails');
//   var printer = printerdata.get('printer');
//   if (printer != null && printer.toString() != '') {
//     if (printer.toString().contains('192.168.')) {
//       await wifisalesbill(billdata);
//     } else {
//       if (Platform.isWindows) {
//         await windowsusbsalesbill(billdata);
//       } else {
//         await andriodsalesbill(billdata);
//       }
//     }
//   } else {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//           child: Scaffold(
//         appBar: AppBar(
//           title: const Text('SALES BILL'),
//         ),
//         body:
//             PdfPreview(build: (format) async => (await salesBillPdf(billdata))),
//       )),
//     );
//   }
// }
