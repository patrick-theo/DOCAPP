import 'dart:convert';
import 'dart:io';
import 'package:final_proj/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_proj/Doctor/Declined.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'Favourites.dart';
import 'details.dart';
import 'docdetail.dart';
import 'history.dart';
import 'lo.dart';
import 'received.dart';
import 'search.dart';
import 'sent.dart';
import 'set.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:url_launcher/url_launcher.dart';

class Hom extends StatefulWidget {
  final String currentUserId;
  final String name1;
  final String email1;
  final String doc;

  Hom({
    Key key,
    this.currentUserId,
    this.name1,
    this.email1,
    this.doc,
  }) : super(key: key);
  @override
  _HomState createState() => _HomState(doc: doc);
}

class _HomState extends State<Hom> with SingleTickerProviderStateMixin {
  var queryResultSet = [];
  var tempSearchStore = [];
  _HomState({Key key, this.doc});
  String doc;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  CollectionReference col = Firestore.instance.collection('Doctors');
  String name1;
  String email1;
  int number;
  String currentUserId;
  String spez;
  File avatarImageFile;
  String names;
  String em;
  List fav;
  String ph;
  Query spe;
  String sp;
  TextEditingController controllername;
  TextEditingController controlleremail;
  String ida;
  String email;
  String name;
  DocumentSnapshot docsnap;
  DocumentReference docref;
  DocumentSnapshot documentSnapshot;
  DocumentReference documentReference;
  bool flag = false;
  bool hi = false;
  String stat = 'false';
  bool pre = false;
  String photoUrl;
  String na;

