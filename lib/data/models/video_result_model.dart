import 'video_model.dart';

class VideoResultModel {
  int id;
  List<VideoModel> videos;

  VideoResultModel({this.id, this.videos});

  VideoResultModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['results'] != null) {
      videos = new List<VideoModel>();
      json['results'].forEach((v) {
        videos.add(new VideoModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.videos != null) {
      data['results'] = this.videos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
