import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yts_wrapper/api.dart';
import 'package:yts_wrapper/screens/home.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dio/dio.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool state = true;
  bool connected = true;
  @override
  void initState() {
    super.initState();
    connectToYTS();
  }

  Future<void> connectToYTS() async {
    var connectionStatus = await Connectivity().checkConnectivity();
    if (connectionStatus != ConnectivityResult.none) {
      setState(() {
        connected = true;
      });
      YtsApi api = await YtsApi.create();
      if (api.useURL != '') {
        setState(() {
          state = true;
        });
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => HomePage(api)));
      } else {
        setState(() {
          state = false;
        });
      }
    } else {
      setState(() {
        connected = false;
      });
    }
  }

  Future<String> getVpn() async {
    final String url = 'https://www.vpngate.net/api/iphone/';
    var response = await Dio().get(url);
    String str = response.toString();
    List<String> data = str.split('\n');
    data.removeAt(0);
    List<String> head = data[0].split(',');
    data.removeAt(0);
    data.removeAt(data.length - 1);
    data.removeAt(data.length - 1);
    String ip = '';
    int speed = 0;
    for (String i in data) {
      List<String> temp = i.split(',');
      if (speed < int.parse(temp[head.indexOf('Speed')])) {
        speed = int.parse(temp[head.indexOf('Speed')]);
        ip = temp[head.indexOf('#HostName')];
      }
    }
    return ip;
  }

  @override
  Widget build(BuildContext context) {
    if (connected == false) {
      Future.delayed(
          Duration.zero,
          () => showAlert(context, 'Connection Error!',
              "Please check connectivity of your device."));
    } else if (state == false) {
      Future.delayed(
          Duration.zero,
          () => showAlert(context, "Cannot connect to YTS!",
              "YTS is blocked by your ISP."));
    }
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('lib/src/logo.png'),
                width: 200,
              ),
              SizedBox(height: 30),
              SpinKitWave(
                color: Colors.green,
                size: 25.0,
              ),
              SizedBox(height: 10),
              Text(
                connected
                    ? 'Retrieving alive endpoint...'
                    : 'Checking Connection...',
                style: TextStyle(color: Colors.green),
              ),
            ],
          )),
    );
  }

  void showAlert(BuildContext context, String title, String text) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(text),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      connectToYTS();
                    },
                    child: Text(title == "Cannot connect to YTS!"
                        ? 'Retry with inbuilt VPN'
                        : 'Retry')),
                TextButton(
                    onPressed: () => {SystemNavigator.pop()},
                    child: Text('Exit'))
              ],
            ));
  }
}
