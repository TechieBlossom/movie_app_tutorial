part of 'loading_bloc.dart';

abstract class LoadingState extends Equatable {
  const LoadingState();
  
  @override
  List<Object> get props => [];
}

class LoadingInitial extends LoadingState {}

class LoadingStarted extends LoadingState {}

class LoadingFinished extends LoadingState {}
