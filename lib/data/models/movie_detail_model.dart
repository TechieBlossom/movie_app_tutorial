import '../../domain/entities/movie_detail_entity.dart';

class MovieDetailModel extends MovieDetailEntity {
  final bool? adult;
  final BelongsToCollection? belongsToCollection;
  final int? budget;
  final List<Genres?>? genres;
  final String? homepage;
  final String? imdbId;
  final String? originalLanguage;
  final String? originalTitle;
  final double? popularity;
  final List<ProductionCompanies?>? productionCompanies;
  final List<ProductionCountries?>? productionCountries;
  final int? revenue;
  final int? runtime;
  final List<SpokenLanguages?>? spokenLanguages;
  final String? status;
  final String? tagline;
  final bool? video;
  final int? voteCount;

  const MovieDetailModel(
      {this.adult,
      super.backdropPath,
      this.belongsToCollection,
      this.budget,
      this.genres,
      this.homepage,
      required super.id,
      this.imdbId,
      this.originalLanguage,
      this.originalTitle,
      super.overview,
      this.popularity,
      required super.posterPath,
      this.productionCompanies,
      this.productionCountries,
      super.releaseDate,
      this.revenue,
      this.runtime,
      this.spokenLanguages,
      this.status,
      this.tagline,
      required super.title,
      this.video,
      super.voteAverage,
      this.voteCount});

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailModel(
      adult: json['adult'],
      backdropPath: json['backdrop_path'],
      belongsToCollection: json['belongs_to_collection'] != null
          ? BelongsToCollection.fromJson(json['belongs_to_collection'])
          : null,
      budget: json['budget'],
      genres: _genres(json),
      homepage: json['homepage'],
      id: json['id'] ?? -1,
      imdbId: json['imdb_id'],
      originalLanguage: json['original_language'],
      originalTitle: json['original_title'],
      overview: json['overview'],
      popularity: json['popularity'],
      posterPath: json['poster_path'] ?? '',
      releaseDate: json['release_date'],
      revenue: json['revenue'],
      runtime: json['runtime'],
      status: json['status'],
      tagline: json['tagline'],
      title: json['title'] ?? '',
      video: json['video'],
      voteAverage: json['vote_average'],
      voteCount: json['vote_count'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['adult'] = adult;
    data['backdrop_path'] = backdropPath;
    if (belongsToCollection != null) {
      data['belongs_to_collection'] = belongsToCollection?.toJson();
    }
    data['budget'] = budget;
    if (genres != null) {
      data['genres'] = genres?.map((v) => v?.toJson()).toList();
    }
    data['homepage'] = homepage;
    data['id'] = id;
    data['imdb_id'] = imdbId;
    data['original_language'] = originalLanguage;
    data['original_title'] = originalTitle;
    data['overview'] = overview;
    data['popularity'] = popularity;
    data['poster_path'] = posterPath;
    if (productionCompanies != null) {
      data['production_companies'] =
          productionCompanies?.map((v) => v?.toJson()).toList();
    }
    if (productionCountries != null) {
      data['production_countries'] =
          productionCountries?.map((v) => v?.toJson()).toList();
    }
    data['release_date'] = releaseDate;
    data['revenue'] = revenue;
    data['runtime'] = runtime;
    if (spokenLanguages != null) {
      data['spoken_languages'] =
          spokenLanguages?.map((v) => v?.toJson()).toList();
    }
    data['status'] = status;
    data['tagline'] = tagline;
    data['title'] = title;
    data['video'] = video;
    data['vote_average'] = voteAverage;
    data['vote_count'] = voteCount;
    return data;
  }
}

_genres(Map<String, dynamic> json) {
  if (json['genres'] != null) {
    final genres = List<Genres>.empty(growable: true);
    json['genres'].forEach((v) {
      genres.add(Genres.fromJson(v));
    });
  }
}

class BelongsToCollection {
  late int? id;
  late String? name;
  late String? posterPath;
  late String? backdropPath;

  BelongsToCollection({this.id, this.name, this.posterPath, this.backdropPath});

  BelongsToCollection.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    posterPath = json['poster_path'];
    backdropPath = json['backdrop_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['poster_path'] = posterPath;
    data['backdrop_path'] = backdropPath;
    return data;
  }
}

class Genres {
  late int? id;
  late String? name;

  Genres({this.id, this.name});

  Genres.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class ProductionCompanies {
  late int? id;
  late String? logoPath;
  late String? name;
  late String? originCountry;

  ProductionCompanies({this.id, this.logoPath, this.name, this.originCountry});

  ProductionCompanies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    logoPath = json['logo_path'];
    name = json['name'];
    originCountry = json['origin_country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['logo_path'] = logoPath;
    data['name'] = name;
    data['origin_country'] = originCountry;
    return data;
  }
}

class ProductionCountries {
  late String? iso31661;
  late String? name;

  ProductionCountries({this.iso31661, this.name});

  ProductionCountries.fromJson(Map<String, dynamic> json) {
    iso31661 = json['iso_3166_1'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['iso_3166_1'] = iso31661;
    data['name'] = name;
    return data;
  }
}

class SpokenLanguages {
  late String? iso6391;
  late String? name;

  SpokenLanguages({this.iso6391, this.name});

  SpokenLanguages.fromJson(Map<String, dynamic> json) {
    iso6391 = json['iso_639_1'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['iso_639_1'] = iso6391;
    data['name'] = name;
    return data;
  }
}
