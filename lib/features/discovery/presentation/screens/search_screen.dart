import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../state/search_filter_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/search_filter_bottom_sheet.dart';
import 'product_details_screen.dart';

/// Assigned to: JAYAWARDANA V. K. A.
/// Branch: feature/buyer-discovery
class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchFilterProvider(),
      child: Consumer<SearchFilterProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            appBar: CustomAppBar(
              title: 'Search Handicrafts',
              actions: [
                IconButton(
                  icon: const Icon(Icons.tune, color: AppColors.primary),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      builder: (_) => SearchFilterBottomSheet(provider: provider),
                    );
                  },
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CustomTextField(
                    label: '',
                    hint: 'Search by craft name, artisan, or district...',
                    controller: _searchController,
                    prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: AppColors.textMuted),
                            onPressed: () {
                              _searchController.clear();
                              provider.performSearch(query: '');
                            },
                          )
                        : null,
                    onChanged: (val) {
                      provider.performSearch(query: val);
                    },
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: provider.isSearching
                        ? const LoadingIndicator(message: 'Searching crafts...')
                        : provider.searchResults.isEmpty
                            ? const EmptyStateView(
                                icon: Icons.search_off,
                                title: 'No crafts found',
                                description: 'Try adjusting your search keywords or filters.',
                              )
                            : GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.72,
                                ),
                                itemCount: provider.searchResults.length,
                                itemBuilder: (context, index) {
                                  final product = provider.searchResults[index];
                                  return ProductCard(
                                    product: product,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ProductDetailsScreen(product: product),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
