import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'received.dart';
import 'package:final_proj/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:slider_button/slider_button.dart';

class Ack extends StatefulWidget {
  final String peerid;
  final String curid;
  final String doc;
  final FirebaseUser user;
  Ack(
      {Key key,
      @required this.peerid,
      @required this.curid,
      this.doc,
      this.user})
      : super(key: key);
  @override
  _AckState createState() =>
      _AckState(peerid: peerid, curid: curid, doc: doc, user: user);
}

class _AckState extends State<Ack> {
  _AckState(
      {Key key,
      @required this.peerid,
      @required this.curid,
      this.doc,
      this.user});
  final FirebaseUser user;

  String peerid;
  String curid;
  String doc;
  var re = new TextEditingController();
  String _date = "Not set";
  String _time = "Not set";
  bool ack = false;
  bool fck = true;
  bool isloading = false;
  String groupID;
  var tcVisibility = false;
  var acVisibility = false;
  var scvisibility = true;
  var dcvisibility = true;
  int count;
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
        title: Text('Patient Info',
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
                ' ${documents['patientname'] ?? 'Not available'}',
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
                                    ' ${documents['age'] ?? 'Not available'}',
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
                ' ${documents['medications'] ?? 'Not available'}',
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
              Text(
                ack ? "Acknowledged" : 'Not Acknowledged',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              Row(children: <Widget>[
                Container(
                  height: 40,
                  child: Visibility(
                    visible: dcvisibility,
                    child: RaisedButton(
                      elevation: 8,
                      textColor: Colors.white,
                      color: Colors.green[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.transparent),
                      ),
                      child: fck
                          ? Text(("Accept"),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35.0))
                          : Text((" cancel"),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35.0)),
                      onPressed: () {
                        setState(() {
                          ack = !ack;
                        });

                        setState(() {
                          fck = !fck;
                          if (acVisibility == false) {
                            acVisibility = true;
                            tcVisibility = false;
                            scvisibility = false;
                          } else {
                            acVisibility = false;
                            scvisibility = true;
                          }
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  height: 40,
                  child: Visibility(
                    visible: scvisibility,
                    child: RaisedButton(
                      elevation: 8,
                      textColor: Colors.white,
                      color: Colors.red[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.transparent),
                      ),
                      child: fck
                          ? Text(("Decline"),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35.0))
                          : Text((" cancel"),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35.0)),
                      onPressed: () {
                        setState(() {
                          fck = !fck;
                          if (tcVisibility == false) {
                            tcVisibility = true;
                            acVisibility = false;
                            dcvisibility = false;
                          } else {
                            tcVisibility = false;
                            dcvisibility = true;
                          }
                        });
                      },
                    ),
                  ),
                ),
              ]),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Visibility(
                  visible: tcVisibility,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(4, 0, 10, 20),
                    child: new TextFormField(
                      controller: re,
                      decoration: new InputDecoration(
                        labelText: "Reason if any",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
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
                ),
              ),
              Container(
                height: 50,
                child: Visibility(
                  visible: tcVisibility,
                  child: SliderButton(
                    height: 50,
                    width: 600,
                    action: () {
                      Firestore.instance
                          .collection("Doctors")
                          .document(curid)
                          .collection("inpatients")
                          .document('${documents['sugid']}')
                          .updateData({
                        'time completed': FieldValue.serverTimestamp(),
                        'status': 'declined',
                        'decline reason': re.text
                      });
                      Firestore.instance
                          .collection("Doctors")
                          .document('${documents['from']}')
                          .collection("outpatients")
                          .document('${documents['sugid']}')
                          .updateData({
                        'time completed': FieldValue.serverTimestamp(),
                        'status': 'declined',
                        'decline reason': re.text
                      });
                      Firestore.instance
                          .collection("Doctors")
                          .document(curid)
                          .updateData({
                        'count': FieldValue.increment(-1),
                      });
                      Firestore.instance
                          .collection("Patients")
                          .document('${documents['pid']}')
                          .collection("suggestions")
                          .document('${documents['sugid']}')
                          .updateData({
                        'time completed': FieldValue.serverTimestamp(),
                        'status': 'declined',
                        'decline reason': re.text
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Rec(
                                    doc: doc,
                                    iid: curid,
                                    user: user,
                                  )));
                    },
                    label: Text(
                      "Slide to Decline",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                    icon: Text(
                      "-",
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
                    buttonColor: Colors.green[400],
                    backgroundColor: Colors.red[400],
                    highlightedColor: Colors.white,
                    baseColor: Colors.black,
                  ),
                ),
              ),
              Visibility(
                visible: acVisibility,
                child: Text(
                  "Choose a date to review the patient",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple[400]),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Visibility(
                visible: acVisibility,
                child: RaisedButton(
                  color: Colors.blue,
                  elevation: 7.0,
                  splashColor: Colors.blue,
                  colorBrightness: Brightness.dark,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.transparent),
                  ),
                  onPressed: () {
                    DatePicker.showDatePicker(context,
                        theme: DatePickerTheme(
                          containerHeight: 300.0,
                          headerColor: Colors.blue[100],
                        ),
                        showTitleActions: true,
                        minTime: DateTime(2000, 1, 1),
                        maxTime: DateTime(2050, 12, 31), onConfirm: (date) {
                      print('confirm $date');
                      _date = '${date.year} - ${date.month} - ${date.day}';
                      setState(() {});
                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.date_range,
                                    size: 18.0,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    " $_date",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Text(
                          "  Choose date",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Visibility(
                visible: acVisibility,
                child: Text(
                  "Choose a Time to review the patient",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Visibility(
                visible: acVisibility,
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
                    DatePicker.showTimePicker(context,
                        theme: DatePickerTheme(
                            containerHeight: 300.0,
                            headerColor: Colors.purple[100]),
                        showTitleActions: true, onConfirm: (time) {
                      print('confirm $time');
                      _time = '${time.hour} : ${time.minute} : ${time.second}';
                      setState(() {});
                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                    setState(() {});
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.access_time,
                                    size: 18.0,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    " $_time",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Text(
                          "  Choose Time",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left: 20.0),
              ),
              SizedBox(
                height: 10,
              ),
              Visibility(
                  visible: acVisibility,
                  child: Container(
                    padding: EdgeInsets.only(left: 80.0, right: 50.0),
                    child: (!isloading)
                        ? RaisedButton(
                            padding: EdgeInsets.only(left: 20.0, right: 20.0),
                            elevation: 8,
                            textColor: Colors.white,
                            color: Colors.purple[400],
                            child: Text(("Acknowledge"),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0)),
                            onPressed: () {
                              if (ack &&
                                  _date == 'Not set' &&
                                  _time == 'Not set') {
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
                              } else if (ack &&
                                  _date != 'Not set' &&
                                  _time != 'Not set') {
                                this.setState(() {
                                  isloading = true;
                                });
                                Firestore.instance
                                    .collection('Doctors')
                                    .document(curid)
                                    .collection("inpatients")
                                    .document('${documents['sugid']}')
                                    .updateData({
                                  'status': 'received',
                                  'scheduled-date': _date,
                                  'scheduled-time': _time,
                                });
                                Firestore.instance
                                    .collection('Doctors')
                                    .document('${documents['from']}')
                                    .collection("outpatients")
                                    .document('${documents['sugid']}')
                                    .updateData({
                                  'status': 'received',
                                  'scheduled-date': _date,
                                  'scheduled-time': _time
                                });

                                Firestore.instance
                                    .collection("Patients")
                                    .document('${documents['pid']}')
                                    .collection("suggestions")
                                    .document('${documents['sugid']}')
                                    .updateData({
                                  'status': 'received',
                                  'scheduled-date': _date,
                                  'scheduled-time': _time
                                });
                                groupID = curid + '${documents['pid']}';
                                Firestore.instance
                                    .collection("appointment")
                                    .document(groupID)
                                    .collection(groupID)
                                    .document('${documents['sugid']}')
                                    .setData({
                                  'idFrom': curid,
                                  'idTo': '${documents['pid']}',
                                  'timestamp': DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString(),
                                });
                                Firestore.instance
                                    .collection("notifications")
                                    .document('${documents['from']}' + curid)
                                    .collection('${documents['from']}' + curid)
                                    .document('${documents['sugid']}')
                                    .delete();

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
                              }
                            },
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                                side: BorderSide(color: Colors.purple[400])),
                          )
                        : LinearProgressIndicator(
                            backgroundColor: Colors.black,
                          ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
