import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gan2/new_process/bloc/upload_bloc.dart';
import 'dart:io';

import 'package:gan2/new_process/choose_image.dart';
import 'package:gan2/new_process/upload_button.dart';

class NewProcessForm extends StatefulWidget {
  final FirebaseUser user;

  const NewProcessForm({Key key, @required this.user}) : super(key: key);
  @override
  _NewProcessFormState createState() => _NewProcessFormState();
}

class _NewProcessFormState extends State<NewProcessForm> {
  File _contentImage;
  File _styleImage;
  String _processName = '';
  double _contentWeight = 1;
  double _styleWeight = 1;
  double _epoch = 1;
  bool showUploadingSnackBar = true;
  bool _uploadRadioButton = true;
  bool _uploadLoading = false;
  bool _isProcessNameUsed = false;

  Future<File> _chooseImage(BuildContext context) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChooseImage(),
      ),
    );
  }

  void _looseKeyboardFocus() {
    //* minimize keyboard
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  void _onUpload() async {
    //* upload images and data
    setState(() {
      _uploadLoading = true;
    });
    _looseKeyboardFocus();
    BlocProvider.of<UploadBloc>(context).add(StartUpload(
      uid: widget.user.uid,
      contentFile: _contentImage,
      processName: _processName,
      styleFile: _styleImage,
      contentWeight: _contentWeight,
      styleWeight: _styleWeight,
      epoch: _epoch,
      runOnUpload: _uploadRadioButton,
    ));
  }

  bool _validUploadState() {
    //* ensures that process name and both images are present
    return _processName.length >= 4 &&
        _styleImage != null &&
        _contentImage != null;
  }

  ScaffoldState _showSnackBar({String text}) {
    return Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(text),
        duration: Duration(seconds: 2),
      ));
  }

  Widget _customText({
    @required String text,
    @required String toolTip,
  }) {
    return Container(
      width: 90,
      child: FlatButton(
        padding: EdgeInsets.all(0),
        onPressed: () {
          showDialog(
              context: context,
              builder: (content) {
                return AlertDialog(
                  title: Text('Info'),
                  content: Text(toolTip),
                );
              });
        },
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  bool _isValidProcessChar(String val) {
    return RegExp(r'^[a-zA-Z0-9]*$').hasMatch(val);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UploadBloc, UploadState>(
      listener: (context, state) {
        if (state is Completed) {
          _showSnackBar(text: 'Done');
        }
        if (state is InProgress && showUploadingSnackBar) {
          _showSnackBar(text: 'Uploading');
          setState(() {
            showUploadingSnackBar = false;
          });
        }
        if (state is ProcessNameUsedState) {
          _showSnackBar(text: 'Invalid Process Name');
          setState(() {
            _uploadLoading = false;
            _isProcessNameUsed = true;
          });
          BlocProvider.of<UploadBloc>(context).add(RevertToInit());
        }
      },
      child: BlocBuilder<UploadBloc, UploadState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.fromLTRB(30, 100, 30, 0),
            child: ListView(
              children: <Widget>[
                TextFormField(
                  autovalidate: true,
                  validator: (String val) {
                    //TODO: implement a more robust validator
                    if (_isProcessNameUsed) {
                      return 'You already have this process name. Please choose another.';
                    } else if (!_isValidProcessChar(val)) {
                      return 'Invalid Character Entered';
                    } else if (val.length <= 3) {
                      return 'Enter A Process Name of Length >= 4';
                    } else
                      return null;
                  },
                  onChanged: (val) {
                    setState(() {
                      _isProcessNameUsed = false;
                      _processName = val.trim();
                    });
                  },
                  decoration: InputDecoration(hintText: 'Enter a Process Name'),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  color: Colors.grey[300],
                  height: 80,
                  child: Center(
                    child: ListTile(
                      leading: _contentImage != null
                          ? Image.file(_contentImage)
                          : Icon(Icons.image),
                      title: Text(
                        'Content Image',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      onTap: () async {
                        _looseKeyboardFocus();
                        File result = await _chooseImage(context);
                        if (result != null) {
                          setState(() {
                            _contentImage = result;
                          });
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  color: Colors.grey[300],
                  height: 80,
                  child: Center(
                    child: ListTile(
                      leading: _styleImage != null
                          ? Image.file(_styleImage)
                          : Icon(Icons.image),
                      title: Text(
                        'Style Image',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      onTap: () async {
                        _looseKeyboardFocus();
                        File result = await _chooseImage(context);
                        if (result != null) {
                          setState(() {
                            _styleImage = result;
                          });
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    _customText(
                        text: 'Content Weight: ',
                        toolTip:
                            'Determines how much of the content image is used.'),
                    Expanded(
                      child: SliderTheme(
                        data: SliderThemeData(),
                        child: Slider(
                          label: _contentWeight.round().toString(),
                          divisions: 9,
                          min: 1,
                          max: 10,
                          activeColor: Colors.cyan,
                          inactiveColor: Colors.blue,
                          value: _contentWeight,
                          onChanged: (val) {
                            setState(() {
                              _contentWeight = val;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    _customText(
                        text: 'Style Weight: ',
                        toolTip:
                            'Determines how much of the style image is used.'),
                    Expanded(
                      child: SliderTheme(
                        data: SliderThemeData(),
                        child: Slider(
                          label: _styleWeight.round().toString(),
                          divisions: 9,
                          min: 1,
                          max: 10,
                          activeColor: Colors.cyan,
                          inactiveColor: Colors.blue,
                          value: _styleWeight,
                          onChanged: (val) {
                            setState(() {
                              _styleWeight = val;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    _customText(
                        text: 'Duration: ',
                        toolTip: 'Determines how long training is done.'),
                    Expanded(
                      child: SliderTheme(
                        data: SliderThemeData(),
                        child: Slider(
                          label: _epoch.round().toString(),
                          divisions: 9,
                          min: 1,
                          max: 10,
                          activeColor: Colors.cyan,
                          inactiveColor: Colors.blue,
                          value: _epoch,
                          onChanged: (val) {
                            setState(() {
                              _epoch = val;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    _customText(
                        text: 'Run On Upload?',
                        toolTip:
                            'Determines whether or not to run the process automatically after uploading.'),
                    Expanded(
                      child: ListTile(
                        leading: Radio(
                          value: true,
                          groupValue: _uploadRadioButton,
                          onChanged: (val) {
                            setState(() {
                              _uploadRadioButton = val;
                            });
                          },
                        ),
                        title: Text(
                          'Yes',
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        leading: Radio(
                          value: false,
                          groupValue: _uploadRadioButton,
                          onChanged: (val) {
                            setState(() {
                              _uploadRadioButton = val;
                            });
                          },
                        ),
                        title: Text(
                          'No',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                if (state is Initial || state is ProcessNameUsedState)
                  if (_uploadLoading)
                    //TODO: optimise
                    Container(
                      width: 20,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else
                    UploadButton(
                      onPressed: _validUploadState() ? _onUpload : null,
                    )
                else if (state is InProgress)
                  Column(
                    children: <Widget>[
                      LinearProgressIndicator(
                        value: state.progressPct(),
                      ),
                      Text('Progress: ${state.progressPct()}'),
                      Text('State: ${state.progressState()}'),
                    ],
                  )
                else if (state is Completed)
                  RaisedButton(
                    color: Colors.green[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('Done'),
                    onPressed: () {
                      // BlocProvider.of<ListViewBloc>(context).add(RefreshData());
                      Navigator.pop(context);
                    },
                  ),
                SizedBox(height: 100)
              ],
            ),
          );
        },
      ),
    );
  }
}
