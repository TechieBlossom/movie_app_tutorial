import 'package:dartz/dartz.dart';

import '../entities/app_error.dart';
import '../entities/movie_entity.dart';
import '../entities/movie_search_params.dart';
import '../repositories/movie_repository.dart';
import 'usecase.dart';

class SearchMovies extends UseCase<List<MovieEntity>, MovieSearchParams> {
  final MovieRepository repository;

  SearchMovies(this.repository);

  @override
  Future<Either<AppError, List<MovieEntity>>> call(
      MovieSearchParams searchParams) async {
    return await repository.getSearchedMovies(searchParams.searchTerm);
  }
}
