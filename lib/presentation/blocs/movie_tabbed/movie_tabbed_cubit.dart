import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/app_error.dart';
import '../../../domain/entities/movie_entity.dart';
import '../../../domain/entities/no_params.dart';
import '../../../domain/usecases/get_coming_soon.dart';
import '../../../domain/usecases/get_playing_now.dart';
import '../../../domain/usecases/get_popular.dart';

part 'movie_tabbed_state.dart';

class MovieTabbedCubit extends Cubit<MovieTabbedState> {
  final GetPopular getPopular;
  final GetPlayingNow getPlayingNow;
  final GetComingSoon getComingSoon;

  MovieTabbedCubit({
    required this.getPopular,
    required this.getPlayingNow,
    required this.getComingSoon,
  }) : super(MovieTabbedInitial());

  void movieTabChanged({int currentTabIndex = 0}) async {
    emit(MovieTabLoading(currentTabIndex: currentTabIndex));
    late Either<AppError, List<MovieEntity>> moviesEither;
    print('before making api call $currentTabIndex');
    switch (currentTabIndex) {
      case 0:
        moviesEither = await getPopular(NoParams());
        break;
      case 1:
        moviesEither = await getPlayingNow(NoParams());
        break;
      case 2:
        moviesEither = await getComingSoon(NoParams());
        break;
    }
    emit(moviesEither.fold(
      (l) => MovieTabLoadError(
        currentTabIndex: currentTabIndex,
        errorType: l.appErrorType,
      ),
      (movies) {
        print('returning state making api call $currentTabIndex');
        return MovieTabChanged(
          currentTabIndex: currentTabIndex,
          movies: movies,
        );
      },
    ));
  }
}
