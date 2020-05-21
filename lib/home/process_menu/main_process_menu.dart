import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gan2/home/process_menu/bloc/processMenu_bloc.dart';
import 'package:gan2/model/data.dart';
import 'package:path_provider/path_provider.dart' as pPath;

class ProcessMenu extends StatefulWidget {
  final OutputData _data;
  const ProcessMenu({Key key, data})
      : assert(data != null),
        _data = data,
        super(key: key);

  @override
  _ProcessMenuState createState() => _ProcessMenuState();
}

class _ProcessMenuState extends State<ProcessMenu> {
  final Directory tempDir = Directory.systemTemp;
  ProcessMenuBloc _processTileBloc;
  File iconContentFile;
  File iconStyleFile;
  List<File> iconOutputFiles = List<File>();

  @override
  void initState() {
    _processTileBloc = BlocProvider.of<ProcessMenuBloc>(context);
    _processTileBloc.add(DownloadImagesEvent(data: widget._data));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProcessMenuBloc, ProcessMenuState>(
      listener: (context, state) {
        if (state is ImageDownloadedState) {
          iconContentFile = File(
              '${tempDir.path}/${widget._data.uid}${widget._data.processName}_iconContent.jpg');
          iconStyleFile = File(
              '${tempDir.path}/${widget._data.uid}${widget._data.processName}_iconStyle.jpg');

          if (widget._data.isProcessed) {
            widget._data.locOutputs.forEach((key, value) {
              List<String> outputNameList = value.split('/').toList();
              String outputName = outputNameList[outputNameList.length - 1];
              File tempFile = File(
                  '${tempDir.path}/${widget._data.uid}${widget._data.processName}_$outputName');
              iconOutputFiles.add(tempFile);
            });
          }
        }
        return true;
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Process Name: ${widget._data.processName}',
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 40, 20, 10),
              child: Column(
                children: <Widget>[
                  if (state is ImageDownloadedState)
                    Column(
                      children: <Widget>[
                        Row(children: <Widget>[
                          Expanded(
                            child: Image.file(
                              iconContentFile,
                              // height: 200,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Image.file(
                            iconStyleFile,
                            // height: 200,
                          )),
                        ]),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Center(
                                  child: Text(
                                'Content Image',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              )),
                            ),
                            Expanded(
                              child: Center(
                                  child: Text(
                                'Style Image',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              )),
                            )
                          ],
                        ),
                      ],
                    )
                  else
                    Container(
                      height: 200,
                      child: Row(children: <Widget>[
                        Expanded(
                            child: Center(child: CircularProgressIndicator())),
                        Expanded(
                            child: Center(child: CircularProgressIndicator())),
                      ]),
                    ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Content Weight: ${widget._data.contentWeight.round()}',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Style Weight: ${widget._data.styleWeight.round()}',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Duration: ${widget._data.epoch.round()}',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'RunOnUpload: ${widget._data.runOnUpload}',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  if (state is ImageDownloadedState && widget._data.isProcessed)
                    _outputWidget()
                  else
                    Container()
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _outputWidget() {
    List<Widget> list = List<Widget>();
    int i = 1;
    iconOutputFiles.sort((a, b) => a.path.compareTo(b.path));
    iconOutputFiles.forEach((File file) {
      list.add(FlatButton(
        onLongPress: () {
          print('a');
          _showLongPressOptions(file: file);
        },
        onPressed: null,
        child: Image.file(file),
      ));
      list.add(SizedBox(height: 10));
      list.add(Text(
        'Output $i',
        style: TextStyle(fontSize: 16),
      ));
      list.add(Text(file.path.split('_')[2]));
      list.add(SizedBox(height: 10));
      i++;
    });
    return Column(children: list);
  }

  void _saveFile(File file) async {
    final Directory saveDir = await pPath.getExternalStorageDirectory();
    final File savePath = File('${saveDir.path}/${widget._data.processName}_' +
        file.path.split('_')[2]);
    print(savePath.path);
    savePath.writeAsBytes(await file.readAsBytes());
    print('saved');
  }

  void _showLongPressOptions({@required File file}) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: <Widget>[
            Container(
              color: Colors.grey[200],
              height: 40,
              child: FlatButton(
                child: Text(
                  'Download Image',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                onPressed: () {
                  _saveFile(file);
                  Navigator.pop(context);
                },
              ),
            ),
            Container(
              color: Colors.grey[200],
              height: 40,
              child: FlatButton(
                child: Text(
                  'Share Image',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
