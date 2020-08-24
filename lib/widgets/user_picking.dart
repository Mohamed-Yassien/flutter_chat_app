import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserPicking extends StatefulWidget {

  UserPicking(this.pickImageFn);
  final void Function(File image) pickImageFn;

  @override
  _UserPickingState createState() => _UserPickingState();
}

class _UserPickingState extends State<UserPicking> {
  File _image;

  void _pickImage() async {
    final pickedImageFile = await ImagePicker.pickImage(source: ImageSource.gallery,imageQuality: 50,maxWidth: 150);
    setState(() {
      _image = pickedImageFile;
    });
    widget.pickImageFn(pickedImageFile);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: _image != null ? FileImage(_image) : null,
        ),
        FlatButton.icon(
          textColor: Theme.of(context).primaryColor,
          onPressed: _pickImage,
          icon: Icon(Icons.image),
          label: Text('pick an image'),
        ),
      ],
    );
  }
}
