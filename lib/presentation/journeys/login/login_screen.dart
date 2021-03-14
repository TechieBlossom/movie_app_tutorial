import 'package:flutter/material.dart';
import 'package:movieapp/presentation/journeys/login/login_form.dart';
import 'package:movieapp/presentation/widgets/logo.dart';
import 'package:movieapp/common/extensions/size_extensions.dart';
import 'package:movieapp/common/constants/size_constants.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: Sizes.dimen_32.h),
              child: Logo(height: Sizes.dimen_12.h),
            ),
            LoginForm(),
          ],
        ),
      ),
    );
  }
}
