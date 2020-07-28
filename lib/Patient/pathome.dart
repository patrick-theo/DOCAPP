import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_proj/Patient/Pathis.dart';
import 'package:final_proj/Patient/patientlog.dart';
import 'dart:convert';
import 'dart:io';
import 'package:final_proj/main.dart';
import 'package:final_proj/Patient/patset.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Patientho extends StatefulWidget {
  final String currentUserId;
  Patientho({
    Key key,
    this.currentUserId,
  }) : super(key: key);
  @override
  _PatienthoState createState() =>
      _PatienthoState(currentUserId: currentUserId);
}

class _PatienthoState extends State<Patientho> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  _PatienthoState({Key key, this.currentUserId});
  String currentUserId;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  FirebaseUser user;
  SharedPreferences prefs;
  int count = 1;
  String ida, name, email, photoUrl;
  bool sug = true;
  bool meet = false;
  String arr;
  @override
  void initState() {
    initUser();
    super.initState();
    readLocal();
    registerNotification();
    configLocalNotification();
  }

  initUser() async {
    user = await FirebaseAuth.instance.currentUser();
    setState(() {});
  }

  void registerNotification() {
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      Platform.isAndroid
          ? showNotification(message['notification'])
          : showNotification(message['aps']['alert']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });

    firebaseMessaging.getToken().then((token) {
      Firestore.instance
          .collection('Patients')
          .document(ida)
          .updateData({'pushToken': token});
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid ? 'com.example.final_proj' : 'com.example.final_proj',
      'Dcom',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Confirm'),
              content: Text('Do you want to exit D-Com'),
              actions: <Widget>[
                FlatButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(false); //Will not exit the App
                  },
                ),
                FlatButton(
                  child: Text('Yes'),
                  onPressed: () {
                    exit(0); //Will exit the App
                  },
                )
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: new Scaffold(
              key: _scaffoldKey,
              appBar: new AppBar(
                elevation: 10,
                backgroundColor: Colors.white,
                centerTitle: true,
                title: Text(
                  "Home Screen",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                leading: IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.black,
                  ),
                  onPressed: () => _scaffoldKey.currentState.openDrawer(),
                ),
              ),
              body: Column(children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(width: 70),
                    Container(
                        height: 40,
                        child: RaisedButton(
                            color: Colors.red[400],
                            elevation: 10.0,
                            splashColor: Colors.orange,
                            colorBrightness: Brightness.dark,
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.transparent),
                            ),
                            onPressed: () {
                              setState(() {
                                count = 1;
                                sug = true;
                                meet = false;
                              });
                            },
                            child: new Text(
                              ("Suggested"),
                              style: TextStyle(fontSize: 15),
                            ))),
                    SizedBox(width: 20),
                    Container(
                        height: 40,
                        child: RaisedButton(
                            color: Colors.orange,
                            elevation: 7.0,
                            splashColor: Colors.red,
                            colorBrightness: Brightness.dark,
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.transparent),
                            ),
                            onPressed: () {
                              setState(() {
                                count = 2;
                                sug = false;
                                meet = true;
                              });
                            },
                            child: new Text(
                              ("Should meet"),
                              style: TextStyle(fontSize: 16),
                            ))),
                    SizedBox(width: 10),
                  ],
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                      height: 2.0, width: 600.0, color: Colors.red[400]),
                ),
                SizedBox(height: 10),
                Visibility(
                  visible: sug,
                  child: Text(
                    "Suggestions will be displayed below",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Visibility(
                  visible: meet,
                  child: Text(
                    "Sheduled details will be displayed below",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: StreamBuilder(
                    stream: str(count),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        );
                      } else {
                        return Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            padding: EdgeInsets.all(10.0),
                            itemBuilder: (context, index) => buildItem(
                                context, snapshot.data.documents[index]),
                            itemCount: snapshot.data.documents.length,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ]),
              drawer: Drawer(
                elevation: 30.0,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.transparent,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 7.0,
                          ),
                        ],
                        gradient:
                            LinearGradient(begin: Alignment.topCenter, colors: [
                          Colors.red[400],
                          Colors.orange,
                          Colors.orangeAccent,
                        ]),
                      ),
                      accountName: "${user.displayName}" != null
                          ? Text("Mr./Mrs. " +
                              "${user.displayName} " +
                              "/" +
                              " ID:" +
                              ida)
                          : Text(
                              'Not availabe',
                              style: TextStyle(color: Colors.black),
                            ),
                      accountEmail: "${user.email}" != null
                          ? Text("${user.email}")
                          : Text('Not availabe'),
                    ),
                    ListTile(
                        title: Text("History"),
                        leading: Icon(Icons.history),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Pathis(
                                        iid: ida,
                                        user: user,
                                      )));
                        }),
                    ListTile(
                        title: Text("Profile"),
                        leading: Icon(Icons.person),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Patsetting(
                                        iid: ida,
                                        user: user,
                                      )));
                        }),
                    ListTile(
                      title: Text("Bug report"),
                      leading: Icon(Icons.bug_report),
                      onTap: () => _launchURL('vareitex.technology@gmail.com',
                          'D-com  Patient Bug Report'),
                    ),
                    ListTile(
                        title: Text("About Us"),
                        leading: Icon(Icons.info),
                        onTap: _launch),
                    ListTile(
                      title: Text("Log Out"),
                      leading: Icon(Icons.exit_to_app),
                      onTap: sign,
                    ),
                  ],
                ),
              ),
            )));
  }

  Widget buildItem(BuildContext context, DocumentSnapshot documents) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 7.0,
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(begin: Alignment.topCenter, colors: [
            Colors.red[400],
            Colors.orange,
            Colors.orangeAccent,
          ])),
      child: FlatButton(
        child: Row(
          children: <Widget>[
            Flexible(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Row(children: <Widget>[
                      Flexible(
                        child: Container(
                          child: Text(
                            ('Dr.${documents['from name'] ?? 'Not available'}'),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 30),
                      Container(
                        child: Icon(
                          Icons.fast_forward,
                          size: 28,
                          color: Colors.black,
                        ),
                        width: 25,
                      ),
                      Container(
                        child: Icon(
                          Icons.fast_forward,
                          size: 28,
                          color: Colors.black,
                        ),
                        width: 25,
                      ),
                      Container(
                        child: Icon(
                          Icons.fast_forward,
                          size: 28,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 20),
                      Flexible(
                        child: Container(
                            child: Text(
                          ('Dr.${documents['to name'] ?? 'Not available'}'),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )),
                      ),
                    ]),
                    SizedBox(height: 10),
                    Row(children: <Widget>[
                      Container(
                        child: Icon(
                          Icons.people,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        child: Text(
                          'Patient Name :',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 5.0),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            '${documents['patientname'] ?? 'Not available'}',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(5.0, 0.0, 10.0, 5.0),
                        ),
                      ),
                    ]),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.0),
                      child: Container(
                          height: 2.0, width: 600.0, color: Colors.black),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Container(
                          child: Icon(Icons.calendar_today),
                        ),
                        Container(
                          child: Text(
                            'Scheduled date:',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          child: Text(
                            ' ${documents['scheduled-date'] ?? 'Not Assigned'}',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          child: Icon(Icons.timer),
                        ),
                        Container(
                          child: Text(
                            'Scheduled time:',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          child: Text(
                            ' ${documents['scheduled-time'] ?? 'Not Assigned'}',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                margin: EdgeInsets.only(left: 20.0),
              ),
            ),
          ],
        ),
        onPressed: () {},
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
    );
  }

  Future<void> sign() async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Patlog()),
        (Route<dynamic> route) => false);
  }

  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    ida = prefs.getString('id') ?? '';
    name = prefs.getString('name') ?? '';
    email = prefs.getString('email') ?? '';
    photoUrl = prefs.getString('photoUrl') ?? '';
  }

  Stream<dynamic> str(int count) {
    if (count == 1) {
      return Firestore.instance
          .collection("Patients")
          .document(ida)
          .collection("suggestions")
          .where('status', isEqualTo: 'send')
          .snapshots();
    }
    if (count == 2) {
      return Firestore.instance
          .collection("Patients")
          .document(ida)
          .collection("suggestions")
          .where('status', isEqualTo: 'received')
          .snapshots();
    }
  }
}

_launchURL(String toMailId, String subject) async {
  var url = 'mailto:$toMailId?subject=$subject';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

_launch() async {
  const url = 'https://vareitex.herokuapp.com/';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
