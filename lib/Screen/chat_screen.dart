import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterflashchatapp/Chat/messages.dart';
import 'package:flutterflashchatapp/Chat/new_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FlashChat'),
        centerTitle: true,
        actions: <Widget>[
            GestureDetector(
              onTap: (){
                FirebaseAuth.instance.signOut();
              },
              child: Icon(
                Icons.logout,
              ),
            )
        ],
      ),
      body: SafeArea(child: Container(
        child: Column(
          children: <Widget>[
            Expanded(child: Messages(),),
            NewMessage(),
          ],
        ),
      ),),
    );
  }
}
