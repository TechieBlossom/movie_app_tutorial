import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/constants/route_constants.dart';
import '../../../common/constants/translation_constants.dart';
import '../../blocs/videos/videos_cubit.dart';
import '../../widgets/button.dart';
import '../watch_video/watch_video_arguments.dart';

class VideosWidget extends StatelessWidget {
  final VideosCubit videosCubit;

  const VideosWidget({
    Key? key,
    required this.videosCubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideosCubit, VideosState>(
      builder: (context, state) {
        if (state is VideosLoaded && state.videos.iterator.moveNext()) {
          final _videos = state.videos;
          return Button(
            text: TranslationConstants.watchTrailers,
            onPressed: () {
              Navigator.of(context).pushNamed(
                RouteList.watchTrailer,
                arguments: WatchVideoArguments(_videos),
              );
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
