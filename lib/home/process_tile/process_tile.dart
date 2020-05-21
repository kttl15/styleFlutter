import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gan2/home/process_menu/bloc/processMenu_bloc.dart';
import 'package:gan2/home/process_menu/main_process_menu.dart';
import 'package:gan2/home/process_tile/bloc/processtile_bloc.dart';
import 'package:gan2/model/data.dart';

class ProcessTile extends StatefulWidget {
  final OutputData _data;

  const ProcessTile({Key key, @required data})
      : assert(data != null),
        _data = data,
        super(key: key);
  @override
  _ProcessTileState createState() => _ProcessTileState();
}

class _ProcessTileState extends State<ProcessTile> {
  final Directory tempDir = Directory.systemTemp;
  File iconOutputFile;
  ProcessMenuBloc _processMenuBloc;
  ProcessTileBloc _processTileBloc;

  @override
  void initState() {
    _processMenuBloc = BlocProvider.of<ProcessMenuBloc>(context);
    _processTileBloc = BlocProvider.of<ProcessTileBloc>(context);
    _processTileBloc.add(DownloadOutputEvent(data: widget._data));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double iconWidth = 100.0;
    return BlocConsumer<ProcessTileBloc, ProcessTileState>(
      listener: (context, state) {
        if (state is OutputImageDownloadedState) {
          setState(() {
            iconOutputFile = File(
                '${tempDir.path}/${widget._data.uid}${widget._data.processName}_iconOutput.jpg');
            print(iconOutputFile.path);
          });
        }
      },
      builder: (context, state) {
        return ListTile(
          key: ValueKey(widget.key),
          title: Text('Process Name: ' + widget._data.processName),
          subtitle: Text('isProcessed: ${widget._data.isProcessed}'),
          leading: state is OutputImageDownloadedState && iconOutputFile != null
              ? Image.file(
                  iconOutputFile,
                  width: iconWidth,
                )
              : SizedBox(
                  width: iconWidth,
                  child: Icon(
                    Icons.image,
                    size: 60,
                  ),
                ),
          onLongPress: () {}, //TODO: popup menu to download or share ...
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: ((context) {
                return BlocProvider<ProcessMenuBloc>(
                  create: (context) => ProcessMenuBloc(),
                  child: ProcessMenu(data: widget._data),
                );
              }),
            ));
          },
          trailing: _showPopupMenu(),
        );
      },
    );
  }

  Widget _showPopupMenu() {
    return PopupMenuButton<String>(
      onSelected: _popupMenuClick,
      itemBuilder: (BuildContext content) {
        return <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            child: Text('Delete Process'),
            value: 'delete',
          ),
          if (widget._data.runOnUpload == false)
            PopupMenuItem<String>(
              child: Text('Start Process'),
              value: 'start',
            )
        ];
      },
    );
  }

  _popupMenuClick(String val) {
    switch (val) {
      case 'delete':
        _processMenuBloc.add(DeleteProcessEvent(data: widget._data));
        print('DeleteProcess');
        break;

      case 'start':
        _processMenuBloc.add(StartProcessEvent(data: widget._data));
        print('StartProcess');
        break;
    }
    // _listViewBloc.add(RefreshData());
  }
}
