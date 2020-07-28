import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_proj/Patient/patientlog.dart';
import 'package:flutter/services.dart';
import 'Home.dart';
import 'Signup.dart';
import 'package:final_proj/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Malog extends StatefulWidget {
  @override
  _MalogState createState() => _MalogState();
}

class _MalogState extends State<Malog> {
  FirebaseUser user;
  SharedPreferences prefs;
  bool _isloading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  var emaill = new TextEditingController();
  var pass = new TextEditingController();
  var res = new TextEditingController();
  bool _obscureText = true;
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
              height: 80,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "LOGIN",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Welcome Doctor !!!",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RaisedButton.icon(
                    onPressed: () {
                      Fluttertoast.showToast(
                          msg: "Long press to Login as Patient ",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.purple[400],
                          textColor: Colors.white,
                          fontSize: 16.0);
                    },
                    onLongPress: patient,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0))),
                    label: Text(
                      'Login as Patient',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    icon: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    textColor: Colors.white,
                    splashColor: Colors.red,
                    color: Colors.orange,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
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
                                padding: EdgeInsets.fromLTRB(15, 25, 20, 20),
                                child: new TextFormField(
                                  decoration: new InputDecoration(
                                    labelText: "E-MAIL ID",
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(25.0),
                                      borderSide: new BorderSide(),
                                    ),

                                    //fillColor: Colors.green
                                  ),
                                  controller: emaill,
                                  validator: (val) {
                                    if (val.length == 0) {
                                      return "Email cannot be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  style: new TextStyle(
                                    fontFamily: "Poppins",
                                  ),
                                ),
                              )),
                              Container(
                                padding: EdgeInsets.fromLTRB(15, 20, 20, 20),
                                child: new TextFormField(
                                  decoration: new InputDecoration(
                                    labelText: "PASSWORD ",
                                    fillColor: Colors.white,

                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(25.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    suffixIcon: IconButton(
                                        icon: Icon(
                                          // Based on passwordVisible state choose the icon
                                          _obscureText
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.grey,
                                        ),
                                        onPressed: _toggle),
                                    //fillColor: Colors.green
                                  ),
                                  validator: (val) {
                                    if (val.length == 0) {
                                      return "Password cannot be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: pass,
                                  obscureText: _obscureText,
                                  keyboardType: TextInputType.visiblePassword,
                                  style: new TextStyle(
                                    fontFamily: "Poppins",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        new GestureDetector(
                          onTap: forgot,
                          child: new Text(
                            ("Forgot Password?"),
                            style: new TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 50.0, right: 50.0),
                          child: (_isloading)
                              ? CircularProgressIndicator(
                                  backgroundColor: Colors.black,
                                  strokeWidth: 5,
                                )
                              : RaisedButton(
                                  padding:
                                      EdgeInsets.only(left: 80.0, right: 80.0),
                                  textColor: Colors.white,
                                  color: Colors.blue,
                                  child: Text(("Sign In"),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15.0)),
                                  onPressed: signin,
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(40.0),
                                      side: BorderSide(color: Colors.white)),
                                ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            padding: EdgeInsets.only(left: 50.0, right: 50.0),
                            child: Visibility(
                              visible: !_isloading,
                              child: RaisedButton(
                                padding:
                                    EdgeInsets.only(left: 80.0, right: 80.0),
                                textColor: Colors.white,
                                color: Colors.purple[400],
                                child: Text(("Sign Up"),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15.0)),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Signup()));
                                },
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(40.0),
                                    side: BorderSide(color: Colors.white)),
                              ),
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(height: 10),
                        Image.asset(
                          "images/VT.png",
                          width: 200,
                        ),
                        Text(
                          "© Vareitex Technology 2020 ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
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

  void signin() async {
    this.setState(() {
      _isloading = true;
    });
    try {
      prefs = await SharedPreferences.getInstance();
      user = (await _auth.signInWithEmailAndPassword(
              email: emaill.text, password: pass.text))
          .user;
      if (user != null) {
        final QuerySnapshot result = await Firestore.instance
            .collection('Doctors')
            .where('Email-id', isEqualTo: emaill.text)
            .getDocuments();
        final List<DocumentSnapshot> documents = result.documents;

        await prefs.setInt('status', 1);
        await prefs.setString('AboutMe', documents[0]['AboutMe']);
        await prefs.setString('id', documents[0]['Npi']);
        await prefs.setString('Email-id', documents[0]['Email-id']);
        await prefs.setString('Education', documents[0]['Education']);
        await prefs.setString(
            'Board Certification', documents[0]['Board Certification']);
        await prefs.setString('Hospital', documents[0]['Hospital']);
        await prefs.setString('Office number', documents[0]['Office number']);
        await prefs.setString('Phone', documents[0]['Phone']);
        await prefs.setString('Fax no', documents[0]['Fax no']);
        await prefs.setString('Nickname', documents[0]['Nickname']);
        await prefs.setString('photoUrl', documents[0]['photoUrl']);
        await prefs.setString('Emergency', documents[0]['Emergency']);
        await prefs.setString('Asap', documents[0]['Asap']);
        await prefs.setString('Normal', documents[0]['Normal']);

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Hom(
                      currentUserId: documents[0]['Npi'],
                    )));
        this.setState(() {
          _isloading = false;
        });
      }
    } on PlatformException catch (err) {
      switch (err.code) {
        case 'ERROR_USER_NOT_FOUND':
          Fluttertoast.showToast(
              msg: "E-mail not available",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.purple[400],
              textColor: Colors.white,
              fontSize: 16.0);
          this.setState(() {
            _isloading = false;
          });
          break;
        case "ERROR_WRONG_PASSWORD":
          Fluttertoast.showToast(
              msg: "Enter correct Password",
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

  void patient() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Patlog()));
  }

  void forgot() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Enter the E-mail Id to send Reset Password"),
          content: new TextFormField(
            decoration: new InputDecoration(
              labelText: "E-MAIL ID",
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(25.0),
                borderSide: new BorderSide(),
              ),
            ),
            validator: (val) {
              if (val.length == 0) {
                return "Email cannot be empty";
              } else {
                return null;
              }
            },
            controller: res,
            keyboardType: TextInputType.emailAddress,
          ),
          actions: <Widget>[
            Row(
              children: <Widget>[
                FlatButton(
                  child: new Text("Send Reset Password"),
                  onPressed: () async {
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: res.text);
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
      },
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
