import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:final_proj/main.dart';

class Pathis extends StatefulWidget {
  final String iid;
  final FirebaseUser user;
  Pathis({Key key, @required this.iid, @required this.user}) : super(key: key);
  @override
  _PathisState createState() => _PathisState(iid: iid, user: user);
}

class _PathisState extends State<Pathis> {
  _PathisState({Key key, @required this.iid, @required this.user});
  FirebaseUser user;
  String iid;
  int count = 1;
  bool success = true;
  bool failure = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 10.0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('History',
              style: TextStyle(
                  fontFamily: 'Varela',
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.black)),
        ),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                SizedBox(width: 80),
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
                          success = true;
                          failure = false;
                          count = 1;
                        });
                      },
                      child: new Text(
                        ("Completed"),
                        style: TextStyle(fontSize: 15),
                      )),
                ),
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
                          success = false;
                          failure = true;
                          count = 2;
                        });
                      },
                      child: new Text(
                        ("Declined"),
                        style: TextStyle(fontSize: 15),
                      )),
                ),
                SizedBox(width: 10),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child:
                  Container(height: 2.0, width: 600.0, color: Colors.red[400]),
            ),
            SizedBox(height: 10),
            Visibility(
              visible: success,
              child: Text(
                "Successfully Completed appointments",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Visibility(
              visible: failure,
              child: Text(
                "Declined appointments",
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
                  } else {
                    return Text("No appoinments found \n     check back later",
                        style: TextStyle(fontSize: 18));
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
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
                    SizedBox(height: 10),
                    Row(children: <Widget>[
                      Flexible(
                        child: Container(
                          child: Text(
                            ('${documents['from name'] ?? 'Not available'}'),
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
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
                            ('${documents['to name'] ?? 'Not available'}'),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
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
                    Row(children: <Widget>[
                      Container(
                        child: Icon(
                          Icons.fiber_pin,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        child: Text(
                          'Pateint ID :',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 5.0),
                      ),
                      Container(
                        child: Text(
                          '${documents['pid'] ?? 'Not available'}',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 5.0),
                      ),
                    ]),
                    Row(children: <Widget>[
                      Container(
                        child: Icon(
                          Icons.child_care,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        child: Text(
                          'Pateint Age :',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 5.0),
                      ),
                      Container(
                        child: Text(
                          '${documents['age'] ?? 'Not available'}',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 5.0),
                      ),
                    ]),
                    Row(children: <Widget>[
                      Container(
                        child: Icon(
                          Icons.comment,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        child: Text(
                          'Reason :',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 5.0),
                      ),
                      Container(
                        child: Text(
                          '${documents['suggestions'] ?? 'Not available'}',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                    ]),
                    Row(children: <Widget>[
                      Container(
                        child: Icon(
                          Icons.local_hospital,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        child: Text(
                          'Medications :',
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
                            '${documents['medications'] ?? 'Not available'}',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                        ),
                      ),
                    ]),
                  ],
                ),
                margin: EdgeInsets.only(left: 20.0),
              ),
            ),
          ],
        ),
        onPressed: () {},
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 0.0, 10.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
    );
  }

  Stream<dynamic> str(int count) {
    if (count == 1) {
      return Firestore.instance
          .collection('Patients')
          .document(iid)
          .collection("suggestions")
          .where('status', isEqualTo: 'finish')
          .orderBy("time completed", descending: true)
          .snapshots();
    }
    if (count == 2) {
      return Firestore.instance
          .collection('Patients')
          .document(iid)
          .collection("suggestions")
          .where('status', isEqualTo: 'declined')
          .orderBy("time completed", descending: true)
          .snapshots();
    }
  }
}
