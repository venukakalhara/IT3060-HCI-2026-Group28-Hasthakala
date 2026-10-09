import '../discovery_labels.dart';
import '../../../../core/localization/tr.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/craft_categories.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../state/search_filter_provider.dart';
import '../widgets/craft_category_chip.dart';
import '../widgets/product_card.dart';
import '../widgets/search_filter_bottom_sheet.dart';
import 'product_details_screen.dart';
import 'favorites_screen.dart';
import '../state/artisan_search_provider.dart';
import '../widgets/artisan_search_results.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen(
      {super.key,
      this.initialCategory,
      this.openFilters = false,
      this.search,
      this.loadArtisans});
  final ArtisanLoader? loadArtisans;
  final String? initialCategory;
  final bool openFilters;
  final DiscoverySearch? search;
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  late final SearchFilterProvider _provider;
  ArtisanSearchProvider? _artisanProvider;
  bool _showArtisans = false;

  void _changeMode(bool artisans) {
    if (artisans == _showArtisans) return;
    if (artisans) {
      if (_artisanProvider == null) {
        _artisanProvider = ArtisanSearchProvider(load: widget.loadArtisans);
        _artisanProvider!.setCategory(widget.initialCategory);
        _artisanProvider!.refresh();
      }
      _artisanProvider!.setQuery(_controller.text);
    } else {
      _provider.performSearch(query: _controller.text);
    }
    setState(() => _showArtisans = artisans);
  }

  void _queryChanged(String value, {bool submit = false}) {
    if (_showArtisans) {
      _artisanProvider!.setQuery(value);
      setState(() {});
    } else if (submit) {
      _provider.performSearch(query: value);
    } else {
      _provider.updateQuery(value);
    }
  }

  @override
  void initState() {
    super.initState();
    _provider = SearchFilterProvider(search: widget.search);
    _provider.setCategory(widget.initialCategory);
    if (widget.openFilters) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _openFilters();
      });
    }
  }

  void _openFilters() {
    FocusScope.of(context).unfocus();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SearchFilterBottomSheet(provider: _provider),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _provider.dispose();
    _artisanProvider?.dispose();
    super.dispose();
  }

  Widget _modeButton(bool artisans) {
    final selected = _showArtisans == artisans;
    return Expanded(
      child: Semantics(
          selected: selected,
          child: TextButton(
            onPressed: () => _changeMode(artisans),
            style: TextButton.styleFrom(
              backgroundColor:
                  selected ? AppColors.surface : Colors.transparent,
              foregroundColor:
                  selected ? AppColors.primary : AppColors.textSecondary,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
                context.tr(artisans
                    ? 'discovery_artisans_tab'
                    : 'discovery_products_tab'),
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w700)),
          )),
    );
  }

  Widget _sortControl() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border)),
        child: Row(children: [
          const Icon(Icons.swap_vert_rounded,
              size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
              child: DropdownButtonHideUnderline(
                  child: DropdownButton<DiscoverySort>(
            key: const ValueKey('discovery-sort'),
            isExpanded: true,
            value: _provider.sort,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 13, color: AppColors.textPrimary),
            borderRadius: BorderRadius.circular(14),
            items: [
              for (final sort in DiscoverySort.values)
                DropdownMenuItem(
                    value: sort,
                    child: Text(context.tr('discovery_sort_${sort.name}')))
            ],
            onChanged: (sort) {
              if (sort != null) _provider.setSort(sort);
            },
          ))),
        ]),
      );

  void _resetSearch() {
    _controller.clear();
    _provider.updateQuery('');
    _provider.clearFilters();
    FocusScope.of(context).unfocus();
  }

  Widget _emptyResults() => SingleChildScrollView(
        child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 480),
              margin: const EdgeInsets.symmetric(vertical: 24),
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border)),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: .08),
                        shape: BoxShape.circle),
                    child: const Icon(Icons.search_off_rounded,
                        size: 36, color: AppColors.primary)),
                const SizedBox(height: 20),
                Text(context.tr('discovery_no_results'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(context.tr('discovery_no_results_help'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: AppColors.textSecondary, height: 1.6)),
                if (_controller.text.isNotEmpty || _provider.hasFilters) ...[
                  const SizedBox(height: 20),
                  TextButton.icon(
                      onPressed: _resetSearch,
                      icon: const Icon(Icons.refresh, size: 18),
                      label: Text(context.tr('discovery_reset_search'))),
                ],
              ]),
            )),
      );

  Widget _products(double width) {
    final provider = _provider;
    final results = provider.searchResults;
    final wide = width >= 600;
    final columns = width >= 900
        ? 4
        : wide
            ? 3
            : 2;
    final title = Text(
        provider.isSearching
            ? context.tr('discovery_searching')
            : context.tr('discovery_results', {'count': '${results.length}'}),
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700));
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
          height: 48,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: CraftCategories.all.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, index) {
              final category =
                  index == 0 ? null : CraftCategories.all[index - 1];
              return Center(
                  child: CraftCategoryChip(
                label: category == null
                    ? context.tr('discovery_all_crafts')
                    : discoveryCategoryLabel(context, category.key),
                isSelected: provider.selectedCategory == category?.key,
                onTap: () => provider.setCategory(category?.key),
              ));
            },
          )),
      const SizedBox(height: 20),
      if (wide)
        Row(children: [
          Expanded(child: title),
          const SizedBox(width: 24),
          SizedBox(width: 260, child: _sortControl())
        ])
      else ...[title, const SizedBox(height: 12), _sortControl()],
      if (provider.hasFilters)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Wrap(
              spacing: 8,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (provider.selectedDistrict != null)
                  Chip(
                      label: Text(discoveryOriginLabel(
                          context, provider.selectedDistrict!))),
                if (provider.maxPrice != null)
                  Chip(
                      label: Text(context.tr('discovery_up_to',
                          {'price': provider.maxPrice!.toStringAsFixed(2)}))),
                TextButton(
                    onPressed: provider.clearFilters,
                    child: Text(context.tr('discovery_clear_filters'))),
              ]),
        ),
      const SizedBox(height: 16),
      Expanded(
        child: provider.isSearching
            ? LoadingIndicator(message: context.tr('discovery_searching_long'))
            : provider.errorMessage != null
                ? SingleChildScrollView(
                    child: EmptyStateView(
                        icon: Icons.cloud_off,
                        title: context.tr('discovery_load_error'),
                        description: context.tr('discovery_retry_help'),
                        actionButtonText: context.tr('discovery_retry'),
                        onActionPressed: provider.performSearch))
                : results.isEmpty
                    ? _emptyResults()
                    : RefreshIndicator(
                        onRefresh: provider.performSearch,
                        child: GridView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 24),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: columns,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 20,
                                  childAspectRatio: .70),
                          itemCount: results.length,
                          itemBuilder: (_, index) => ProductCard(
                              key: ValueKey(results[index].id),
                              product: results[index],
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ProductDetailsScreen(
                                          product: results[index])))),
                        )),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _provider,
        builder: (context, _) => Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
              child: Center(
                  child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: LayoutBuilder(builder: (context, constraints) {
              final wide = constraints.maxWidth >= 600;
              final compact = constraints.maxHeight < 600;
              return Padding(
                padding: EdgeInsets.fromLTRB(
                    wide ? 32 : 16, wide ? 28 : 12, wide ? 32 : 16, 0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!compact) ...[
                        Row(children: [
                          if (Navigator.of(context).canPop())
                            const BackButton(),
                          Expanded(
                              child: Text(context.tr('discovery_explore_title'),
                                  style: TextStyle(
                                      fontSize: wide ? 30 : 24,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -.5))),
                          IconButton(
                              tooltip: context.tr('discovery_saved_action'),
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const FavoritesScreen())),
                              icon: const Icon(Icons.favorite_border_rounded)),
                        ]),
                        if (wide) ...[
                          const SizedBox(height: 4),
                          Text(context.tr('discovery_explore_subtitle'),
                              style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14)),
                        ],
                        const SizedBox(height: 20),
                      ],
                      Row(children: [
                        if (compact && Navigator.of(context).canPop())
                          const BackButton(),
                        Expanded(
                            child: TextField(
                          controller: _controller,
                          onChanged: _queryChanged,
                          onSubmitted: (value) =>
                              _queryChanged(value, submit: true),
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            hintText: context.tr(_showArtisans
                                ? 'discovery_artisans_hint'
                                : 'discovery_search'),
                            filled: true,
                            fillColor: AppColors.surface,
                            prefixIcon: const Icon(Icons.search_rounded,
                                color: AppColors.primary),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide:
                                    const BorderSide(color: AppColors.border)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide:
                                    const BorderSide(color: AppColors.border)),
                            suffixIcon: _controller.text.isEmpty
                                ? null
                                : IconButton(
                                    tooltip:
                                        context.tr('discovery_clear_search'),
                                    icon: const Icon(Icons.close_rounded,
                                        size: 20),
                                    onPressed: () {
                                      _controller.clear();
                                      _queryChanged('', submit: true);
                                    }),
                          ),
                        )),
                        if (!_showArtisans) ...[
                          const SizedBox(width: 10),
                          IconButton.filled(
                              tooltip: context.tr('discovery_filter_action'),
                              onPressed: _openFilters,
                              style: IconButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.onPrimary,
                                  minimumSize: const Size(52, 52),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16))),
                              icon: Badge(
                                  isLabelVisible: _provider.hasFilters,
                                  child: const Icon(Icons.tune_rounded))),
                        ],
                      ]),
                      const SizedBox(height: 16),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 400),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: .07),
                                borderRadius: BorderRadius.circular(16)),
                            child: Row(children: [
                              _modeButton(false),
                              _modeButton(true)
                            ]),
                          )),
                      const SizedBox(height: 12),
                      Expanded(
                          child: _showArtisans
                              ? ArtisanSearchResults(
                                  provider: _artisanProvider!)
                              : _products(
                                  constraints.maxWidth - (wide ? 64 : 32))),
                    ]),
              );
            }),
          ))),
        ),
      );
}
