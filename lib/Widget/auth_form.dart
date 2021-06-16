import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutterflashchatapp/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading);

  final bool isLoading;
  late final void Function(String email, String password, String username,File userImage ,bool isLogin, BuildContext ctx) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  bool _isLogged = true;
  var _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLogged) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: Text('Select an image'),
        ),
      );
      return;
    }

    if (isValid && _userImageFile != null) {
      _formKey.currentState!.save();
      print(_userEmail);
      print(_userName);
      print(_userPassword);
      widget.submitFn(_userEmail.trim(), _userPassword.trim(), _userName.trim(),_userImageFile, _isLogged, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
      margin: EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (!_isLogged) UserImagePicker(_pickedImage),
                TextFormField(
                  key: ValueKey('email'),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                  ),
                  validator: (String? value) {
                    return (value != null && value.contains('@'))
                        ? null
                        : 'Please enter a valid email address';
                  },
                  onSaved: (value) {
                    _userEmail = value!;
                  },
                ),
                if (!_isLogged)
                  TextFormField(
                    key: ValueKey('name'),
                    decoration: InputDecoration(
                      labelText: 'Username',
                    ),
                    validator: (String? value) {
                      return (value != null && value.length > 4)
                          ? null
                          : 'Please enter at least 4 characters ';
                    },
                    onSaved: (value) {
                      _userName = value!;
                    },
                  ),
                TextFormField(
                  key: ValueKey('password'),
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  validator: (String? value) {
                    return (value != null && value.length > 7)
                        ? null
                        : 'Password must be at least 7 characters';
                  },
                  onSaved: (value) {
                    _userPassword = value!;
                  },
                ),
                SizedBox(
                  height: 12.0,
                ),
                if (widget.isLoading) CircularProgressIndicator(),
                if (!widget.isLoading)
                  ElevatedButton(
                    onPressed: () {
                      _trySubmit();
                    },
                    child: Text(_isLogged ? 'Login' : 'Sign Up'),
                  ),
                if (!widget.isLoading)
                  TextButton(
                    style: TextButton.styleFrom(
                        primary: Theme.of(context).primaryColor),
                    onPressed: () {
                      setState(() {
                        _isLogged = !_isLogged;
                      });
                    },
                    child: Text(_isLogged
                        ? 'Create new account'
                        : 'I already have an account'),
                  )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
