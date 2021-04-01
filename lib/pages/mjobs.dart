import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:vehicel_assistance/pages/data.dart';
import 'package:vehicel_assistance/pages/mechanichome.dart';

class MJobs extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<MJobs> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      
      
      body: formWidget(),
    );
  }
Widget formWidget(){
  return StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('jobs').where('status', isEqualTo: 'Pending').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());

                  return ListView(
                    children: snapshot.data.docs.map<Widget>((document) {
                      GeoPoint point = document['location']['geopoint']; 
                      var lat =point.latitude;
                      var lon=point.longitude;
                      var id=document.id;
                      return Center(
                        child: Container(
                          
                            margin: const EdgeInsets.fromLTRB(20, 20, 20, 15),
                            height: 100,
                            width: 500,
                            child:TextButton(
                              onPressed: () 
                                async {
                      return showDialog(context: context,
      builder:(_) => AlertDialog(
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
            child: Text('Locate Vehicle'),
            onPressed: () async{
                MapsLauncher.launchCoordinates(
                    lat, lon, 'Vehicle is here');      
            },
          ),
          TextButton(
            child: Text('Accept Job'),
            onPressed: () {
               acceptjob(id);
            },
          ),
        ],
      ),

      barrierDismissible: true);
             
                    },
                                
                            child: Card(
                              
                              color: Colors.blue[600],
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
                                        child: Text(
                                           document["vmodel"]
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                            )),
                                        onPressed: () {/* ... */},
                                      ),
                                      const SizedBox(width: 8),
                                  
                                    // this creates scat.length many elements inside the Column
                                     Padding(
                                    padding: const EdgeInsets.all(6.0),
                                  child:Text((document["issue"]),
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      )),
                                  ),

                                    
                                     Padding(
                                    padding: const EdgeInsets.all(6.0),
                                  child:
                                      Text((document["ocontact"]),
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      )),),
                                    
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


void acceptjob(String id){
  CollectionReference users = FirebaseFirestore.instance.collection('jobs');

Future<void> updateUser() {
  return users
    .doc(id)
    .update({'mechanic': Data.userid,
    'mcontact': Data.contact,
    'status': 'Accepted',
    
    
    })
    .then((value) => print("User Updated"))
    .catchError((error) => print("Failed to update user: $error"));
}
updateUser();
Navigator.push(context,MaterialPageRoute(builder: (context) => MechanicHome()));
}

  
}
