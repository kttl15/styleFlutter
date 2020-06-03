import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gan2/new_process/bloc/upload_bloc.dart';
import 'package:gan2/new_process/choose_image.dart';
import 'package:gan2/new_process/upload_button.dart';

class AdvanceNewProcess extends StatefulWidget {
  final FirebaseUser user;
  final double textScale;

  const AdvanceNewProcess(
      {Key key, @required this.user, @required this.textScale})
      : super(key: key);
  @override
  _AdvanceNewProcessState createState() => _AdvanceNewProcessState();
}

class _AdvanceNewProcessState extends State<AdvanceNewProcess> {
  File _contentImage;
  File _styleImage;
  String _processName = '';
  double _contentWeight = 1;
  double _styleWeight = 1;
  String _epoch;
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
      epoch: int.parse(_epoch),
      runOnUpload: _uploadRadioButton,
    ));
  }

  bool _validateUploadState() {
    //* ensures that process name and both images are present
    return _processName.length >= 4 &&
        _styleImage != null &&
        _contentImage != null &&
        _validateEpoch();
  }

  bool _validateEpoch() {
    if (_epoch != '' &&
        RegExp(r'^[0-9]*$').hasMatch(_epoch.toString()) &&
        int.parse(_epoch) >= 1 &&
        int.parse(_epoch) <= 20)
      return true;
    else
      return false;
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
                  title: Text(
                    'Info',
                    textScaleFactor: widget.textScale,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  content: Text(
                    toolTip,
                    textScaleFactor: widget.textScale,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                );
              });
        },
        child: Text(
          text,
          textScaleFactor: widget.textScale,
          softWrap: true,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .subtitle1
              .copyWith(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  bool _isValidProcessChar(String val) {
    return RegExp(r'^[a-zA-Z0-9\s]*$').hasMatch(val);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UploadBloc, UploadState>(
      listener: (context, state) {
        if (state is Completed) {
          // _showSnackBar(text: 'Done');
          Flushbar(
            message: 'Done!',
            duration: Duration(seconds: 2),
          );
        }
        if (state is InProgress && showUploadingSnackBar) {
          // _showSnackBar(text: 'Uploading. Do Not Exit', seconds: 2);
          Flushbar(
            message: 'Uploading. Do Not Exit',
            duration: Duration(seconds: 2),
          );
          setState(() {
            showUploadingSnackBar = false;
          });
        }
        if (state is ProcessNameUsedState) {
          // _showSnackBar(text: 'Invalid Process Name');
          Flushbar(
            message: 'Invalid Process Name',
            duration: Duration(seconds: 2),
          );
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
            padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    autovalidate: true,
                    enabled: !_uploadLoading,
                    validator: (String val) {
                      val = val.trim();
                      if (_isProcessNameUsed) {
                        return 'You already have this process name. Please choose another.';
                      } else if (!_isValidProcessChar(val)) {
                        return 'Invalid Character Entered';
                      } else if (val.length <= 3) {
                        return 'Enter a Process Name of Length >= 4';
                      } else
                        return null;
                    },
                    onChanged: (String val) {
                      setState(() {
                        _isProcessNameUsed = false;
                        _processName = val.trim();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter a Process Name',
                      hintStyle: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontWeight: FontWeight.w300,
                          ),
                    ),
                  ),
                  Divider(
                    indent: 32,
                    endIndent: 32,
                    color: Colors.grey[200],
                    thickness: 1,
                    height: 40,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).accentColor,
                    ),
                    height: 80,
                    child: Center(
                      child: ListTile(
                        enabled: !_uploadLoading,
                        leading: _contentImage != null
                            ? Image.file(
                                _contentImage,
                                width: 80,
                              )
                            : Container(
                                child: Icon(
                                  Icons.image,
                                  size: 60,
                                ),
                                width: 80,
                              ),
                        title: Text(
                          'Content Image',
                          style: Theme.of(context).textTheme.headline4,
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
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).accentColor,
                    ),
                    height: 80,
                    child: Center(
                      child: ListTile(
                        enabled: !_uploadLoading,
                        leading: _styleImage != null
                            ? Image.file(
                                _styleImage,
                                width: 80,
                              )
                            : Container(
                                width: 80,
                                child: Icon(
                                  Icons.image,
                                  size: 60,
                                ),
                              ),
                        title: Text(
                          'Style Image',
                          style: Theme.of(context).textTheme.headline4,
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
                    height: 12,
                  ),
                  Divider(
                    indent: 32,
                    endIndent: 32,
                    color: Colors.grey[200],
                    thickness: 1,
                    height: 20,
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
                            activeColor: Colors.blue,
                            inactiveColor: Colors.blue,
                            value: _contentWeight,
                            onChanged: (val) {
                              _looseKeyboardFocus();
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
                            activeColor: Colors.blue,
                            inactiveColor: Colors.blue,
                            value: _styleWeight,
                            onChanged: (val) {
                              _looseKeyboardFocus();
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
                          toolTip:
                              'Determines how long the process is carried out.'),
                      Expanded(
                        child: TextFormField(
                          enabled: !_uploadLoading,
                          keyboardType: TextInputType.number,
                          autovalidate: true,
                          decoration: InputDecoration(
                            hintText: "Enter a Duration from 1 - 20",
                            hintStyle:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      fontWeight: FontWeight.w300,
                                    ),
                          ),
                          validator: (val) {
                            if (val == '') return 'Please Enter a Duration';
                            if (!_validateEpoch())
                              return "Invalid Input";
                            else
                              return null;
                          },
                          onChanged: (String val) {
                            setState(() {
                              _epoch = val;
                            });
                          },
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
                              _looseKeyboardFocus();
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
                              _looseKeyboardFocus();
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
                  Divider(
                    indent: 32,
                    endIndent: 32,
                    color: Colors.grey[200],
                    thickness: 1,
                    height: 10,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (state is Initial || state is ProcessNameUsedState)
                    if (_uploadLoading)
                      Container(
                        width: 40,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else
                      Container(
                        width: 150,
                        child: UploadButton(
                          onPressed: _validateUploadState() ? _onUpload : null,
                        ),
                      )
                  else if (state is InProgress)
                    Column(
                      children: <Widget>[
                        // LinearProgressIndicator(
                        //   value: state.progressPct(),
                        // ),
                        Text('Progress: ${state.progressPct()}'),
                        // Text('State: ${state.progressState()}'),
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
                        Navigator.pop(context);
                      },
                    ),
                  SizedBox(height: 100)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
