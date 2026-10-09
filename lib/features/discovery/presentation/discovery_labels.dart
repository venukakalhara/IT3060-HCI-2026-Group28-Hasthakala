import 'package:flutter/widgets.dart';
import '../../../core/constants/craft_categories.dart';
import '../../../core/localization/app_strings.dart';
import '../../discovery/data/discovery_filters.dart';

// Translate display labels only. Queries and stored values keep their original keys.
String discoveryCategoryLabel(BuildContext context, String value) {
  final key = discoveryCategoryKey(value);
  final translation = 'discovery_category_$key';
  return AppStrings.values.containsKey(translation)
      ? AppStrings.get(
          translation, Localizations.localeOf(context).languageCode)
      : CraftCategories.labelFor(key ?? value);
}

String discoveryOriginLabel(BuildContext context, String value) {
  final key = 'discovery_origin_${value.toLowerCase().replaceAll(' ', '_')}';
  return AppStrings.values.containsKey(key)
      ? AppStrings.get(key, Localizations.localeOf(context).languageCode)
      : value;
}
