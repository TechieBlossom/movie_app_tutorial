import 'package:equatable/equatable.dart';

class VideoEntity extends Equatable {
  final String title, key;
  final String? type;

  const VideoEntity({
    required this.title,
    required this.key,
    this.type,
  });

  @override
  List<Object> get props => [title];

  @override
  bool get stringify => true;
}
