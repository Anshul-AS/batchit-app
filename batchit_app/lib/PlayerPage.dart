import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/crud.dart';

class PlayerPage extends StatefulWidget {
  final String my_url;
  final String my_title;
  final int my_likes;
  final String my_docID;
  PlayerPage(this.my_docID,this.my_url,this.my_title,this.my_likes);
  @override
  State<StatefulWidget> createState(){
    return PlayerPageState(this.my_docID,this.my_url,this.my_title,this.my_likes);
  }
}

class PlayerPageState extends State<PlayerPage> {
  //variables for all properties of a video
  String my_url;
  String my_title;
  int my_likes;
  String my_docID;
  PlayerPageState(this.my_docID,this.my_url,this.my_title,this.my_likes);
  //video playing variables
  VideoPlayerController controller;
  Future<void> futureController;

  //query snapshot of comments
  QuerySnapshot comments_jai;
  crudMethods crudObj = new crudMethods();

  //Like fuctionality with the help of boolean function
  bool is_liked = false;
  int new_doc_id;

//getting comments and initializing videocontroller
  @override
  void initState() {
    crudObj.getComments(my_title).then((results){
      setState(() {
        comments_jai = results;
        this.new_doc_id = comments_jai.documents.length;
      });
    });
    controller = VideoPlayerController.network(my_url);
    futureController = controller.initialize();
    controller.setVolume(25.0);
    controller.setLooping(true);
    super.initState();
  }


//disposing video controller
  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  //UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text(my_title),
        actions: <Widget>[
          MaterialButton(
            onPressed: (){},
            child: Center(
              child: Text("$my_likes\nlikes",style: TextStyle(color: Colors.white),),
            ),
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: (){
              crudObj.getComments(my_title).then((results){
                setState(() {
                  comments_jai = results;
                  this.new_doc_id = comments_jai.documents.length;
                });
              });
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 2.0),),
            AspectRatio(
              aspectRatio: 16/9,
              child: Container(
                margin: EdgeInsets.fromLTRB(2.0, 0, 2.0, 0),
                color: Colors.black38,
                child: FutureBuilder(
                future: futureController,
                builder: (context,snapshot){
                  if(snapshot.connectionState == ConnectionState.done){
                    return VideoPlayer(controller);
                  }else{
                    return Image(
                      image: AssetImage("assets/logo1.jpg"),
                    );
                  }
                },
              )
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
                  Padding(padding: EdgeInsets.only(left: 5.0),),
                  Container(
                    child: MaterialButton(
                      onPressed: (){
                        setState(() {
                        if(controller.value.isPlaying){
                          controller.pause();
                        }else{
                          controller.play();
                        }
                       });                       
                      },
                      child: Icon(
                        (controller.value.isPlaying ? Icons.pause : Icons.play_arrow),color: Colors.white,
                      ),
                    ),
                    width: 110.0,
                  ),
                  Padding(padding: EdgeInsets.only(left: 7.0),),
                  Container(
                    child: MaterialButton(
                      onPressed: (){},
                      child: Icon(Icons.share,color: Colors.white,),
                    ),
                    width: 110.0,
                  ),
                  Padding(padding: EdgeInsets.only(left: 7.0),),
                  Container(
                    child: MaterialButton(
                      onPressed: (){
                        if(this.is_liked == false){
                          setState(() {
                            this.is_liked = true;
                          });
                          int temp_likes = my_likes + 1;
                            Firestore.instance
                                .collection('videos')
                                .document(my_docID)
                                .updateData({
                                  "urlLink" : my_url,
                                  "title" : my_title,
                                  "likes" : temp_likes,
                                })
                                .catchError((e){
                                 print(e);
                                });
                        }else{
                          setState(() {
                            this.is_liked = false;
                          });
                          int temp_likes = my_likes ;
                            Firestore.instance
                                .collection('videos')
                                .document(my_docID)
                                .updateData({
                                  "urlLink" : my_url,
                                  "title" : my_title,
                                  "likes" : my_likes,
                                })
                                .catchError((e){
                                 print(e);
                                });
                        }

                      },
                      child: ((is_liked)
                      ?Icon(Icons.thumb_down,color: Colors.white,)
                      :Icon(Icons.thumb_up,color: Colors.white,)),
                    ),
                    width: 110.0,
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 2.0),),
            Container(
              margin: EdgeInsets.fromLTRB(2.0, 0, 2.0, 0),
              height: 30.0,
              color: Colors.lightBlue,
              child: MaterialButton(
                onPressed: (){},
                child: Center(child: Text("Comments",style: TextStyle(fontSize: 20.0,color: Colors.white),)),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(2.0, 0, 2.0, 0),
                
                color: Colors.blueGrey,
                child: ((comments_jai!=null)
                ?ListView.builder(
                  itemCount: comments_jai.documents.length,
                  itemBuilder: (context,position){
                    return Container(
                      height: 40.0,
                      margin: EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
                      child: Center(
                        child: Text(comments_jai.documents[position].data["details"],
                        style: TextStyle(fontSize: 17.0,color: Colors.white),),
                      ),
                    );
                  },
                )
                :Text("Loading")),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        onPressed: (){
          //insert the comment
          infoDialog(context,my_title);
          crudObj.getComments(my_title).then((results){
                setState(() {
                  this.comments_jai = results;
                  
                });
              });
          setState(() {
            this.comments_jai = crudObj.getComments(my_title);
            this.new_doc_id = comments_jai.documents.length;
          });    
        },
        child: Icon(Icons.add_comment,color: Colors.white,),
      ),
    );
  }
  //dialog UI for comment addition
  Future<bool> infoDialog(BuildContext context,String tempTitle){
    String comment_new;
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context){
        return AlertDialog(
          
          title: Text("Add Comment",style: TextStyle(color: Colors.blue),),
          content: TextField(
                decoration: InputDecoration(hintText: "Enter the commment"),
                onSubmitted: (String str){
                  comment_new = str;
                },
              ),
          actions: <Widget>[
            FlatButton(
              child: Text("Add"),
              onPressed: (){
                new_doc_id=new_doc_id+1;
                //adding new comment to databse
                Firestore.instance.collection(tempTitle).document("$new_doc_id").setData({"details":comment_new});        
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }
}


