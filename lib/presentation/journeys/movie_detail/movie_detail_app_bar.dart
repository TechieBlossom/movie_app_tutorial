import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/presentation/blocs/theme/theme_cubit.dart';
import 'package:movieapp/presentation/themes/theme_color.dart';

import '../../../common/constants/size_constants.dart';
import '../../../common/extensions/size_extensions.dart';
import '../../../domain/entities/movie_detail_entity.dart';
import '../../../domain/entities/movie_entity.dart';
import '../../blocs/favorite/favorite_cubit.dart';

class MovieDetailAppBar extends StatelessWidget {
  final MovieDetailEntity movieDetailEntity;

  const MovieDetailAppBar({
    Key? key,
    required this.movieDetailEntity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: context.read<ThemeCubit>().state == Themes.dark
                ? Colors.white
                : AppColor.vulcan,
            size: Sizes.dimen_12.h,
          ),
        ),
        BlocBuilder<FavoriteCubit, FavoriteState>(
          builder: (context, state) {
            if (state is IsFavoriteMovie) {
              return GestureDetector(
                onTap: () =>
                    BlocProvider.of<FavoriteCubit>(context).toggleFavoriteMovie(
                  MovieEntity.fromMovieDetailEntity(movieDetailEntity),
                  state.isMovieFavorite,
                ),
                child: Icon(
                  state.isMovieFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: context.read<ThemeCubit>().state == Themes.dark
                      ? Colors.white
                      : AppColor.vulcan,
                  size: Sizes.dimen_12.h,
                ),
              );
            } else {
              return Icon(
                Icons.favorite_border,
                color: context.read<ThemeCubit>().state == Themes.dark
                    ? Colors.white
                    : AppColor.vulcan,
                size: Sizes.dimen_12.h,
              );
            }
          },
        ),
      ],
    );
  }
}
