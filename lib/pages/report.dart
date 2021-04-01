import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vehicel_assistance/pages/data.dart';
import 'package:vehicel_assistance/pages/home_page.dart';
import 'package:vehicel_assistance/pages/ownerhome.dart';

class Report extends StatefulWidget {
  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Report> {
  Position position ;
  TextEditingController numberController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController issueController = TextEditingController();
  
Geoflutterfire geo = Geoflutterfire();
Future<Widget> reloadLocation;
Widget _child;

Future<void> initState()  {
  super.initState();
  reloadLocation=locate();
  
  
}
Future<Widget> locate() async{
 
LocationPermission permission;
 
         
         permission = await Geolocator.checkPermission();
         if (permission == LocationPermission.deniedForever) {
           permission = await Geolocator.requestPermission();
         }
    
         else if (permission == LocationPermission.denied) {
           permission = await Geolocator.requestPermission();
         if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
            permission = await Geolocator.requestPermission();
            }
        }
        else {
          position = await Geolocator.getCurrentPosition(desiredAccuracy: 
          LocationAccuracy.high); 
          print(position.latitude.toString());
                   
        }
    return _child=formWidget();
        
}


 

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Report"),
      ),
      body: formWidget(),
    );
  }

  Widget formWidget(){
    return FutureBuilder(
      future:reloadLocation ,
      builder: (context,state)
      {
                  if (state.connectionState == ConnectionState.active ||
                      state.connectionState == ConnectionState.waiting) {
                      return Column(
                        
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:<Widget>[
                          Container(
                            alignment:Alignment.center,
                            child:CircularProgressIndicator()
                          ),
                        
                        ]);
                  } else {
                       return ListView(
                        children: <Widget>[
                        
                  Container(
                    padding: EdgeInsets.all(20),
                    child: TextField(
                      controller: numberController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Vehicle Number',
                      ),
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.all(20),
                    child: TextField(
                      controller: modelController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Vehicle Model',
                      ),
                    ),
                  ),

                   Container(
                    padding: EdgeInsets.all(20),
                    child: TextField(
                      controller: issueController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Vehicle Issue',
                      ),
                    ),
                  ),    
                       Container(
                    padding: EdgeInsets.only(top :50, left: 20,right: 20 ),
                      child: RaisedButton(
                        textColor: Colors.white,
                        color: Colors.blue,
                        child: Text('Add Job' , style: TextStyle(fontSize: 20,color: Colors.white,fontWeight:FontWeight.bold),),
                       onPressed: () {addjob(numberController.text, modelController.text,issueController.text,
                              context); }),
                  ),
                      ],
                     );
                }});
                }
                
            
void addjob(String number, String type,String issue, BuildContext context){

  CollectionReference users = FirebaseFirestore.instance.collection('jobs');
  Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      GeoFirePoint point = geo.point(latitude: position.latitude, longitude: position.longitude);
      return users
          .add({
            'vmodel': type, // John Doe
            'vnumber': number, // Stokes and Sons
            'status': 'Pending', // 42
            'location': point.data,
            'issue':issue,
            'owner':Data.userid,
            'mechanic':'None',
            'ocontact':Data.contact
          })
          .then((value) => {print("User Added"),success()})
          .catchError((error) => {print("Failed to add user: $error"),CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: "Travel Pass not Matching. Try Again",
         
        )});
    }    

   print((number.length.toString()));
   print((type.length.toString()));
  if(number.length<1 || type.length<1){
     CoolAlert.show(
          context: context,
          type: CoolAlertType.warning,
          text: "Fill All",
         
        );

  }
  else{
    addUser();
  }
}
bool tapped=false;
void success() async{
  CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          text: "Reported Successfully!",
         onConfirmBtnTap: () =>{
           tapped=true,
           Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => OwnerHome(),
      ),
      (route) => false,
    ) ,
    }
        );
      await Future.delayed(const Duration(seconds: 5), (){
        if(!tapped){
Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => OwnerHome(),
      ),
      (route) => false,
    );
}

                });} 
} 

