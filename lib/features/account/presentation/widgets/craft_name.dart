import 'package:flutter/widgets.dart';

import '../../../../core/constants/craft_categories.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/localization/tr.dart';

// craft name in the chosen language (craft_<key> in app_strings).
// falls back to the English label from craft_categories.dart
String craftName(BuildContext context, String key) {
  final textKey = 'craft_$key';
  if (AppStrings.values.containsKey(textKey)) return context.tr(textKey);
  return CraftCategories.labelFor(key);
}
