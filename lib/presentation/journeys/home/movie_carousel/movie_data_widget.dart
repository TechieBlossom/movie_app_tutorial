import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/movie_entity.dart';
import '../../../blocs/movie_backdrop/movie_backdrop_cubit.dart';

class MovieDataWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieBackdropCubit, MovieEntity?>(
      builder: (context, movie) {
        return Text(
          movie?.title ?? '',
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.fade,
          style: Theme.of(context).textTheme.headline6,
        );
      },
    );
  }
}
