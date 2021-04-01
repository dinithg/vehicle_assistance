import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vehicel_assistance/pages/data.dart';

class OwnerHome extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<OwnerHome> {
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
          .where('owner', isEqualTo: Data.userid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        return ListView(
          children: snapshot.data.docs.map<Widget>((document) {
            var _phone = document["mcontact"].toString();

            return Center(
              child: SingleChildScrollView(
                child: Container(
                    margin: const EdgeInsets.fromLTRB(20, 20, 20, 15),
                    height: 100,
                    width: 500,
                    child: TextButton(
                      onPressed: () {
                        _makePhoneCall('tel:$_phone');
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
                              child: Text((document["mcontact"]),
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    )),
              ),
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
}
