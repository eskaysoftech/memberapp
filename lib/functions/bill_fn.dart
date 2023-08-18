import 'dart:io';

import 'package:memberapp/functions/app_func.dart';
import 'package:memberapp/localstore/global_var.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import "package:pdf/pdf.dart";
import 'package:pdf/widgets.dart' as pw;

Future downloadbill(var data) async {
  // final pdf = pw.Document();
  try {
    final pdffile = await createBillPdf(data);

    /// to download n save file with name in android and windows

    String dirloc = "";
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      if (status.isGranted) {
        dirloc = "/sdcard/download";
      } else {
        dirloc = "/sdcard/download";
      }
    } else {
      var loc = (await getApplicationDocumentsDirectory()).path;
// Create Directory
      final dirpath = Directory("$loc/Club_Bills");

// Check if Directory exists and create
      if (!(await dirpath.exists())) {
        dirpath.create();
      }
      dirloc = dirpath.path.toString();
    }

    int num = 1;
    print(dirloc);
    File file = File(
        "$dirloc/ClubBill_${datetime('monthf', data['start'].toString())} - ${datetime('monthf', data['end'].toString())}.pdf");
    while (await file.exists()) {
      file = File(
          "$dirloc/ClubBill_${datetime('monthf', data['start'].toString())} - ${datetime('monthf', data['end'].toString())}(${num++}).pdf");
    }
    var saveyn = await file.writeAsBytes(pdffile);

    return saveyn;
  } catch (e) {
    return null;
  }
}

