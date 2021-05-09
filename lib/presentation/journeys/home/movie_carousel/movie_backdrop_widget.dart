import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/constants/size_constants.dart';
import '../../../../common/extensions/size_extensions.dart';
import '../../../../common/screenutil/screenutil.dart';
import '../../../../data/core/api_constants.dart';
import '../../../../domain/entities/movie_entity.dart';
import '../../../blocs/movie_backdrop/movie_backdrop_cubit.dart';

class MovieBackdropWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.topCenter,
      heightFactor: 0.7,
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(Sizes.dimen_40.w),
        ),
        child: Stack(
          children: <Widget>[
            FractionallySizedBox(
              heightFactor: 1,
              widthFactor: 1,
              child: BlocBuilder<MovieBackdropCubit, MovieEntity?>(
                builder: (context, movie) {
                  return CachedNetworkImage(
                    imageUrl:
                        '${ApiConstants.BASE_IMAGE_URL}${movie?.backdropPath}',
                    fit: BoxFit.fitHeight,
                  );
                },
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                width: ScreenUtil.screenWidth,
                height: 1,
                color: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
