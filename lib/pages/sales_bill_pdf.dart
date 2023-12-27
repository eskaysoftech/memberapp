import 'package:intl/intl.dart';
import 'package:memberapp/functions/app_func.dart';
import "package:pdf/pdf.dart";
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:number_to_words/number_to_words.dart';

import '../localstore/global_var.dart';

Future salesBillPdf(Map printdata, fheader, ffooter) async {
  grandtot = 0;
  List<pw.Widget> pageLst = [];
  var header = fheader;
  var footer = ffooter;

  pageLst = [
    billHeader(header),
    detailsTab(
      printdata['trdate'].toString(),
      printdata['orderno'].toString(),
      printdata['tablekey'].toString(),
      printdata['tableno'].toString(),
      printdata['waiterkey'].toString(),
      printdata['waitername'].toString(),
      printdata['transactiontype'].toString(),
      printdata['contactid'].toString(),
      printdata['contactname'].toString(),
      printdata['contactmobile'].toString(),
      printdata['contactadd'].toString(),
      printdata['contactgst'].toString(),
      printdata['barbilldata'] != null ? "Liqour" : "Food",
      printdata['barbilldata'] != null
          ? printdata['barbilldata']['billno'].toString()
          : printdata['foodbilldata'] != null
              ? printdata['foodbilldata']['billno'].toString()
              : '',
      printdata['sectioncode'].toString(),
      printdata,
    ),
  ];
  if (printdata['barbilldata'] != null) {
    var barbill = printdata['barbilldata'];
    // headertbl('LIQOUR', barbill['billno'].toString());
    pageLst.add(contenttab(barbill['billitems'], 'L',
        barbill['billno'].toString(), true, printdata));
  }
  if (printdata['foodbilldata'] != null) {
    var foodbill = printdata['foodbilldata'];

    pageLst.add(contenttab(
        foodbill['billitems'],
        'F',
        foodbill['billno'].toString(),
        printdata['barbilldata'] == null,
        printdata));
  }
  if (printdata['transactiontype'] != 'XI') {
    pageLst.add(totbilldata(
        double.parse(printdata['total'].toString()),
        double.parse(printdata['round'].toString()),
        printdata['paymentmode1'] ?? '',
        printdata['paymentmode2'] ?? '',
        double.parse(printdata['payment1'].toString()),
        double.parse(printdata['payment2'].toString()),
        printdata));
  }
  pageLst.add(billFooter(footer));
  /*  pageLst.add(TotWid((double.parse(printdata['total'].toString()) +
      double.parse(printdata['round'].toString())))); */

  if (printdata['paymentqrcodelink'].toString() != '') {
    pageLst.add(qrCode(printdata['paymentqrcodelink'].toString(), printdata));
  }
  // pageLst.add(datetimeWid(printdata['edatetime'].toString())); //changed as per asked on 09-10-23

  final pdf = pw.Document();
/*   for (int i = 0;
      i < int.parse(flagApplication['noofcopiesbilltoprint'].toString());
      i++) { */
  const double inch = 75.0;
  const double mm = inch / 25.0;

  pdf.addPage(pw.Page(
      theme: pw.ThemeData.withFont(
        base: await PdfGoogleFonts
            .oswaldMedium(), //.oswaldRegular(), //.robotoMonoRegular(),
        bold: await PdfGoogleFonts.oswaldBold(),
        //.robotoMonoBold(), //PdfGoogleFonts.robotoCondensedBold(),
        icons: await PdfGoogleFonts.materialIcons(),
      ),
      pageFormat: const PdfPageFormat(80 * mm, double.infinity,
          marginTop: 5 * mm,
          marginBottom: 5 * mm,
          marginLeft: 3 * mm,
          marginRight: 10 * mm),

      // margin: tmargin, // const pw.EdgeInsets.all(0),
      build: (context) {
        return pw.Expanded(
            child: pw.Container(
                width: double.infinity,
                padding: pw.EdgeInsets.all(5),
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  //  border: pw.Border.all(color: PdfColors.black)
                ),
                child: pw.Column(
                    mainAxisSize: pw.MainAxisSize.max, children: pageLst)));
      }));

  return await pdf.save();
}

Map withintaxitems = {};
Map abovetaxtitems = {};
double t_amtfile = 0;

pw.Widget wid2Struct(String htext, String textstr) {
  pw.TextStyle detstyle = pw.TextStyle(
    color: PdfColors.black,
    fontSize: 9,
    fontWeight: pw.FontWeight.normal,
  );
  return pw.Container(
      width: double.infinity,
      decoration:
          pw.BoxDecoration(/* border: pw.Border.all(color: PdfColors.black) */),
      child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          //mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
          children: [
            pw.Container(
                width: 40,
                child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [pw.Text(htext, style: detstyle)])),
            pw.Expanded(
                child: pw.Container(
                    width: double.infinity,
                    child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            textstr,
                            style: detstyle,
                          )
                        ])))
          ]));
}

