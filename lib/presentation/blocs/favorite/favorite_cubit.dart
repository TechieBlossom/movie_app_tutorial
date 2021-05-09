import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/app_error.dart';
import '../../../domain/entities/movie_entity.dart';
import '../../../domain/entities/movie_params.dart';
import '../../../domain/entities/no_params.dart';
import '../../../domain/usecases/check_if_movie_favorite.dart';
import '../../../domain/usecases/delete_favorite_movie.dart';
import '../../../domain/usecases/get_favorite_movies.dart';
import '../../../domain/usecases/save_movie.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final SaveMovie saveMovie;
  final GetFavoriteMovies getFavoriteMovies;
  final DeleteFavoriteMovie deleteFavoriteMovie;
  final CheckIfFavoriteMovie checkIfFavoriteMovie;

  FavoriteCubit({
    required this.saveMovie,
    required this.getFavoriteMovies,
    required this.deleteFavoriteMovie,
    required this.checkIfFavoriteMovie,
  }) : super(FavoriteInitial());

  void toggleFavoriteMovie(MovieEntity movieEntity, bool isFavorite) async {
    if (isFavorite) {
      await deleteFavoriteMovie(MovieParams(movieEntity.id));
    } else {
      await saveMovie(movieEntity);
    }
    final response = await checkIfFavoriteMovie(MovieParams(movieEntity.id));
    emit(response.fold(
      (l) => FavoriteMoviesError(),
      (r) => IsFavoriteMovie(r),
    ));
  }

  void loadFavoriteMovie() async {
    final Either<AppError, List<MovieEntity>> response =
        await getFavoriteMovies(NoParams());

    emit(response.fold(
      (l) => FavoriteMoviesError(),
      (r) => FavoriteMoviesLoaded(r),
    ));
  }

  void deleteMovie(int movieId) async {
    await deleteFavoriteMovie(MovieParams(movieId));
    loadFavoriteMovie();
  }

  void checkIfMovieFavorite(int movieId) async {
    final response = await checkIfFavoriteMovie(MovieParams(movieId));
    emit(response.fold(
      (l) => FavoriteMoviesError(),
      (r) => IsFavoriteMovie(r),
    ));
  }
}
