import 'dart:io';
import 'package:final_proj/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_proj/Doctor/Home.dart';
import 'package:final_proj/Doctor/lo.dart';
import 'package:final_proj/Doctor/set.dart';
import 'package:final_proj/Patient/patientlog.dart';
import 'package:final_proj/specs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Patsign extends StatefulWidget {
  final String specialization;
  Patsign({Key key, this.specialization}) : super(key: key);

  @override
  _PatsignState createState() => _PatsignState(specialization: specialization);
}

class _PatsignState extends State<Patsign> {
  _PatsignState({
    Key key,
    this.specialization,
  });
  String specialization;
  FirebaseUser currentuser;
  String spez;
  int choice = 0;
  bool isLoading;
  File avatarImageFile;
  bool obscuretext = true;
  bool obscuretext1 = true;
  List<Specs> _specs = Specs.getSpecs();
  List<DropdownMenuItem<Specs>> _dropdownMenuItems;
  Specs _selectedspecs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var email = new TextEditingController();
  var pass = new TextEditingController();
  var name = new TextEditingController();
  var years = new TextEditingController();
  var edu = new TextEditingController();
  var uiid = new TextEditingController();
  var hos = new TextEditingController();
  var offnum = new TextEditingController();
  var faxnum = new TextEditingController();
  var cpass = new TextEditingController();
  bool genera = false;
  bool phy = false;
  String photoUrl;
  SharedPreferences prefs;
  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_specs);
    _selectedspecs = _dropdownMenuItems[0].value;

    super.initState();
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
                    ("SIGN UP"),
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
                              Center(
                                  child: Container(
                                padding: EdgeInsets.fromLTRB(4, 2, 10, 20),
                                child: new TextFormField(
                                  controller: name,
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
                                  controller: uiid,
                                  decoration: new InputDecoration(
                                    labelText: "Unique ID",
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(25.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                  keyboardType: TextInputType.text,
                                  style: new TextStyle(
                                    fontFamily: "Poppins",
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(4, 0, 10, 20),
                                child: new TextFormField(
                                  controller: offnum,
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
                                  keyboardType: TextInputType.phone,
                                  style: new TextStyle(
                                    fontFamily: "Poppins",
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(4, 0, 10, 20),
                                child: new TextFormField(
                                  controller: email,
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
                                  validator: (val) {
                                    if (val.length == 0) {
                                      return "E-mail Id cannot be empty";
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
                                padding: EdgeInsets.fromLTRB(4, 0, 10, 20),
                                child: new TextFormField(
                                  obscureText: obscuretext,
                                  controller: pass,
                                  decoration: new InputDecoration(
                                    labelText: "Password",
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(25.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    suffixIcon: IconButton(
                                        icon: Icon(
                                          // Based on passwordVisible state choose the icon
                                          obscuretext
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.grey,
                                        ),
                                        onPressed: _toggle),
                                    //fillColor: Colors.green
                                  ),
                                  validator: (val) {
                                    if (val.length == 0) {
                                      return "Enter Password";
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.visiblePassword,
                                  style: new TextStyle(
                                    fontFamily: "Poppins",
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(4, 0, 10, 20),
                                child: new TextFormField(
                                  obscureText: obscuretext1,
                                  controller: cpass,
                                  decoration: new InputDecoration(
                                    labelText: "Enter Password Again",
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(25.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    suffixIcon: IconButton(
                                        icon: Icon(
                                          // Based on passwordVisible state choose the icon
                                          obscuretext1
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.grey,
                                        ),
                                        onPressed: _toggle1),
                                    //fillColor: Colors.green
                                  ),
                                  validator: (val) {
                                    if (val.length == 0) {
                                      return "Enter Password";
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.visiblePassword,
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
                            child: Text(("Sign Up"),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.0)),
                            onPressed: sign,
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
    );
  }

  void sign() async {
    try {
      if (pass.text == cpass.text) {
        FirebaseUser user;

        user = (await _auth.createUserWithEmailAndPassword(
                email: email.text, password: pass.text))
            .user;

        if (user != null) {
          final QuerySnapshot result = await Firestore.instance
              .collection('Patients')
              .where('id', isEqualTo: uiid.text)
              .getDocuments();
          final List<DocumentSnapshot> documents = result.documents;
          if (documents.length == 0) {
            Firestore.instance
                .collection('Patients')
                .document(uiid.text)
                .setData({
              'Name': name.text,
              'id': uiid.text,
              'pushToken': null,
              'Email-id': email.text,
              'Phone': offnum.text,
            });

            Fluttertoast.showToast(
                msg: "Sign in successfull ",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            FirebaseAuth.instance.currentUser().then((val) {
              UserUpdateInfo updateUser = UserUpdateInfo();

              updateUser.displayName = name.text;
              val.updateProfile(updateUser);
            });

            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Patlog()));
          }
        }
      } else {
        Fluttertoast.showToast(
            msg: "Check If Passwords Match",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } on PlatformException catch (err) {
      switch (err.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
          Fluttertoast.showToast(
              msg: "E-mail Already Registered",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.purple[400],
              textColor: Colors.white,
              fontSize: 16.0);
          break;

        case "ERROR_INVALID_EMAIL":
          Fluttertoast.showToast(
              msg: "Enter Valid E-mail",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.purple[400],
              textColor: Colors.white,
              fontSize: 16.0);
          break;
        case "error":
          Fluttertoast.showToast(
              msg: "Enter Credentials",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.purple[400],
              textColor: Colors.white,
              fontSize: 16.0);
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          Fluttertoast.showToast(
              msg: "Too many requests,Try later",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.purple[400],
              textColor: Colors.white,
              fontSize: 16.0);
          break;
        case "ERROR_NETWORD_REQUEST_FAILED":
          Fluttertoast.showToast(
              msg: "Check Internet Connection",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.purple[400],
              textColor: Colors.white,
              fontSize: 16.0);
          break;

        default:
          Fluttertoast.showToast(
              msg: "Check Internet Connection",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.purple[400],
              textColor: Colors.white,
              fontSize: 16.0);
          break;
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
    });
  }

  void _toggle() {
    setState(() {
      obscuretext = !obscuretext;
    });
  }

  void _toggle1() {
    setState(() {
      obscuretext1 = !obscuretext1;
    });
  }
}