pw.Widget threeWidStruct(String txt1, String txt2, String txt3, bool boldyn) {
  pw.TextStyle detstyle = pw.TextStyle(
    color: PdfColors.black,
    fontSize: 9,
    fontWeight: boldyn ? pw.FontWeight.bold : pw.FontWeight.normal,
  );
  return pw.Container(
      child: pw.Row(children: [
    pw.Expanded(
        child: pw.Container(
            width: double.infinity,
            child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    txt1,
                    style: detstyle,
                  )
                ]))),
    pw.Container(
        width: 60,
        child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [pw.Text(txt2, style: detstyle)])),
    pw.Container(
        width: 40,
        child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [pw.Text(txt3, style: detstyle)])),
  ]));
}

pw.Widget tableStruct(
    String txt1, String txt2, String txt3, String txt4, bool headyn) {
  pw.TextStyle detstyle = pw.TextStyle(
    color: PdfColors.black,
    fontSize: headyn ? 10 : 9,
    fontWeight: pw.FontWeight
        .normal, //headyn ? pw.FontWeight.bold : pw.FontWeight.normal,
  );
  return pw.Container(
      padding: pw.EdgeInsets.only(top: 2),
      decoration: pw.BoxDecoration(
          border: headyn
              ? const pw.Border(
                  top: pw.BorderSide(
                    color: PdfColors.black,
                    style: pw.BorderStyle.dashed,
                  ),
                  bottom: pw.BorderSide(
                    color: PdfColors.black,
                    style: pw.BorderStyle.dashed,
                  ))
              : null),
      child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Expanded(
                child: pw.Container(
                    width: double.infinity,
                    child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            txt1,
                            style: detstyle,
                          )
                        ]))),
            pw.Container(
                width: 20,
                child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [pw.Text(txt2, style: detstyle)])),
            pw.Container(
                width: 40,
                child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [pw.Text(txt3, style: detstyle)])),
            pw.Container(
                width: 40,
                child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [pw.Text(txt4, style: detstyle)])),
          ]));
}

pw.Widget grandNtotWid(String txt1, String txt2, String grandyn) {
  pw.TextStyle totstyle = pw.TextStyle(
      color: PdfColors.black,
      fontSize: grandyn == 'Y' ? 10 : 16,
      letterSpacing: 1
      //fontWeight: pw.FontWeight.bold,
      );
  return pw.Container(
      margin: pw.EdgeInsets.only(top: 5, bottom: 5),
      decoration: pw.BoxDecoration(
          border: grandyn == 'Y'
              ? const pw.Border(
                  top: pw.BorderSide(
                    color: PdfColors.black,
                    style: pw.BorderStyle.dashed,
                  ),
                  bottom: pw.BorderSide(
                    color: PdfColors.black,
                    style: pw.BorderStyle.dashed,
                  ))
              : null),
      child: pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Container(
            width: 100,
            child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [pw.Text(txt1, style: totstyle)])),
        pw.Expanded(
            child: pw.Container(
                width: double.infinity,
                child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        txt2,
                        style: totstyle,
                      )
                    ])))
      ]));
}

pw.Widget taxStruct(String txt1, String txt2, String txt3, String txt4,
    String txt5, String txt6, bool headyn, bool cess) {
  pw.TextStyle detstyle = pw.TextStyle(
    color: PdfColors.black,
    fontSize: headyn ? 10 : 8,
    fontWeight: pw.FontWeight
        .normal, //headyn ? pw.FontWeight.bold : pw.FontWeight.normal,
  );
  List<pw.Widget> rowlist = [];
  if (cess == false) {
    rowlist = [
      pw.Expanded(
          child: pw.Container(
              width: double.infinity,
              child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      txt1,
                      style: detstyle,
                    )
                  ]))),
      pw.Container(
          width: 23,
          padding: EdgeInsets.only(right: 2),
          child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [pw.Text(txt2, style: detstyle)])),
      pw.Container(
          width: 38,
          padding: EdgeInsets.only(left: 2, right: 2),
          child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [pw.Text(txt3, style: detstyle)])),
      pw.Container(
          width: 25,
          padding: EdgeInsets.only(left: 2, right: 2),
          child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [pw.Text(txt4, style: detstyle)])),
      pw.Container(
          width: 25,
          padding: EdgeInsets.only(left: 2, right: 2),
          child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [pw.Text(txt5, style: detstyle)])),
      if (txt6 != '')
        pw.Container(
            width: 25,
            padding: EdgeInsets.only(left: 2, right: 2),
            child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [pw.Text(txt6, style: detstyle)]))
    ];
  } else {
    rowlist = [
      pw.Expanded(
          child: pw.Container(
              width: double.infinity,
              child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      txt1,
                      style: detstyle,
                    )
                  ]))),
      pw.Container(
          width: 30,
          child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [pw.Text(txt2, style: detstyle)])),
      pw.Container(
          width: 55,
          padding: EdgeInsets.only(left: 2, right: 2),
          child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [pw.Text(txt3, style: detstyle)])),
      pw.Container(
          width: 55,
          padding: EdgeInsets.only(left: 2, right: 2),
          child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [pw.Text(txt4, style: detstyle)]))
    ];
  }

  return pw.Container(
      decoration: pw.BoxDecoration(
          border: headyn
              ? const pw.Border(
                  top: pw.BorderSide(
                    color: PdfColors.black,
                    style: pw.BorderStyle.dashed,
                  ),
                  bottom: pw.BorderSide(
                    color: PdfColors.black,
                    style: pw.BorderStyle.dashed,
                  ))
              : null),
      padding: !headyn ? EdgeInsets.only(top: 2, bottom: 2) : null,
      child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: rowlist));
}

