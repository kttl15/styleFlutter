import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ChooseImage extends StatefulWidget {
  @override
  _ChooseImageState createState() => _ChooseImageState();
}

class _ChooseImageState extends State<ChooseImage> {
  File _imageFile;

  Future<void> _cropImage(File _image) async {
    File _croppedImage = await ImageCropper.cropImage(
      compressFormat: ImageCompressFormat.jpg,
      sourcePath: _image.path,
      androidUiSettings: AndroidUiSettings(
          toolbarColor: Colors.purple,
          toolbarWidgetColor: Colors.white,
          toolbarTitle: 'Crop'),
    );
    setState(() {
      _imageFile = _croppedImage ?? _imageFile;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    File _image = await ImagePicker.pickImage(source: source);
    setState(() {
      _imageFile = _image;
    });
  }

  void _clear() {
    setState(() {
      _imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    //TODO: optimise layout

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: () {
                _pickImage(ImageSource.camera);
              },
            ),
            IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: () {
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
      body: ListView(
        children: <Widget>[
          if (_imageFile != null) ...[
            Image.file(_imageFile),
            Row(
              children: <Widget>[
                FlatButton(
                  child: Icon(Icons.crop),
                  onPressed: () {
                    _cropImage(_imageFile);
                  },
                ),
                FlatButton(
                  //TODO: change icon
                  child: Icon(Icons.refresh),
                  onPressed: () {
                    _clear();
                  },
                ),
                FlatButton(
                  child: Icon(Icons.check),
                  onPressed: () {
                    Navigator.pop(context, _imageFile);
                  },
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
