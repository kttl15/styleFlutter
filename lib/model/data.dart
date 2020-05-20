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
  final Map<String, dynamic> locOutputs;
  // final String locIconOutputs;
  final double contentWeight;
  final double styleWeight;
  final double epoch;
  final bool isProcessed;
  final bool runOnUpload;

  OutputData({
    @required this.uid,
    @required this.processName,
    @required this.uploadDate,
    @required this.locContent,
    @required this.locIconContent,
    @required this.locStyle,
    @required this.locIconStyle,
    @required this.locOutputs,
    @required this.contentWeight,
    @required this.styleWeight,
    @required this.epoch,
    @required this.isProcessed,
    @required this.runOnUpload,
  });

  @override
  String toString() => '''OutputData
  {
    uid: $uid,
    processName: $processName,
    date: $uploadDate,
    locContent: $locContent,
    locStyle: $locStyle,
    locOutputs: $locOutputs,
    contentWeight: $contentWeight,
    styleWeight: $styleWeight,
    epoch: $epoch,
    isProcessed: $isProcessed,
    runOnUpload: $runOnUpload,
  }''';
}
