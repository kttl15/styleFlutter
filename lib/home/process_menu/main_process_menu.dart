import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gan2/home/process_menu/bloc/download_image_bloc.dart';
import 'package:gan2/home/process_menu/process_image.dart';
import 'package:gan2/model/data.dart';
import 'package:path_provider/path_provider.dart' as pPath;

class MainProcessMenu extends StatefulWidget {
  final OutputData _data;
  final double textScale;
  const MainProcessMenu({Key key, @required data, @required this.textScale})
      : assert(data != null),
        _data = data,
        super(key: key);

  @override
  _MainProcessMenuState createState() => _MainProcessMenuState();
}

class _MainProcessMenuState extends State<MainProcessMenu> {
  final Directory tempDir = Directory.systemTemp;

  @override
  Widget build(BuildContext context) {
    File iconContentFile = File(
        '${tempDir.path}/${widget._data.uid}${widget._data.processName}_iconContent.jpg');
    File iconStyleFile = File(
        '${tempDir.path}/${widget._data.uid}${widget._data.processName}_iconStyle.jpg');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Process Name: ${widget._data.processName}',
          textScaleFactor: widget.textScale,
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 40, 20, 10),
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: BlocProvider(
                          create: (context) => DownloadImageBloc(),
                          child: ProcessMenuImage(
                            file: iconContentFile,
                            loc: widget._data.locIconContent,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: BlocProvider(
                          create: (context) => DownloadImageBloc(),
                          child: ProcessMenuImage(
                            file: iconStyleFile,
                            loc: widget._data.locIconStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Center(
                          child: Text(
                            'Content Image',
                            textScaleFactor: widget.textScale,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Style Image',
                            textScaleFactor: widget.textScale,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'Content Weight: ${widget._data.contentWeight.round()}',
                textScaleFactor: widget.textScale,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                'Style Weight: ${widget._data.styleWeight.round()}',
                textScaleFactor: widget.textScale,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                'Duration: ${widget._data.epoch.round()}',
                textScaleFactor: widget.textScale,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              if (widget._data.isProcessed) _outputImageWidget()
            ],
          ),
        ),
      ),
    );
  }

  Widget _outputImageWidget() {
    // returns a column widget which contains a list of output images
    // and their correponding captions.
    List<Widget> list = List<Widget>();
    int i = 1;
    List<dynamic> iconOutputLoc = widget._data.locOutputs.values.toList();
    iconOutputLoc.sort((a, b) => a.compareTo(b));

    iconOutputLoc.forEach((loc) {
      List<String> outputNameList = loc.split('/').toList();
      String outputName = outputNameList[outputNameList.length - 1];
      File outputFile = File(
          '${tempDir.path}/${widget._data.uid}${widget._data.processName}_$outputName');
      list.add(
        FlatButton(
          onLongPress: () {
            print('a');
            _showLongPressOptions(file: outputFile);
          },
          onPressed: null,
          child: BlocProvider(
            create: (context) => DownloadImageBloc(),
            child: ProcessMenuImage(
              file: outputFile,
              loc: loc,
            ),
          ),
        ),
      );

      list.add(SizedBox(height: 10));
      list.add(Text(
        'Output $i',
        textScaleFactor: widget.textScale,
        style: TextStyle(fontSize: 16),
      ));
      list.add(SizedBox(height: 10));
      i++;
    });
    return Column(children: list);
  }

  void _saveFile(BuildContext context, File file) async {
    // saves a given image to a permanent dir
    final Directory saveDir = await pPath.getExternalStorageDirectory();
    final File savePath = File('${saveDir.path}/${widget._data.processName}_' +
        file.path.split('_')[2]);
    savePath.writeAsBytes(await file.readAsBytes());
    Flushbar(
      message: 'saved at ${savePath.path}',
      duration: Duration(seconds: 3),
    )..show(context);
  }

  void _showLongPressOptions({@required File file}) {
    // shows options to save or share the image
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: <Widget>[
            Container(
              color: Colors.grey[200],
              height: 40,
              child: Builder(
                builder: (context) => FlatButton(
                  child: Text(
                    'Download Image',
                    textScaleFactor: widget.textScale,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  onPressed: () {
                    _saveFile(context, file);
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Container(
              color: Colors.grey[200],
              height: 40,
              child: FlatButton(
                child: Text(
                  'Share Image',
                  textScaleFactor: widget.textScale,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                onPressed: () {
                  //TODO: do something
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
