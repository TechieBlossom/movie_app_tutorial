import 'package:dartz/dartz.dart';

import '../entities/app_error.dart';
import '../repositories/app_repository.dart';
import 'usecase.dart';

class UpdateLanguage extends UseCase<void, String> {
  final AppRepository appRepository;

  UpdateLanguage(this.appRepository);

  @override
  Future<Either<AppError, void>> call(String languageCode) async {
    return await appRepository.updateLanguage(languageCode);
  }
}
