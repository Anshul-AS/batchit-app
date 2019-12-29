//UI for information of each contacts
//also added url laucher for calling and sending 
//message to the contact

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import '../Contact.dart';
import '../database_helper.dart';
import 'package:intl/intl.dart';
import 'ContactDetails.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class ContactCall extends StatefulWidget {
  final String appBarTitle;
  final Contact contact;

  ContactCall(this.contact,this.appBarTitle);
  @override
  State<StatefulWidget> createState(){
    return ContactCallState(this.contact,this.appBarTitle);
  }
}
//second part


class ContactCallState extends State<ContactCall> {
  DatabaseHelper helper = DatabaseHelper();
  String appBarTitle;
  Contact contact;
  ContactCallState(this.contact,this.appBarTitle);

  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    firstnameController.text = contact.firstname;
    lastnameController.text = contact.lastname;
    phoneController.text = contact.phone;
    emailController.text = contact.email;
    print(contact.phone);
    return WillPopScope(
      
      onWillPop: (){
        
        moveToLastScreen();
      },
      child: Scaffold(
        
        appBar: AppBar(
          
          title: Text(appBarTitle),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              moveToLastScreen();
            },
          ),
        ),
        body: Padding(
            padding: EdgeInsets.all(10.0),
            child: Card(
              color: Colors.blueGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: 
                        EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0),
                        child: Center(
                          child: Image(
                            image: AssetImage("images/download.jpg"),
                            height: 100.0,
                            width: 100.0,
                          ),
                        ),
                  ),
                  // firstname Element
                  Padding(
                    padding:
                        EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0),
                    child: TextField(
                      controller: firstnameController,
                      style: textStyle,
                      
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        labelStyle: textStyle,
                        icon: Icon(Icons.person,color: Colors.white,),
                      ),
                    ),
                  ),
                  // lastname Element
                  Padding(
                    padding:
                        EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0),
                    child: TextField(
                      controller: lastnameController,
                      style: textStyle,
                      
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        icon: Icon(Icons.people,color: Colors.white,),
                      ),
                    ),
                  ),
                  // phone Element
                  Padding(
                    padding:
                        EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0),
                    child: TextField(
                      controller: phoneController,
                      style: textStyle,
                      
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        icon: Icon(Icons.phone,color: Colors.white,),
                      ),
                    ),
                  ),
                  // email Element
                  Padding(
                    padding:
                        EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0),
                    child: TextField(
                      controller: emailController,
                      style: textStyle,
                      decoration: InputDecoration(
                        labelText: 'E-Mail',
                        icon: Icon(Icons.email,color: Colors.white,),
                      ),
                    ),
                  ),

                  // Save Delete Element
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(115.0),
                            ),
                            textColor: Colors.white,
                            color: Colors.white,
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.call,
                              color: Colors.green,
                            ),
                            onPressed: () async {
                              String jai = contact.phone;
                              String url = 'tel:$jai';
                              if(await canLaunch(url)){
                                await launch(url);
                              }else{
                                throw "Can't connect";
                              }
                            },
                          ),
                        ),
                        Container(
                          width: 5.0,
                        ),
                        Expanded(
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(115.0),
                            ),
                            textColor: Colors.white,
                            color: Colors.white,
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.message,
                              color: Colors.yellow,
                            ),
                            onPressed: () async {
                              String jai1 = contact.phone;
                              String url1 = 'sms:$jai1';
                              if(await canLaunch(url1)){
                                await launch(url1);
                              }else{
                                throw "Can't connect";
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(115.0),
                            ),
                            textColor: Colors.white,
                            color: Colors.white,
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.edit,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              navigateToDetail(this.contact, 'Contact Edit');
                            },
                          ),
                        ),
                        Container(
                          width: 5.0,
                        ),
                        Expanded(
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(115.0),
                            ),
                            textColor: Colors.white,
                            color: Colors.white,
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                _delete();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ),
    );
  }
  


  void navigateToDetail(Contact contact,String title1007) async {
    bool result = 
        await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
          return ContactDetail(contact,title1007);
        }));


  }

  void _delete() async {
    moveToLastScreen();
    if(contact.id == null){
      _showAlertDialog('Status', 'First add a Contact');
      return;
    }

  int result = await helper.deleteContact(contact.id);
  if(result != 0){
      _showAlertDialog('Status', 'Contact Deleted successfully');
    }else{
      _showAlertDialog('Status', 'Error');
    }
  }
  void moveToLastScreen(){
    Navigator.pop(context, true);
  }
  void _showAlertDialog(String title, String message){
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_)=>alertDialog);
  }

}
