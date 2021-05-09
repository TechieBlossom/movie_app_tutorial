import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movieapp/domain/entities/app_error.dart';
import 'package:movieapp/domain/entities/no_params.dart';
import 'package:movieapp/domain/usecases/get_coming_soon.dart';
import 'package:movieapp/domain/usecases/get_playing_now.dart';
import 'package:movieapp/domain/usecases/get_popular.dart';
import 'package:movieapp/presentation/blocs/movie_tabbed/movie_tabbed_cubit.dart';

class GetPopularMock extends Mock implements GetPopular {}

class GetPlayingNowMock extends Mock implements GetPlayingNow {}

class GetComingSoonMock extends Mock implements GetComingSoon {}

main() {
  late GetPopularMock getPopularMock;
  late GetPlayingNowMock getPlayingNowMock;
  late GetComingSoonMock getComingSoonMock;

  late MovieTabbedCubit movieTabbedCubit;

  setUp(() {
    getPopularMock = GetPopularMock();
    getPlayingNowMock = GetPlayingNowMock();
    getComingSoonMock = GetComingSoonMock();

    movieTabbedCubit = MovieTabbedCubit(
      getPopular: getPopularMock,
      getPlayingNow: getPlayingNowMock,
      getComingSoon: getComingSoonMock,
    );
  });

  tearDown(() {
    movieTabbedCubit.close();
  });

  test('bloc should have initial state as [MovieTabbedInitial]', () {
    expect(movieTabbedCubit.state.runtimeType, MovieTabbedInitial);
  });

  blocTest(
      'should emit [MovieTabLoading, MovieTabChanged] state when playing now tab changed success',
      build: () => movieTabbedCubit,
      act: (MovieTabbedCubit cubit) {
        when(getPlayingNowMock.call(NoParams()))
            .thenAnswer((_) async => Right([]));

        cubit.movieTabChanged(currentTabIndex: 1);
      },
      expect: () => [
            isA<MovieTabLoading>(),
            isA<MovieTabChanged>(),
          ],
      verify: (MovieTabbedCubit cubit) {
        verify(getPlayingNowMock.call(NoParams())).called(1);
      });

  blocTest(
      'should emit [MovieTabLoading, MovieTabChanged] state when popular tab changed success',
      build: () => movieTabbedCubit,
      act: (MovieTabbedCubit cubit) {
        when(getPopularMock.call(NoParams()))
            .thenAnswer((_) async => Right([]));

        cubit.movieTabChanged(currentTabIndex: 0);
      },
      expect: () => [
            isA<MovieTabLoading>(),
            isA<MovieTabChanged>(),
          ],
      verify: (MovieTabbedCubit cubit) {
        verify(getPopularMock.call(NoParams())).called(1);
      });

  blocTest(
      'should emit [MovieTabLoading, MovieTabChanged] state when coming soon tab changed success',
      build: () => movieTabbedCubit,
      act: (MovieTabbedCubit cubit) {
        when(getComingSoonMock.call(NoParams()))
            .thenAnswer((_) async => Right([]));

        cubit.movieTabChanged(currentTabIndex: 2);
      },
      expect: () => [
            isA<MovieTabLoading>(),
            isA<MovieTabChanged>(),
          ],
      verify: (MovieTabbedCubit cubit) {
        verify(getComingSoonMock.call(NoParams())).called(1);
      });

  blocTest(
      'should emit [MovieTabLoading, MovieTabLoadError] state when coming soon tab changed fail',
      build: () => movieTabbedCubit,
      act: (MovieTabbedCubit cubit) {
        when(getComingSoonMock.call(NoParams()))
            .thenAnswer((_) async => Left(AppError(AppErrorType.api)));

        cubit.movieTabChanged(currentTabIndex: 2);
      },
      expect: () => [
            isA<MovieTabLoading>(),
            isA<MovieTabLoadError>(),
          ],
      verify: (MovieTabbedCubit cubit) {
        verify(getComingSoonMock.call(NoParams())).called(1);
      });
}
