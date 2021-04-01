import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vehicel_assistance/pages/data.dart';

class MechanicHome extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<MechanicHome> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: formWidget(),
    );
  }

  Widget formWidget() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('jobs')
          .where('mechanic', isEqualTo: Data.userid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        return ListView(
          children: snapshot.data.docs.map<Widget>((document) {
            var _phone = document["ocontact"].toString();
            var id = document.id;
            return Center(
              child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 20, 20, 15),
                  height: 100,
                  width: 500,
                  child: TextButton(
                    onPressed: () async {
                      if (document["status"].toString() == 'Active') {
                        return showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  title: Text('Job'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text('What do you want to do?'),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Complete Job'),
                                      onPressed: () async {
                                        acceptjob(id);
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Call Owner'),
                                      onPressed: () {
                                        _makePhoneCall('tel:$_phone');
                                      },
                                    ),
                                  ],
                                ),
                            barrierDismissible: true);
                      } else {
                        return showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  title: Text('Job'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text('Do you want to call the owner?'),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Call Owner'),
                                      onPressed: () {
                                        _makePhoneCall('tel:$_phone');
                                      },
                                    ),
                                  ],
                                ),
                            barrierDismissible: true);
                      }
                    },
                    child: Card(
                      color: Colors.cyan,
                      child: ListView(
                        //mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Icon(
                              Icons.car_repair,
                              color: Colors.white,
                            ),
                          ),
                          TextButton(
                            child: Text(document["status"].toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                )),
                            onPressed: () {/* ... */},
                          ),
                          const SizedBox(width: 8),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text((document["vnumber"]),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                )),
                          ),
                          // this creates scat.length many elements inside the Column
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text((document["issue"]),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                )),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text((document["ocontact"]),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                )),
                          ),
                        ],
                      ),
                    ),
                  )),
            );
          }
              //

              ).toList(),
        );
      },
    );
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void acceptjob(String id) {
    CollectionReference users = FirebaseFirestore.instance.collection('jobs');

    Future<void> updateUser() {
      return users
          .doc(id)
          .update({
            'status': 'Completed',
          })
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    }

    updateUser();
  }
}
