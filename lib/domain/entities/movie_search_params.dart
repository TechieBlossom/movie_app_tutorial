import 'package:equatable/equatable.dart';

class MovieSearchParams extends Equatable {
  final String searchTerm;

  const MovieSearchParams({required this.searchTerm});

  @override
  List<Object> get props => [searchTerm];
}
