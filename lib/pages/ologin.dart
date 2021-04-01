import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vehicel_assistance/pages/data.dart';
import 'package:vehicel_assistance/pages/vehicelowner.dart';

class OLogin extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<OLogin> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Scaffold(
          body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                    child: Text(
                      'Hello',
                      style: TextStyle(
                          fontSize: 80.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(18.0, 175.0, 0.0, 0.0),
                    child: Text(
                      'There',
                      style: TextStyle(
                          fontSize: 80.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(220.0, 175.0, 0.0, 0.0),
                    child: Text(
                      '.',
                      style: TextStyle(
                          fontSize: 80.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: email,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan)),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    controller: pass,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan)),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 5.0),
                  Container(
                    alignment: Alignment(1.0, 0.0),
                    padding: EdgeInsets.only(top: 15.0, left: 20.0),
                    child: InkWell(
                      onTap: () {},
                      child: Text(
                        'Forgot Password',
                        style: TextStyle(
                            color: Colors.cyan,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.0),
                  Container(
                    height: 40.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      shadowColor: Colors.cyanAccent,
                      color: Colors.cyan,
                      elevation: 7.0,
                      child: RaisedButton(
                        color: Colors.cyan,
                        padding: EdgeInsets.symmetric(horizontal: 80),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        onPressed: () {
                          login();
                        },
                        child: Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    height: 40.0,
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black,
                            style: BorderStyle.solid,
                            width: 1.0),
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: Text(
                              'Register',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  bool found = false;
  Future<void> login() async {
    print(email.text.toString().length);
    if (email.text.toString().length > 1 && pass.text.toString().length > 1) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      FirebaseFirestore.instance.collection("owner").get().then((value) {
        for (var i = 0; i < value.docs.length; i++) {
          if (email.text == value.docs[i]["email"]) {
            found = true;
            if (pass.text == value.docs[i]["password"]) {
              prefs.setString('userID', value.docs[i].id);
              prefs.setString('type', 'Owner');
              Data.userid = value.docs[i].id;
              Data.usertype = "Owner";
              Data.contact = value.docs[i]["contact"];
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Owner()));

              break;
            } else {
              CoolAlert.show(
                context: context,
                type: CoolAlertType.warning,
                text: "Password not matching",
              );
              print("pass not match");
              break;
            }
          }
        }
        if (!found) {
          CoolAlert.show(
            context: context,
            type: CoolAlertType.warning,
            text: "Incorrect ID",
          );
        }
      });
    } else {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.warning,
        text: "Fill All",
      );
    }
  }
}
