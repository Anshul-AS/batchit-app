import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

//methods file
class crudMethods{
//getting all comments for a particular title video
  Future<void> addComment(String title,Map commentData) async {
    Firestore.instance.collection(title).add(commentData).catchError((e){
      print(e);
    });
  }
//getting all videos
  getData() async {
    return await Firestore.instance.collection('videos').getDocuments();
  }
//getting all group messages
  getMessages() async {
    return await Firestore.instance.collection('groupChat').getDocuments();
  }
//getting all comments
  getComments(String title) async {
    return await Firestore.instance.collection(title).getDocuments();
  }
//for updating likes of a video
  updateData(selectedDoc, newValues){
    Firestore.instance
        .collection('videos')
        .document(selectedDoc)
        .updateData(newValues)
        .catchError((e){
          print(e);
        });
  }
}