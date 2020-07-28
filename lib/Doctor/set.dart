import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:final_proj/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Home.dart';

class Setting extends StatefulWidget {
  final String currentUserId;
  FirebaseUser user;
  final bool lov;

  Setting({Key key, this.currentUserId, this.user, this.lov}) : super(key: key);
  @override
  _SettingState createState() => _SettingState(lov: lov);
}

class Specs {
  int id;
  String name;

  Specs(
    this.id,
    this.name,
  );

  static List<Specs> getSpecs() {
    return <Specs>[
      Specs(1, 'Choose your specialization'),
      Specs(2, 'General Physicial'),
      Specs(3, 'Orthopaedics'),
      Specs(4, 'Paediatrics'),
      Specs(5, 'Physiology'),
      Specs(6, 'Urology'),
      Specs(7, 'Psychiatry'),
      Specs(8, 'Gynaecology'),
      Specs(9, 'Nephrology'),
      Specs(10, 'Otorhinolaryngology'),
      Specs(11, 'Rheumatology'),
      Specs(12, 'Cardiology')
    ];
  }
}

class _SettingState extends State<Setting> {
  _SettingState({Key key, this.lov});

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

  int selectedradio;
  String na;
  String currentUserId;
  FirebaseUser user;
  TextEditingController controllerspez;
  TextEditingController controllerNickname;
  TextEditingController controllerAboutMe;
  TextEditingController controllerhospital;
  TextEditingController controllerboard;
  TextEditingController controlleroffice;
  TextEditingController controllerNPI;
  TextEditingController controllerFax;
  TextEditingController controlleredu;
  TextEditingController controlleremer;
  TextEditingController controllerasap;
  TextEditingController controllernor;
  TextEditingController controllerema;
  TextEditingController controllerpho;
  bool lov;
  SharedPreferences prefs;
  List dept;
  String id = '';
  String board = '';
  String nickname = '';
  String aboutMe = '';
  String photoUrl = '';
  String hospital = '';
  String years = '';
  String specs = '';
  String fax = '';
  String edu = '';
  String ema = '';
  String pho = '';
  String off = '';
  String npi = '';
  String emer = '';
  String asa = '';
  String normal = '';
  String del;
  bool isLoading = false;
  File avatarImageFile;
  String str;
  final FocusNode focusNodeNickname = new FocusNode();
  final FocusNode focusNodeAboutMe = new FocusNode();
  final FocusNode focusNodehospital = new FocusNode();
  final FocusNode focusNodeboard = new FocusNode();
  final FocusNode focusNodespecs = new FocusNode();
  final FocusNode focusNodeedu = new FocusNode();
  final FocusNode focusNodefaxa = new FocusNode();
  final FocusNode focusNodeoff = new FocusNode();
  final FocusNode focusNodeema = new FocusNode();
  final FocusNode focusNodenpi = new FocusNode();
  final FocusNode focusNodepho = new FocusNode();

  @override
  void initState() {
    selectedradio = 0;
    super.initState();
    readLocal();
  }

  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id') ?? '';
    board = prefs.getString('Board Certification') ?? '';
    nickname = prefs.getString('Nickname') ?? '';
    aboutMe = prefs.getString('AboutMe') ?? '';
    photoUrl = prefs.getString('photoUrl') ?? '';
    hospital = prefs.getString('Hospital') ?? '';
    edu = prefs.getString('Education') ?? '';
    fax = prefs.getString('Fax no') ?? '';
    off = prefs.getString('Office number') ?? '';
    ema = prefs.getString('Email-id') ?? '';
    emer = prefs.getString('Emergency') ?? '';
    asa = prefs.getString('Asap') ?? '';
    normal = prefs.getString('Normal') ?? '';
    pho = prefs.getString('Phone') ?? '';
    DocumentReference documentReference =
        Firestore.instance.collection("Doctors").document(id);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    dept = documentSnapshot.data['Specialization'];
    str = dept.toString().replaceAll('[', '').replaceAll(']', '');

