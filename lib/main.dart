import 'package:flutter/material.dart';
import 'package:yts_wrapper/api.dart';
import 'package:yts_wrapper/screens/splash.dart';

void main() => runApp(YTS());

class YTS extends StatelessWidget {
  final api = YtsApi;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YTS Movies',
      theme: ThemeData(
          primaryColor: Colors.white,
          primaryIconTheme: IconThemeData(color: Colors.black)),
      initialRoute: '/',
      routes: {'/': (context) => SplashScreen()},
    );
  }
}
