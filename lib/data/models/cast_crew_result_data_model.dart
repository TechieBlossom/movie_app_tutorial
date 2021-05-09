import '../../domain/entities/cast_entity.dart';

class CastCrewResultModel {
  final int id;
  late final List<CastModel> cast;
  late final List<Crew> crew;

  CastCrewResultModel(
      {required this.id, required this.cast, required this.crew});

  factory CastCrewResultModel.fromJson(Map<String, dynamic> json) {
    var cast = List<CastModel>.empty(growable: true);
    var crew = List<Crew>.empty(growable: true);
    if (json['cast'] != null) {
      json['cast'].forEach((v) {
        final castModel = CastModel.fromJson(v);
        if (_isValidCast(castModel)) {
          cast.add(CastModel.fromJson(v));
        }
      });
    }
    if (json['crew'] != null) {
      json['crew'].forEach((v) {
        final crewModel = Crew.fromJson(v);
        if (_isValidCrew(crewModel)) {
          crew.add(crewModel);
        }
      });
    }

    return CastCrewResultModel(
      id: json['id'],
      cast: cast,
      crew: crew,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cast'] = this.cast.map((v) => v.toJson()).toList();
    data['crew'] = this.crew.map((v) => v.toJson()).toList();
    return data;
  }
}

bool _isValidCast(CastModel castModel) {
  return castModel.creditId.isNotEmpty &&
      castModel.character.isNotEmpty &&
      castModel.name.isNotEmpty &&
      castModel.posterPath.isNotEmpty;
}

bool _isValidCrew(Crew crewModel) {
  return crewModel.creditId.isNotEmpty &&
      crewModel.department.isNotEmpty &&
      crewModel.name.isNotEmpty &&
      crewModel.profilePath.isNotEmpty;
}

class CastModel extends CastEntity {
  final int? castId;
  final String character;
  final String creditId;
  final int? gender;
  final int? id;
  final String name;
  final int? order;
  final String profilePath;

  CastModel({
    this.castId,
    required this.character,
    required this.creditId,
    this.gender,
    this.id,
    required this.name,
    this.order,
    required this.profilePath,
  }) : super(
          creditId: creditId,
          name: name,
          posterPath: profilePath,
          character: character,
        );

  factory CastModel.fromJson(Map<String, dynamic> json) {
    return CastModel(
      castId: json['cast_id'],
      character: json['character'] ?? '',
      creditId: json['credit_id'] ?? '',
      gender: json['gender'],
      id: json['id'],
      name: json['name'] ?? '',
      order: json['order'],
      profilePath: json['profile_path'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cast_id'] = this.castId;
    data['character'] = this.character;
    data['credit_id'] = this.creditId;
    data['gender'] = this.gender;
    data['id'] = this.id;
    data['name'] = this.name;
    data['order'] = this.order;
    data['profile_path'] = this.profilePath;
    return data;
  }
}

class Crew {
  late String creditId;
  late String department;
  late int? gender;
  late int? id;
  late String? job;
  late String name;
  late String profilePath;

  Crew(
      {required this.creditId,
      required this.department,
      this.gender,
      this.id,
      this.job,
      required this.name,
      required this.profilePath});

  Crew.fromJson(Map<String, dynamic> json) {
    creditId = json['credit_id'] ?? '';
    department = json['department'] ?? '';
    gender = json['gender'];
    id = json['id'];
    job = json['job'];
    name = json['name'] ?? '';
    profilePath = json['profile_path'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['credit_id'] = this.creditId;
    data['department'] = this.department;
    data['gender'] = this.gender;
    data['id'] = this.id;
    data['job'] = this.job;
    data['name'] = this.name;
    data['profile_path'] = this.profilePath;
    return data;
  }
}
