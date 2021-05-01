part of 'movie_tabbed_cubit.dart';

abstract class MovieTabbedState extends Equatable {
  final int currentTabIndex;

  const MovieTabbedState({this.currentTabIndex = 0});

  @override
  List<Object> get props => [currentTabIndex];
}

class MovieTabbedInitial extends MovieTabbedState {}

class MovieTabChanged extends MovieTabbedState {
  final List<MovieEntity> movies;

  const MovieTabChanged({int currentTabIndex = 0, required this.movies})
      : super(currentTabIndex: currentTabIndex);

  @override
  List<Object> get props => [currentTabIndex, movies];
}

class MovieTabLoadError extends MovieTabbedState {
  final AppErrorType errorType;

  const MovieTabLoadError({
    int currentTabIndex = 0,
    required this.errorType,
  }) : super(currentTabIndex: currentTabIndex);
}

class MovieTabLoading extends MovieTabbedState {
  const MovieTabLoading({int currentTabIndex = 0})
      : super(currentTabIndex: currentTabIndex);
}
