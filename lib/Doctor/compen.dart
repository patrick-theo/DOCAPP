import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:final_proj/main.dart';

class Compp extends StatefulWidget {
  final String peerid;
  final String curid;
  final String doc;

  Compp({
    Key key,
    @required this.peerid,
    @required this.curid,
    this.doc,
  }) : super(key: key);
  @override
  _ComppState createState() => _ComppState(
        peerid: peerid,
        curid: curid,
        doc: doc,
      );
}

class _ComppState extends State<Compp> {
  _ComppState({
    Key key,
    @required this.peerid,
    @required this.curid,
    this.doc,
  });
  String peerid;
  String curid;
  String doc;

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
                  .collection("Doctors")
                  .document(curid)
                  .collection("PendingOut")
                  .where("doc-id", isEqualTo: doc)
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
      width: SizeConfig.blockSizeVertical * 50,
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
                ' ${documents['refered from'] ?? 'Not available'}',
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
                ' ${documents['Patient name'] ?? 'Not available'}',
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
                '${documents['Patient id'] ?? 'Not available'}',
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
                                    ' ${documents['Patient age'] ?? 'Not available'}',
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
                '${documents['reason'] ?? 'Not available'}',
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
                ' ${documents['status'] ?? 'Not available'}',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                "Time Suggested",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[400]),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                ' ${documents['Time Suggested'] ?? 'Not available'}',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                "Review Time",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[400]),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                ' ${documents['time for review'] ?? 'Not available'}',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.0),
                child:
                    Container(height: 2.0, width: 600.0, color: Colors.purple),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.0),
                child: Container(height: 2.0, width: 600.0, color: Colors.blue),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