pw.Widget wid4Struct(
  String txt1,
  String txt2,
  String txt3,
  String txt4,
) {
  pw.TextStyle detstyle = pw.TextStyle(
    color: PdfColors.black,
    fontSize: 9,
    fontWeight: pw.FontWeight
        .normal, //headyn ? pw.FontWeight.bold : pw.FontWeight.normal,
  );
  return pw.Container(
      decoration: pw.BoxDecoration(),
      child: pw.Row(children: [
        pw.Container(
            width: 55,
            child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [pw.Text(txt1, style: detstyle)])),
        pw.Expanded(
            child: pw.Container(
                width: double.infinity,
                child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        txt2,
                        style: detstyle,
                      )
                    ]))),
        pw.Container(
            width: 25,
            decoration:
                BoxDecoration(), //border: Border.all(color: PdfColors.amber)
            child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [pw.Text(txt3, style: detstyle)])),
        pw.Expanded(
            child: pw.Container(
                width: double.infinity,
                // margin: pw.EdgeInsets.only(left: 5),
                child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        txt4,
                        style: detstyle,
                      )
                    ]))),
      ]));
}

pw.Widget detailsTab(
    String date,
    String orderno,
    String tabletitle,
    String tableno,
    String waitertitle,
    String waiter,
    String trans,
    String customerid,
    String custname,
    String mblno,
    String custaddr,
    String gstno,
    String billtitle,
    String billno,
    String section,
    Map data) {
  String dtformat;

  List<pw.Widget> colList = [];
  pw.TextStyle fbstyle = pw.TextStyle(
    color: PdfColors.black,
    fontSize: 10,
    fontWeight: pw.FontWeight.bold,
  );

  dtformat = datetime('date', date);
  String transtitle = trans == 'XI' ? 'Provisional Bill' : "Invoice No";
  String transnum = trans == 'XI' ? orderno : billno;
  String invoicetitle = trans == 'I' ? 'Provisional Bill No' : '';

  colList.add(pw.Container(
      width: double.infinity,
      margin: pw.EdgeInsets.only(top: 5),
      padding: pw.EdgeInsets.only(bottom: 3, top: 3),
      decoration: const pw.BoxDecoration(
          border: pw.Border(
        top: pw.BorderSide(
          color: PdfColors.black,
          //style: pw.BorderStyle.dashed,
        ),
        /*    bottom: pw.BorderSide(
                color: PdfColors.black,
                style: pw.BorderStyle.dashed,
              ) */
      )),
      child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            wid4Struct(
              transtitle,
              ": $transnum",
              (waitertitle != '') ? waitertitle : '',
              (waiter != '') ? ": $waiter" : '',
            ),
            wid2Struct('Date',
                ": $dtformat ${datetime('time', data['edatetime'].toString())}"),
            wid4Struct(
              section != '' ? section : '',
              "",
              '',
              '',
            )
          ])));
  if (flagApplication['defaultcustomer'].toString() != customerid)
    colList.add(pw.Container(
        decoration: const pw.BoxDecoration(
            border: pw.Border(
                top: pw.BorderSide(
          color: PdfColors.black,
          // style: pw.BorderStyle.dashed,
        ))),
        margin: pw.EdgeInsets.only(bottom: 5),
        padding: pw.EdgeInsets.only(top: 3),
        child: pw.Column(children: [
          wid2Struct('Mem No', ": $tableno"),
          wid2Struct('Name', ": $custname"),
          /*   wid2Struct("Mobile No", ": $mblno"),
          wid2Struct("Address", ": $custaddr"), */
        ])));

  return pw.Container(
      width: double.infinity,
      decoration:
          pw.BoxDecoration(/* border: pw.Border.all(color: PdfColors.black) */),
      /*  padding:
          pw.EdgeInsets.only(left: 5, right: 5), */ //65), //edited on 25-05-23
      child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start, children: colList));
}

