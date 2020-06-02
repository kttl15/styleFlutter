part of 'download_image_bloc.dart';

abstract class DownloadImageState extends Equatable {
  const DownloadImageState();

  @override
  List<Object> get props => [];
}

class DownloadImageInitial extends DownloadImageState {
  @override
  List<Object> get props => [];
}

class ImageDownloading extends DownloadImageState {
  @override
  String toString() => 'ImageDownloading';
}

class ImageDownloaded extends DownloadImageState {}
