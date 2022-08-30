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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cast'] = cast.map((v) => v.toJson()).toList();
    data['crew'] = crew.map((v) => v.toJson()).toList();
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
  final int? gender;
  final int? id;
  final int? order;
  final String profilePath;

  const CastModel({
    this.castId,
    required super.character,
    required super.creditId,
    this.gender,
    this.id,
    required super.name,
    this.order,
    required this.profilePath,
  }) : super(
          posterPath: profilePath,
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cast_id'] = castId;
    data['character'] = character;
    data['credit_id'] = creditId;
    data['gender'] = gender;
    data['id'] = id;
    data['name'] = name;
    data['order'] = order;
    data['profile_path'] = profilePath;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['credit_id'] = creditId;
    data['department'] = department;
    data['gender'] = gender;
    data['id'] = id;
    data['job'] = job;
    data['name'] = name;
    data['profile_path'] = profilePath;
    return data;
  }
}