pw.Widget qrCode(String paylink, Map data) {
  var qr = paylink.replaceAll(
      '#amt#', (grandtot + double.parse(data['round'].toString())).toString());

  return pw.Container(
      width: double.infinity,
      decoration: pw.BoxDecoration(),
      child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.BarcodeWidget(
                data: qr, barcode: Barcode.qrCode(), width: 50, height: 50)
          ]));
}

pw.Widget totbilldata(double total, double roundamt, String paym1, String paym2,
    double pay1, double pay2, Map data) {
  List<pw.Widget> colList = [];
  pw.TextStyle dstyle = pw.TextStyle(
    color: PdfColors.black,
    fontSize: 9,
    fontWeight: pw.FontWeight.bold,
  );

  if (roundamt != 0 || t_disc != 0) {
    colList.add(
        threeWidStruct("", "Total Bill", grandtot.toStringAsFixed(2), false));
  }

  if (roundamt != 0) {
    colList.add(
        threeWidStruct("", "Round Up", roundamt.toStringAsFixed(2), false));
  }
  if (total > 0) {
    colList.add(pw.Container(
        decoration: pw.BoxDecoration(
            border: pw.Border(
          top: pw.BorderSide(
            color: PdfColors.black,
            style: pw.BorderStyle.dashed,
          ),
        )),
        width: double.infinity,
        //  margin: pw.EdgeInsets.only(top: 5),
        padding: pw.EdgeInsets.only(top: 3),
        child:
            pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
          Expanded(child: Text("GRAND TOTAL", style: dstyle)),
          Expanded(
              child: Text((grandtot + roundamt).toStringAsFixed(2),
                  style: dstyle, textAlign: TextAlign.right))
        ])));
  }
  //threeWidStruct("Grand Total", "", (total + roundamt).toStringAsFixed(2)));

  if (data['foodbilldata'] != null &&
      data['transactiontype'].toString() == 'I') {
    if (taxavl) {
      if (withintaxitems.isNotEmpty) {
        colList.add(TaxData(withintaxitems));
      }
    }
  }
  if (paym1 != 'US') {
    pay1 > 0
        ? colList
            .add(threeWidStruct("", "$paym1 :", pay1.toStringAsFixed(2), true))
        : '';
    pay2 > 0
        ? colList
            .add(threeWidStruct("", "$paym2 :", pay2.toStringAsFixed(2), true))
        : '';
  }

  int bint = (grandtot + roundamt).toInt();
  if (bint > 0) {
    String ntw = '${NumberToWord().convert('en-in', bint)}only';
    colList.add(pw.Container(
        decoration: pw.BoxDecoration(
            border: pw.Border(
                top: pw.BorderSide(
                  color: PdfColors.black,
                  style: pw.BorderStyle.dashed,
                ),
                bottom: pw.BorderSide(
                  color: PdfColors.black,
                  style: pw.BorderStyle.dashed,
                ))),
        width: double.infinity,
        margin: pw.EdgeInsets.only(top: 5),
        child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [pw.Text(ntw.toUpperCase(), style: dstyle)])));
  }
  return pw.Container(
      width: double.infinity,
      decoration:
          pw.BoxDecoration(/* border: pw.Border.all(color: PdfColors.black) */),
      /*  padding:
          pw.EdgeInsets.only(left: 5, right: 5), */ //65), //edited on 25-05-23
      child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start, children: colList));
}

double t_amt = 0;
double t_tax = 0;
double t_disc = 0;
double grandtot = 0;
bool taxavl = false;

pw.Widget taxsumm(taxdet) {
  List<pw.Widget> colList = [];
  List cesslist = taxdet.values
      .toList()
      .where((t) => double.parse(t['cess'].toString()) > 0)
      .toList();
  List taxlist = taxdet.values
      .toList()
      .where((t) => double.parse(t['cess'].toString()) == 0)
      .toList();
  for (var t in taxlist) {
    if (double.parse(t['igst'].toString()) > 0) {
      colList.add(threeWidStruct("", "IGST ${t['taxpercentage'].toString()}%:",
          double.parse(t['igst'].toString()).toStringAsFixed(2), false));
    }
    if (double.parse(t['sgst'].toString()) > 0) {
      colList.add(threeWidStruct(
          "",
          "CGST ${(double.parse(t['gstper'].toString()) / 2).toStringAsFixed(2)}%:",
          double.parse(t['cgst'].toString()).toStringAsFixed(2),
          false));
      colList.add(threeWidStruct(
          "",
          "SGST ${(double.parse(t['gstper'].toString()) / 2).toStringAsFixed(2)}%:",
          double.parse(t['sgst'].toString()).toStringAsFixed(2),
          false));
    }
  }
  if (cesslist.isNotEmpty) {
    for (var t in cesslist) {
      if (double.parse(t['cess'].toString()) > 0) {
        colList.add(threeWidStruct(
            "",
            "CESS ${double.parse(t['cessper'].toString()).toStringAsFixed(2)}%:",
            double.parse(t['cess'].toString()).toString(),
            false));
      }
    }
  }

  return pw.Container(
      width: double.infinity,
      decoration:
          pw.BoxDecoration(/* border: pw.Border.all(color: PdfColors.black) */),
      /*  padding:
          pw.EdgeInsets.only(left: 5, right: 5), */ //65), //edited on 25-05-23
      child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start, children: colList));
}

