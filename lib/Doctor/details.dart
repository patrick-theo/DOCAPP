import 'dart:convert';
import 'dart:developer';

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_proj/Doctor/docdetail.dart';
import 'package:uuid/uuid.dart';
import 'Home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Details extends StatefulWidget {
  final String peerId;
  final String nam;
  final FirebaseUser user;
  Details(
      {Key key, @required this.peerId, @required this.nam, @required this.user})
      : super(key: key);
  @override
  _DetailsState createState() =>
      new _DetailsState(peerId: peerId, nam: nam, user: user);
}

class _DetailsState extends State<Details> {
  _DetailsState(
      {Key key,
      @required this.peerId,
      @required this.nam,
      @required this.user});
  String peerId;
  String nam;
  FirebaseUser user;
  var uuid = Uuid();
  String doc;
  String act;
  String groupId;
  int count;
  DocumentReference collectionReference;
  DocumentSnapshot documentSnapshot;
  var fav;
  SharedPreferences prefs;
  String id;
  var name1 = new TextEditingController();
  var name2 = new TextEditingController();
  bool isloading = false;
  var email = new TextEditingController();
  var numb = new TextEditingController();
  var paid = new TextEditingController();
  var age = new TextEditingController();
  var weight = new TextEditingController();
  var reason = new TextEditingController();
  var med = new TextEditingController();
  var com = new TextEditingController();
  @override
  void initState() {
    readLocal();
  }

