part of 'videos_bloc.dart';

abstract class VideosEvent extends Equatable {
  const VideosEvent();

  @override
  List<Object> get props => [];
}

class LoadVideosEvent extends VideosEvent {
  final int movieId;

  LoadVideosEvent(this.movieId);

  @override
  List<Object> get props => [movieId];
}
