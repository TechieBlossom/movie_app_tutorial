import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movieapp/common/constants/languages.dart';
import 'package:movieapp/common/screenutil/screenutil.dart';
import 'package:movieapp/presentation/app_localizations.dart';
import 'package:movieapp/presentation/blocs/language/language_cubit.dart';
import 'package:movieapp/presentation/blocs/loading/loading_cubit.dart';
import 'package:movieapp/presentation/blocs/login/login_cubit.dart';
import 'package:movieapp/presentation/journeys/login/login_form.dart';

class LanguageCubitMock extends Mock implements LanguageCubit {}

class LoginCubitMock extends Mock implements LoginCubit {}

class LoadingCubitMock extends Mock implements LoadingCubit {}

class NavigatorObseverMock extends Mock implements NavigatorObserver {}

class MockRoute extends Route {
  final RouteSettings settings;

  MockRoute(this.settings) : super(settings: settings);
}

main() {
  late Widget app;
  late LanguageCubitMock _languageCubitMock;
  late LoginCubitMock _loginCubitMock;
  late LoadingCubitMock _loadingCubitMock;
  late NavigatorObseverMock _observer;

  setUp(() {
    _languageCubitMock = LanguageCubitMock();
    _loginCubitMock = LoginCubitMock();
    _loadingCubitMock = LoadingCubitMock();
    _observer = NavigatorObseverMock();

    ScreenUtil.init();
    app = MultiBlocProvider(
      providers: [
        BlocProvider<LanguageCubit>.value(value: _languageCubitMock),
        BlocProvider<LoginCubit>.value(value: _loginCubitMock),
        BlocProvider<LoadingCubit>.value(value: _loadingCubitMock),
      ],
      child: MaterialApp(
        locale: Locale(Languages.languages[0].code),
        supportedLocales:
            Languages.languages.map((e) => Locale(e.code)).toList(),
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: Scaffold(
          body: LoginForm(),
        ),
        navigatorObservers: [_observer],
      ),
    );
  });

  tearDown(() {
    _loginCubitMock.close();
    _loadingCubitMock.close();
    _languageCubitMock.close();
  });

  // testWidgets(
  //     'should show error message when sign in API call with username, password is made',
  //     (WidgetTester tester) async {
  //   when(_loginCubitMock.state)
  //       .thenAnswer((_) => LoginError(TranslationConstants.sessionDenied));

  //   await tester.pumpWidget(app);
  //   await tester.pump();

  //   final Finder usernameField =
  //       find.byKey(const ValueKey('username_text_field_key'));
  //   final Finder passwordField =
  //       find.byKey(const ValueKey('password_text_field_key'));
  //   final Finder signInButton = find.byType(TextButton);

  //   expect(usernameField, findsOneWidget);
  //   expect(passwordField, findsOneWidget);
  //   expect(signInButton, findsOneWidget);

  //   await tester.enterText(usernameField, 'username');
  //   await tester.enterText(passwordField, 'password');
  //   await tester.pump();

  //   await tester.tap(signInButton);
  //   await tester.pump();

  //   expect(find.text('Session denied'), findsOneWidget);

  //   verify(_loginCubitMock.initiateLogin('username', 'password')).called(1);
  // });

  testWidgets(
      'should show success message when sign in API call with username, password is made',
      (WidgetTester tester) async {
    when(_loginCubitMock.state).thenAnswer((_) => LoginSuccess());

    await tester.pumpWidget(app);
    await tester.pump();

    final Finder usernameField =
        find.byKey(const ValueKey('username_text_field_key'));
    final Finder passwordField =
        find.byKey(const ValueKey('password_text_field_key'));
    final Finder signInButton = find.byType(TextButton);

    expect(usernameField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    expect(signInButton, findsOneWidget);

    await tester.enterText(usernameField, 'username');
    await tester.enterText(passwordField, 'password');
    await tester.pump();

    await tester.tap(signInButton);
    await tester.pump();

    expect(find.text('Session denied'), findsNothing);

    verify(_observer.didPush(MockRoute(RouteSettings(name: '/')),
        MockRoute(RouteSettings(name: '/home'))));
    verify(_loginCubitMock.initiateLogin('username', 'password')).called(1);
  });
}
