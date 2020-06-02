import 'dart:io';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gan2/home/process_menu/bloc/download_image_bloc.dart';

class ProcessMenuImage extends StatefulWidget {
  // final FirebaseUser user;
  final File file;
  final String loc;

  const ProcessMenuImage({
    Key key,
    // @required this.user,
    @required this.file,
    @required this.loc,
  }) : super(key: key);
  @override
  _ProcessMenuImageState createState() => _ProcessMenuImageState();
}

class _ProcessMenuImageState extends State<ProcessMenuImage> {
  @override
  void initState() {
    BlocProvider.of<DownloadImageBloc>(context)
        .add(ImageDownloadEvent(file: widget.file, loc: widget.loc));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DownloadImageBloc, DownloadImageState>(
      builder: (context, state) {
        if (state is ImageDownloaded)
          return Image.file(widget.file);
        else
          return Container(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
      },
    );
  }
}
