import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/app_error.dart';
import '../../../domain/entities/cast_entity.dart';
import '../../../domain/entities/movie_params.dart';
import '../../../domain/usecases/get_cast.dart';

part 'cast_state.dart';

class CastCubit extends Cubit<CastState> {
  final GetCast getCast;

  CastCubit({required this.getCast}) : super(CastInitial());

  void loadCast(int movieId) async {
    Either<AppError, List<CastEntity>> eitherResponse =
        await getCast(MovieParams(movieId));

    emit(eitherResponse.fold(
      (l) => CastError(),
      (r) => CastLoaded(casts: r),
    ));
  }
}
