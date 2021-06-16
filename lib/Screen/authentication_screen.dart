import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterflashchatapp/Widget/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading=false;

  void _submitAuthForm(String email, String password, String username,File userImage,bool isLogin, BuildContext ctx) async {
    var authResult;
    try {
      setState(() {
        _isLoading=true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        ////
        // var url='';
        // try{
        //   final ref=FirebaseStorage.instance.ref().child('user_image').child(authResult.user.uid+'.jpg');
        //   ref.putFile(userImage).whenComplete(() => null);
        //   url=await ref.getDownloadURL();
        // }catch(e){
        //   Scaffold.of(ctx).removeCurrentSnackBar();
        //   Scaffold.of(ctx).showSnackBar(SnackBar(
        //     content: Text('Something went wrong try again later !'),
        //     backgroundColor: Theme.of(ctx).errorColor,
        //   ));
        // }
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(authResult.user.uid + '.jpg');

        await ref.putFile(userImage);

        final url = await ref.getDownloadURL();
        print('Hello');
        print(url);


        await FirebaseFirestore.instance.collection('users').doc(authResult.user.uid).set({'username': username, 'email': email,'image_url':url},);
      }
      setState(() {
        _isLoading=false;
      });
    } on PlatformException catch (error) {
      var message = 'An error occurred,Please check your credentials';
      if (error.message != null) message = error.message!;
      Scaffold.of(ctx).removeCurrentSnackBar();
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
      setState(() {
        _isLoading=false;
      });
    } catch (error) {
      print(error);
      Scaffold.of(ctx).removeCurrentSnackBar();
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text('Something went wrong try again later !'),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
      setState(() {
        _isLoading=false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: AuthForm(_submitAuthForm,_isLoading),
        ));
  }
}
