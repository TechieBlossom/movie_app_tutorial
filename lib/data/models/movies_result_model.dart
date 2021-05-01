import 'movie_model.dart';

class MoviesResultModel {
  late final List<MovieModel> movies;

  MoviesResultModel({required this.movies});

  factory MoviesResultModel.fromJson(Map<String, dynamic> json) {
    var movies = List<MovieModel>.empty(growable: true);
    if (json['results'] != null) {
      json['results'].forEach((v) {
        movies.add(MovieModel.fromJson(v));
      });
    }
    return MoviesResultModel(movies: movies);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.movies != null) {
      data['results'] = this.movies?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
