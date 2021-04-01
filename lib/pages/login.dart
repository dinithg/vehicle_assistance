import 'package:flutter/material.dart';
import 'package:vehicel_assistance/pages/mlogin.dart';
import 'package:vehicel_assistance/pages/ologin.dart';

class Login extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Scaffold(
            body: Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
              child: Container(
            padding: EdgeInsets.only(top: 50, left: 20, right: 20),
            child: RaisedButton(
                textColor: Colors.white,
                color: Colors.cyan,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                ),
                child: Text(
                  'Mechanic',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MLogin()));
                }),
          )),
          Center(
              child: Container(
            padding: EdgeInsets.only(top: 50, left: 20, right: 20),
            child: RaisedButton(
                textColor: Colors.white,
                color: Colors.cyan,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                ),
                child: Text(
                  'Customer',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => OLogin()));
                }),
          ))
        ],
      ),
    )));
  }
}
