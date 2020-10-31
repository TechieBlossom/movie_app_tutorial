import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movieapp/common/constants/size_constants.dart';
import 'package:movieapp/common/extensions/size_extensions.dart';
import 'package:movieapp/common/extensions/string_extensions.dart';
import 'package:movieapp/data/core/api_constants.dart';
import 'package:movieapp/presentation/journeys/movie_detail/movie_detail_arguments.dart';
import 'package:movieapp/presentation/journeys/movie_detail/movie_detail_screen.dart';

class MovieTabCardWidget extends StatelessWidget {
  final int movieId;
  final String title, posterPath;

  const MovieTabCardWidget({
    Key key,
    @required this.movieId,
    @required this.title,
    @required this.posterPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MovieDetailScreen(
              movieDetailArguments: MovieDetailArguments(movieId),
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Sizes.dimen_16.w),
              child: CachedNetworkImage(
                imageUrl: '${ApiConstants.BASE_IMAGE_URL}$posterPath',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: Sizes.dimen_4.h),
            child: Text(
              title.intelliTrim(),
              maxLines: 1,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ],
      ),
    );
  }
}
