import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:final_proj/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Patsetting extends StatefulWidget {
  final String iid;
  FirebaseUser user;

  Patsetting({Key key, this.iid, this.user}) : super(key: key);
  @override
  _PatsettingState createState() => _PatsettingState(iid: iid, user: user);
}

class _PatsettingState extends State<Patsetting> {
  _PatsettingState({
    Key key,
    @required this.iid,
    @required this.user,
  });
  String iid;
  FirebaseUser user;
  TextEditingController controllerNickname;

  TextEditingController controllerph;
  TextEditingController controllerNPI;

  TextEditingController controllerema;

  SharedPreferences prefs;

  String id = '';
  String nickname = '';

  String ema = '';
  String phone = '';

  String del;
  bool isLoading = false;
  bool lovs = false;
  File avatarImageFile;

  final FocusNode focusNodeNickname = new FocusNode();

  final FocusNode focusNodephone = new FocusNode();
  final FocusNode focusNodeema = new FocusNode();

  @override
  void initState() {
    super.initState();
    readLocal();
  }

  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id') ?? '';

    nickname = prefs.getString('Name') ?? '';

    ema = prefs.getString('Email-id') ?? '';

    phone = prefs.getString('Phone') ?? '';

    controllerNickname = new TextEditingController(text: nickname);

    controllerNPI = new TextEditingController(text: id);
    controllerema = new TextEditingController(text: ema);

    controllerph = new TextEditingController(text: phone);

    uploadFile();
  }

  Future uploadFile() async {
    Firestore.instance.collection('Doctors').document(id).updateData({
      'Name': nickname,
      'Phone': phone,
      'Email-id': ema,
    });

    FirebaseAuth.instance.currentUser().then((val) {
      UserUpdateInfo updateUser = UserUpdateInfo();
      updateUser.displayName = controllerNickname.text;

      val.updateProfile(updateUser);
    });
  }

  void handleUpdateData() {
    focusNodeNickname.unfocus();
    focusNodephone.unfocus();
    focusNodeema.unfocus();

    setState(() {
      isLoading = true;
    });

    Firestore.instance.collection('Patients').document(iid).updateData({
      'Name': nickname,
      'Phone': phone,
      'Email-id': ema,
    }).then((data) async {
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(
        msg: "Update success",
      );
    }).catchError((err) {
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: err.toString());
    });
    FirebaseAuth.instance.currentUser().then((val) {
      UserUpdateInfo updateUser = UserUpdateInfo();
      updateUser.displayName = controllerNickname.text;

      val.updateProfile(updateUser);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Colors.orange,
          Colors.red[400],
          Colors.orangeAccent,
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
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    ("PROFILE"),
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
              height: 10,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(60))),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 100,
                              ),
                              Center(
                                  child: Container(
                                padding: EdgeInsets.fromLTRB(4, 2, 10, 20),
                                child: new TextFormField(
                                  decoration: new InputDecoration(
                                    labelText: "Name",
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(25.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                  controller: controllerNickname,
                                  enabled: lovs,
                                  onChanged: (value) {
                                    nickname = value;
                                  },
                                  focusNode: focusNodeNickname,
                                  validator: (val) {
                                    if (val.length == 0) {
                                      return " Name cannot be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.text,
                                  style: new TextStyle(
                                    fontFamily: "Poppins",
                                  ),
                                ),
                              )),
                              Padding(
                                padding: EdgeInsets.fromLTRB(4, 0, 10, 20),
                                child: new TextFormField(
                                  decoration: new InputDecoration(
                                    labelText: "Phone Number",
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(25.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                  controller: controllerph,
                                  enabled: lovs,
                                  onChanged: (value) {
                                    phone = value;
                                  },
                                  focusNode: focusNodephone,
                                  validator: (val) {
                                    if (val.length == 0) {
                                      return "Phone Number cannot be empty";
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
                                padding: EdgeInsets.fromLTRB(4, 0, 10, 20),
                                child: new TextFormField(
                                  decoration: new InputDecoration(
                                    labelText: "E-mail Id",
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(25.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                  controller: controllerema,
                                  enabled: lovs,
                                  onChanged: (value) {
                                    ema = value;
                                  },
                                  focusNode: focusNodeema,
                                  validator: (val) {
                                    if (val.length == 0) {
                                      return "E-mail Id cannot be empty";
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
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 50.0, right: 50.0),
                          child: RaisedButton(
                            padding: EdgeInsets.only(left: 25.0, right: 25.0),
                            textColor: Colors.white,
                            color: Colors.orange,
                            child: Text(("Update"),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.0)),
                            onPressed: lovs ? handleUpdateData : null,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(40.0),
                                side: BorderSide(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            lovs = !lovs;
          });
        },
        elevation: 10,
        label: Text('Edit'),
        icon: Icon(Icons.edit),
        backgroundColor: Colors.green,
      ),
    );
  }
}
