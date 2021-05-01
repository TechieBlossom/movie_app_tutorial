import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/app_error.dart';
import '../../../domain/entities/movie_entity.dart';
import '../../../domain/entities/movie_search_params.dart';
import '../../../domain/usecases/search_movies.dart';
import '../loading/loading_cubit.dart';

part 'search_movie_state.dart';

class SearchMovieCubit extends Cubit<SearchMovieState> {
  final SearchMovies searchMovies;
  final LoadingCubit loadingCubit;

  SearchMovieCubit({
    required this.searchMovies,
    required this.loadingCubit,
  }) : super(SearchMovieInitial());

  Future<void> searchTermChanged(String searchTerm) async {
    loadingCubit.show();
    if (searchTerm.length > 2) {
      emit(SearchMovieLoading());
      final Either<AppError, List<MovieEntity>> response =
          await searchMovies(MovieSearchParams(searchTerm: searchTerm));
      emit(response.fold(
        (l) => SearchMovieError(l.appErrorType),
        (r) => SearchMovieLoaded(r),
      ));
    }
    loadingCubit.hide();
  }
}
