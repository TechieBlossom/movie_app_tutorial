import 'package:equatable/equatable.dart';

class MovieDetailEntity extends Equatable {
  final int id;
  final String title;
  final String overview;
  final String releaseDate;
  final num voteAverage;
  final String backdropPath;
  final String posterPath;

  const MovieDetailEntity({
    this.id,
    this.title,
    this.overview,
    this.releaseDate,
    this.voteAverage,
    this.backdropPath,
    this.posterPath,
  });

  @override
  List<Object> get props => [id];
}
