import 'package:flutter/material.dart';
import 'services/crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'PlayerPage.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  GlobalKey<FormState> _key = new GlobalKey();
  //getting all docs of video for comparision
  QuerySnapshot videos_jai;
  String search_title="";
  crudMethods crudObj = new crudMethods();

  @override
  void initState(){
    crudObj.getData().then((results){
      setState(() {
        videos_jai = results;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search"),),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.all(10.0),),
              TextField(
                decoration: InputDecoration(hintText: "Enter the title"),
                onSubmitted: (String str){
                  setState(() {
                    this.search_title=str;
                    navigateToPlayer(this.search_title);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  //navigating to player screen
  //comparing searched result with the database result and on perfect match going to player page
  void navigateToPlayer(String temp) async {
    print("$temp ioioioioioioioioioioiioioioioioioio");
    String surl,stitle,sdocid;
    int slikes;
    for(int i=0;i<(videos_jai.documents.length);i++){
      if(temp == videos_jai.documents[i].data["title"]){
        surl=videos_jai.documents[i].data["urlLink"];
        stitle=videos_jai.documents[i].data["title"];
        slikes=videos_jai.documents[i].data["likes"];
        sdocid=videos_jai.documents[i].documentID;
      }
    }
    bool result = 
        await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
          return PlayerPage(sdocid,surl,stitle,slikes);
        }));
  }
}