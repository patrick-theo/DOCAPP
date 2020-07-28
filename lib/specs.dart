import 'Doctor/Signup.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Specsa extends StatefulWidget {
  @override
  _SpecsaState createState() => _SpecsaState();
}

class _SpecsaState extends State<Specsa> {
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
          title: Text('Choose your Specialisation',
              style: TextStyle(
                  fontFamily: 'Varela',
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.black)),
        ),
        body: Container(
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
                        car = false;
                      }
                    });
                  }),
              SizedBox(height: 10),
              RaisedButton(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                elevation: 8,
                textColor: Colors.white,
                color: Colors.blue,
                child: Text(("Confirm Specialisation"),
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0)),
                onPressed: hi,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                    side: BorderSide(color: Colors.blue)),
              ),
            ],
          ),
        ));
  }

  void hi() {
    Fluttertoast.showToast(
        msg: "Value is " + sp,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.purple[400],
        textColor: Colors.white,
        fontSize: 16.0);

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Signup(specialization: sp)));
  }
}
