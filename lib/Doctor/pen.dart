import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_proj/Doctor/received.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slider_button/slider_button.dart';
import 'package:final_proj/main.dart';

class Pending extends StatefulWidget {
  final String peerid;
  final String curid;
  final String doc;
  final FirebaseUser user;

  Pending(
      {Key key,
      @required this.peerid,
      @required this.curid,
      this.doc,
      this.user})
      : super(key: key);
  @override
  _PendingState createState() =>
      _PendingState(peerid: peerid, curid: curid, doc: doc, user: user);
}

class _PendingState extends State<Pending> {
  _PendingState(
      {Key key,
      @required this.peerid,
      @required this.curid,
      this.doc,
      this.user});
  String peerid;
  String curid;
  String doc;
  final FirebaseUser user;

  @override
  var time = new TextEditingController();
  bool ack = false;
  int count;
  bool isloading = false;
  SharedPreferences prefs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text('Pending page',
            style: TextStyle(
                fontFamily: 'Varela',
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.black)),
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection('Doctors')
                  .document(curid)
                  .collection("inpatients")
                  .where('sugid', isEqualTo: doc)
                  .snapshots(),
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
        ],
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot documents) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Image.asset('images/patient-min.png'),
              SizedBox(height: 10),
              SizedBox(
                height: 20,
              ),
              Text(
                "Refered by",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[400]),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Dr:${documents['from name'] ?? 'Not available'}',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Patient Name",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[400]),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                '${documents['patientname'] ?? 'Not available'}',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Patient ID",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[400]),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                '${documents['pid'] ?? 'Not available'}',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Patient Age",
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple[400]),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width - 238,
                                  child: Text(
                                    '${documents['age'] ?? 'Not available'}',
                                    style: TextStyle(color: Colors.black),
                                  ))
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Reason for suggestion",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[400]),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                '${documents['suggestions'] ?? 'Not available'}',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Comments",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[400]),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                '${documents['medications'] ?? 'Not available'}',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Status",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[400]),
              ),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                '${documents['status'] ?? 'Not available'}',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 30,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: <Widget>[
                      Text('***Patient ',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 28.0)),
                      SizedBox(width: 1.0),
                      Text('Checked***',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.purple[400],
                              fontWeight: FontWeight.bold,
                              fontSize: 28.0))
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 30,
                child: Padding(
                  padding: EdgeInsets.only(left: 70.0, right: 50.0),
                  child: RaisedButton(
                    elevation: 8,
                    textColor: Colors.white,
                    color: Colors.purple[400],
                    child: ack
                        ? Text(("Completed"),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0))
                        : Text((" Not Completed"),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0)),
                    onPressed: () {
                      setState(() {
                        ack = !ack;
                      });
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                        side: BorderSide(color: Colors.purple[400])),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              (!isloading)
                  ? SliderButton(
                      height: 50,
                      width: 600,
                      action: () {
                        if (ack) {
                          this.setState(() {
                            isloading = true;
                          });
                          Firestore.instance
                              .collection('Doctors')
                              .document(curid)
                              .collection("inpatients")
                              .document('${documents['sugid']}')
                              .updateData({
                            'status': 'finish',
                            'time completed': FieldValue.serverTimestamp(),
                          });
                          Firestore.instance
                              .collection('Doctors')
                              .document('${documents['from']}')
                              .collection("outpatients")
                              .document('${documents['sugid']}')
                              .updateData({
                            'status': 'finish',
                            'time completed': FieldValue.serverTimestamp(),
                          });
                          Firestore.instance
                              .collection('Patients')
                              .document('${documents['pid']}')
                              .collection("suggestions")
                              .document('${documents['sugid']}')
                              .updateData({
                            'status': 'finish',
                            'time completed': FieldValue.serverTimestamp(),
                          });
                          Firestore.instance
                              .collection("Doctors")
                              .document(curid)
                              .updateData({
                            'count': FieldValue.increment(-1),
                          });

                          Fluttertoast.showToast(
                              msg: "Done",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.purple[400],
                              textColor: Colors.white,
                              fontSize: 16.0);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Rec(
                                        doc: doc,
                                        iid: curid,
                                        user: user,
                                      )));
                          this.setState(() {
                            isloading = false;
                          });
                        } else {
                          Fluttertoast.showToast(
                              msg: "No changes done to update ",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.blue,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          this.setState(() {
                            isloading = false;
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Rec(
                                        doc: doc,
                                        iid: curid,
                                        user: user,
                                      )));
                        }
                      },
                      label: Text(
                        "Slide to Complete",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                      icon: Text(
                        "+",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 41,
                        ),
                      ),
                      boxShadow: BoxShadow(
                        color: Colors.black,
                        blurRadius: 10.0,
                      ),
                      buttonColor: Colors.purple[400],
                      backgroundColor: Colors.blue,
                      highlightedColor: Colors.white,
                      baseColor: Colors.blue,
                    )
                  : LinearProgressIndicator(
                      backgroundColor: Colors.black,
                    ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
