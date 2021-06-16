import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterflashchatapp/Chat/message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder <QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('chat').orderBy('createdAt',descending: true).snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.hasError) {
          return Text("Something went wrong");
        }
        if(!chatSnapshot.hasData)
        {
            return Center (child: CircularProgressIndicator(),);
        }
        if(chatSnapshot.connectionState==ConnectionState.waiting)
        {
            return Center (child: CircularProgressIndicator(),);
        }
        final loggedInId = FirebaseAuth.instance.currentUser!.uid;
        final screenWidth=MediaQuery.of(context).size.width;
        //print(loggedInId);
        return ListView.builder(
          reverse: true,
          itemBuilder: (ctx,index) {
            //print(chatSnapshot.data!.docs[index]['userId']);
          return MessageBubble(messageText:chatSnapshot.data!.docs[index]['text'],isMe:(chatSnapshot.data!.docs[index]['userId']==loggedInId)? true:false,userName: chatSnapshot.data!.docs[index]['userName'],imageURL:chatSnapshot.data!.docs[index]['userImage'],screenWidth:screenWidth);
        },itemCount: chatSnapshot.data!.size,);
      },
    );
  }
}
