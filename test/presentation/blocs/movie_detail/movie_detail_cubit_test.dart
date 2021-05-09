import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movieapp/domain/entities/app_error.dart';
import 'package:movieapp/domain/entities/movie_detail_entity.dart';
import 'package:movieapp/domain/entities/movie_params.dart';
import 'package:movieapp/domain/usecases/get_movie_detail.dart';
import 'package:movieapp/presentation/blocs/cast/cast_cubit.dart';
import 'package:movieapp/presentation/blocs/favorite/favorite_cubit.dart';
import 'package:movieapp/presentation/blocs/loading/loading_cubit.dart';
import 'package:movieapp/presentation/blocs/movie_detail/movie_detail_cubit.dart';
import 'package:movieapp/presentation/blocs/videos/videos_cubit.dart';

class GetMovieDetailMock extends Mock implements GetMovieDetail {}

class CastCubitMock extends MockCubit<CastState> implements CastCubit {}

class VideosCubitMock extends MockCubit<VideosState> implements VideosCubit {}

class FavoriteCubitMock extends MockCubit<FavoriteState>
    implements FavoriteCubit {}

class LoadingCubitMock extends MockCubit<bool> implements LoadingCubit {}

void main() {
  var movieDetailMock;
  var castCubitMock;
  var videosCubitMock;
  var favoriteCubitMock;
  var loadingCubitMock;

  late MovieDetailCubit movieDetailCubit;

  setUp(() {
    movieDetailMock = GetMovieDetailMock();
    castCubitMock = CastCubitMock();
    videosCubitMock = VideosCubitMock();
    favoriteCubitMock = FavoriteCubitMock();
    loadingCubitMock = LoadingCubitMock();

    movieDetailCubit = MovieDetailCubit(
      getMovieDetail: movieDetailMock,
      castBloc: castCubitMock,
      videosCubit: videosCubitMock,
      favoriteCubit: favoriteCubitMock,
      loadingCubit: loadingCubitMock,
    );
  });

  tearDown(() {
    castCubitMock.close();
    videosCubitMock.close();
    favoriteCubitMock.close();
    loadingCubitMock.close();
    movieDetailCubit.close();
  });

  group('MovieDetailBloc', () {
    test('initial state should be [MovieDetailInitial]', () {
      expect(movieDetailCubit.state.runtimeType, MovieDetailInitial);
    });

    blocTest('should load movie success',
        build: () => movieDetailCubit,
        act: (MovieDetailCubit bloc) async {
          when(movieDetailMock.call(MovieParams(1))).thenAnswer(
            (_) async => Right(
              MovieDetailEntity(
                id: 1,
                backdropPath: '',
                overview: '',
                posterPath: '',
                releaseDate: '',
                title: '',
                voteAverage: 3,
              ),
            ),
          );
          bloc.loadMovieDetail(1);
        },
        expect: () => [isA<MovieDetailLoaded>()],
        verify: (bloc) {
          verify(loadingCubitMock.show()).called(1);
          verify(castCubitMock.loadCast(1)).called(1);
          verify(videosCubitMock.loadVideos(1)).called(1);
          verify(favoriteCubitMock.checkIfMovieFavorite(1)).called(1);
          verify(loadingCubitMock.hide()).called(1);
        });

    blocTest('should load movie failure',
        build: () => movieDetailCubit,
        act: (MovieDetailCubit bloc) async {
          when(movieDetailMock.call(MovieParams(1)))
              .thenAnswer((_) async => Left(AppError(AppErrorType.api)));
          bloc.loadMovieDetail(1);
        },
        expect: () => [isA<MovieDetailError>()],
        verify: (bloc) {
          verify(loadingCubitMock.show()).called(1);
          verify(castCubitMock.loadCast(1)).called(1);
          verify(videosCubitMock.loadVideos(1)).called(1);
          verify(favoriteCubitMock.checkIfMovieFavorite(1)).called(1);
          verify(loadingCubitMock.hide()).called(1);
        });
  });
}
