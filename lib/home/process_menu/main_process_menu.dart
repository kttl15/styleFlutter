import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gan2/home/process_menu/bloc/processMenu_bloc.dart';
import 'package:gan2/model/data.dart';

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
        }
        return true;
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Process Name: ${widget._data.processName}'),
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
                                'Content',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              )),
                            ),
                            Expanded(
                              child: Center(
                                  child: Text(
                                'Style',
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
                  Text('Content Weight: ${widget._data.contentWeight.round()}'),
                  Text('Style Weight: ${widget._data.styleWeight.round()}'),
                  Text('Duration: ${widget._data.epoch.round()}'),
                  Text('RunOnUpload: ${widget._data.runOnUpload}'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
