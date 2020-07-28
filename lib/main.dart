import 'package:final_proj/Patient/pathome.dart';
import 'Doctor/Home.dart';
import 'Doctor/lo.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]).then((_) {
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    ));
  });
}

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
  }
}

class Homepage extends StatefulWidget {
  Homepage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences prefs;
  int status = 0;
  bool isLoading = false;
  bool isloggedin = false;
  FirebaseUser user;
  String id = '';
  String name = '';
  String aboutMe = '';
  String photoUrl = '';
  String hospital = '';
  String years = '';
  String specs = '';
  String fax = '';
  String edu = '';
  String ema = '';
  String off = '';
  String npi = '';
  String emer = '';
  String asa = '';
  String normal = '';
  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, isSignedIn);
  }

  void isSignedIn() async {
    FirebaseAuth.instance.currentUser().then((user) => user != null
        ? setState(() {
            isloggedin = true;
          })
        : null);

    user = await FirebaseAuth.instance.currentUser();
    prefs = await SharedPreferences.getInstance();
    status = prefs.getInt('status');

    if (status == 1 && isloggedin) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Hom(
              currentUserId: prefs.getString('id'),
            ),
          ));
    } else if (status == 2 && isloggedin) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Patientho(
              currentUserId: prefs.getString('id'),
            ),
          ));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Malog()));
    }

    this.setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
              Colors.purple[400],
              Colors.blue[600],
              Colors.purple[500]
            ]))),
        Center(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 100.0,
                          backgroundImage: AssetImage("images/med_logo.png"),
                        ),
                        decoration: new BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(1.0, 1.0),
                              blurRadius: 10.0,
                            ),
                          ],
                          shape: BoxShape.circle,
                          border: new Border.all(
                            color: Colors.transparent,
                            width: 5.0,
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Text(
                        'D-COM',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black,
                              offset: Offset(5.0, 5.0),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              CircularProgressIndicator(
                backgroundColor: Colors.black,
                strokeWidth: 5,
              ),
              Padding(
                padding: EdgeInsets.only(top: 16, bottom: 102),
                child: Text(
                  "Let's Suggest and get Connected",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black,
                        offset: Offset(5.0, 5.0),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    ));
  }
}
