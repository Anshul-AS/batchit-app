//UI for listing all contacts on page
//methods for getting details of each contacts
//mthods name are defined according to their working

import 'package:flutter/material.dart';
import 'dart:async';
import '../database_helper.dart';
import '../Contact.dart';
import 'ContactDetails.dart';
import 'package:sqflite/sqflite.dart';
import 'ContactCall.dart';

class ContactList extends StatefulWidget {
  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Contact> contactList;
  int count=0;
  
  @override
  Widget build(BuildContext context) {
    if(contactList == null){
      contactList = List<Contact>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        
        title: Text('Contacts'),
      ),
      body: getContactListView(),
      floatingActionButton: FloatingActionButton(
        
        child: Icon(Icons.add,color: Colors.white,),
        onPressed: (){
          navigateToDetail(Contact('','','',''), 'Add Contact');
        },
      ),
    );
  }

  ListView getContactListView(){
    return ListView.builder(
      itemCount: count,
      itemBuilder: (context,position){
        return Card(
          color: Colors.blueGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 4.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage("images/download.jpg"),
            ),
            title: Text(this.contactList[position].firstname + ' ' +this.contactList[position].lastname,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25.0,
              color: Colors.white
            ),
            ),
            subtitle: Text(this.contactList[position].phone,style: TextStyle(color: Colors.white),),
            trailing: GestureDetector(
              child: Icon(Icons.open_in_new,color: Colors.white,),
              onTap: (){
                navigateToDetail0101(this.contactList[position], 'Contact Info');
              }
            ),
            ),
        );
      },
    );
  }

  void navigateToDetail0101(Contact contact,String title1007) async {
    bool result = 
        await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
          return ContactCall(contact,title1007);
        }));

    if(result == true){
      updateListView();
    }
  }



  void navigateToDetail(Contact contact,String title1007) async {
    bool result = 
        await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
          return ContactDetail(contact,title1007);
        }));

    if(result == true){
      updateListView();
    }
  }
  void updateListView(){
    final Future<Database> dbFuture = databaseHelper.initalizeDatabase();
    dbFuture.then((databse){
      Future<List<Contact>> contactListFuture = databaseHelper.getContactList();
      contactListFuture.then((contactList){
        setState(() {
          this.contactList = contactList;
          this.count = contactList.length;
        });
      });
    });
  }

}