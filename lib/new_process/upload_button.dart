import 'package:flutter/material.dart';

class UploadButton extends StatelessWidget {
  final VoidCallback _onPressed;

  const UploadButton({Key key, VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
        icon: Icon(Icons.cloud_upload),
        label: Text('Upload'),
        color: Colors.blue[300],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: _onPressed);
  }
}