bool cessavl = false;
pw.Widget contenttab(
    List items, String itemtype, String billno, bool headeryn, Map data) {
  List<pw.Widget> colList = [];

  withintaxitems = {};
  abovetaxtitems = {};

  t_tax = 0;
  t_disc = 0;
  t_tax = 0;
  t_amt = 0;
  t_disc = 0;
  double c_amt = 0;
  taxavl = false;
  t_amtfile = 0;
  cessavl = false;

  colList.add(pw.Container(
      margin: pw.EdgeInsets.only(bottom: 5),
      child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
          children: [
            if (headeryn)
              tableStruct("ITEM NAME", 'QTY', "RATE", "AMOUNT", true),
            ...items.map((db) {
              double qty = 0;
              if (double.parse(db['bottlequantity'].toString()) > 0) {
                qty = double.parse(db['bottlequantity'].toString());
              } else {
                qty = getMlQ(double.parse(db['mlqty'].toString()),
                    double.parse(db['quantity'].toString()));
              }
              if (db['withintaxyn'] == 'N') {
                t_tax += double.parse(db['taxamount'].toString());
              }
              t_disc += double.parse(db['discountamt'].toString());
              t_amt += (double.parse(db['rate'].toString()) * qty);
              c_amt += ((double.parse(db['rate'].toString()) * qty) -
                  double.parse(db['discountamt'].toString()));
              t_amtfile += (double.parse(db['rate'].toString()) * qty);
              if (db['withintaxyn'] == 'Y') {
                taxavl = true;
              }
              if (double.parse(db['cessamt'].toString()) > 0 &&
                  double.parse(db['cesspercentage'].toString()) > 0) {
                cessavl = true;
              }

              if (double.parse(db['taxamount'].toString()) > 0) {
                if (db['withintaxyn'] == 'Y') {
                  if (db['taxtype'] == 'IGST' || db['taxtype'] == 'VAT') {
                    if (withintaxitems.containsKey(db['hsncode'].toString() +
                        db['taxpercentage'].toString())) {
                      withintaxitems.forEach((key, value) {
                        if (key ==
                            db['hsncode'].toString() +
                                db['taxpercentage'].toString()) {
                          value['taxable'] =
                              (double.parse(value['taxable'].toString()) +
                                  (double.parse(db['amount'].toString()) -
                                      double.parse(db['taxamount'].toString()) -
                                      double.parse(db['cessamt'].toString())));
                          value['igst'] =
                              double.parse(value['igst'].toString()) +
                                  double.parse(db['taxamount'].toString());
                          if (double.parse(db['cessamt'].toString()) > 0 &&
                              double.parse(db['cesspercentage'].toString()) >
                                  0) {
                            value['cess'] =
                                double.parse(value['cess'].toString()) +
                                    double.parse(db['cessamt'].toString());
                          }
                        }
                      });
                    } else {
                      withintaxitems.addAll({
                        db['hsncode'].toString() +
                            db['taxpercentage'].toString(): {
                          "hsncode": db['hsncode'],
                          'gstper': db['taxpercentage'],
                          "taxable": (double.parse(db['amount'].toString()) -
                              double.parse(db['taxamount'].toString()) -
                              double.parse(db['cessamt'].toString())),
                          "cgst": '',
                          "sgst": '',
                          'igst': db['taxamount'],
                          "cessper": db['cesspercentage'],
                          "cess": db['cessamt'],
                          "taxtype": db['taxtype'].toString()
                        }
                      });
                    }
                  } else if (db['taxtype'] == 'GST') {
                    if (withintaxitems.containsKey(db['hsncode'].toString() +
                        db['taxpercentage'].toString())) {
                      withintaxitems.forEach((key, value) {
                        if (key ==
                            db['hsncode'].toString() +
                                db['taxpercentage'].toString()) {
                          value['taxable'] =
                              double.parse(value['taxable'].toString()) +
                                  (double.parse(db['amount'].toString()) -
                                      double.parse(db['taxamount'].toString()) -
                                      double.parse(db['cessamt'].toString()));
                          value['cgst'] =
                              double.parse(value['cgst'].toString()) +
                                  (double.parse(db['taxamount'].toString()) /
                                      2);
                          value['sgst'] =
                              double.parse(value['sgst'].toString()) +
                                  (double.parse(db['taxamount'].toString()) /
                                      2);
                          if (double.parse(db['cessamt'].toString()) > 0 &&
                              double.parse(db['cesspercentage'].toString()) >
                                  0) {
                            value['cess'] =
                                double.parse(value['cess'].toString()) +
                                    double.parse(db['cessamt'].toString());
                          }
                        }
                      });
                    } else {
                      withintaxitems.addAll({
                        db['hsncode'].toString() +
                            db['taxpercentage'].toString(): {
                          "hsncode": db['hsncode'],
                          'gstper': db['taxpercentage'],
                          "taxable": (double.parse(db['amount'].toString()) -
                              double.parse(db['taxamount'].toString()) -
                              double.parse(db['cessamt'].toString())),
                          "cgst": double.parse(db['taxamount'].toString()) / 2,
                          "sgst": double.parse(db['taxamount'].toString()) / 2,
                          'igst': 0,
                          "cessper": db['cesspercentage'],
                          "cess": db['cessamt'],
                          "taxtype": db['taxtype'].toString()
                        }
                      });
                    }
                  }
                } else if (db['withintaxyn'] == 'N') {
                  if (db['taxtype'] == 'IGST' || db['taxtype'] == 'VAT') {
                    if (abovetaxtitems.containsKey(db['hsncode'].toString() +
                        db['taxpercentage'].toString())) {
                      abovetaxtitems.forEach((key, value) {
                        if (key ==
                            db['hsncode'].toString() +
                                db['taxpercentage'].toString()) {
                          value['taxable'] = (double.parse(
                                  value['taxable'].toString()) +
                              (double.parse(db['amount'].toString()) -
                                  double.parse(db['taxamount'].toString())));
                          value['igst'] =
                              double.parse(value['igst'].toString()) +
                                  double.parse(db['taxamount'].toString());
                        }
                      });
                    } else {
                      abovetaxtitems.addAll({
                        db['hsncode'].toString() +
                            db['taxpercentage'].toString(): {
                          "hsncode": db['hsncode'],
                          'gstper': db['taxpercentage'],
                          "taxable": (double.parse(db['amount'].toString()) -
                              double.parse(db['taxamount'].toString())),
                          "cgst": 0,
                          "sgst": 0,
                          'igst': db['taxamount'],
                          "cessper": 0,
                          "cess": 0,
                          "taxtype": db['taxtype'].toString()
                        }
                      });
                    }
                  } else if (db['taxtype'] == 'GST') {
                    if (abovetaxtitems.containsKey(db['hsncode'].toString() +
                        db['taxpercentage'].toString())) {
                      abovetaxtitems.forEach((key, value) {
                        if (key ==
                            db['hsncode'].toString() +
                                db['taxpercentage'].toString()) {
                          value['taxable'] =
                              double.parse(value['taxable'].toString()) +
                                  (double.parse(db['amount'].toString()) -
                                      double.parse(db['taxamount'].toString()) -
                                      double.parse(db['cessamt'].toString()));
                          value['cgst'] =
                              double.parse(value['cgst'].toString()) +
                                  (double.parse(db['taxamount'].toString()) /
                                      2);
                          value['sgst'] =
                              double.parse(value['sgst'].toString()) +
                                  (double.parse(db['taxamount'].toString()) /
                                      2);
                        }
                      });
                    } else {
                      abovetaxtitems.addAll({
                        db['hsncode'].toString() +
                            db['taxpercentage'].toString(): {
                          "hsncode": db['hsncode'],
                          'gstper': db['taxpercentage'],
                          "taxable": (double.parse(db['amount'].toString()) -
                              double.parse(db['taxamount'].toString()) -
                              double.parse(db['cessamt'].toString())),
                          "cgst": double.parse(db['taxamount'].toString()) / 2,
                          "sgst": double.parse(db['taxamount'].toString()) / 2,
                          'igst': 0,
                          "cessper": 0,
                          "cess": 0,
                          "taxtype": db['taxtype'].toString()
                        }
                      });
                    }
                  }
                  if (double.parse(db['cessamt'].toString()) > 0 &&
                      double.parse(db['cesspercentage'].toString()) > 0) {
                    if (abovetaxtitems.containsKey(
                        "${db['hsncode']}${db['cesspercentage']}CESS")) {
                      abovetaxtitems.forEach((key, value) {
                        if (key ==
                            "${db['hsncode']}${db['cesspercentage']}CESS") {
                          value['cess'] =
                              double.parse(value['cess'].toString()) +
                                  double.parse(db['cessamt'].toString());
                        }
                      });
                    } else {
                      abovetaxtitems.addAll({
                        "${db['hsncode']}${db['taxpercentage']}CESS": {
                          "hsncode": db['hsncode'],
                          'gstper': db['taxpercentage'],
                          "taxable": (double.parse(db['amount'].toString()) -
                              double.parse(db['taxamount'].toString()) -
                              double.parse(db['cessamt'].toString())),
                          "cgst": 0,
                          "sgst": 0,
                          'igst': 0,
                          "cessper":
                              double.parse(db['cesspercentage'].toString()),
                          "cess": double.parse(db['cessamt'].toString()),
                          "taxtype": db['taxtype'].toString()
                        }
                      });
                    }
                  }
                }
              }

              return pw.Padding(
                  padding: pw.EdgeInsets.only(top: 2),
                  child: tableStruct(
                      "${db['menuitemname']} ${double.parse(db['mlqty'].toString()) > 0 ? "${db['mlqty']}ML" : ""}${db['containername']}",
                      qty.toString(),
                      double.parse(db['rate'].toString()).toStringAsFixed(2),
                      (double.parse(db['rate'].toString()) * qty)
                          .toStringAsFixed(2),
                      false));
            })
          ])));
  grandtot += t_amtfile;
  if (data['seperatebillnoforbarfood'] == 'Y') {
    colList.add(tableStruct(
        "${itemtype == 'F' ? 'Food' : 'Liqour'} ${data['transactiontype'] != 'XI' ? 'Bill No' : 'Total'} ${billno != '' && double.parse(billno) != 0 ? billno : ''}",
        '',
        "",
        t_amtfile.toStringAsFixed(2),
        true));
  } else {
    if (t_tax != 0 || data['transactiontype'] == 'XI') {
      colList.add(
          tableStruct("Total", '', "", t_amtfile.toStringAsFixed(2), true));
    }
  }

  if (data['transactiontype'] != 'XI') {
    double totsumm = 0;
    if (t_disc != 0) {
      colList.add(
          threeWidStruct("", "Discount :", t_disc.toStringAsFixed(2), false));
      totsumm += t_disc;
    }

    if (t_amt > c_amt) {
      colList.add(threeWidStruct("", "Tax :", t_tax.toStringAsFixed(2), false));
      totsumm += t_tax;
    }
    if (t_tax != 0) {
      if (abovetaxtitems.isNotEmpty) {
        colList.add(taxsumm(abovetaxtitems));
      }
    }
    if (t_disc != 0 || t_amt > c_amt) {
      colList.add(
          threeWidStruct("", "TOTAL : ", (totsumm).toStringAsFixed(2), false));
    }
  }

  return pw.Container(
      width: double.infinity,
      decoration:
          pw.BoxDecoration(/* border: pw.Border.all(color: PdfColors.black) */),
      /*  padding:
          pw.EdgeInsets.only(left: 5, right: 5), */ //65), //edited on 25-05-23
      child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start, children: colList));
}

