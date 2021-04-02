part of 'videos_cubit.dart';

abstract class VideosState extends Equatable {
  const VideosState();

  @override
  List<Object> get props => [];
}

class VideosInitial extends VideosState {}

class NoVideos extends VideosState {}

class VideosLoaded extends VideosState {
  final List<VideoEntity> videos;

  VideosLoaded(this.videos);

  @override
  List<Object> get props => [videos];
}