Future createBillPdf(var data) async {
  final pdf = pw.Document();
  /*  final headerimage = await imageFromAssetBundle(
      'media/belgaum_club_header.png');  */ // needs printing package

  ByteData _bytes = await rootBundle.load('media/clublogo.png');
  var logobytes = _bytes.buffer.asUint8List();
  final headerimage = pw.MemoryImage(logobytes);
  /*  final headerimage = PdfImage.file(
    pdf.document,
    bytes: logobytes,
  ); */
/*   final headerimage =
      pw.MemoryImage(File('media/clublogo.png').readAsBytesSync()); */

  pw.EdgeInsets tmargin =
      const pw.EdgeInsets.only(top: 25.0, left: 25, right: 25.0, bottom: 8.0);

  pw.TextStyle b2512 = pw.TextStyle(
    color: const PdfColor.fromInt(0xFF252525),
    fontSize: 9,
    fontWeight: pw.FontWeight.bold,
  );

  pw.TextStyle b259 = pw.TextStyle(
    color: const PdfColor.fromInt(0xFF252525),
    fontSize: 9,
    fontWeight: pw.FontWeight.normal,
  );
  pw.TextStyle ff12 = pw.TextStyle(
    color: const PdfColor.fromInt(0xFFffffff),
    fontSize: 10,
    fontWeight: pw.FontWeight.bold,
  );
  // pw.TextStyle ff14 = pw.TextStyle(
  //   color: const PdfColor.fromInt(0xFFffffff),
  //   fontSize: 11,
  //   fontWeight: pw.FontWeight.bold,
  // );

  pdf.addPage(pw.Page(
      /*  theme: pw.ThemeData.withFont(
        base: await PdfGoogleFonts.robotoCondensedRegular(),
        bold: await PdfGoogleFonts.robotoCondensedBold(),
        icons: await PdfGoogleFonts.materialIcons(),
      ), */
      pageFormat: PdfPageFormat.a4,
      margin: tmargin, // const pw.EdgeInsets.all(0),
      build: (context) {
        return pw.Container(
          /*   width: MediaQuery.of(context).size.width * 0.45,
    height: MediaQuery.of(context).size.height * 0.85, */
          decoration: pw.BoxDecoration(
            color: PdfColors.white,
            borderRadius: pw.BorderRadius.circular(2),
          ),
          child: pw.Padding(
            padding: const pw.EdgeInsets.fromLTRB(
                20, 0, 20, 20), //EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
            child: pw.Column(
              mainAxisSize: pw.MainAxisSize.max,
              children: [
                pw.Container(
                    child: pw.Image(
                  headerimage as pw.ImageProvider,
                  width: 150,
                  height: 120,
                  fit: pw.BoxFit.fitWidth,
                )),
                pw.Padding(
                  padding: const pw.EdgeInsets.fromLTRB(0, 10, 0,
                      10), //EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                  child: pw.Container(
                    width: double.infinity,
                    height: 35,
                    decoration: const pw.BoxDecoration(
                      color: PdfColor.fromInt(0xFFEDEDED),
                    ),
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.fromLTRB(5, 5, 5,
                          5), //EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                      child: pw.Column(
                        mainAxisSize: pw.MainAxisSize.max,
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            flagShopDetails['address']
                                .toString(), // 'Club Road,Belagavi-590001 Tel:0831-2420532',
                            style: b2512,
                          ),
                          pw.Text(
                            flagShopDetails['address1']
                                .toString(), //' Email : info@belgaumclub.in GST No. 29AAAAB5928M1ZD',
                            style: b2512,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.fromLTRB(0, 0, 0,
                      10), // EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                  child: pw.Container(
                    width: double.infinity,
                    height: 25,
                    decoration: const pw.BoxDecoration(
                        color: PdfColor.fromInt(
                            0XFFFFFF)) //Color.fromARGB(0, 237, 237, 237),
                    ,
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.fromLTRB(5, 0, 0,
                          0), // EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      child: pw.Column(
                        mainAxisSize: pw.MainAxisSize.max,
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Bill Details : ${datetime('monthf', data['start'].toString())} - ${datetime('monthf', data['end'].toString())}',
                            style: b259,
                          ),
                          pw.Text(
                            '${data["memberid"]} | ${data["membername"]}',
                            style: b259,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                pw.Container(
                  width: double.infinity,
                  height: 23,
                  decoration: pw.BoxDecoration(
                    color: const PdfColor.fromInt(0xFFC92C6D),
                    borderRadius: pw.BorderRadius.circular(2),
                  ),
                  child: pw.Row(
                    mainAxisSize: pw.MainAxisSize.max,
                    children: [
                      pw.Container(
                        width: 80,
                        height: 100,
                        decoration: const pw.BoxDecoration(),
                        child: pw.Row(
                          mainAxisSize: pw.MainAxisSize.max,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(
                              'INVOICE',
                              style: ff12,
                            ),
                          ],
                        ),
                      ),
                      pw.Container(
                        width: 70,
                        height: 100,
                        decoration: const pw.BoxDecoration(),
                        child: pw.Row(
                          mainAxisSize: pw.MainAxisSize.max,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(
                              'DATE',
                              style: ff12,
                            ),
                          ],
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Container(
                          width: 100,
                          height: 100,
                          decoration: const pw.BoxDecoration(),
                          child: pw.Padding(
                            padding: const pw.EdgeInsets.fromLTRB(5, 0, 5,
                                0), // EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                            child: pw.Row(
                              mainAxisSize: pw.MainAxisSize.max,
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: [
                                pw.Text(
                                  'DETAILS',
                                  style: ff12,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 80,
                        height: 100,
                        decoration: const pw.BoxDecoration(),
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.fromLTRB(5, 0, 5,
                              0), // EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                          child: pw.Row(
                            mainAxisSize: pw.MainAxisSize.max,
                            mainAxisAlignment: pw.MainAxisAlignment.end,
                            children: [
                              pw.Text(
                                'RATE',
                                style: ff12,
                              ),
                            ],
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 50,
                        height: 100,
                        decoration: const pw.BoxDecoration(),
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.fromLTRB(5, 0, 5,
                              0), //EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                          child: pw.Row(
                            mainAxisSize: pw.MainAxisSize.max,
                            mainAxisAlignment: pw.MainAxisAlignment.end,
                            children: [
                              pw.Text(
                                'TAX',
                                style: ff12,
                              ),
                            ],
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 65,
                        height: 100,
                        decoration: const pw.BoxDecoration(),
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.fromLTRB(5, 0, 5,
                              0), // EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                          child: pw.Row(
                            mainAxisSize: pw.MainAxisSize.max,
                            mainAxisAlignment: pw.MainAxisAlignment.end,
                            children: [
                              pw.Text(
                                'TAX (Rs)',
                                style: ff12,
                              ),
                            ],
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 90,
                        height: 100,
                        decoration: const pw.BoxDecoration(),
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.fromLTRB(5, 0, 5,
                              0), //EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                          child: pw.Row(
                            mainAxisSize: pw.MainAxisSize.max,
                            mainAxisAlignment: pw.MainAxisAlignment.end,
                            children: [
                              pw.Text(
                                'AMOUNT',
                                style: ff12,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                listBilldata(data['list'])
              ],
            ),
          ),
        );
      }));
  return await pdf.save();
}

pw.Widget listBilldata(List data) {
  List<pw.Container> file = [];
  // totalMember = 0;

  double disrate = 0;
  double distax = 0;
  double disamount = 0;
  pw.TextStyle ff14 = pw.TextStyle(
    color: const PdfColor.fromInt(0xFFffffff),
    fontSize: 11,
    fontWeight: pw.FontWeight.bold,
  );

  pw.TextStyle ff10 = pw.TextStyle(
    color: const PdfColor.fromInt(0xFF000000),
    fontSize: 8.8,
    fontWeight: pw.FontWeight.normal,
  );
  int fileindex = 1;
  for (var e in data) {
    double rate = double.parse(e['rate'].toString());
    double tax = double.parse(e['taxamt'].toString());
    rate = e['withintaxyn'].toString() == "Y" ? (rate - tax) : rate;
    double amount = double.parse(e['amount'].toString());

    disrate += rate;
    distax += tax;
    disamount += amount;
    PdfColor filecolr = fileindex.isEven
        ? const PdfColor.fromInt(0xFFEDEDED)
        : const PdfColor.fromInt(0XFFFFFF);
    file.add(pw.Container(
      width: double.infinity,
      height: 23,
      decoration: pw.BoxDecoration(color: filecolr),
      child: pw.Row(
        mainAxisSize: pw.MainAxisSize.max,
        children: [
          pw.Container(
            width: 80,
            height: 100,
            decoration: const pw.BoxDecoration(),
            child: pw.Row(
              mainAxisSize: pw.MainAxisSize.max,
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  e['invoiceno'].toString(),
                  style: ff10,
                ),
              ],
            ),
          ),
          pw.Container(
            width: 70,
            height: 100,
            decoration: const pw.BoxDecoration(),
            child: pw.Row(
              mainAxisSize: pw.MainAxisSize.max,
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  datetime('date', e['trdate'].toString()),
                  style: ff10,
                ),
              ],
            ),
          ),
          pw.Expanded(
            child: pw.Container(
              width: 100,
              height: 100,
              decoration: const pw.BoxDecoration(),
              child: pw.Padding(
                padding: const pw.EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: pw.Row(
                  mainAxisSize: pw.MainAxisSize.max,
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text(
                      e['menuitemname'],
                      style: ff10,
                    ),
                  ],
                ),
              ),
            ),
          ),
          pw.Container(
            width: 80,
            height: 100,
            decoration: const pw.BoxDecoration(),
            child: pw.Padding(
              padding: const pw.EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: pw.Row(
                mainAxisSize: pw.MainAxisSize.max,
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    rate.toStringAsFixed(2),
                    style: ff10,
                  ),
                ],
              ),
            ),
          ),
          pw.Container(
            width: 50,
            height: 100,
            decoration: const pw.BoxDecoration(),
            child: pw.Padding(
              padding: const pw.EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: pw.Row(
                mainAxisSize: pw.MainAxisSize.max,
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    '${e['tax']} %',
                    style: ff10,
                  ),
                ],
              ),
            ),
          ),
          pw.Container(
            width: 65,
            height: 100,
            decoration: const pw.BoxDecoration(),
            child: pw.Padding(
              padding: const pw.EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: pw.Row(
                mainAxisSize: pw.MainAxisSize.max,
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    tax.toStringAsFixed(2),
                    style: ff10,
                  ),
                ],
              ),
            ),
          ),
          pw.Container(
            width: 90,
            height: 100,
            decoration: const pw.BoxDecoration(),
            child: pw.Padding(
              padding: const pw.EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: pw.Row(
                mainAxisSize: pw.MainAxisSize.max,
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    amount.toStringAsFixed(2),
                    style: ff10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
    fileindex++;
  }

  return pw.Expanded(
      child: pw.Container(
          child: pw.Column(children: [
    pw.Expanded(
      child: pw.Padding(
        padding: const pw.EdgeInsets.fromLTRB(
            0, 10, 0, 10), //pw.EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
        child: pw.Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const pw.BoxDecoration(),
          child: pw.Column(mainAxisSize: pw.MainAxisSize.max, children: file),
        ),
      ),
    ),
    pw.Container(
      width: double.infinity,
      height: 25,
      decoration: pw.BoxDecoration(
        color: const PdfColor.fromInt(0xFFC92C6D), // Color(0xFFC92C6D),
        borderRadius: pw.BorderRadius.circular(2),
      ),
      child: pw.Row(
        mainAxisSize: pw.MainAxisSize.max,
        children: [
          pw.Container(
            width: 80,
            height: 100,
            decoration: const pw.BoxDecoration(),
            child: pw.Row(
              mainAxisSize: pw.MainAxisSize.max,
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  'TOTAL',
                  style: ff14,
                ),
              ],
            ),
          ),
          pw.Container(
            width: 70,
            height: 100,
            decoration: const pw.BoxDecoration(),
          ),
          pw.Expanded(
            child: pw.Container(
              width: 100,
              height: 100,
              decoration: const pw.BoxDecoration(),
            ),
          ),
          pw.Container(
            width: 80,
            height: 100,
            decoration: const pw.BoxDecoration(),
            child: pw.Padding(
              padding: const pw.EdgeInsets.fromLTRB(
                  5, 0, 5, 0), //EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
              child: pw.Row(
                mainAxisSize: pw.MainAxisSize.max,
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    disrate.toStringAsFixed(2),
                    style: ff14,
                  ),
                ],
              ),
            ),
          ),
          pw.Container(
            width: 50,
            height: 100,
            decoration: const pw.BoxDecoration(),
            child: pw.Padding(
              padding: const pw.EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: pw.Row(
                mainAxisSize: pw.MainAxisSize.max,
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    '',
                    style: ff14,
                  ),
                ],
              ),
            ),
          ),
          pw.Container(
            width: 65,
            height: 100,
            decoration: const pw.BoxDecoration(),
            child: pw.Padding(
              padding: const pw.EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: pw.Row(
                mainAxisSize: pw.MainAxisSize.max,
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    distax.toStringAsFixed(2),
                    style: ff14,
                  ),
                ],
              ),
            ),
          ),
          pw.Container(
            width: 90,
            height: 100,
            decoration: const pw.BoxDecoration(),
            child: pw.Padding(
              padding: const pw.EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: pw.Row(
                mainAxisSize: pw.MainAxisSize.max,
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    disamount.toStringAsFixed(2),
                    style: ff14,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  ])));
}
