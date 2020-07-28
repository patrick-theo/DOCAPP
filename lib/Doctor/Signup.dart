import 'dart:io';
import 'package:final_proj/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'lo.dart';
import 'set.dart';
import 'package:final_proj/specs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {
  final String specialization;
  Signup({Key key, this.specialization}) : super(key: key);

  @override
  _SignupState createState() => _SignupState(specialization: specialization);
}

class _SignupState extends State<Signup> {
  _SignupState({
    Key key,
    this.specialization,
  });
  String specialization;
  FirebaseUser currentuser;
  String spez;
  int choice = 0;
  String na;
  bool _isloading = false;
  bool _isloadingnp = false;
  bool check = false;
  bool gen = false,
      orth = false,
      pae = false,
      phy = false,
      uru = false,
      psy = false,
      gyn = false,
      nep = false,
      oto = false,
      rhe = false,
      car = false;
  String sp;
  bool _obscuretext = true;
  bool _obscuretexts = true;
  File avatarImageFile;
  List<Specs> _specs = Specs.getSpecs();
  List<DropdownMenuItem<Specs>> _dropdownMenuItems;
  Specs _selectedspecs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var email = new TextEditingController();
  var pass = new TextEditingController();
  var passch = new TextEditingController();
  var name = new TextEditingController();
  var years = new TextEditingController();
  var edu = new TextEditingController();
  var npi = new TextEditingController();
  var hos = new TextEditingController();
  var offnum = new TextEditingController();
  var faxnum = new TextEditingController();
  var phnum = new TextEditingController();
  var abtme = new TextEditingController();

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
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width * 5,
        height: MediaQuery.of(context).size.height * 5,
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
              padding: EdgeInsets.all(20),
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
            Row(children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(25.0, 0.0, 0.0, 10.0),
                child: Stack(
                  children: <Widget>[
                    (avatarImageFile == null)
                        ? Icon(
                            Icons.account_circle,
                            size: 130.0,
                            color: Colors.white,
                          )
                        : Material(
                            child: Image.file(
                              avatarImageFile,
                              width: 120.0,
                              height: 120.0,
                              fit: BoxFit.cover,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(60.0)),
                            clipBehavior: Clip.hardEdge,
                            elevation: 50,
                          ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Container(
                height: 40,
                child: RaisedButton.icon(
                  onPressed: check ? getImage : null,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  label: Text(
                    'Choose a Profile Pic',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  icon: Icon(
                    Icons.camera,
                    color: Colors.white,
                  ),
                  textColor: Colors.white,
                  splashColor: Colors.red,
                  color: Colors.orange,
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ]),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(60))),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 0, 10)),
                              Expanded(
                                child: TextFormField(
                                  controller: npi,
                                  enabled: !check,
                                  decoration: new InputDecoration(
                                    labelText: "NPI Number",
                                    labelStyle: TextStyle(color: Colors.black),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.redAccent, width: 2.0),
                                      borderRadius:
                                          new BorderRadius.circular(25.0),
                                    ),
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
                                      return "NPI Number cannot be empty";
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
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0)),
                              Expanded(
                                  child: RaisedButton.icon(
                                onPressed: check
                                    ? null
                                    : () async {
                                        final snapShot = await Firestore
                                            .instance
                                            .collection('Doctors')
                                            .document(npi.text)
                                            .get();
                                        this.setState(() {
                                          _isloadingnp = true;
                                        });
                                        if (snapShot == null ||
                                            !snapShot.exists) {
                                          Fluttertoast.showToast(
                                              msg: "Npi not available",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor:
                                                  Colors.purple[400],
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                          this.setState(() {
                                            _isloadingnp = false;
                                          });
                                        } else if (snapShot.data['Nickname'] ==
                                            null) {
                                          Fluttertoast.showToast(
                                              msg: "Found Npi",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor:
                                                  Colors.purple[400],
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                          this.setState(() {
                                            _isloadingnp = false;
                                            check = true;
                                          });
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: "Npi Already registered",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor:
                                                  Colors.purple[400],
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                          this.setState(() {
                                            _isloadingnp = false;
                                          });
                                        }
                                      },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(30.0))),
                                label: (!_isloadingnp)
                                    ? Text(
                                        'Check',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      )
                                    : CircularProgressIndicator(
                                        backgroundColor: Colors.black,
                                        strokeWidth: 5,
                                      ),
                                icon: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                ),
                                textColor: Colors.white,
                                splashColor: Colors.deepOrangeAccent,
                                color: Colors.redAccent,
                              )),
                            ]),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 40,
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: RaisedButton.icon(
                            onPressed: check ? dept : null,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0))),
                            label: Text(
                              'Choose Your Specialisation',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 21),
                            ),
                            icon: Icon(
                              Icons.swap_vertical_circle,
                              color: Colors.white,
                            ),
                            textColor: Colors.white,
                            splashColor: Colors.blue,
                            color: Colors.purple[400],
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          child: Column(
                            children: <Widget>[
                              Center(
                                  child: Container(
                                padding: EdgeInsets.fromLTRB(4, 2, 10, 20),
                                child: new TextFormField(
                                  controller: name,
                                  enabled: check,
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
                                  controller: edu,
                                  enabled: check,
                                  decoration: new InputDecoration(
                                    labelText: "Education",
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
                                      return "Education cannot be empty";
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 10, 0, 10)),
                                    Expanded(
                                      child: new TextFormField(
                                        controller: offnum,
                                        enabled: check,
                                        decoration: new InputDecoration(
                                          labelText: "Office Number",
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
                                            return "Office Number cannot be empty";
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
                                      height: 1,
                                      width: 15,
                                    ),
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 10, 0, 10)),
                                    Expanded(
                                      child: new TextFormField(
                                        controller: faxnum,
                                        enabled: check,
                                        decoration: new InputDecoration(
                                          labelText: "Fax Number",
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
                                            return "Fax Number cannot be empty";
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
                                      width: 20,
                                    ),
                                  ]),
                              Padding(
                                padding: EdgeInsets.fromLTRB(4, 0, 10, 20),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(4, 0, 10, 20),
                                child: new TextFormField(
                                  controller: years,
                                  enabled: check,
                                  decoration: new InputDecoration(
                                    labelText: " Board Certification",
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
                                      return "Board Certification cannot be empty";
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
                                  controller: hos,
                                  enabled: check,
                                  decoration: new InputDecoration(
                                    labelText: "Hospital Currently Working",
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
                                  controller: phnum,
                                  enabled: check,
                                  decoration: new InputDecoration(
                                    labelText:
                                        "Enter your Personal phone number",
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
                                      return "Enter your Personal phone number";
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
                                padding: EdgeInsets.fromLTRB(4, 0, 10, 20),
                                child: new TextFormField(
                                  controller: email,
                                  enabled: check,
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
                                  controller: pass,
                                  enabled: check,
                                  decoration: new InputDecoration(
                                    labelText: "Enter your password",
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(25.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    suffixIcon: IconButton(
                                        icon: Icon(
                                          // Based on passwordVisible state choose the icon
                                          _obscuretext
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.grey,
                                        ),
                                        onPressed: _toggle),
                                    //fillColor: Colors.green
                                  ),
                                  validator: (val) {
                                    if (val.length == 0) {
                                      return "Enter your password";
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: _obscuretext,
                                  style: new TextStyle(
                                    fontFamily: "Poppins",
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(4, 0, 10, 20),
                                child: new TextFormField(
                                  controller: passch,
                                  enabled: check,
                                  decoration: new InputDecoration(
                                    labelText: "Type Your password again",
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(25.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    suffixIcon: IconButton(
                                        icon: Icon(
                                          // Based on passwordVisible state choose the icon
                                          _obscuretexts
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.grey,
                                        ),
                                        onPressed: _toggles),
                                    //fillColor: Colors.green
                                  ),
                                  validator: (val) {
                                    if (val.length == 0) {
                                      return "Password cannot be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: _obscuretexts,
                                  style: new TextStyle(
                                    fontFamily: "Poppins",
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(4, 0, 10, 20),
                                child: new TextFormField(
                                  controller: abtme,
                                  enabled: check,
                                  maxLines: 10,
                                  decoration: new InputDecoration(
                                    labelText: "About Me",
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
                                      return "About Me cannot be empty";
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
                            child: Visibility(
                              visible: !_isloading,
                              child: (_isloading)
                                  ? LinearProgressIndicator(
                                      backgroundColor: Colors.black,
                                    )
                                  : RaisedButton(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0),
                                      textColor: Colors.white,
                                      color: Colors.blue,
                                      child: Text(("Sign Up"),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0)),
                                      onPressed: check ? sign : null,
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(40.0),
                                          side:
                                              BorderSide(color: Colors.white)),
                                    ),
                            )),
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

  void _toggle() {
    setState(() {
      _obscuretext = !_obscuretext;
    });
  }

  void _toggles() {
    setState(() {
      _obscuretexts = !_obscuretexts;
    });
  }

  void sign() async {
    this.setState(() {
      _isloading = true;
    });
    try {
      if (pass.text != passch.text) {
        Fluttertoast.showToast(
            msg: "Make sure the passwords are the same",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.purple[400],
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        na = name.text.substring(0, 1).toUpperCase() +
            name.text.substring(1, name.text.length).toLowerCase();
        FirebaseUser user;

        if (sp == null) {
          Fluttertoast.showToast(
              msg: "Choose specialization",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.purple[400],
              textColor: Colors.white,
              fontSize: 16.0);
          this.setState(() {
            _isloading = false;
          });
        } else {
          user = (await _auth.createUserWithEmailAndPassword(
                  email: email.text, password: pass.text))
              .user;

          if (user != null) {
            final QuerySnapshot result = await Firestore.instance
                .collection('Doctors')
                .where('npi', isEqualTo: npi.text)
                .getDocuments();
            final List<DocumentSnapshot> documents = result.documents;
            if (documents.length == 0) {
              Firestore.instance
                  .collection('Doctors')
                  .document(npi.text)
                  .setData({
                'Nickname': na,
                'Npi': npi.text,
                'Email-id': email.text,
                'Education': edu.text,
                'Board Certification': years.text,
                'Phone': phnum.text,
                'pushToken': null,
                'Hospital': hos.text,
                'Office number': offnum.text,
                'Fax no': faxnum.text,
                'AboutMe': abtme.text,
                'photoUrl': null,
                'Specialization': FieldValue.arrayUnion(sp.split(',')),
                'Emergency': 'false',
                'Asap': 'false',
                'Normal': 'true',
                'searchKey': '${na[0]}',
                'count': 0,
                'Coordinator': 'No',
                'cemail': 'Not added',
                'cname': 'Not added',
                'cnumber': 'Not added',
              });
              if (avatarImageFile != null) {
                String fileName = npi.text;
                StorageReference reference =
                    FirebaseStorage.instance.ref().child(fileName);
                StorageUploadTask uploadTask =
                    reference.putFile(avatarImageFile);
                StorageTaskSnapshot storageTaskSnapshot;
                uploadTask.onComplete.then((value) {
                  if (value.error == null) {
                    storageTaskSnapshot = value;
                    storageTaskSnapshot.ref
                        .getDownloadURL()
                        .then((downloadUrl) {
                      photoUrl = downloadUrl;
                      Firestore.instance
                          .collection('Doctors')
                          .document(npi.text)
                          .updateData({
                        'photoUrl': photoUrl,
                      });
                      FirebaseAuth.instance.currentUser().then((val) {
                        UserUpdateInfo updateUser = UserUpdateInfo();

                        updateUser.photoUrl = photoUrl;
                        val.updateProfile(updateUser);
                      });
                    });
                  }
                });
              }
              Fluttertoast.showToast(
                  msg: "Sign in successfull ",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.purple[400],
                  textColor: Colors.white,
                  fontSize: 16.0);
              FirebaseAuth.instance.currentUser().then((val) {
                UserUpdateInfo updateUser = UserUpdateInfo();

                updateUser.displayName = na;
                val.updateProfile(updateUser);
              });

              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Malog()));
              this.setState(() {
                _isloading = false;
              });
            }
          }
        }
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
          this.setState(() {
            _isloading = false;
          });
          break;

        case "ERROR_INVALID_EMAIL":
          Fluttertoast.showToast(
              msg: "Enter Valid E-mail",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.purple[400],
              textColor: Colors.white,
              fontSize: 16.0);
          this.setState(() {
            _isloading = false;
          });
          break;
        case "error":
          Fluttertoast.showToast(
              msg: "Enter Credentials",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.purple[400],
              textColor: Colors.white,
              fontSize: 16.0);
          this.setState(() {
            _isloading = false;
          });
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          Fluttertoast.showToast(
              msg: "Too many requests,Try later",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.purple[400],
              textColor: Colors.white,
              fontSize: 16.0);
          this.setState(() {
            _isloading = false;
          });
          break;
        case "ERROR_NETWORD_REQUEST_FAILED":
          Fluttertoast.showToast(
              msg: "Check Internet Connection",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.purple[400],
              textColor: Colors.white,
              fontSize: 16.0);
          this.setState(() {
            _isloading = false;
          });
          break;

        default:
          Fluttertoast.showToast(
              msg: "Check Internet Connection",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.purple[400],
              textColor: Colors.white,
              fontSize: 16.0);
          this.setState(() {
            _isloading = false;
          });
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

  void getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        avatarImageFile = image;
      });
    }
    uploadFile();
  }

  Future uploadFile() async {}

  void spe() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Specsa()));
  }

  void dept() {
    sp = null;
    gen = false;
    orth = false;
    pae = false;
    phy = false;
    uru = false;
    psy = false;
    gyn = false;
    nep = false;
    oto = false;
    rhe = false;
    car = false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: new Text("Reset password"),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  CheckboxListTile(
                      title: Text(
                        ("General Physician"),
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[400]),
                      ),
                      secondary: new Icon(Icons.local_hospital),
                      checkColor: Colors.white,
                      value: gen,
                      onChanged: (bool value) {
                        setState(() {
                          if (gen == false) {
                            gen = true;
                            if (sp == null) {
                              sp = "General Physicial";
                            } else {
                              sp = sp + ",General Physicial";
                            }
                          } else {
                            sp = sp.replaceAll("General Physicial", "");
                            gen = false;
                          }
                        });
                      }),
                  CheckboxListTile(
                      title: Text(
                        ("Orthopaedics"),
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[400]),
                      ),
                      secondary: new Icon(Icons.local_hospital),
                      value: orth,
                      onChanged: (bool value) {
                        setState(() {
                          if (orth == false) {
                            orth = true;
                            if (sp == null) {
                              sp = "Orthopaedics";
                            } else {
                              sp = sp + ",Orthopaedics";
                            }
                          } else {
                            sp = sp.replaceAll("Orthopaedics", "");
                            orth = false;
                          }
                        });
                      }),
                  CheckboxListTile(
                      title: Text(
                        ("Paediatrics"),
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[400]),
                      ),
                      secondary: new Icon(Icons.local_hospital),
                      value: pae,
                      onChanged: (bool value) {
                        setState(() {
                          if (pae == false) {
                            pae = true;
                            if (sp == null) {
                              sp = "Paediatrics";
                            } else {
                              sp = sp + ",Paediatrics";
                            }
                          } else {
                            sp = sp.replaceAll("Paediatrics", "");
                            pae = false;
                          }
                        });
                      }),
                  CheckboxListTile(
                      title: Text(
                        ("Physiology"),
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[400]),
                      ),
                      secondary: new Icon(Icons.local_hospital),
                      value: phy,
                      onChanged: (bool value) {
                        setState(() {
                          if (phy == false) {
                            phy = true;
                            if (sp == null) {
                              sp = "Physiology";
                            } else {
                              sp = sp + ",'Physiology";
                            }
                          } else {
                            sp = sp.replaceAll("Physiology", "");
                            phy = false;
                          }
                        });
                      }),
                  CheckboxListTile(
                      title: Text(
                        ("Urology"),
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[400]),
                      ),
                      secondary: new Icon(Icons.local_hospital),
                      value: uru,
                      onChanged: (bool value) {
                        setState(() {
                          if (uru == false) {
                            uru = true;
                            if (sp == null) {
                              sp = "Urology";
                            } else {
                              sp = sp + ",Urology";
                            }
                          } else {
                            sp = sp.replaceAll("Urology", "");
                            uru = false;
                          }
                        });
                      }),
                  CheckboxListTile(
                      title: Text(
                        ("Psychiatry"),
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[400]),
                      ),
                      secondary: new Icon(Icons.local_hospital),
                      value: psy,
                      onChanged: (bool value) {
                        setState(() {
                          if (psy == false) {
                            psy = true;
                            if (sp == null) {
                              sp = "Psychiatry";
                            } else {
                              sp = sp + ",Psychiatry";
                            }
                          } else {
                            sp = sp.replaceAll("Psychiatry", "");
                            psy = false;
                          }
                        });
                      }),
                  CheckboxListTile(
                      title: Text(
                        ("Gynaecology"),
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[400]),
                      ),
                      secondary: new Icon(Icons.local_hospital),
                      value: gyn,
                      onChanged: (bool value) {
                        setState(() {
                          if (gyn == false) {
                            gyn = true;
                            if (sp == null) {
                              sp = "Gynaecology";
                            } else {
                              sp = sp + ",Gynaecology";
                            }
                          } else {
                            sp = sp.replaceAll("Gynaecology", "");
                            gyn = false;
                          }
                        });
                      }),
                  CheckboxListTile(
                      title: Text(
                        ("Nephrology"),
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[400]),
                      ),
                      secondary: new Icon(Icons.local_hospital),
                      value: nep,
                      onChanged: (bool value) {
                        setState(() {
                          if (nep == false) {
                            nep = true;
                            if (sp == null) {
                              sp = "Nephrology";
                            } else {
                              sp = sp + ",Nephrology";
                            }
                          } else {
                            sp = sp.replaceAll("Nephrology", "");
                            nep = false;
                          }
                        });
                      }),
                  CheckboxListTile(
                      title: Text(
                        ("Otorhinolaryngology"),
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[400]),
                      ),
                      secondary: new Icon(Icons.local_hospital),
                      value: oto,
                      onChanged: (bool value) {
                        setState(() {
                          if (oto == false) {
                            oto = true;
                            if (sp == null) {
                              sp = "Otorhinolaryngology";
                            } else {
                              sp = sp + ",Otorhinolaryngology";
                            }
                          } else {
                            sp = sp.replaceAll("Otorhinolaryngology", "");
                            oto = false;
                          }
                        });
                      }),
                  CheckboxListTile(
                      title: Text(
                        ("Rheumatology"),
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[400]),
                      ),
                      secondary: new Icon(Icons.local_hospital),
                      value: rhe,
                      onChanged: (bool value) {
                        setState(() {
                          if (rhe == false) {
                            rhe = true;
                            if (sp == null) {
                              sp = "Rheumatology";
                            } else {
                              sp = sp + ",Rheumatology";
                            }
                          } else {
                            sp = sp.replaceAll("Rheumatology", "");
                            rhe = false;
                          }
                        });
                      }),
                  CheckboxListTile(
                      title: Text(
                        ("Cardiology"),
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[400]),
                      ),
                      secondary: new Icon(Icons.local_hospital),
                      value: car,
                      onChanged: (bool value) {
                        setState(() {
                          if (car == false) {
                            car = true;
                            if (sp == null) {
                              sp = "Cardiology";
                            } else {
                              sp = sp + ",Cardiology";
                            }
                          } else {
                            sp = sp.replaceAll("Cardiology", "");
                            car = false;
                          }
                        });
                      }),
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                children: <Widget>[
                  FlatButton(
                    child: new Text("Okay"),
                    onPressed: () async {
                      Fluttertoast.showToast(
                          msg: "Added " + sp,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.purple[400],
                          textColor: Colors.white,
                          fontSize: 16.0);
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: new Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            ],
          );
        });
      },
    );
  }
}
