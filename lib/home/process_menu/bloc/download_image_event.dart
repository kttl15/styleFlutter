part of 'download_image_bloc.dart';

abstract class DownloadImageEvent extends Equatable {
  const DownloadImageEvent();

  @override
  List<Object> get props => null;
}

class ImageDownloadEvent extends DownloadImageEvent {
  final File file;
  final String loc;

  ImageDownloadEvent({@required this.file, @required this.loc});

  @override
  List<Object> get props => [file];
}
