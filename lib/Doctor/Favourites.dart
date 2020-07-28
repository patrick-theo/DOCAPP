import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_proj/Doctor/details.dart';
import 'package:final_proj/Doctor/docdetail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Home.dart';
import 'received.dart';
import 'sent.dart';
import 'set.dart';

class Fav extends StatefulWidget {
  final String iid;
  final FirebaseUser user;
  Fav({Key key, @required this.iid, @required this.user}) : super(key: key);

  @override
  _FavState createState() => _FavState(iid: iid, user: user);
}

class _FavState extends State<Fav> {
  _FavState({Key key, @required this.iid, @required this.user});
  FirebaseUser user;
  String iid;

  String naame = " ";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text('Favourites',
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
                  .document(iid)
                  .collection("fav")
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
      bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 6.0,
          color: Colors.transparent,
          elevation: 9.0,
          clipBehavior: Clip.antiAlias,
          child: Container(
              height: 50.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0)),
                  color: Colors.white),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        height: 50.0,
                        width: MediaQuery.of(context).size.width / 2 - 40.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.home),
                              iconSize: 32,
                              color: Color(0xFF2196F3),
                              onPressed: homes,
                            ),
                            IconButton(
                              icon: Icon(Icons.arrow_upward),
                              iconSize: 32,
                              color: Color(0xFF676E79),
                              onPressed: sent,
                            ),
                          ],
                        )),
                    Container(
                        height: 50.0,
                        width: MediaQuery.of(context).size.width / 2 - 40.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 32,
                              color: Color(0xFF676E79),
                              onPressed: rec,
                            ),
                            IconButton(
                              icon: Icon(Icons.person_outline),
                              iconSize: 32,
                              color: Color(0xFF676E79),
                              onPressed: setting,
                            )
                          ],
                        )),
                  ]))),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot documents) {
    if (documents['count'] >= 5) {
      return Container(
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
                            'Doctor name :',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                        ),
                      ]),
                      Row(children: <Widget>[
                        Container(
                          child: Icon(
                            Icons.stars,
                            size: 30,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Container(
                            child: FutureBuilder(
                              future:
                                  getUserInfo(documents.documentID.toString()),
                              builder: (context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return Text(
                                    snapshot.data.data['Nickname'].toString(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  );
                                } else if (snapshot.connectionState ==
                                    ConnectionState.none) {
                                  return Text(" ");
                                }
                                return Text(" ");
                              },
                            ),
                          ),
                        ),
                      ]),
                    ],
                  ),
                  margin: EdgeInsets.only(left: 20.0),
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
                      {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Details(
                                      peerId: documents.documentID,
                                      nam: '${documents['Name']}',
                                      user: user,
                                    )));
                      }
                    },
                  ))
            ],
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Doc(
                        peerid: documents.documentID,
                        user: user,
                        name: '${documents['Name']}')));
          },
          padding: EdgeInsets.fromLTRB(5.0, 10.0, 25.0, 10.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
      );
    } else {
      return Container();
    }
  }

  Future<DocumentSnapshot> getUserInfo(String npi) async {
    return await Firestore.instance.collection("Doctors").document(npi).get();
  }

  void sent() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Sent(
                  iid: iid,
                  user: user,
                )));
  }

  void rec() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Rec(
                  iid: iid,
                  user: user,
                )));
  }

  void setting() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Setting(
                  currentUserId: iid,
                  user: user,
                  lov: false,
                )));
  }

  void homes() {}
}
