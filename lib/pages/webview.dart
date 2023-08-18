import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../components/fonts.dart';

class Webview extends StatefulWidget {
  final String url;
  final String title;
  final bool dash;
  const Webview(
      {super.key, required this.url, required this.title, required this.dash});

  @override
  State<Webview> createState() => _WebviewState();
}

class _WebviewState extends State<Webview> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  TextStyle ed16 = fontFile(16, Color(0xFFEDEDED), 0, FontWeight.bold);

  late InAppWebViewController controllera;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Color(0xFF171717)],
              stops: [0, 1],
              begin: AlignmentDirectional(0, -1),
              end: AlignmentDirectional(0, 1),
            ),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(15, 35, 15, 15),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            //       duration: Duration(milliseconds: 200),
                            //       reverseDuration: Duration(milliseconds: 200),
                            //       child: widget.dash ? Dashboard() : Login(),
                            //     ),
                            //     ModalRoute.withName("/Home"));
                          },
                          child: Icon(
                            Icons.arrow_back_rounded,
                            color: Color(0xFFEDEDED),
                            size: 25,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(15, 0, 0, 0),
                          child: Text(
                            widget.title,
                            style: ed16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                _progress < 1
                    ? Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                        child: Container(
                          child: LinearProgressIndicator(
                            value: _progress,
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                        child: SizedBox(),
                      ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    child: Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(),
                      child: InAppWebView(
                        initialUrlRequest:
                            URLRequest(url: Uri.parse(widget.url)),
                        onWebViewCreated: (InAppWebViewController controller) {
                          controllera = controller;
                        },
                        onProgressChanged:
                            (InAppWebViewController controller, int progess) {
                          setState(() {
                            _progress = progess / 100;
                          });
                        },
                      ),
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
}
