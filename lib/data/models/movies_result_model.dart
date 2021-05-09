import 'movie_model.dart';

class MoviesResultModel {
  late final List<MovieModel> movies;

  MoviesResultModel({required this.movies});

  factory MoviesResultModel.fromJson(Map<String, dynamic> json) {
    var movies = List<MovieModel>.empty(growable: true);
    if (json['results'] != null) {
      json['results'].forEach((v) {
        final movieModel = MovieModel.fromJson(v);
        if (_isValidMovie(movieModel)) {
          movies.add(movieModel);
        }
      });
    }
    return MoviesResultModel(movies: movies);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['results'] = this.movies.map((v) => v.toJson()).toList();
    return data;
  }
}

bool _isValidMovie(MovieModel movieModel) {
  return movieModel.id != -1 &&
      movieModel.title.isNotEmpty &&
      movieModel.backdropPath.isNotEmpty &&
      movieModel.posterPath.isNotEmpty;
}
