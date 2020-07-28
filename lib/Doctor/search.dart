import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_proj/Doctor/details.dart';
import 'package:final_proj/Doctor/docdetail.dart';
import 'package:final_proj/service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'Favourites.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Sear extends StatefulWidget {
  final String iid;
  final FirebaseUser user;
  Sear({Key key, @required this.iid, @required this.user}) : super(key: key);
  @override
  _SearState createState() => _SearState(iid: iid, user: user);
}

class _SearState extends State<Sear> {
  _SearState({Key key, @required this.iid, @required this.user});
  FirebaseUser user;
  String iid;
  List fav;
  DocumentReference documentReference;
  DocumentSnapshot documentSnapshot;
  var queryResultSet = [];
  var tempSearchStore = [];
  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          queryResultSet.add(docs.documents[i].data);
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['Nickname'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
              Navigator.pop(context);
            },
          ),
          title: Text('Search Doctors',
              style: TextStyle(
                  fontFamily: 'Varela',
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.black)),
        ),
        body: ListView(children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, top: 20, right: 10),
            child: TextField(
              cursorColor: Colors.black,
              onChanged: (val) {
                initiateSearch(val);
              },
              decoration: InputDecoration(
                  labelText: "Search",
                  hintText: ("Search"),
                  labelStyle: TextStyle(color: Colors.black),
                  hintStyle: TextStyle(color: Colors.black),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            ),
          ),
          SizedBox(height: 10.0),
          GridView.count(
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
              childAspectRatio: 28.0 / 9.0,
              crossAxisCount: 1,
              primary: false,
              shrinkWrap: true,
              children: tempSearchStore.map((element) {
                return buildResultCard(element, context, user);
              }).toList())
        ]));
  }

  Widget buildResultCard(data, BuildContext context, FirebaseUser user) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 5.0,
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
            Material(
              child: data['photoUrl'] != null
                  ? CachedNetworkImage(
                      placeholder: (context, url) => Container(
                        child: CircularProgressIndicator(
                          strokeWidth: 1.0,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                        width: 70.0,
                        height: 70.0,
                        padding: EdgeInsets.all(15.0),
                      ),
                      imageUrl: data['photoUrl'],
                      width: 70.0,
                      height: 70.0,
                      fit: BoxFit.cover,
                    )
                  : Icon(
                      Icons.account_circle,
                      size: 70.0,
                      color: Colors.blue,
                    ),
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              clipBehavior: Clip.hardEdge,
            ),
            Flexible(
              child: Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    Container(
                      child: Text(
                        'Dr: ${data['Nickname'] ?? 'Not Available'}',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(25.0, 0.0, 0.0, 5.0),
                    ),
                    SizedBox(height: 5),
                    Container(
                      child: Text(
                        'Specialisation: ${data['Specialization'] ?? 'Not available'}'
                            .replaceAll('[', "")
                            .replaceAll(']', ""),
                        style: TextStyle(color: Colors.white),
                      ),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(25.0, 0.0, 0.0, 0.0),
                    ),
                  ],
                ),
                margin: EdgeInsets.only(left: 20.0),
              ),
            ),
            Column(children: <Widget>[
              Ink(
                decoration: const ShapeDecoration(
                  color: Colors.transparent,
                  shape: CircleBorder(),
                ),
                child: FutureBuilder<dynamic>(
                  future: solu('${data['Nickname']}'),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.data == true) {
                      return StatefulBuilder(builder: (context, setState) {
                        return IconButton(
                          icon: Icon(Icons.star_border),
                          color: Colors.yellowAccent,
                          onPressed: () {
                            documentReference.updateData({
                              'Fav': FieldValue.arrayRemove(['${data['Nickname']}'])
                            });
                            Firestore.instance
                                .collection("Doctors")
                                .document(iid)
                                .collection("fav")
                                .document('${data['Npi']}')
                                .delete();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Sear(
                                          iid: iid,
                                          user: user,
                                        )));
                            Fluttertoast.showToast(
                                msg:
                                    'Dr.${data['Nickname']} Removed from Favorites',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          },
                        );
                      });
                    } else {
                      return StatefulBuilder(builder: (context, setState) {
                        return IconButton(
                          icon: Icon(Icons.star_border),
                          color: Colors.black,
                          onPressed: () {
                            Firestore.instance
                                .collection("Doctors")
                                .document(iid)
                                .collection("fav")
                                .document('${data['Npi']}')
                                .setData(
                                    {'Name': '${data['Nickname']}', 'count': 5});
                            documentReference.updateData({
                              'Fav': FieldValue.arrayUnion(['${data['Nickname']}'])
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Sear(
                                          iid: iid,
                                          user: user,
                                        )));

                            Fluttertoast.showToast(
                                msg: 'Dr.${data['Nickname']} Added to Favorites',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          },
                        );
                      });
                    }
                  },
                ),
              ),
              Ink(
                decoration: const ShapeDecoration(
                  color: Colors.transparent,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.navigate_next,
                  ),
                  iconSize: 25,
                  color: Colors.white,
                  splashColor: Colors.white,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Details(
                                  peerId: data['Npi'],
                                  nam: data['Nickname'],
                                  user: user,
                                )));
                  },
                ),
              ),
            ]),
          ],
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Doc(peerid: data['Npi'], user: user, name: data['Nickname'])));
        },
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      margin: EdgeInsets.only(bottom: 8.0, left: 5.0, right: 5.0),
    );
  }

  solu(event) async {
    documentReference = Firestore.instance.collection("Doctors").document(iid);
    documentSnapshot = await documentReference.get();
    fav = documentSnapshot.data['Fav'];
    if (fav.contains(event)) {
      return true;
    } else {
      return false;
    }
  }
}
