//UI for group chat
//methods for retreving previous messages and inserting neew message

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'user.dart';
import 'universal_variables.dart';
import 'appbar.dart';
import 'custom_tile.dart';
import 'dart:async';

class ChatScreen extends StatefulWidget {
  final User receiver;
  final String thisUser;
  ChatScreen(this.receiver,this.thisUser);

  @override
  _ChatScreenState createState() => _ChatScreenState(this.receiver,this.thisUser);
}

class _ChatScreenState extends State<ChatScreen> {
  final User receiver;
  final String thisUser;
  _ChatScreenState(this.receiver,this.thisUser);

  //query snapshot
  QuerySnapshot messages_jai;
  //for adding new messages
  String typed_message;
  int new_doc_id;

  TextEditingController textFieldController = TextEditingController();

  bool isWriting = false;

  getmesafunc() async {
    return await Firestore.instance.collection('groupChat').getDocuments();
  } 

  @override
  void initState(){
    getmesafunc().then((results){
      setState(() {
        messages_jai=results;
        this.new_doc_id = messages_jai.documents.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppBar(context),
      body: Column(
        children: <Widget>[
          //message appear in this section
          Flexible(
            child: messageList(),
          ),
          //control pannel for adding messages
          chatControls(),
        ],
      ),
    );
  }

  Widget messageList() {
    if(messages_jai!=null){
      return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: messages_jai.documents.length,
      itemBuilder: (context, index) {
        return chatMessageItem(messages_jai.documents[index].data["mUser"],messages_jai.documents[index].data["mMessage"]);
      },
    );
    }else{
      return Center(child: CircularProgressIndicator());
    }
  }

  Widget chatMessageItem(String username,String detailmessage) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Container(
        //for detailing messages right or left
        alignment:((username==thisUser)
        ?Alignment.centerRight
        :Alignment.centerLeft), 
        
        child: ((username==thisUser)
        ?senderLayout(detailmessage)
        :receiverLayout(detailmessage,username)),
      ),
    );
  }
//if message is from same user then this layout
  Widget senderLayout(String message) {
    Radius messageRadius = Radius.circular(10);

    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: Colors.lightBlue,
        borderRadius: BorderRadius.only(
          topLeft: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
//if message is from other users then this layout
  Widget receiverLayout(String message,String senduser) {
    Radius messageRadius = Radius.circular(10);

    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          bottomRight: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(10,4,10,10),
        child: Column(
          children: <Widget>[
            Text(senduser,style: TextStyle(color: Colors.white,fontSize: 10)),
            Padding(padding: EdgeInsets.all(2.0),),
            Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chatControls() {
    setWritingTo(bool val,String messageTyped) {
      setState(() {
        isWriting = val;
        this.typed_message = messageTyped;
      });
    }

    addMediaModal(context) {
      showModalBottomSheet(
          context: context,
          elevation: 0,
          backgroundColor: UniversalVariables.blackColor,
          builder: (context) {
            return Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: <Widget>[
                      FlatButton(
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Content and tools",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView(
                    children: <Widget>[
                      ModalTile(
                        title: "Media",
                        subtitle: "Share Photos and Video",
                        icon: Icons.image,
                      ),
                      ModalTile(
                        title: "File",
                        subtitle: "Share files",
                        icon: Icons.tab),
                    ModalTile(
                        title: "Contact",
                        subtitle: "Share contacts",
                        icon: Icons.contacts),
                    ModalTile(
                        title: "Location",
                        subtitle: "Share a location",
                        icon: Icons.add_location),
                    ModalTile(
                        title: "Schedule Call",
                        subtitle: "Arrange a video call and get reminders",
                        icon: Icons.schedule),
                    ModalTile(
                        title: "Create Poll",
                        subtitle: "Share polls",
                        icon: Icons.poll)
                    ],
                  ),
                ),
              ],
            );
          });
    }

    return Container(
      
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => addMediaModal(context),
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                gradient: UniversalVariables.fabGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add,color:Colors.white,),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: TextField(
              controller: textFieldController,
              style: TextStyle(
                color: Colors.white,
              ),
              onChanged: (val) {
                (val.length > 0 && val.trim() != "")
                    ? setWritingTo(true,val)
                    : setWritingTo(false,val);
              },
              decoration: InputDecoration(
                hintText: "Type a message",
                hintStyle: TextStyle(
                  color: Colors.white,
                ),
                border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(50.0),
                    ),
                    borderSide: BorderSide.none),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                filled: true,
                fillColor: UniversalVariables.separatorColor,
                suffixIcon: GestureDetector(
                  onTap: () {},
                  child: Icon(Icons.face,color: Colors.lightBlue,),
                ),
              ),
            ),
          ),
          isWriting
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.record_voice_over,color: Colors.lightBlue,),
                ),
          isWriting ? Container() : Icon(Icons.camera_alt,color: Colors.lightBlue,),
          isWriting
              ? Container(
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      gradient: UniversalVariables.fabGradient,
                      shape: BoxShape.circle),
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 15,
                    ),
                    onPressed: () {
                      new_doc_id=new_doc_id+1;
                      Firestore.instance.collection("groupChat").document("$new_doc_id").setData({"mUser":thisUser,"mMessage":typed_message});      

                      setState(() {
                        this.isWriting=false;
                      });
                      getmesafunc().then((results){
                        setState(() {
                          this.messages_jai = results;
                          this.new_doc_id = messages_jai.documents.length;
                        });
                      });
                    },
                  ))
              : Container()
        ],
      ),
    );
  }



    //app bar     
  CustomAppBar customAppBar(context) {
    return CustomAppBar(
      
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: false,
      title: Text(
        widget.receiver.name,
        style: TextStyle(color: Colors.white),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.video_call,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(
            Icons.refresh,
            color: Colors.white,
          ),
          onPressed: () {
            getmesafunc().then((results){
      setState(() {
        messages_jai=results;
        this.new_doc_id = messages_jai.documents.length;
      });
    });
          },
        )
      ],
    );
  }
}
//common class for tiles
class ModalTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const ModalTile({
    @required this.title,
    @required this.subtitle,
    @required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: CustomTile(
        mini: false,
        leading: Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: UniversalVariables.receiverColor,
          ),
          padding: EdgeInsets.all(10),
          child: Icon(
            icon,
            color: UniversalVariables.greyColor,
            size: 38,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: UniversalVariables.greyColor,
            fontSize: 14,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}