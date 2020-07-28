import 'package:cloud_firestore/cloud_firestore.dart';
import 'details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:slider_button/slider_button.dart';

class Doc extends StatefulWidget {
  final String peerid;
  final String name;

  final FirebaseUser user;
  Doc(
      {Key key,
      @required this.peerid,
      @required this.user,
      @required this.name})
      : super(key: key);
  @override
  _DocState createState() => _DocState(peerid: peerid, user: user, name: name);
}

class _DocState extends State<Doc> {
  _DocState(
      {Key key,
      @required this.peerid,
      @required this.user,
      @required this.name});
  FirebaseUser user;
  String peerid;
  String name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 10.0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.navigate_before,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Doctor Details Page',
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
                  .where('Npi', isEqualTo: peerid)
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
        child: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 2.0),
              child: Row(
                children: <Widget>[
                  Text('DOCTOR ',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0)),
                  SizedBox(width: 1.0),
                  Text('DETAILS',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.purple[400],
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0))
                ],
              ),
            ),
            SizedBox(
              height: 5,
              width: 200,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 100, horizontal: 10),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage('${documents['photoUrl']}'),
                            fit: BoxFit.cover),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 15.0,
                          ),
                        ],
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 222,
                  height: 220,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Dr. ${documents['Nickname'] ?? 'Not available'}',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'NPI : ${documents['Npi'] ?? 'Not available'}',
                        style: TextStyle(fontSize: 19, color: Colors.grey),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Center(
                          child: SliderButton(
                        height: 50,
                        action: () {
                          {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Details(
                                          peerId: documents.documentID,
                                          nam: name,
                                          user: user,
                                        )));
                          }
                        },
                        label: Text(
                          "Refer",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
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
                      )),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "*Specialisation",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[400]),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              '  ${documents['Specialization'] ?? 'Not available'}'
                  .replaceAll('[', "")
                  .replaceAll("]", ""),
              style: TextStyle(
                  fontSize: 19,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "*Status",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[400]),
            ),
            SizedBox(
              height: 5,
            ),
            Row(children: <Widget>[
              hello('  ${documents["Emergency"]}', '${documents["Asap"]}',
                  '${documents["Normal"]}'),
            ]),
            SizedBox(height: 10),
            Text(
              "*Education",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[400]),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              '  ${documents['Education'] ?? 'Not available'}',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "*Board Certification",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[400]),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              '  ${documents['Board Certification'] ?? 'Not available'}',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "*Current Hospital",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[400]),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              '  ${documents['Hospital'] ?? 'Not available'}',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "*About",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[400]),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              '  ${documents['AboutMe'] ?? 'Not available'}',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(height: 20),
            Text(
              "Contacts",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[400]),
            ),
            SizedBox(
              height: 22,
            ),
            Row(
              children: <Widget>[
                Container(
                    width: 40,
                    height: 40,
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 10.0,
                          ),
                        ],
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(16)),
                    child: IconButton(
                      icon: Icon(
                        Icons.phone_android,
                        color: Colors.black,
                      ),
                      iconSize: 20,
                      onPressed: () => _callPhone(
                          '${documents['Phone'] ?? 'Not available'}'),
                    )),
                Container(
                  child: Text(
                    ' ${documents['Phone'] ?? 'Not available'}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 10.0,
                        ),
                      ],
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(16)),
                  child: IconButton(
                    icon: Icon(
                      Icons.phone,
                      color: Colors.black,
                    ),
                    iconSize: 20,
                    onPressed: () => _callPhone(
                        '${documents['Office number'] ?? 'Not available'}'),
                  ),
                ),
                Container(
                  child: Text(
                    ' ${documents['Office number'] ?? 'Not available'}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 0.0), //(x,y)
                          blurRadius: 10.0,
                        ),
                      ],
                      color: Colors.purple[400],
                      borderRadius: BorderRadius.circular(16)),
                  child: IconButton(
                    icon: Icon(
                      Icons.mail,
                      color: Colors.black,
                    ),
                    iconSize: 20,
                    onPressed: () => _launchURL(
                        '${documents['Email-id'] ?? 'Not available'}',
                        'D-com Refferal Info'),
                  ),
                ),
                Container(
                  child: Text(
                    '${documents['Email-id'] ?? 'Not available'}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }

  _callPhone(String phone) async {
    if (await canLaunch('tel:$phone')) {
      await launch('tel:$phone');
    } else {
      throw 'Could not Call Phone';
    }
  }

  _launchURL(String toMailId, String subject) async {
    var url = 'mailto:$toMailId?subject=$subject';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  hello(String emer, String asa, String nor) {
    if (emer == 'true') {
      return Text('  Emergency',
          style: TextStyle(fontSize: 17, color: Colors.black));
    } else if (asa == 'true') {
      return Text('  Asap',
          style: TextStyle(fontSize: 17, color: Colors.black));
    } else if (nor == 'true') {
      return Text('  Nomal',
          style: TextStyle(fontSize: 17, color: Colors.black));
    } else {
      return Text('  error',
          style: TextStyle(fontSize: 17, color: Colors.black));
    }
  }
}
