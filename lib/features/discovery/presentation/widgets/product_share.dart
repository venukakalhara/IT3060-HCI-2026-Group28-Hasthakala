import '../../../../core/localization/tr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/shared_models/product_model.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/localization/app_strings.dart';

String productShareText(ProductModel product, {String languageCode = 'en'}) {
  String label(String key, String value, String argument) =>
      AppStrings.get('discovery_$key', languageCode)
          .replaceAll('{$argument}', value);
  return [
    '${product.title} — Hasthakala',
    CurrencyFormatter.formatLKR(product.priceLkr),
    if (product.artisanName.isNotEmpty)
      label('by', product.artisanName, 'name'),
    if (product.district.isNotEmpty)
      label('origin_value', product.district, 'place'),
    label('product_id', product.id, 'id'),
  ].join('\n');
}

Future<void> showProductShare(
    BuildContext context, ProductModel product) async {
  final text = productShareText(product,
      languageCode: Localizations.localeOf(context).languageCode);
  await showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    builder: (sheetContext) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.tr('discovery_share_title'),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              SelectableText(text),
              const SizedBox(height: 16),
              Text(context.tr('discovery_copy_help')),
              const SizedBox(height: 12),
              FilledButton.icon(
                  icon: const Icon(Icons.copy),
                  label: Text(context.tr('discovery_copy_details')),
                  onPressed: () async {
                    try {
                      await Clipboard.setData(ClipboardData(text: text));
                      if (!sheetContext.mounted) return;
                      Navigator.pop(sheetContext);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(context.tr('discovery_copied'))));
                      }
                    } catch (_) {
                      if (sheetContext.mounted) {
                        ScaffoldMessenger.of(sheetContext).showSnackBar(
                            SnackBar(
                                content:
                                    Text(context.tr('discovery_copy_error'))));
                      }
                    }
                  }),
            ])),
  );
}
