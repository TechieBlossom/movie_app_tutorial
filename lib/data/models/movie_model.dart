import '../../domain/entities/movie_entity.dart';

class MovieModel extends MovieEntity {
  final int id;
  final bool? video;
  final int? voteCount;
  final double? voteAverage;
  final String title;
  final String? releaseDate;
  final String? originalLanguage;
  final String? originalTitle;
  final List<int>? genreIds;
  final String backdropPath;
  final bool? adult;
  final String? overview;
  final String posterPath;
  final double? popularity;
  final String? mediaType;

  MovieModel({
    required this.id,
    this.video,
    this.voteCount,
    this.voteAverage,
    required this.title,
    this.releaseDate,
    this.originalLanguage,
    this.originalTitle,
    this.genreIds,
    required this.backdropPath,
    this.adult,
    this.overview,
    required this.posterPath,
    this.popularity,
    this.mediaType,
  }) : super(
          id: id,
          title: title,
          backdropPath: backdropPath,
          posterPath: posterPath,
          releaseDate: releaseDate,
          voteAverage: voteAverage,
          overview: overview,
        );

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      popularity: json['popularity']?.toDouble() ?? 0.0,
      voteCount: json['vote_count'],
      video: json['video'],
      posterPath: json['poster_path'] ?? '',
      id: json['id'] ?? -1,
      adult: json['adult'],
      backdropPath: json['backdrop_path'] ?? '',
      originalLanguage: json['original_language'],
      originalTitle: json['original_title'],
      genreIds: json['genre_ids'].cast<int>(),
      title: json['title'] ?? '',
      voteAverage: json['vote_average']?.toDouble() ?? 0.0,
      overview: json['overview'],
      releaseDate: json['release_date'],
      mediaType: json['media_type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['video'] = this.video;
    data['vote_count'] = this.voteCount;
    data['vote_average'] = this.voteAverage;
    data['title'] = this.title;
    data['release_date'] = this.releaseDate;
    data['original_language'] = this.originalLanguage;
    data['original_title'] = this.originalTitle;
    data['genre_ids'] = this.genreIds;
    data['backdrop_path'] = this.backdropPath;
    data['adult'] = this.adult;
    data['overview'] = this.overview;
    data['poster_path'] = this.posterPath;
    data['popularity'] = this.popularity;
    data['media_type'] = this.mediaType;
    return data;
  }
}
