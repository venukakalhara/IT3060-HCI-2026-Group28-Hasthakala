import 'package:flutter/widgets.dart';

import 'app_strings.dart';

extension Translate on BuildContext {
  // context.tr('sign_in')  or  context.tr('hello', {'name': 'Kavindu'}) for "{name}"
  String tr(String key, [Map<String, String>? args]) {
    var text = AppStrings.get(key, Localizations.localeOf(this).languageCode);
    args?.forEach((k, v) => text = text.replaceAll('{$k}', v));
    return text;
  }

  // translates a known English message (validator or sign-in error);
  // anything unknown is shown as it is
  String? trMessage(String? message) {
    if (message == null) return null;
    final key = AppStrings.messageKeys[message];
    return key == null ? message : tr(key);
  }
}
