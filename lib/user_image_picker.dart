import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickerFunction);

  final void Function(File pickedImage) imagePickerFunction;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _image;

  void _pickImage() async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      imageQuality: 60,
      maxWidth: 400,
      maxHeight: 400,
    );
    setState(() {
      _image = File(pickedFile!.path);
    });
    widget.imagePickerFunction(File(pickedFile!.path));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 40.0,
          backgroundColor: Colors.grey,
          backgroundImage: _image != null ? FileImage(_image!) : null,
        ),
        TextButton.icon(
          style: TextButton.styleFrom(primary: Theme.of(context).primaryColor),
          onPressed: () {
            _pickImage();
          },
          icon: Icon(Icons.image),
          label: Text('Add Image'),
        ),
      ],
    );
  }
}
