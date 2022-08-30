import 'package:flutter/material.dart';

import '../../presentation/app_localizations.dart';

extension StringExtension on String {
  String intelliTrim() {
    return length > 15 ? '${substring(0, 15)}...' : this;
  }

  String t(BuildContext context) {
    return AppLocalizations.of(context)?.translate(this) ?? '';
  }
}
