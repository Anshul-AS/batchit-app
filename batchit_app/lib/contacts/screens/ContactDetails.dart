//UI for adding new contact to db
//use methods defined in databasehelper file 
//To add data of contacts
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import '../Contact.dart';
import '../database_helper.dart';
import 'package:intl/intl.dart';


class ContactDetail extends StatefulWidget {
  final String appBarTitle;
  final Contact contact;

  ContactDetail(this.contact,this.appBarTitle);
  @override
  State<StatefulWidget> createState(){
    return ContactDetailState(this.contact,this.appBarTitle);
  }
}

class ContactDetailState extends State<ContactDetail> {
  DatabaseHelper helper = DatabaseHelper();
  String appBarTitle;
  Contact contact;
  ContactDetailState(this.contact,this.appBarTitle);

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
                      onChanged: (value) {
                        updateFirstName0101();
                      },
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
                      onChanged: (value) {
                        updateLastName0101();
                      },
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
                      onChanged: (value) {
                        updatePhone0101();
                      },
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
                      onChanged: (value) {
                        updateEmail0101();
                      },
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
                              Icons.save,
                              color: Colors.green,
                            ),
                            onPressed: () {
                              setState(() {
                                debugPrint("Save button clicked");
                                _save();
                              });
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

  void updateFirstName0101(){
    contact.firstname = firstnameController.text;
  }
  void updateLastName0101(){
    contact.lastname = lastnameController.text;
  }
  void updatePhone0101(){
    contact.phone = phoneController.text;
  }
  void updateEmail0101(){
    contact.email = emailController.text;
  } 

  void _save() async{
    moveToLastScreen();
    int result;
    if(contact.id != null){
      result = await helper.updatetContact(contact);
    }else{
      result = await helper.insertContact(contact);
    }
    if(result != 0){
      _showAlertDialog('Status', 'Contact Saved successfully');
    }else{
      _showAlertDialog('Status', 'Problem saving Contact');
    }
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