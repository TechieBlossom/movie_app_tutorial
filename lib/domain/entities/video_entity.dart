import 'package:equatable/equatable.dart';

class VideoEntity extends Equatable {
  final String title, key, type;

  VideoEntity({
    this.title,
    this.key,
    this.type,
  });

  @override
  List<Object> get props => [title];

  @override
  bool get stringify => true;
}
