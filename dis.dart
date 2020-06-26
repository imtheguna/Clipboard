import 'package:Look/web.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  var result1 = '';
  var r = 'text';

  @override
  void initState() {
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
  }

  void clipboard() {
    Stream.periodic(Duration(seconds: 1)).listen((_) {
      getData('text/plain');
    });
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  NotificationAppLaunchDetails notificationAppLaunchDetails;
  void showNotification(result1) async {
    print(result1);
    try {
      var android = new AndroidNotificationDetails('clip', 't', 'g',
          priority: Priority.High, importance: Importance.Max);
      var iOS = new IOSNotificationDetails();
      var platform = new NotificationDetails(android, iOS);

      await flutterLocalNotificationsPlugin.show(
          0, 'Clipboard', "Search the $result1", platform,
          payload: 'Search the $result1');
    } catch (e) {
      print(e);
    }
  }

  Future<String> getData(String format) async {
    final Map<String, dynamic> result =
        await SystemChannels.platform.invokeMethod(
      'Clipboard.getData',
      format,
    );
    result1 = result['text'] as String;
    if (r != result1) {
      print(result1);
      showNotification(result1);
      r = result1;
    }

    if (result == null) return null;

    return result.toString();
  }

  Future onSelectNotification(String payload) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => MyWebView(
              title: "Search",
              selectedUrl: "https://www.google.com/search?q=$result1",
            )));
  }

  DateTime backbuttonpressedTime;
  @override
  Widget build(BuildContext context) {
    Future<bool> onWillPop() async {
      DateTime currentTime = DateTime.now();

      //bifbackbuttonhasnotbeenpreedOrToasthasbeenclosed
      //Statement 1 Or statement2
      bool backButton = backbuttonpressedTime == null ||
          currentTime.difference(backbuttonpressedTime) > Duration(seconds: 3);

      if (backButton) {
        backbuttonpressedTime = currentTime;

        return false;
      }
      return true;
    }

    return Scaffold(
      body: Center(
        child: WillPopScope(
          onWillPop: onWillPop,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topCenter, colors: [
              Colors.orange[700],
              Colors.orange[400],
              Colors.orange[200]
            ])),
            child: Center(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Row(
                                children: <Widget>[],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "Welcome",
                        style: TextStyle(
                            color: Colors.orange,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.orange[900]),
                        child: Center(
                            child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: FlatButton(
                            onPressed: () {
                              clipboard();
                            },
                            child: Text(
                              "Start",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )),
                      ),
                      Image.asset("assets/image.png", fit: BoxFit.cover)
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
