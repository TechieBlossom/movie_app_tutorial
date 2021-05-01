import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../common/constants/languages.dart';
import '../common/constants/route_constants.dart';
import '../common/screenutil/screenutil.dart';
import '../di/get_it.dart';
import 'app_localizations.dart';
import 'blocs/language/language_cubit.dart';
import 'blocs/loading/loading_cubit.dart';
import 'blocs/login/login_cubit.dart';
import 'fade_page_route_builder.dart';
import 'journeys/loading/loading_screen.dart';
import 'routes.dart';
import 'themes/theme_color.dart';
import 'themes/theme_text.dart';
import 'wiredash_app.dart';

class MovieApp extends StatefulWidget {
  @override
  _MovieAppState createState() => _MovieAppState();
}

class _MovieAppState extends State<MovieApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late LanguageCubit _languageCubit;
  late LoginCubit _loginBloc;
  late LoadingCubit _loadingCubit;

  @override
  void initState() {
    super.initState();
    _languageCubit = getItInstance<LanguageCubit>();
    _languageCubit.loadPreferredLanguage();
    _loginBloc = getItInstance<LoginCubit>();
    _loadingCubit = getItInstance<LoadingCubit>();
  }

  @override
  void dispose() {
    _languageCubit.close();
    _loginBloc.close();
    _loadingCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init();
    return MultiBlocProvider(
      providers: [
        BlocProvider<LanguageCubit>.value(
          value: _languageCubit,
        ),
        BlocProvider<LoginCubit>.value(
          value: _loginBloc,
        ),
        BlocProvider<LoadingCubit>.value(
          value: _loadingCubit,
        ),
      ],
      child: BlocBuilder<LanguageCubit, Locale>(builder: (context, locale) {
        return WiredashApp(
          navigatorKey: _navigatorKey,
          languageCode: locale.languageCode,
          child: MaterialApp(
            navigatorKey: _navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Movie App',
            theme: ThemeData(
              unselectedWidgetColor: AppColor.royalBlue,
              primaryColor: AppColor.vulcan,
              accentColor: AppColor.royalBlue,
              scaffoldBackgroundColor: AppColor.vulcan,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              textTheme: ThemeText.getTextTheme(),
              appBarTheme: const AppBarTheme(elevation: 0),
            ),
            supportedLocales:
                Languages.languages.map((e) => Locale(e.code)).toList(),
            locale: locale,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            builder: (context, child) {
              return LoadingScreen(
                screen: child!,
              );
            },
            initialRoute: RouteList.initial,
            onGenerateRoute: (RouteSettings settings) {
              final routes = Routes.getRoutes(settings);
              final WidgetBuilder? builder = routes[settings.name];
              return FadePageRouteBuilder(
                builder: builder!,
                settings: settings,
              );
            },
          ),
        );
      }),
    );
  }
}