pw.Widget TaxData(Map taxdata) {
  List<pw.Widget> colList = [];

  double totsgst = 0;
  double totcgst = 0;
  double totigst = 0;
  double tottaxamt = 0;
  double totcessamt = 0;
  colList.add(pw.Container(
      margin: EdgeInsets.only(top: 5, bottom: 5),
      decoration: const pw.BoxDecoration(),
      child: pw.Column(children: [
        cessavl
            ? taxStruct(
                "HSN Code", "Taxable", "GST", "CESS", "", '', true, cessavl)
            : taxStruct(
                'HSNCODE',
                'GST',
                'TAXABLE',
                'CGST',
                'SGST',
                taxdata.values.toList()[0]['taxtype'] == 'IGST' ? 'IGST' : '',
                true,
                cessavl),
        ...taxdata.values.map((t) {
          tottaxamt += double.parse(t['taxable'].toString());
          totcgst += double.parse(t['cgst'].toString());
          totsgst += double.parse(t['sgst'].toString());

          if (cessavl) {
            totcessamt += double.parse(t['cess'].toString());
            return taxStruct(
                t['hsncode'],
                double.parse(t['taxable'].toString()).toStringAsFixed(2),
                "(${t['gstper']}%) ${(double.parse(t['cgst'].toString()) + double.parse(t['sgst'].toString())).toStringAsFixed(2)}",
                "(${t['cessper']}%) ${double.parse(t['cess'].toString()).toStringAsFixed(2)}",
                "",
                "",
                false,
                cessavl);
          } else {
            return taxStruct(
                t['hsncode'],
                "${t['gstper']}%",
                double.parse(t['taxable'].toString()).toStringAsFixed(2),
                double.parse(t['cgst'].toString()).toStringAsFixed(2),
                double.parse(t['sgst'].toString()).toStringAsFixed(2),
                t['taxtype'] == 'IGST'
                    ? double.parse(t['igst'].toString()).toStringAsFixed(2)
                    : '',
                false,
                cessavl);
          }
        }),
        cessavl
            ? taxStruct(
                "Total",
                tottaxamt.toStringAsFixed(2),
                (totcgst + totsgst).toStringAsFixed(2),
                totcessamt.toStringAsFixed(2),
                '',
                '',
                true,
                cessavl)
            : taxStruct(
                "Total",
                "",
                tottaxamt.toStringAsFixed(2),
                totcgst.toStringAsFixed(2),
                totsgst.toStringAsFixed(2),
                totigst > 0 ? totigst.toStringAsFixed(2) : '',
                true,
                cessavl)
      ])));
  return pw.Container(
      width: double.infinity,
      decoration: pw.BoxDecoration(),
      child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start, children: colList));
}

