import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_proj/Doctor/comdeta.dart';
import 'package:final_proj/Doctor/compen.dart';
import 'package:final_proj/main.dart';
import 'Home.dart';
import 'received.dart';
import 'set.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Sent extends StatefulWidget {
  final String iid;
  final FirebaseUser user;
  Sent({Key key, @required this.iid, @required this.user}) : super(key: key);
  @override
  _SentState createState() => _SentState(iid: iid, user: user);
}

class _SentState extends State<Sent> {
  _SentState({Key key, @required this.iid, @required this.user});
  FirebaseUser user;
  String iid;
  int count = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: new Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 10.0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Hom()));
              },
            ),
            title: Text('Sent Patients',
                style: TextStyle(
                    fontFamily: 'Varela',
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.black)),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  SizedBox(width: 20),
                  Container(
                    height: 40,
                    child: RaisedButton(
                        color: Colors.blue,
                        elevation: 10.0,
                        splashColor: Colors.purple[400],
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
                        child: new Text(
                          ("Not Acknowledged"),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15),
                        )),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    height: 40,
                    width: 175,
                    child: RaisedButton(
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
                            count = 2;
                          });
                        },
                        child: new Text(
                          ("Acknowledged"),
                          style: TextStyle(fontSize: 15),
                        )),
                  ),
                  SizedBox(
                    width: 15,
                  )
                ],
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child:
                    Container(height: 2.0, width: 600.0, color: Colors.purple),
              ),
              SizedBox(height: 10),
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
              )
            ],
          ),
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
                                  color: Color(0xFF676E79),
                                  iconSize: 32,
                                  onPressed: homes,
                                ),
                                IconButton(
                                  icon: Icon(Icons.arrow_upward),
                                  iconSize: 32,
                                  color: Colors.red,
                                  highlightColor: Colors.purple,
                                  onPressed: () {},
                                ),
                              ],
                            )),
                        Container(
                            height: 50.0,
                            width: MediaQuery.of(context).size.width / 2 - 40.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.arrow_downward),
                                  iconSize: 32,
                                  color: Color(0xFF676E79),
                                  onPressed: rec,
                                ),
                                IconButton(
                                  icon: Icon(Icons.person_outline),
                                  iconSize: 32,
                                  color: Color(0xFF676E79),
                                  onPressed: setting,
                                )
                              ],
                            )),
                      ]))),
        ));
  }

  Widget buildItem(BuildContext context, DocumentSnapshot documents) {
    return Container(
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
            Colors.blueAccent[400],
            Colors.purple[400],
            Colors.blue[400],
          ])),
      child: FlatButton(
        child: Row(
          children: <Widget>[
            Flexible(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Row(children: <Widget>[
                      SizedBox(
                        width: 30,
                      ),
                      Container(
                          child: Text(
                        ("YOU"),
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )),
                      SizedBox(width: 30),
                      Container(
                        child: Icon(
                          Icons.fast_forward,
                          size: 30,
                          color: Colors.black,
                        ),
                        width: 25,
                      ),
                      Container(
                        child: Icon(
                          Icons.fast_forward,
                          size: 30,
                          color: Colors.black,
                        ),
                        width: 25,
                      ),
                      Container(
                        child: Icon(
                          Icons.fast_forward,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 20),
                      Flexible(
                        child: Container(
                            child: Text(
                          ('Dr.${documents['to name'] ?? 'Error'}'),
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
                          'Patient name :',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            '${documents['patientname'] ?? 'Not available'}',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                        ),
                      ),
                    ]),
                    Row(children: <Widget>[
                      Container(
                        child: Icon(
                          Icons.info_outline,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        child: Text(
                          'STATUS :',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                      Container(
                        child: Text(
                          '${documents['status'] ?? 'Not available'}',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                    ]),
                  ],
                ),
                margin: EdgeInsets.only(left: 20.0),
              ),
            ),
          ],
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Compd(
                        peerid: '${documents['patientname']}',
                        curid: iid,
                        doc: '${documents['sugid']}',
                      )));
        },
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 25.0, 10.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
    );
  }

  void homes() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Hom(
                  currentUserId: iid,
                )));
  }

  void rec() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Rec(
                  iid: iid,
                  user: user,
                )));
  }

  void sent() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Sent(
                  iid: iid,
                  user: user,
                )));
  }

  void setting() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Setting(
                  currentUserId: iid,
                  user: user,
                  lov: false,
                )));
  }

  Stream<dynamic> str(int count) {
    if (count == 1) {
      return Firestore.instance
          .collection("Doctors")
          .document(iid)
          .collection("outpatients")
          .where('status', isEqualTo: 'send')
          .snapshots();
    }
    if (count == 2) {
      return Firestore.instance
          .collection("Doctors")
          .document(iid)
          .collection("outpatients")
          .where('status', isEqualTo: 'received')
          .snapshots();
    }
  }
}
