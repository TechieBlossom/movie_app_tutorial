import 'package:movieapp/domain/entities/app_error.dart';
import 'package:dartz/dartz.dart';
import 'package:movieapp/domain/entities/no_params.dart';
import 'package:movieapp/domain/repositories/authentication_repository.dart';
import 'package:movieapp/domain/usecases/usecase.dart';

class LogoutUser extends UseCase<void, NoParams> {
  final AuthenticationRepository _authenticationRepository;

  LogoutUser(this._authenticationRepository);

  @override
  Future<Either<AppError, void>> call(NoParams noParams) async =>
      _authenticationRepository.logoutUser();
}