    controllerNickname = new TextEditingController(text: nickname);
    controllerAboutMe = new TextEditingController(text: aboutMe);
    controllerhospital = new TextEditingController(text: hospital);
    controllerboard = new TextEditingController(text: board);
    controlleredu = new TextEditingController(text: edu);
    controllerFax = new TextEditingController(text: fax);
    controllerpho = new TextEditingController(text: pho);
    controlleroffice = new TextEditingController(text: off);
    controllerNPI = new TextEditingController(text: id);
    controllerema = new TextEditingController(text: ema);
    controlleremer = new TextEditingController(text: emer);
    controllerasap = new TextEditingController(text: asa);
    controllernor = new TextEditingController(text: normal);
    if (emer == 'true') {
      setSelectedRadio(3);
    }
    if (asa == 'true') {
      setSelectedRadio(2);
    }
    if (normal == 'true') {
      setSelectedRadio(1);
    }

    setState(() {});
  }

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        avatarImageFile = image;
        isLoading = true;
      });
    }
    uploadFile();
  }

  Future uploadFile() async {
    String fileName = id;
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(avatarImageFile);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          photoUrl = downloadUrl;

          Firestore.instance.collection('Doctors').document(id).updateData({
            'Nickname': nickname,
            'AboutMe': aboutMe,
            'photoUrl': photoUrl,
            'Hospital': hospital,
            'Board Certification': board,
            'Education': edu,
            'Office number': off,
            'Phone': pho,
            'Fax no': fax,
            'Npi': id,
            'Email-id': ema,
            'Emergency': emer,
            'Asap': asa,
            'Normal': normal,
          }).then((data) async {
            await prefs.setString('photoUrl', photoUrl);
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: "Upload success");
          }).catchError((err) {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: err.toString());
          });
        }, onError: (err) {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: 'This file is not an image');
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: 'This file is not an image');
      }
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: err.toString());
    });
  }

  void handleUpdateData() {
    String na = controllerNickname.text.substring(0, 1).toUpperCase() +
        controllerNickname.text
            .substring(1, controllerNickname.text.length)
            .toLowerCase();

    focusNodeNickname.unfocus();
    focusNodeAboutMe.unfocus();

    setState(() {
      isLoading = true;
    });
    Firestore.instance.collection('Doctors').document(id).updateData({
      'Nickname': na,
      'AboutMe': aboutMe,
      'photoUrl': photoUrl,
      'Hospital': hospital,
      'Board Certification': board,
      'Education': edu,
      'Office number': off,
      'Phone': pho,
      'Fax no': fax,
      'Npi': id,
      'Email-id': ema,
      'Emergency': emer,
      'Asap': asa,
      'Normal': normal,
      'searchKey': '${na[0]}',
    }).then((data) async {
      await prefs.setString('Nickname', na);
      await prefs.setString('AboutMe', aboutMe);
      await prefs.setString('photoUrl', photoUrl);
      await prefs.setString('Hospital', hospital);
      await prefs.setString('Board Certification', board);
      await prefs.setString('Education', edu);
      await prefs.setString('Office number', off);
      await prefs.setString('Phone', pho);
      await prefs.setString('Fax no', fax);
      await prefs.setString('Npi', id);
      await prefs.setString('Email-id', ema);
      await prefs.setString('Emergency', emer);
      await prefs.setString('Asap', asa);
      await prefs.setString('Normal', normal);
      QuerySnapshot querySnapshot = await Firestore.instance
          .collection("Doctors")
          .where('fav', arrayContains: id)
          .getDocuments();
      List<DocumentSnapshot> documents = querySnapshot.documents;
      int length = documents.length;
      for (int i = 0; i < length; i++) {
        Firestore.instance
            .collection("Doctors")
            .document(documents[i]['Npi'])
            .collection("fav")
            .document(id)
            .updateData({'Name': na});
      }

      setState(() {
        isLoading = false;
      });
      FirebaseAuth.instance.currentUser().then((val) {
        UserUpdateInfo updateUser = UserUpdateInfo();
        updateUser.displayName = na;
        val.updateProfile(updateUser);
        updateUser.photoUrl = photoUrl;
        val.updateProfile(updateUser);
      });
      Fluttertoast.showToast(msg: "Update success");
    }).catchError((err) {
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: err.toString());
    });

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Hom(currentUserId: currentUserId)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Hom()));
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
            Row(children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(25.0, 0.0, 0.0, 10.0),
                child: Stack(
                  children: <Widget>[
                    (avatarImageFile == null)
                        ? (photoUrl != ''
                            ? Material(
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                    width: 120.0,
                                    height: 120.0,
                                    padding: EdgeInsets.all(20.0),
                                  ),
                                  imageUrl: photoUrl,
                                  width: 120.0,
                                  height: 120.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(60.0)),
                                clipBehavior: Clip.hardEdge,
                              )
                            : Icon(
                                Icons.account_circle,
                                size: 120.0,
                                color: Colors.white,
                              ))
                        : Material(
                            child: Image.file(
                              avatarImageFile,
                              width: 120.0,
                              height: 120.0,
                              fit: BoxFit.cover,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(45.0)),
                            clipBehavior: Clip.hardEdge,
                          ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              RaisedButton.icon(
                onPressed: lov ? getImage : null,
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
              SizedBox(
                height: 10,
              ),
            ]),
            Expanded(
              child: Container(
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
                        Text(
                          ("Specialisation"),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        FittedBox(
                          child: Container(
                            height: 100,
                            width: 450,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(35.0),
                            ),
                            child: Align(
                                alignment: Alignment.topCenter,
                                child: (str != null)
                                    ? Text(
                                        str,
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : Text('loading')),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 35.0, right: 10.0),
                            child: RaisedButton.icon(
                              onPressed: lov ? hi : null,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0))),
                              label: Text(
                                'Add ',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 21),
                              ),
                              icon: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              textColor: Colors.white,
                              splashColor: Colors.redAccent,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            child: RaisedButton.icon(
                              onPressed: lov ? bye : null,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0))),
                              label: Text(
                                'Remove ',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 21),
                              ),
                              icon: Icon(
                                Icons.remove,
                                color: Colors.white,
                              ),
                              textColor: Colors.white,
                              splashColor: Colors.green,
                              color: Colors.redAccent,
                            ),
                          ),
                        ]),
                        SizedBox(height: 20),
                        Container(
                          child: Column(
                            children: <Widget>[
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
                                  enabled: lov,
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
                                    labelText: "NPI Number",
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(25.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                  controller: controllerNPI,
                                  enabled: lov,
                                  onChanged: (value) {
                                    id = value;
                                  },
                                  focusNode: focusNodenpi,
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
                                padding: EdgeInsets.fromLTRB(4, 0, 10, 20),
                                child: new TextFormField(
                                  decoration: new InputDecoration(
                                    labelText: "Education",
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(25.0),
                                      borderSide: new BorderSide(),
                                    ),
                                  ),
                                  controller: controlleredu,
                                  enabled: lov,
                                  onChanged: (value) {
                                    edu = value;
                                  },
                                  focusNode: focusNodeedu,
                                  validator: (val) {
                                    if (val.length == 0) {
                                      return "Degree cannot be empty";
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
                                        decoration: new InputDecoration(
                                          labelText: "Office Number",
                                          fillColor: Colors.white,
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.circular(25.0),
                                            borderSide: new BorderSide(),
                                          ),
                                        ),
                                        controller: controlleroffice,
                                        enabled: lov,
                                        onChanged: (value) {
                                          off = value;
                                        },
                                        focusNode: focusNodeoff,
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
                                        decoration: new InputDecoration(
                                          labelText: "Fax Number",
                                          fillColor: Colors.white,
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.circular(25.0),
                                            borderSide: new BorderSide(),
                                          ),
                                        ),
                                        controller: controllerFax,
                                        enabled: lov,
                                        onChanged: (value) {
                                          fax = value;
                                        },
                                        focusNode: focusNodefaxa,
                                        validator: (val) {
                                          if (val.length == 0) {
                                            return "Fax Number cannot be empty";
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
                                  decoration: new InputDecoration(
                                    labelText: "Board Certification",
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(25.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                  onChanged: (value) {
                                    board = value;
                                  },
                                  controller: controllerboard,
                                  enabled: lov,
                                  validator: (val) {
                                    if (val.length == 0) {
                                      return "Board cannot be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                  focusNode: focusNodeboard,
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
                                    labelText: "Hospital Currently Working",
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(25.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                  controller: controllerhospital,
                                  enabled: lov,
                                  onChanged: (value) {
                                    hospital = value;
                                  },
                                  focusNode: focusNodehospital,
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
                                  enabled: lov,
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
                                  keyboardType: TextInputType.emailAddress,
                                  style: new TextStyle(
                                    fontFamily: "Poppins",
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(4, 0, 10, 20),
                                child: new TextFormField(
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
                                  controller: controllerpho,
                                  enabled: lov,
                                  onChanged: (value) {
                                    pho = value;
                                  },
                                  focusNode: focusNodepho,
                                  validator: (val) {
                                    if (val.length == 0) {
                                      return "phone Number cannot be empty";
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
                                  controller: controllerAboutMe,
                                  enabled: lov,
                                  onChanged: (value) {
                                    aboutMe = value;
                                  },
                                  focusNode: focusNodeAboutMe,
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
                              Column(
                                children: <Widget>[
                                  RadioListTile(
                                      value: 1,
                                      groupValue: selectedradio,
                                      title: Text(('Normal'),
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              color: Colors.blue[300],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0)),
                                      activeColor: Colors.blue,
                                      onChanged: lov
                                          ? (val) {
                                              emer = 'false';
                                              asa = 'false';
                                              normal = 'true';
                                              setSelectedRadio(val);
                                            }
                                          : null),
                                  RadioListTile(
                                      value: 2,
                                      groupValue: selectedradio,
                                      title: Text(('Asap'),
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              color: Colors.blue[700],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0)),
                                      activeColor: Colors.blue,
                                      onChanged: lov
                                          ? (val) {
                                              emer = 'false';
                                              asa = 'true';
                                              normal = 'false';
                                              setSelectedRadio(val);
                                            }
                                          : null),
                                  RadioListTile(
                                      value: 3,
                                      groupValue: selectedradio,
                                      title: Text(('Emergency'),
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              color: Colors.blue[900],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0)),
                                      activeColor: Colors.blue,
                                      onChanged: lov
                                          ? (val) {
                                              emer = 'true';
                                              asa = 'false';
                                              normal = 'false';
                                              setSelectedRadio(val);
                                            }
                                          : null),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 50.0, right: 50.0),
                          child: RaisedButton(
                            padding: EdgeInsets.only(left: 25.0, right: 25.0),
                            textColor: Colors.white,
                            color: Colors.blue,
                            child: Text(("Update"),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.0)),
                            onPressed: lov ? handleUpdateData : null,
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
            lov = !lov;
          });
        },
        elevation: 10,
        label: Text('Edit'),
        icon: Icon(Icons.edit),
        backgroundColor: Colors.green,
      ),
    );
  }

  void setSelectedRadio(val) {
    setState(() {
      selectedradio = val;
    });
  }

  void hi() async {
    sp = null;
    DocumentReference documentReference =
        Firestore.instance.collection("Doctors").document(id);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    dept = documentSnapshot.data['Specialization'];
    if (dept.contains('General Physicial')) {
      setState(() {
        gen = true;

        if (sp == null) {
          sp = 'General Physicial';
        } else {
          sp = sp + ',General Physicial';
        }
      });
    } else {
      setState(() {
        gen = false;
      });
    }
    if (dept.contains('Orthopaedics')) {
      setState(() {
        orth = true;

        if (sp == null) {
          sp = 'Orthopaedics';
        } else {
          sp = sp + ',Orthopaedics';
        }
      });
    } else {
      setState(() {
        orth = false;
      });
    }
    if (dept.contains('Paediatrics')) {
      setState(() {
        pae = true;

        if (sp == null) {
          sp = 'Paediatrics';
        } else {
          sp = sp + ',Paediatrics';
        }
      });
    } else {
      setState(() {
        pae = false;
      });
    }
    if (dept.contains('Physiology')) {
      setState(() {
        phy = true;

        if (sp == null) {
          sp = 'Physiology';
        } else {
          sp = sp + ',Physiology';
        }
      });
    } else {
      setState(() {
        phy = false;
      });
    }
    if (dept.contains('Urology')) {
      setState(() {
        uru = true;

        if (sp == null) {
          sp = 'Urology';
        } else {
          sp = sp + ',Urology';
        }
      });
    } else {
      setState(() {
        uru = false;
      });
    }
    if (dept.contains('Psychiatry')) {
      setState(() {
        psy = true;

        if (sp == null) {
          sp = 'Psychiatry';
        } else {
          sp = sp + ',Psychiatry';
        }
      });
    } else {
      setState(() {
        psy = false;
      });
    }
    if (dept.contains('Gynaecology')) {
      setState(() {
        gyn = true;

        if (sp == null) {
          sp = 'Gynaecology';
        } else {
          sp = sp + ',Gynaecology';
        }
      });
    } else {
      setState(() {
        gyn = false;
      });
    }
    if (dept.contains('Nephrology')) {
      setState(() {
        nep = true;

        if (sp == null) {
          sp = 'Nephrology';
        } else {
          sp = sp + ',Nephrology';
        }
      });
    } else {
      setState(() {
        nep = false;
      });
    }
    if (dept.contains('Otorhinolaryngology')) {
      setState(() {
        oto = true;

        if (sp == null) {
          sp = 'Otorhinolaryngology';
        } else {
          sp = sp + ',Otorhinolaryngology';
        }
      });
    } else {
      setState(() {
        oto = false;
      });
    }
    if (dept.contains('Rheumatology')) {
      setState(() {
        rhe = true;

        if (sp == null) {
          sp = 'Rheumatology';
        } else {
          sp = sp + ',Rheumatology';
        }
      });
    } else {
      setState(() {
        rhe = false;
      });
    }
    if (dept.contains('Cardiology')) {
      setState(() {
        car = true;

        if (sp == null) {
          sp = 'Cardiology';
        } else {
          sp = sp + ',Cardiology';
        }
      });
    } else {
      setState(() {
        car = false;
      });
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: new Text("Add Specialisation"),
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
                            sp = sp.replaceAll(",General Physicial", "");
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
                            sp = sp.replaceAll(",Orthopaedics", "");
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
                            sp = sp.replaceAll(",Paediatrics", "");
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
                              sp = sp + ",Physiology";
                            }
                          } else {
                            sp = sp.replaceAll(",Physiology", "");
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
                            sp = sp.replaceAll(",Urology", "");
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
                            sp = sp.replaceAll(",Psychiatry", "");
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
                            sp = sp.replaceAll(",Gynaecology", "");
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
                            sp = sp.replaceAll(",Nephrology", "");
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
                            sp = sp.replaceAll(",Otorhinolaryngology", "");
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
                            sp = sp.replaceAll(",Rheumatology", "");
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
                            sp = sp.replaceAll(",Cardiology", "");
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
                      Firestore.instance
                          .collection("Doctors")
                          .document(id)
                          .updateData({
                        'Specialization': FieldValue.arrayUnion(sp.split(','))
                      });
                      DocumentSnapshot documentSnapshot = await Firestore
                          .instance
                          .collection("Doctors")
                          .document(id)
                          .get();
                      str = null;
                      setState(() {
                        dept = documentSnapshot.data['Specialization'];
                        str = dept.toString();
                      });

                      Fluttertoast.showToast(
                          msg: sp,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.purple[400],
                          textColor: Colors.white,
                          fontSize: 16.0);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Setting(
                                    currentUserId: currentUserId,
                                    user: user,
                                    lov: true,
                                  )));
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

  void bye() async {
    sp = null;
    DocumentReference documentReference =
        Firestore.instance.collection("Doctors").document(id);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    dept = documentSnapshot.data['Specialization'];
    if (dept.contains('General Physicial')) {
      setState(() {
        gen = true;

        if (sp == null) {
          sp = 'General Physicial';
        } else {
          sp = sp + ',General Physicial';
        }
      });
    } else {
      setState(() {
        gen = false;
      });
    }
    if (dept.contains('Orthopaedics')) {
      setState(() {
        orth = true;

        if (sp == null) {
          sp = 'Orthopaedics';
        } else {
          sp = sp + ',Orthopaedics';
        }
      });
    } else {
      setState(() {
        orth = false;
      });
    }
    if (dept.contains('Paediatrics')) {
      setState(() {
        pae = true;

        if (sp == null) {
          sp = 'Paediatrics';
        } else {
          sp = sp + ',Paediatrics';
        }
      });
    } else {
      setState(() {
        pae = false;
      });
    }
    if (dept.contains('Physiology')) {
      setState(() {
        phy = true;

        if (sp == null) {
          sp = 'Physiology';
        } else {
          sp = sp + ',Physiology';
        }
      });
    } else {
      setState(() {
        phy = false;
      });
    }
    if (dept.contains('Urology')) {
      setState(() {
        uru = true;

        if (sp == null) {
          sp = 'Urology';
        } else {
          sp = sp + ',Urology';
        }
      });
    } else {
      setState(() {
        uru = false;
      });
    }
    if (dept.contains('Psychiatry')) {
      setState(() {
        psy = true;

        if (sp == null) {
          sp = 'Psychiatry';
        } else {
          sp = sp + ',Psychiatry';
        }
      });
    } else {
      setState(() {
        psy = false;
      });
    }
    if (dept.contains('Gynaecology')) {
      setState(() {
        gyn = true;

        if (sp == null) {
          sp = 'Gynaecology';
        } else {
          sp = sp + ',Gynaecology';
        }
      });
    } else {
      setState(() {
        gyn = false;
      });
    }
    if (dept.contains('Nephrology')) {
      setState(() {
        nep = true;

        if (sp == null) {
          sp = 'Nephrology';
        } else {
          sp = sp + ',Nephrology';
        }
      });
    } else {
      setState(() {
        nep = false;
      });
    }
    if (dept.contains('Otorhinolaryngology')) {
      setState(() {
        oto = true;

        if (sp == null) {
          sp = 'Otorhinolaryngology';
        } else {
          sp = sp + ',Otorhinolaryngology';
        }
      });
    } else {
      setState(() {
        oto = false;
      });
    }
    if (dept.contains('Rheumatology')) {
      setState(() {
        rhe = true;

        if (sp == null) {
          sp = 'Rheumatology';
        } else {
          sp = sp + ',Rheumatology';
        }
      });
    } else {
      setState(() {
        rhe = false;
      });
    }
    if (dept.contains('Cardiology')) {
      setState(() {
        car = true;

        if (sp == null) {
          sp = 'Cardiology';
        } else {
          sp = sp + ',Cardiology';
        }
      });
    } else {
      setState(() {
        car = false;
      });
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: new Text("Remove Specialisation"),
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
                          } else {
                            if (del == null) {
                              del = 'General Physicial';
                            } else {
                              del = del + ',General Physicial';
                            }

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
                          } else {
                            if (del == null) {
                              del = 'Orthopaedics';
                            } else {
                              del = del + ',Orthopaedics';
                            }

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
                          } else {
                            if (del == null) {
                              del = 'Paediatrics';
                            } else {
                              del = del + ',Paediatrics';
                            }

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
                          } else {
                            if (del == null) {
                              del = 'Physiology';
                            } else {
                              del = del + ',Physiology';
                            }

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
                          } else {
                            if (del == null) {
                              del = 'Urology';
                            } else {
                              del = del + ',Urology';
                            }

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
                          } else {
                            if (del == null) {
                              del = 'Psychiatry';
                            } else {
                              del = del + ',Psychiatry';
                            }

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
                          } else {
                            if (del == null) {
                              del = 'Gynaecology';
                            } else {
                              del = del + ',Gynaecology';
                            }

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
                          } else {
                            if (del == null) {
                              del = 'Nephrology';
                            } else {
                              del = del + ',Nephrology';
                            }

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
                          } else {
                            if (del == null) {
                              del = 'Otorhinolaryngology';
                            } else {
                              del = del + ',Otorhinolaryngology';
                            }

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
                          } else {
                            if (del == null) {
                              del = 'Rheumatology';
                            } else {
                              del = del + ',Rheumatology';
                            }

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
                          } else {
                            if (del == null) {
                              del = 'Cardiology';
                            } else {
                              del = del + ',Cardiology';
                            }

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
                      Firestore.instance
                          .collection("Doctors")
                          .document(id)
                          .updateData({
                        'Specialization': FieldValue.arrayRemove(del.split(','))
                      });
                      DocumentSnapshot documentSnapshot = await Firestore
                          .instance
                          .collection("Doctors")
                          .document(id)
                          .get();
                      str = null;
                      setState(() {
                        dept = documentSnapshot.data['Specialization'];
                        str = dept.toString();
                      });

                      Fluttertoast.showToast(
                          msg: del,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.purple[400],
                          textColor: Colors.white,
                          fontSize: 16.0);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Setting(
                                    currentUserId: currentUserId,
                                    user: user,
                                    lov: true,
                                  )));
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
