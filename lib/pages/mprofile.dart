import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vehicel_assistance/pages/data.dart';
import 'package:vehicel_assistance/pages/login.dart';

class MProfile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<MProfile> {
  bool showPassword = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 16.0, top: 25.0, right: 16.0),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Text(
                'Edit  Owner Profile',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 15.0,
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 4,
                            color: Colors.cyan,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  "https://st3.depositphotos.com/15648834/17930/v/600/depositphotos_179308454-stock-illustration-unknown-person-silhouette-glasses-profile.jpg"))),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                          color: Colors.cyan,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 35.0,
              ),
              StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('mechanic')
                        .doc(Data.userid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      var userDocument = snapshot.data;
                      
                      return Column(children: [
                        TextFormField(
                          controller: nameController..text=userDocument["name"],
                              
  decoration: InputDecoration(
    labelText: 'Full Name'
    
  ),
),
TextFormField(
                          controller: emailController..text=userDocument["email"],
  decoration: InputDecoration(
    labelText: 'E-mail'
    
  ),
),
 TextFormField(
                          controller: passwordController..text=userDocument["password"],
                            obscureText: true,
  decoration: InputDecoration(
    labelText: 'Password',

  ),
),
TextFormField(
                          controller: mobileController..text=userDocument["contact"],
  decoration: InputDecoration(
    labelText: 'Contact'
    
  ),
),
TextFormField(
                          controller: addressController..text=userDocument["address"],
  decoration: InputDecoration(
    labelText: 'Home Address'
    
  ),
),
              
              
              SizedBox(
                height: 35.0,
              ),
                      ]);}),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  
                  RaisedButton(
                    onPressed: () {
                      update();
                    },
                    color: Colors.cyan,
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Text(
                      "Save",
                      style: TextStyle(
                        fontSize: 14.0,
                        letterSpacing: 2.2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  RaisedButton(
                color: Colors.red,
                
                    padding: EdgeInsets.symmetric(
                      horizontal: 50,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    onPressed: () async {
                      return showDialog(context: context,
      builder:(_) => AlertDialog(
        title: Text('LogOut'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you sure you want to logout ?'),
              
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Yes'),
            onPressed: () async{
              SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('userID');
                prefs.remove('type');
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
            },
          ),
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
               Navigator.of(context).pop();
            },
          ),
        ],
      ),

      barrierDismissible: false);
             
                    },
                    child: Text(
                      "LogOut",
                      style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 2.2,
                        color: Colors.white,

                      ),
                    ),
                  )
                ],
              ),
              
            ],
          ),
        ),
      ),
    );
  }

 
Future<void> update() async {
   
 if(nameController.text.toString().length>1 && passwordController.text.toString().length>1 && emailController.text.toString().length>1 && mobileController.text.toString().length>1 && addressController.text.toString().length>1){  
  if(mobileController.text.toString().length==10){
CollectionReference users = FirebaseFirestore.instance.collection('owner');

Future<void> updateUser() {
  return users
    .doc(Data.userid)
    .update({'name': nameController.text.toString(),
    'address': addressController.text.toString(),
    'email': emailController.text.toString(),
    'contact': mobileController.text.toString(),
    
    })
    .then((value) => print("User Updated"))
    .catchError((error) => print("Failed to update user: $error"));
}
updateUser();
  }
  else{
    CoolAlert.show(
          context: context,
          type: CoolAlertType.warning,
          text: "Contact should have 10 numbers",
         
        );
  }
 }
 else{
    CoolAlert.show(
          context: context,
          type: CoolAlertType.warning,
          text: "Fill All",
         
        );

 }
 } 

}