pw.Widget billHeader(var header) {
  var file;

  List<pw.Widget> colList = [];
  file = header;

  if (file['result'] == true) {
    pw.TextStyle fstyle = pw.TextStyle(
      color: PdfColors.black,
      fontSize: 9,
      fontWeight: pw.FontWeight.normal,
    );
    for (var db in file['data']) {
      int fsize = double.parse(db['font_size'].toString()).toInt();
      if (fsize >= 3) {
        fstyle = pw.TextStyle(
          color: PdfColors.black,
          fontSize: 12,
          fontWeight: db['boldyn'].toString() == 'Y'
              ? pw.FontWeight.bold
              : pw.FontWeight.normal,
        );
      } else if (fsize == 2) {
        fstyle = pw.TextStyle(
          color: PdfColors.black,
          fontSize: 10,
          fontWeight: db['boldyn'].toString() == 'Y'
              ? pw.FontWeight.bold
              : pw.FontWeight.normal,
        );
      } else {
        fstyle = pw.TextStyle(
          color: PdfColors.black,
          fontSize: 9,
          fontWeight: db['boldyn'].toString() == 'Y'
              ? pw.FontWeight.bold
              : pw.FontWeight.normal,
        );
      }
      colList.add(pw.Container(
          margin: pw.EdgeInsets.only(bottom: 2),
          child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(db['texttoprint'].toString(), style: fstyle)
              ])));
    }
  }
  return pw.Container(
    decoration:
        pw.BoxDecoration(/* border: pw.Border.all(color: PdfColors.black) */),
    width: double.infinity,
    child: pw.Column(children: colList),
  );
}

