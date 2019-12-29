import 'src/pages/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'contacts/screens/ContactList.dart';
import 'groupchat/chatscreens.dart';
import 'services/crud.dart';
import 'PlayerPage.dart';
import 'SearchPage.dart';
import 'dart:async';
import 'groupchat/user.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //getting collection of signedin users
  final FirebaseAuth _auth =FirebaseAuth.instance;

  FirebaseUser user;
  bool isSignedIn = false;

  //getting collection of documents for individual video title likes and url
  QuerySnapshot videos_jai;
  crudMethods crudObj = new crudMethods();

  //checking authentication for home page
  checkAuthentication() async {
    _auth.onAuthStateChanged.listen((user){
      if (user == null){
        Navigator.pushReplacementNamed(context, "/SigninPage");
      }
    });
  }
  //getting current user
  getUser() async {
    FirebaseUser firebaseUser = await _auth.currentUser();
    await firebaseUser?.reload();
    firebaseUser = await _auth.currentUser();

    if(firebaseUser !=null){
      setState(() {
        this.user = firebaseUser;
        this.isSignedIn = true;
      });
    }
    print(this.user);
  }
  //siging out of user method
  signOut() async {
    _auth.signOut();
  }
  //at launch checking auth and getting videos doc list
  @override
  void initState(){
    super.initState();
    this.checkAuthentication();
    this.getUser();

    this.crudObj.getData().then((results){
      setState(() {
        videos_jai = results;
      });
    });
  }
  //UI of page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text('Home Screen'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: (){
              crudObj.getData().then((results){
                setState(() {
                  videos_jai = results;
                });
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              navigateToSearch();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child:!isSignedIn
        ? CircularProgressIndicator() 
        : ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("${user.displayName}"),
              accountEmail: Text("${user.email}"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Image(
                  image: AssetImage("assets/logo.png"),
                  width: 50.0,
                  height: 50.0,
                ),
              ),
            ),
            ListTile(
              title: Text("Home"),
              trailing: Icon(Icons.home),
              onTap: (){
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text("Contacts"),
              trailing: Icon(Icons.contacts),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ContactList(),
                ));
              },
            ),
            ListTile(
              title: Text("Group Chat"),
              trailing: Icon(Icons.message),
              onTap: (){
                  User searchedUser = User(
                    uid: "",
                    profilePhoto: "logo.png",
                    name: "Group Chat",
                    username: "Group Chat",
                  );
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ChatScreen(searchedUser,"${user.displayName}")
                  ));
              },
            ),
            ListTile(
              title: Text("Video Call"),
              trailing: Icon(Icons.video_call),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => IndexPage(),
                ));
              },
            ),
            Divider(color: Colors.black),
            ListTile(
              title: Text("Sign Out"),
              trailing: Icon(Icons.backspace),
              onTap: signOut,
            ),
          ],
        ),
      ),

      body: Container(
        child: Center(
          child: !isSignedIn
          ? CircularProgressIndicator()
          : _carList()
        ),
      ),
    );
  }

  //UI of body
  Widget _carList(){
    if(videos_jai != null){
      return ListView.builder(
        itemCount: videos_jai.documents.length,
        itemBuilder: (context,i){
          int my_likes_007 = videos_jai.documents[i].data["likes"];
          return Column(
            children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          AspectRatio(
            aspectRatio: 16/9,
            child: Container(
              margin: EdgeInsets.fromLTRB(2.0, 0, 2.0, 0),
              color: Colors.black38,
              child: Image(
                image: AssetImage("assets/logo1.jpg"),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 2.0),
          ),
          Container(
            color: Colors.lightBlue,
            margin: EdgeInsets.fromLTRB(2.0, 0, 2.0, 0),
            height:60.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(height: 60.0,width: 256.0,
                padding: EdgeInsets.all(5.0),
                  child: Text(
                    (videos_jai.documents[i].data['title']),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.fromLTRB(2.0, 0, 2.0, 0),),
                Container(
                  height: 60.0,
                  width: 40.0,
                  child: Center(child: Text("$my_likes_007\nLikes",style: TextStyle(color: Colors.white),)),
                ),
                Padding(padding: EdgeInsets.fromLTRB(2.0, 0, 2.0, 0),),
                Container(
                  height: 60.0,
                  width: 40.0,
                  child: MaterialButton(
                    onPressed: (){
                      String temp1 = videos_jai.documents[i].documentID;
                      navigateToPlayer(videos_jai.documents[i].documentID,videos_jai.documents[i].data['urlLink'],videos_jai.documents[i].data['title'],videos_jai.documents[i].data['likes']);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1000.0),
                    ),
                    
                    child: Icon(Icons.play_arrow,color: Colors.white,),
                  ),
                )
              ],
            ),
          ),
        ],
          );
        },
      );
    }else{
      return Center(child: Text('Loading..'));
    }
  }



  //navigating to player screen
  void navigateToPlayer(String docID,String url,String title,int likes) async {
    
    bool result = 
        await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
          return PlayerPage(docID,url,title,likes);
        }));
  }

  //navigate to search page
  void navigateToSearch() async {
    bool result = 
        await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
          return SearchPage();
        }));
  }
}