  int choice = 0;
  List<Specs> _specs = Specs.getSpecs();
  final ref = FirebaseStorage.instance.ref();
  List<DropdownMenuItem<Specs>> _dropdownMenuItems;
  Specs _selectedspecs;
  FirebaseUser user;
  int count = 1;
  SharedPreferences prefs;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String nu;
  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_specs);
    _selectedspecs = _dropdownMenuItems[0].value;
    initUser();
    super.initState();
    readLocal();
    local();
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
          .collection('Doctors')
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
              content: Text('Do you want to exit D-com'),
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

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: new Scaffold(
        key: _scaffoldKey,
        body: Column(children: <Widget>[
          ClipPath(
            clipper: MyClipper(),
            child: Container(
              padding: EdgeInsets.only(left: 0, top: 50, right: 0),
              height: 260,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topCenter, colors: [
                  Colors.blueAccent[400],
                  Colors.purple[400],
                ]),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                          padding: EdgeInsets.only(left: 20, top: 10, right: 0),
                          child: GestureDetector(
                            onTap: () {
                              _scaffoldKey.currentState.openDrawer();
                            }, // handle your image tap here
                            child: SvgPicture.asset(
                              "images/menu.svg",
                              fit: BoxFit.fitWidth,
                            ),
                          ))),
                  Padding(
                    padding: EdgeInsets.only(left: 0, top: 0, right: 0),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                      child: Stack(
                    children: <Widget>[
                      new Positioned(
                        right: 250,
                        child: Image.asset(
                          "images/half_doctor.png",
                          width: 178,
                        ),
                      ),
                      new Positioned(
                        left: 30.0,
                        child: Image.asset(
                          "images/half_patient.png",
                          width: 180,
                        ),
                      ),
                      new Positioned(
                        left: 100.0,
                        child: Image.asset(
                          "images/half_doctor.png",
                          width: 170,
                        ),
                      ),
                      Positioned(
                          top: 5,
                          left: 220,
                          child: Text(
                            "Refer to \n        get\n        Connected",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontFamily: 'Pacifico',
                            ),
                          )),
                      Container(),
                    ],
                  )),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            height: 55,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Color(0xFFE5E5E5),
              ),
            ),
            child: Row(
              children: <Widget>[
                Icon(
                    // Add this
                    Icons.filter_list, // Add this
                    color: Colors.blue),
                SizedBox(width: 20),
                Expanded(
                  child: DropdownButton(
                    elevation: 10,
                    isExpanded: true,
                    underline: SizedBox(),
                    style: TextStyle(
                      color: Colors.purple[400],
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                    value: _selectedspecs,
                    items: _dropdownMenuItems,
                    onChanged: onChangeDropdownItem,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              SizedBox(width: 15),
              new RaisedButton(
                color: Colors.blue,
                elevation: 7.0,
                splashColor: Colors.purple[400],
                colorBrightness: Brightness.dark,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.transparent),
                ),
                onPressed: () {
                  setState(() {
                    count = 2;
                  });
                },
                child: new Text("Urgent"),
              ),
              SizedBox(width: 5),
              new RaisedButton(
                color: Colors.purple[300],
                elevation: 7.0,
                splashColor: Colors.blue,
                colorBrightness: Brightness.dark,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.transparent),
                ),
                onPressed: () {
                  setState(() {
                    count = 3;
                  });
                },
                child: new Text("ASAP"),
              ),
              SizedBox(width: 5),
              new RaisedButton(
                color: Colors.blue,
                elevation: 7.0,
                splashColor: Colors.purple[400],
                colorBrightness: Brightness.dark,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.transparent),
                ),
                onPressed: () {
                  setState(() {
                    count = 4;
                  });
                },
                child: new Text("NA"),
              ),
              SizedBox(width: 5),
              new RaisedButton(
                color: Colors.purple[300],
                elevation: 7.0,
                splashColor: Colors.blue,
                colorBrightness: Brightness.dark,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.transparent),
                ),
                onPressed: () {
                  setState(() {
                    count = 1;
                  });
                },
                child: new Text("All"),
              ),
              SizedBox(width: 2),
            ],
          ),
          Container(
            child: StreamBuilder(
              stream: stream(count),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      padding: EdgeInsets.all(10.0),
                      itemBuilder: (context, index) =>
                          buildItem(context, snapshot.data.documents[index]),
                      itemCount: snapshot.data.documents.length,
                    ),
                  );
                }
              },
            ),
          )
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Sear(
                          iid: ida,
                          user: user,
                        )));
          },
          backgroundColor: Colors.purple[400],
          child: Icon(Icons.search),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 6.0,
            color: Colors.transparent,
            elevation: 9.0,
            clipBehavior: Clip.antiAlias,
            child: Container(
                height: 50.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0)),
                    color: Colors.white),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          height: 50.0,
                          width: MediaQuery.of(context).size.width / 2 - 40.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.home),
                                iconSize: 32,
                                color: Colors.red,
                                highlightColor: Colors.purple,
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(Icons.arrow_upward),
                                color: Color(0xFF676E79),
                                iconSize: 32,
                                onPressed: sent,
                              ),
                            ],
                          )),
                      GestureDetector(
                        onTap: rec,
                        child: Container(
                            height: 50.0,
                            width: MediaQuery.of(context).size.width / 2 - 40.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    Icon(
                                      Icons.arrow_downward,
                                      color: Color(0xFF676E79),
                                      size: 33,
                                    ),
                                    new Positioned(
                                      right: 0,
                                      left: 22,
                                      bottom: 16,
                                      child: new Container(
                                        padding: EdgeInsets.all(1),
                                        decoration: new BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        constraints: BoxConstraints(
                                          minWidth: 15,
                                          minHeight: 15,
                                        ),
                                        child: FutureBuilder(
                                          future: getUserInfo(),
                                          builder: (context,
                                              AsyncSnapshot<DocumentSnapshot>
                                                  snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              return Text(snapshot
                                                  .data.data['count']
                                                  .toString());
                                            } else if (snapshot
                                                    .connectionState ==
                                                ConnectionState.none) {
                                              return Text("l");
                                            }
                                            return Text("l");
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                IconButton(
                                  icon: Icon(Icons.person_outline),
                                  color: Color(0xFF676E79),
                                  iconSize: 32,
                                  onPressed: setting,
                                )
                              ],
                            )),
                      )
                    ]))),
        drawer: Drawer(
          elevation: 30.0,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter, colors: [
                    Colors.blueAccent[400],
                    Colors.purple[400],
                  ]),
                ),
                accountName: "${user.displayName}" != null
                    ? Text("Dr " + "${user.displayName}" + " ID:" + ida)
                    : Text(
                        'Not availabe',
                        style: TextStyle(color: Colors.black),
                      ),
                accountEmail: "${user.email}" != null
                    ? Text("${user.email}")
                    : Text('Not availabe'),
                currentAccountPicture: CircleAvatar(
                  radius: 50.0,
                  backgroundImage: NetworkImage("${user.photoUrl}") != null
                      ? NetworkImage("${user.photoUrl}")
                      : Icon(Icons.account_circle),
                  backgroundColor: Colors.white,
                ),
              ),
              ListTile(
                  title: Text("Succesful"),
                  leading: Icon(Icons.history),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Hist(
                                  iid: ida,
                                  user: user,
                                )));
                  }),
              ListTile(
                  title: Text("Declined"),
                  leading: Icon(Icons.cancel),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Decl(
                                  iid: ida,
                                  user: user,
                                )));
                  }),
              ListTile(
                  title: Text("Favourites"),
                  leading: Icon(Icons.favorite),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Fav(
                                  iid: ida,
                                  user: user,
                                )));
                  }),
              ListTile(
                title: Text("Bug report"),
                leading: Icon(Icons.bug_report),
                onTap: () => _launchURL(
                    'vareitex.technology@gmail.com', 'D-com Bug Report'),
              ),
              ListTile(
                  title: Text("About Us"),
                  leading: Icon(Icons.info),
                  onTap: _launch),
              ListTile(
                  title: Text("Log Out"),
                  leading: Icon(Icons.exit_to_app),
                  onTap: signout),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> signout() async {
    this.setState(() {
      isLoading = true;
    });

    await FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();

    this.setState(() {
      isLoading = false;
    });

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Malog()),
        (Route<dynamic> route) => false);
  }

  void setting() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Setting(
                  currentUserId: currentUserId,
                  user: user,
                  lov: false,
                )));
  }

  Widget buildItem(BuildContext context, DocumentSnapshot documents) {
    if (documents['Npi'] == ida) {
      return Container(
        width: SizeConfig.blockSizeVertical * 50,
      );
    } else {
      return Container(
        width: SizeConfig.blockSizeVertical * 50,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 5.0,
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
              Colors.blueAccent[400],
              Colors.purple[400],
              Colors.blue[400],
            ])),
        child: FlatButton(
          child: Row(
            children: <Widget>[
              Material(
                child: documents['photoUrl'] != null
                    ? CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          child: CircularProgressIndicator(
                            strokeWidth: 1.0,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                          width: 70.0,
                          height: 70.0,
                          padding: EdgeInsets.all(15.0),
                        ),
                        imageUrl: documents['photoUrl'],
                        width: 70.0,
                        height: 70.0,
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.account_circle,
                        size: 70.0,
                        color: Colors.blue,
                      ),
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                clipBehavior: Clip.hardEdge,
              ),
              Flexible(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          'Dr: ${documents['Nickname'] ?? 'Not Available'}',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(25.0, 0.0, 0.0, 5.0),
                      ),
                      SizedBox(height: 5),
                      Container(
                        child: Text(
                          'Specialisation: ${documents['Specialization'] ?? 'Not available'}'
                              .replaceAll('[', "")
                              .replaceAll(']', ""),
                          style: TextStyle(color: Colors.white),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(25.0, 0.0, 0.0, 0.0),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.only(left: 20.0),
                ),
              ),
              Column(children: <Widget>[
                Ink(
                  decoration: const ShapeDecoration(
                    color: Colors.transparent,
                    shape: CircleBorder(),
                  ),
                  child: FutureBuilder<dynamic>(
                    future: solu('${documents['Npi']}'),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.data == true) {
                        return StatefulBuilder(builder: (context, setState) {
                          return IconButton(
                            icon: Icon(Icons.star),
                            color: Colors.yellowAccent,
                            onPressed: () {
                              documentReference.updateData({
                                'fav': FieldValue.arrayRemove(
                                    ['${documents['Npi']}'])
                              });
                              Firestore.instance
                                  .collection("Doctors")
                                  .document(ida)
                                  .collection("fav")
                                  .document(documents.documentID)
                                  .delete();

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Hom()));

                              Fluttertoast.showToast(
                                  msg:
                                      'Dr.${documents['Nickname']} Removed from Favorites',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            },
                          );
                        });
                      } else {
                        return StatefulBuilder(builder: (context, setState) {
                          return IconButton(
                            icon: Icon(Icons.star_border),
                            color: Colors.black,
                            onPressed: () {
                              Firestore.instance
                                  .collection("Doctors")
                                  .document(ida)
                                  .collection("fav")
                                  .document(documents.documentID)
                                  .setData({'count': 5});
                              documentReference.updateData({
                                'fav': FieldValue.arrayUnion(
                                    ['${documents['Npi']}'])
                              });

                              {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Hom()));
                              }
                              Fluttertoast.showToast(
                                  msg:
                                      'Dr.${documents['Nickname']} Added to Favorites',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            },
                          );
                        });
                      }
                    },
                  ),
                ),
                Ink(
                  decoration: const ShapeDecoration(
                    color: Colors.transparent,
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.navigate_next,
                    ),
                    iconSize: 25,
                    color: Colors.white,
                    splashColor: Colors.white,
                    onPressed: () {
                      {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Details(
                                      peerId: documents.documentID,
                                      nam: '${documents['Nickname']}',
                                      user: user,
                                    )));
                      }
                    },
                  ),
                ),
              ]),
            ],
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Doc(
                        peerid: documents.documentID,
                        user: user,
                        name: '${documents['Nickname']}')));
          },
          padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        ),
        margin: EdgeInsets.only(bottom: 8.0, left: 5.0, right: 5.0),
      );
    }
  }

  Stream<dynamic> stream(int count) {
    Query eme = Firestore.instance
        .collection("Doctors")
        .where('Emergency', isEqualTo: 'true');
    Query asa = Firestore.instance
        .collection("Doctors")
        .where('Asap', isEqualTo: 'true');
    Query no = Firestore.instance
        .collection("Doctors")
        .where('Normal', isEqualTo: 'true');
    if (choice == 0) {
      if (count == 1) {
        return Firestore.instance.collection("Doctors").snapshots();
      } else if (count == 2) {
        return eme.snapshots();
      } else if (count == 3) {
        return asa.snapshots();
      } else if (count == 4) {
        return no.snapshots();
      }
    }
    if (choice == 1) {
      if (count == 1) {
        return Firestore.instance
            .collection("Doctors")
            .where('Specialization', arrayContains: _selectedspecs.name)
            .snapshots();
      } else if (count == 2) {
        return Firestore.instance
            .collection("Doctors")
            .where('Emergency', isEqualTo: 'true')
            .where('Specialization', arrayContains: _selectedspecs.name)
            .snapshots();
      } else if (count == 3) {
        return Firestore.instance
            .collection("Doctors")
            .where('Asap', isEqualTo: 'true')
            .where('Specialization', arrayContains: _selectedspecs.name)
            .snapshots();
      } else if (count == 4) {
        return Firestore.instance
            .collection("Doctors")
            .where('Normal', isEqualTo: 'true')
            .where('Specialization', arrayContains: _selectedspecs.name)
            .snapshots();
      }
    }
  }

  List<DropdownMenuItem<Specs>> buildDropdownMenuItems(List<Specs> specs) {
    List<DropdownMenuItem<Specs>> items = List();
    for (Specs specs in specs) {
      items.add(DropdownMenuItem(
        value: specs,
        child: Text(specs.name),
      ));
    }
    return items;
  }

  void onChangeDropdownItem(Specs selectedSpecs) {
    setState(() {
      _selectedspecs = selectedSpecs;

      choice = 1;
      if (_selectedspecs.name == 'Choose your specialization') {
        choice = 0;
      }
    });
  }

  void sent() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Sent(
                  iid: ida,
                  user: user,
                )));
  }

  void hist() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Hist(
                  iid: ida,
                  user: user,
                )));
  }

  void rec() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Rec(iid: ida, user: user)));
  }

  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    ida = prefs.getString('id') ?? '';
    name = prefs.getString('Nickname') ?? '';
    email = prefs.getString('Email-id') ?? '';
    photoUrl = prefs.getString('photoUrl') ?? '';
    controllername = new TextEditingController(text: name);
    controlleremail = new TextEditingController(text: email);
    names = "${user.displayName}";
    em = "${user.email}";
    ph = "${user.photoUrl}";
    local();
  }

  void local() async {
    final QuerySnapshot result = await Firestore.instance
        .collection('Doctors')
        .where('Npi', isEqualTo: ida)
        .getDocuments();
    final List<DocumentSnapshot> docum = result.documents;
    if (docum[0]['count'] != null) {
      pre = true;
      nu = await docum[0]['count'];
    } else {
      pre = false;
      nu = 'l';
    }
  }

  void se() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Sear(
                  iid: ida,
                  user: user,
                )));
  }

  solu(event) async {
    documentReference = Firestore.instance.collection("Doctors").document(ida);
    documentSnapshot = await documentReference.get();
    fav = documentSnapshot.data['fav'];
    if (fav.contains(event)) {
      return true;
    } else {
      return false;
    }
  }

  Future<DocumentSnapshot> getUserInfo() async {
    return await Firestore.instance.collection("Doctors").document(ida).get();
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 4, size.height - 40, size.width / 2, size.height - 20);
    path.quadraticBezierTo(
        3 / 4 * size.width, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
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
