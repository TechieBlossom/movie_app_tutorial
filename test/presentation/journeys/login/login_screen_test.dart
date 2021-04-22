import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movieapp/common/screenutil/screenutil.dart';
import 'package:movieapp/presentation/blocs/language/language_cubit.dart';
import 'package:movieapp/presentation/blocs/loading/loading_cubit.dart';
import 'package:movieapp/presentation/blocs/login/login_cubit.dart';
import 'package:movieapp/presentation/journeys/login/login_screen.dart';
import 'package:movieapp/presentation/widgets/logo.dart';

import '../../../common/utils/test_utils.dart';

class LanguageCubitMock extends Mock implements LanguageCubit {}

class LoginCubitMock extends Mock implements LoginCubit {}

class LoadingCubitMock extends Mock implements LoadingCubit {}

class NavigatorObserverMock extends Mock implements NavigatorObserver {}

main() {
  Widget app;
  LanguageCubitMock _languageCubitMock;
  LoginCubitMock _loginCubitMock;
  LoadingCubitMock _loadingCubitMock;
  NavigatorObserverMock _mockObserver;

  setUp(() {
    _languageCubitMock = LanguageCubitMock();
    _loginCubitMock = LoginCubitMock();
    _loadingCubitMock = LoadingCubitMock();
    _mockObserver = NavigatorObserverMock();

    ScreenUtil.init();
    app = materialWrapperWithBlocs(
      LoginScreen(),
      [
        BlocProvider<LanguageCubit>.value(value: _languageCubitMock),
        BlocProvider<LoginCubit>.value(value: _loginCubitMock),
        BlocProvider<LoadingCubit>.value(value: _loadingCubitMock),
      ],
      _mockObserver,
    );
  });

  tearDown(() {
    _loginCubitMock.close();
    _loadingCubitMock.close();
    _languageCubitMock.close();
  });

  testWidgets('should show basic login screen UI login form and logo',
      (WidgetTester tester) async {
    //When

    const loginFormKey = ValueKey('login_form_key');
    const logoKey = ValueKey('logo_key');

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    expect(find.byType(Logo), findsOneWidget);
    expect(find.byKey(loginFormKey), findsOneWidget);
  });
}
