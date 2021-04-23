import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movieapp/common/constants/languages.dart';
import 'package:movieapp/common/constants/translation_constants.dart';
import 'package:movieapp/common/screenutil/screenutil.dart';
import 'package:movieapp/presentation/app_localizations.dart';
import 'package:movieapp/presentation/blocs/language/language_cubit.dart';
import 'package:movieapp/presentation/blocs/loading/loading_cubit.dart';
import 'package:movieapp/presentation/blocs/login/login_cubit.dart';
import 'package:movieapp/presentation/journeys/login/label_field_widget.dart';
import 'package:movieapp/presentation/journeys/login/login_form.dart';
import 'package:movieapp/presentation/widgets/button.dart';

import '../../../common/utils/test_utils.dart';

class LanguageCubitMock extends Mock implements LanguageCubit {}

class LoginCubitMock extends Mock implements LoginCubit {}

class LoadingCubitMock extends Mock implements LoadingCubit {}

class NavigatorObserverMock extends Mock implements NavigatorObserver {}

main() {
  LanguageCubitMock _languageCubitMock;
  LoginCubitMock _loginCubitMock;
  LoadingCubitMock _loadingCubitMock;
  NavigatorObserverMock _mockObserver;

  setUp(() {
    _languageCubitMock = LanguageCubitMock();
    _loadingCubitMock = LoadingCubitMock();
    _loginCubitMock = LoginCubitMock();
    _mockObserver = NavigatorObserverMock();

    ScreenUtil.init();
  });

  tearDown(() {
    _languageCubitMock.close();
    _loadingCubitMock.close();
    _loginCubitMock.close();
  });

  Widget getWidget() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LanguageCubit>(create: (_) => _languageCubitMock),
        BlocProvider<LoginCubit>(create: (_) => _loginCubitMock),
        BlocProvider<LoadingCubit>(create: (_) => _loadingCubitMock),
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
        home: Scaffold(body: LoginForm()),
        navigatorObservers: [_mockObserver],
      ),
    );
  }

  group(('Login Form Test 2'), () {
    final Finder usernameFieldFinder =
        find.byKey(ValueKey('username_text_field_key'));
    final Finder passwordFieldFinder =
        find.byKey(ValueKey('password_text_field_key'));
    final Finder signInButtonFinder = find.byType(TextButton);

    // Future<Null> _verifyBasic() async {
    //   expect(usernameFieldFinder, findsOneWidget);
    //   expect(passwordFieldFinder, findsOneWidget);
    //   expect(signInButtonFinder, findsOneWidget);
    // }

    // testWidgets(
    //     'should show error message when sign in API call with username, password is made',
    //     (WidgetTester tester) async {
    //   when(_loginCubitMock.state)
    //       .thenAnswer((_) => LoginError(TranslationConstants.sessionDenied));

    //   await tester.pumpWidget(getWidget());
    //   await tester.pumpAndSettle();

    //   await _verifyBasic();

    //   await tester.enterText(usernameFieldFinder, 'username');
    //   await tester.enterText(passwordFieldFinder, 'password');
    //   await tester.pumpAndSettle();

    //   await tester.tap(signInButtonFinder);
    //   await tester.pumpAndSettle();

    //   expect(find.text('Session denied'), findsOneWidget);

    //   verify(_loginCubitMock.initiateLogin(any, any)).called(1);
    // });

    testWidgets(
        'should show success message when sign in API call with username, password is made',
        (WidgetTester tester) async {
      when(_loginCubitMock.state).thenAnswer((_) => LoginSuccess());

      await tester.pumpWidget(getWidget());
      await tester.pumpAndSettle();

      await tester.enterText(usernameFieldFinder, 'username');
      await tester.enterText(passwordFieldFinder, 'password');
      await tester.pumpAndSettle();

      await tester.tap(signInButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('Session denied'), findsNothing);

      verify(_loginCubitMock.initiateLogin(any, any)).called(1);
      verify(_mockObserver.didPush(any, any));
    });
  });
}
