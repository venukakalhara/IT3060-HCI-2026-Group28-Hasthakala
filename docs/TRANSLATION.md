# Adding translations

1. Add the text to `lib/core/localization/app_strings.dart`:

```dart
'cart_title': {'en': 'My Cart', 'si': 'මගේ කරත්තය', 'ta': 'எனது கூடை'},
```

2. Use it in your screen:

```dart
import '../../../../core/localization/tr.dart';

Text(context.tr('cart_title'))
Text(context.tr('items_count', {'count': '3'}))   // for text with {count} in it
```

Notes:
- a Text using `context.tr` can't be `const`
- if a language is missing, English shows
- if you see the key itself on screen, it isn't in app_strings.dart yet
- product names, descriptions and messages typed by users aren't translated
- get someone who speaks Sinhala / Tamil to check new text
