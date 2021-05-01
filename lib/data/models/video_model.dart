import '../../domain/entities/video_entity.dart';

class VideoModel extends VideoEntity {
  final String? id;
  final String? iso6391;
  final String? iso31661;
  final String key;
  final String name;
  final String? site;
  final int? size;
  final String type;

  VideoModel({
    this.id,
    this.iso6391,
    this.iso31661,
    required this.key,
    required this.name,
    this.site,
    this.size,
    required this.type,
  }) : super(
          title: name,
          key: key,
          type: type,
        );

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'],
      iso6391: json['iso_639_1'],
      iso31661: json['iso_3166_1'],
      key: json['key'] ?? '',
      name: json['name'] ?? '',
      site: json['site'],
      size: json['size'],
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['iso_639_1'] = this.iso6391;
    data['iso_3166_1'] = this.iso31661;
    data['key'] = this.key;
    data['name'] = this.name;
    data['site'] = this.site;
    data['size'] = this.size;
    data['type'] = this.type;
    return data;
  }
}
