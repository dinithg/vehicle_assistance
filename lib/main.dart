import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vehicel_assistance/pages/data.dart';
import 'package:vehicel_assistance/pages/login.dart';
import 'package:vehicel_assistance/pages/mechanic.dart';

import 'package:vehicel_assistance/pages/report.dart';
import 'package:vehicel_assistance/pages/vehicelowner.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var userId = prefs.getString('userID');
  var type = prefs.getString('type');
  Data.userid = userId;
  Data.usertype = type;
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: userId == null
          ? Login()
          : type == 'Owner'
              ? Owner()
              : Mechanic()));
}

//{if(Data.usertype=='Mechanic') Mechanic() else Owner()}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vehicle Assistance',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(),
    );
  }
}
