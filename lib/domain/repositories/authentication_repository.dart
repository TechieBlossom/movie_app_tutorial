import 'package:dartz/dartz.dart';
import 'package:movieapp/domain/entities/app_error.dart';

abstract class AuthenticationRepository {
  Future<Either<AppError, bool>> loginUser(Map<String, dynamic> params);
  Future<Either<AppError, void>> logoutUser();
}