pw.Widget TotWid(double tot) {
  return pw.Container(
      //  margin: pw.EdgeInsets.only(top: 15, bottom: 5),
      decoration:
          pw.BoxDecoration(/* border: pw.Border.all(color: PdfColors.black) */),
      child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
          children: [grandNtotWid("TOTAL", tot.toStringAsFixed(2), 'N')]));
}

pw.Widget datetimeWid(String datetime) {
  pw.TextStyle dstyle = pw.TextStyle(
    color: PdfColors.black,
    fontSize: 10,
    fontWeight: pw.FontWeight.normal,
  );
  return pw.Container(
      width: double.infinity,
      child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: [
            pw.Text(DateFormat("HH:mm:ss").format(DateTime.parse(datetime)),
                style: dstyle)
          ]));
}

pw.Widget billFooter(var footer) {
  List<pw.Widget> colLst = [];
  var file;
  file = footer;

  pw.CrossAxisAlignment align = pw.CrossAxisAlignment.start;
  pw.TextStyle fstyle = pw.TextStyle(
    color: PdfColors.black,
    fontSize: 7,
    fontWeight: pw.FontWeight.normal,
  );

  if (file['result'] == true) {
    for (var db in file['data']) {
      db['textalign'].toString() == '1'
          ? align = pw.CrossAxisAlignment.center
          : db['textalign'].toString() == '2'
              ? align = pw.CrossAxisAlignment.end
              : align = pw.CrossAxisAlignment.start;

      fstyle = pw.TextStyle(
        color: PdfColors.black,
        fontSize: db['font_size'].toString() != '1' ? 9 : 10,
        fontWeight: db['boldyn'].toString() == 'Y'
            ? pw.FontWeight.bold
            : pw.FontWeight.normal,
      );
      colLst.add(pw.Text(
        db['texttoprint'].toString(),
        style: fstyle,
      ));
    }
  }

  return pw.Container(
      margin: pw.EdgeInsets.only(top: 2),
      /*    decoration: pw.BoxDecoration(
          border: const pw.Border(
        top: pw.BorderSide(
          color: PdfColors.black,
          style: pw.BorderStyle.dashed,
        ),
      )), */
      width: double.infinity,
      //padding: pw.EdgeInsets.only(left: 5),
      child: pw.Column(crossAxisAlignment: align, children: colLst));
}
