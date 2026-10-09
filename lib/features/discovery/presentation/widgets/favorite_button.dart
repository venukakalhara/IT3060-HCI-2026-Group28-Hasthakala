import '../../../../core/localization/tr.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../state/favorites_provider.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key, required this.productId});
  final String productId;
  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>();
    final selected = favorites.contains(productId);
    return IconButton(
      tooltip: selected
          ? context.tr('discovery_remove_favorite')
          : context.tr('discovery_save_favorite'),
      isSelected: selected,
      icon: Icon(selected ? Icons.favorite : Icons.favorite_border,
          color: selected ? AppColors.primary : AppColors.textSecondary),
      onPressed: favorites.busy
          ? null
          : () async {
              final saved = await favorites.toggle(productId);
              if (!context.mounted) return;
              if (!saved) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(favorites.error != null
                      ? context.tr('discovery_load_favorites_error')
                      : context.tr('discovery_save_error')),
                  action: favorites.error == null
                      ? null
                      : SnackBarAction(
                          label: context.tr('discovery_retry'),
                          onPressed: () => favorites
                              .setAccount(favorites.account, reload: true)),
                ));
              }
            },
    );
  }
}
