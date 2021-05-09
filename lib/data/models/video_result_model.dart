import 'video_model.dart';

class VideoResultModel {
  final int id;
  late final List<VideoModel> videos;

  VideoResultModel({required this.id, required this.videos});

  factory VideoResultModel.fromJson(Map<String, dynamic> json) {
    var videos = List<VideoModel>.empty(growable: true);
    if (json['results'] != null) {
      json['results'].forEach((v) {
        var _videoModel = VideoModel.fromJson(v);
        if (_isValidVideo(_videoModel)) {
          videos.add(VideoModel.fromJson(v));
        }
      });
    }

    return VideoResultModel(id: json['id'], videos: videos);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['results'] = this.videos.map((v) => v.toJson()).toList();
    return data;
  }
}

bool _isValidVideo(VideoModel videoModel) {
  return videoModel.key.isNotEmpty &&
      videoModel.name.isNotEmpty &&
      videoModel.type.isNotEmpty;
}
