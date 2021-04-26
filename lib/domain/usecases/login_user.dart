import 'package:dartz/dartz.dart';

import '../entities/app_error.dart';
import '../entities/login_request_params.dart';
import '../repositories/authentication_repository.dart';
import 'usecase.dart';

class LoginUser extends UseCase<bool, LoginRequestParams> {
  final AuthenticationRepository _authenticationRepository;

  LoginUser(this._authenticationRepository);

  @override
  Future<Either<AppError, bool>> call(LoginRequestParams params) async =>
      _authenticationRepository.loginUser(params.toJson());
}
