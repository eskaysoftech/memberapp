import 'dart:io';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provide;

import 'localstore/global_var.dart';
import 'localstore/logindetails.dart';
import 'localstore/systemsetup/appsettings.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await path_provide.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(LogindetailsAdapter());
  if (Platform.isIOS) {
    topMargin = 55.0;
    bottomMargin = 25.0;
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Eskay Club',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
            future: Hive.openBox('clublogo'), //Hive.openBox('logindetails'),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else {
                  final logoip = Hive.box("clublogo");
                  //var logimg = logoip.get('Logo');
                  clublogoimg = logoip.get('Logo');
                  return Scaffold(
                      body: AnimatedSplashScreen(
                    duration: 2000,
                    splash: Center(
                      child: Image.asset(
                        'media/logo.png',
                        width: 250,
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                    ),
                    // Center(
                    //   child: clublogoimg != null &&
                    //           clublogoimg.toString() != 'null' &&
                    //           clublogoimg.toString() != ''
                    //       ? Image.memory(
                    //           base64Decode(clublogoimg.toString()),
                    //           width: 250,
                    //           height: 150,
                    //         )
                    //       : Image.asset(
                    //           'media/logo.png',
                    //           width: 250,
                    //           height: 150,
                    //           fit: BoxFit.contain,
                    //         ),
                    // ),
                    splashIconSize: double.infinity,
                    nextScreen: const Login(),
                    // nextScreen: MemberList(),
                    splashTransition: SplashTransition.scaleTransition,
                    backgroundColor: const Color.fromARGB(255, 16, 16, 16),
                  ));
                }
              } else {
                return const Scaffold(
                  // key: scaffoldKey,
                  backgroundColor: Color(0xFF262626),
                );
              }
            }));
  }
}