  @override
  Widget build(BuildContext context) {
    //Change end gradient color here

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Colors.blueAccent[400],
          Colors.purple[400],
          Colors.blue[400],
        ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Hom()));
                    },
                  ),
                  SizedBox(height: 10),
                  Text(
                    ("PATIENT DETAILS"),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
                child: Container(
              height: MediaQuery.of(context).size.height - 10.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)),
              ),
              child: ListView(
                primary: false,
                padding: EdgeInsets.only(left: 25.0, right: 20.0),
                children: <Widget>[
                  SizedBox(height: 20),
                  Center(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(15, 25, 20, 20),
                      child: new TextFormField(
                        decoration: new InputDecoration(
                          labelText: "Patient first Name",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(),
                          ),
                          //fillColor: Colors.green
                        ),
                        controller: name1,
                        validator: (val) {
                          if (val.length == 0) {
                            return "Patient Name cannot be empty";
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.text,
                        style: new TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 20, 20),
                    child: new TextFormField(
                      decoration: new InputDecoration(
                        labelText: "Patient Second Name",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                        //fillColor: Colors.green
                      ),
                      controller: name2,
                      validator: (val) {
                        if (val.length == 0) {
                          return "Patient Name cannot be empty";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.text,
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 20, 20),
                    child: new TextFormField(
                      decoration: new InputDecoration(
                        labelText: "Patient phone number",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                        //fillColor: Colors.green
                      ),
                      controller: numb,
                      validator: (val) {
                        if (val.length == 0) {
                          return "Patient Name cannot be empty";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.phone,
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 20, 20),
                    child: new TextFormField(
                      decoration: new InputDecoration(
                        labelText: "Patient Email-id",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                        //fillColor: Colors.green
                      ),
                      controller: email,
                      validator: (val) {
                        if (val.length == 0) {
                          return "Patient Name cannot be empty";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 20, 20),
                    child: new TextFormField(
                      decoration: new InputDecoration(
                        labelText: "Patient ID",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                        //fillColor: Colors.green
                      ),
                      controller: paid,
                      validator: (val) {
                        if (val.length == 0) {
                          return "Patient ID cannot be empty";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.text,
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: new TextFormField(
                            decoration: new InputDecoration(
                              labelText: "Age",
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(25.0),
                                borderSide: new BorderSide(),
                              ),
                              //fillColor: Colors.green
                            ),
                            controller: age,
                            validator: (val) {
                              if (val.length == 0) {
                                return "Age cannot be empty";
                              } else {
                                return null;
                              }
                            },
                            keyboardType: TextInputType.number,
                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ]),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 150, 20),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: new TextFormField(
                      decoration: new InputDecoration(
                        labelText: "Reason for Suggestion",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                        //fillColor: Colors.green
                      ),
                      controller: reason,
                      keyboardType: TextInputType.text,
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: new TextFormField(
                      maxLines: 10,
                      decoration: new InputDecoration(
                        labelText: "Comments",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                        //fillColor: Colors.green
                      ),
                      validator: (val) {
                        if (val.length == 0) {
                          return "it cannot be empty";
                        } else {
                          return null;
                        }
                      },
                      controller: med,
                      keyboardType: TextInputType.text,
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  (!isloading)
                      ? Padding(
                          padding: EdgeInsets.only(left: 100.0, right: 100.0),
                          child: RaisedButton(
                            elevation: 8,
                            textColor: Colors.white,
                            color: Colors.purple[400],
                            child: Text(("SUBMIT"),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0)),
                            onPressed: submit,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                                side: BorderSide(color: Colors.purple[400])),
                          ))
                      : LinearProgressIndicator(
                          backgroundColor: Colors.black,
                        ),
                  SizedBox(height: 20)
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  void submit() async {
    this.setState(() {
      isloading = true;
    });
    String doc = uuid.v1().toString();
    Firestore.instance
        .collection('Doctors')
        .document(peerId)
        .collection('inpatients')
        .document(doc)
        .setData({
      'sugid': doc,
      'patientname': name1.text + " " + name2.text,
      'pid': paid.text,
      'age': age.text,
      'phone number': numb.text,
      'email': email.text,
      'medications': med.text,
      'decline reason': 'nil',
      'from': id,
      'from name': '${user.displayName}',
      'to': peerId,
      'to name': nam,
      'suggestions': reason.text,
      'status': 'send',
      'created': FieldValue.serverTimestamp(),
      'scheduled-date': null,
      'scheduled-time': null,
    });
    Firestore.instance
        .collection('Doctors')
        .document(id)
        .collection('outpatients')
        .document(doc)
        .setData({
      'sugid': doc,
      'patientname': name1.text + " " + name2.text,
      'pid': paid.text,
      'age': age.text,
      'phone number': numb.text,
      'email': email.text,
      'medications': med.text,
      'to': peerId,
      'decline reason': 'nil',
      'to name': nam,
      'suggestions': reason.text,
      'status': 'send',
      'from': id,
      'from name': '${user.displayName}',
      'created': FieldValue.serverTimestamp(),
      'scheduled-date': null,
      'scheduled-time': null,
    });
    Firestore.instance
        .collection('Patients')
        .document(paid.text)
        .collection("suggestions")
        .document(doc)
        .setData({
      'patientname': name1.text + " " + name2.text,
      'pid': paid.text,
      'age': age.text,
      'phone number': numb.text,
      'email': email.text,
      'medications': med.text,
      'decline reason': 'nil',
      'to': peerId,
      'to name': nam,
      'suggestions': reason.text,
      'status': 'send',
      'from': id,
      'from name': '${user.displayName}',
      'created': FieldValue.serverTimestamp(),
      'scheduled-date': null,
      'scheduled-time': null,
    });
    groupId = id + peerId;
    Firestore.instance
        .collection("notifications")
        .document(groupId)
        .collection(groupId)
        .document(doc)
        .setData({
      'idFrom': id,
      'idTo1': peerId,
      'idTo2': paid.text,
      'sugid': doc,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
    });
    collectionReference = Firestore.instance
        .collection("Doctors")
        .document(id)
        .collection("fav")
        .document(peerId);
    documentSnapshot = await collectionReference.get();
    if (documentSnapshot == null || !documentSnapshot.exists) {
      Firestore.instance
          .collection("Doctors")
          .document(id)
          .collection("fav")
          .document(peerId)
          .setData({
        'count': 1,
      });
    } else {
      Firestore.instance
          .collection("Doctors")
          .document(id)
          .collection("fav")
          .document(peerId)
          .updateData({'count': FieldValue.increment(1)});
      final QuerySnapshot result = await Firestore.instance
          .collection('Doctors')
          .document(id)
          .collection("fav")
          .where('id', isEqualTo: peerId)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      count = documents[0]['count'];
      if (count >= 5) {
        Firestore.instance.collection("Doctors").document(id).updateData({
          'fav': FieldValue.arrayUnion([peerId])
        });
      }
    }
    Firestore.instance.collection('Doctors').document(peerId).updateData({
      'count': FieldValue.increment(1),
    });

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Hom(doc: doc)));
    this.setState(() {
      isloading = false;
    });
  }

  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id') ?? '';
  }
}
