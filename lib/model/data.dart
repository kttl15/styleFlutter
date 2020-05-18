import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class OutputData {
  final String uid;
  final String processName;
  final Timestamp uploadDate;
  final String locContent;
  final String locIconContent;
  final String locStyle;
  final String locIconStyle;
  final String locOutput;
  final double contentWeight;
  final double styleWeight;
  final double epoch;
  final bool unprocessedFlag;
  final bool runOnUpload;
  final bool isDone;

  OutputData({
    @required this.uid,
    @required this.processName,
    @required this.uploadDate,
    @required this.locContent,
    @required this.locIconContent,
    @required this.locStyle,
    @required this.locIconStyle,
    @required this.locOutput,
    @required this.contentWeight,
    @required this.styleWeight,
    @required this.epoch,
    @required this.unprocessedFlag,
    @required this.runOnUpload,
    @required this.isDone,
  });

  @override
  String toString() => '''OutputData
  {
    uid: $uid,
    processName: $processName,
    date: $uploadDate,
    locContent: $locContent,
    locStyle: $locStyle,
    locOutput: $locOutput,
    contentWeight: $contentWeight,
    styleWeight: $styleWeight,
    epoch: $epoch,
    unprocessedFlag: $unprocessedFlag,
    runOnUpload: $runOnUpload,
    isDone: $isDone,
  }''';
}
