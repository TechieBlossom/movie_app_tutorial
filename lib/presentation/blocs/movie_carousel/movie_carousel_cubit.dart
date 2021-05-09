import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/app_error.dart';
import '../../../domain/entities/movie_entity.dart';
import '../../../domain/entities/no_params.dart';
import '../../../domain/usecases/get_trending.dart';
import '../loading/loading_cubit.dart';
import '../movie_backdrop/movie_backdrop_cubit.dart';

part 'movie_carousel_state.dart';

class MovieCarouselCubit extends Cubit<MovieCarouselState> {
  final GetTrending getTrending;
  final MovieBackdropCubit movieBackdropCubit;
  final LoadingCubit loadingCubit;

  MovieCarouselCubit({
    required this.getTrending,
    required this.movieBackdropCubit,
    required this.loadingCubit,
  }) : super(MovieCarouselInitial());

  void loadCarousel({int defaultIndex = 0}) async {
    loadingCubit.show();
    final moviesEither = await getTrending(NoParams());
    emit(moviesEither.fold(
      (l) => MovieCarouselError(l.appErrorType),
      (movies) {
        movieBackdropCubit.backdropChanged(movies[defaultIndex]);
        return MovieCarouselLoaded(
          movies: movies,
          defaultIndex: defaultIndex,
        );
      },
    ));
    loadingCubit.hide();
  }
}
