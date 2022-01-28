import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class Webview extends StatefulWidget {
  const Webview({Key? key}) : super(key: key);

  @override
  _WebviewState createState() => _WebviewState();
}

class _WebviewState extends State<Webview> {
  @override
  Widget build(BuildContext context) {
    return const WebviewScaffold(
      withZoom: true,
      url: "https://www.tradingview.com/markets/cryptocurrencies/prices-all/",
      withJavascript: true,
      // appBar: AppBar(
      //   title: Text("hjg"),
      //   backgroundColor: Colors.black,
      // ),
    );
  }
}
