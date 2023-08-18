import 'package:http/http.dart' as http;
import 'dart:convert';
import '../localstore/global_var.dart';
import '../localstore/systemsetup/appsettings.dart';

Future getActivities(String fromdt, String todt) async {
  Map<String, dynamic> senddata = {
    "DBName": dbName,
    "DBUser": dbUser,
    "fromdate": fromdt,
    "todate": todt,
    "memberid": userid
  };

  String data = json.encode(senddata);
  //print(data);
  String url =
      "https://eskaysoftech.com/CLUB_MEMBER_API/tran files/loadactivity.php";

  final response = await http.post(Uri.parse(url),
      headers: {
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials":
            "true", // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers":
            "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, OPTIONS"
      },
      body: data);

  final dbody = json.decode(response.body);
  List datalist = [];
  if (dbody['result']) {
    datalist = dbody['data'];
    // print(datalist);
  }
  return datalist;
}
