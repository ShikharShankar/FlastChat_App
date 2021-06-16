import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  TextEditingController messageController = TextEditingController();

  void _sendMessage()  async{
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    print(user);
    final userData = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    print(userData['username']);
    FirebaseFirestore.instance.collection('chat').add(
      {
        'text': messageController.text,
        'createdAt': Timestamp.now(),
        'userId': user.uid,
        'userName' : userData['username'],
        'userImage': userData['image_url'],
      },
    );
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              decoration: InputDecoration(labelText: 'Send a Message ...'),
              controller: messageController,
            ),
          ),
          IconButton(
            onPressed: () {
              //print(messageController.text);
              _sendMessage();
            },
            icon: Icon(Icons.send),
            color: Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }
}
