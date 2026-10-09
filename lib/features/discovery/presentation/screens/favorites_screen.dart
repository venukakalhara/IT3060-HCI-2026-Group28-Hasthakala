import '../../../../core/localization/tr.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/shared_models/product_model.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../state/favorites_provider.dart';
import '../../data/datasources/discovery_remote_datasource.dart';
import '../widgets/product_card.dart';
import '../widgets/favorite_button.dart';
import 'product_details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key, this.loadProducts});
  final Future<List<ProductModel>> Function(List<String>)? loadProducts;
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String? _key;
  Future<List<ProductModel>>? _products;
  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>();
    final ids = favorites.ids.toList()..sort();
    final key = jsonEncode([favorites.account, ids]);
    if (_key != key) {
      _key = key;
      _products = ids.isEmpty
          ? Future.value([])
          : (widget.loadProducts ??
              DiscoveryRemoteDataSource().getSavedProducts)(ids);
    }
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('discovery_saved_title'))),
      body: favorites.error != null
          ? EmptyStateView(
              icon: Icons.error_outline,
              title: context.tr('discovery_favorites_error'),
              description: context.tr('discovery_load_favorites_error'),
              actionButtonText: context.tr('discovery_retry'),
              onActionPressed: () =>
                  favorites.setAccount(favorites.account, reload: true))
          : favorites.busy && ids.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ids.isEmpty
                  ? EmptyStateView(
                      icon: Icons.favorite_border,
                      title: context.tr('discovery_favorites_empty'),
                      description: context.tr('discovery_favorites_help'))
                  : FutureBuilder<List<ProductModel>>(
                      future: _products,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done)
                          return const Center(
                              child: CircularProgressIndicator());
                        if (snapshot.hasError)
                          return EmptyStateView(
                              icon: Icons.cloud_off,
                              title: context.tr('discovery_load_error'),
                              description:
                                  context.tr('discovery_favorites_offline'),
                              actionButtonText: context.tr('discovery_retry'),
                              onActionPressed: () =>
                                  setState(() => _key = null));
                        final products = {
                          for (final product in snapshot.data!)
                            product.id: product
                        };
                        return GridView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: ids.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: .70),
                            itemBuilder: (_, index) {
                              final product = products[ids[index]];
                              if (product == null)
                                return Card(
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                      Text(context
                                          .tr('discovery_craft_unavailable')),
                                      FavoriteButton(productId: ids[index]),
                                    ]));
                              return ProductCard(
                                  key: ValueKey(product.id),
                                  product: product,
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => ProductDetailsScreen(
                                              product: product))));
                            });
                      }),
    );
  }
}
