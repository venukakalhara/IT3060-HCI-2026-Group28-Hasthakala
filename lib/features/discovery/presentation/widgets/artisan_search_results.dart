import 'package:flutter/material.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/constants/craft_categories.dart';
import '../../../../core/localization/tr.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../discovery_labels.dart';
import '../state/artisan_search_provider.dart';

class ArtisanSearchResults extends StatelessWidget {
  const ArtisanSearchResults({super.key, required this.provider});
  final ArtisanSearchProvider provider;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: provider,
        builder: (context, _) {
          final results = provider.results;
          return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                  height: 48,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: CraftCategories.all.length + 1,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, index) {
                      final category =
                          index == 0 ? null : CraftCategories.all[index - 1];
                      return ChoiceChip(
                        label: Text(category == null
                            ? context.tr('discovery_all_crafts')
                            : discoveryCategoryLabel(context, category.key)),
                        selected: provider.category == category?.key,
                        onSelected: (_) => provider.setCategory(category?.key),
                      );
                    },
                  )),
              FilterChip(
                label: Text(context.tr('discovery_verified_only')),
                selected: provider.verifiedOnly,
                onSelected: provider.setVerifiedOnly,
              ),
              const SizedBox(height: 8),
              Expanded(
                  child: provider.loading
                      ? LoadingIndicator(
                          message: context.tr('discovery_artisans_loading'))
                      : SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: provider.failed
                              ? EmptyStateView(
                                  icon: Icons.cloud_off,
                                  title: context.tr('discovery_artisans_error'),
                                  description:
                                      context.tr('discovery_retry_help'),
                                  actionButtonText:
                                      context.tr('discovery_retry'),
                                  onActionPressed: provider.refresh)
                              : results.isEmpty
                                  ? EmptyStateView(
                                      icon: Icons.person_search,
                                      title: context
                                          .tr('discovery_artisans_empty'),
                                      description: context
                                          .tr('discovery_no_results_help'),
                                      actionButtonText:
                                          context.tr('discovery_retry'),
                                      onActionPressed: provider.refresh)
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                          Row(children: [
                                            Expanded(
                                                child: Text(context.tr(
                                                    'discovery_artisans_count',
                                                    {
                                                  'count': '${results.length}'
                                                }))),
                                            IconButton(
                                                tooltip: context
                                                    .tr('discovery_refresh'),
                                                icon: const Icon(Icons.refresh),
                                                onPressed: provider.refresh),
                                          ]),
                                          for (final artisan in results)
                                            Card(
                                                child: ListTile(
                                              key: ValueKey(
                                                  'artisan-${artisan.artisanUid}'),
                                              leading: CircleAvatar(
                                                  child: artisan.photoUrl
                                                              ?.isNotEmpty ==
                                                          true
                                                      ? ClipOval(
                                                          child: Image.network(
                                                              artisan.photoUrl!,
                                                              width: 40,
                                                              height: 40,
                                                              fit: BoxFit.cover,
                                                              errorBuilder: (_,
                                                                      __,
                                                                      ___) =>
                                                                  const Icon(Icons
                                                                      .person)))
                                                      : const Icon(
                                                          Icons.person)),
                                              title: Text(artisan
                                                      .displayName.isEmpty
                                                  ? context.tr(
                                                      'discovery_profile_fallback')
                                                  : artisan.displayName),
                                              subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    if (artisan
                                                        .craftType.isNotEmpty)
                                                      Text(
                                                          discoveryCategoryLabel(
                                                              context,
                                                              artisan
                                                                  .craftType)),
                                                    if (artisan
                                                        .location.isNotEmpty)
                                                      Text(discoveryOriginLabel(
                                                          context,
                                                          artisan.location)),
                                                    if (artisan.verified)
                                                      Text(context.tr(
                                                          'discovery_verified')),
                                                  ]),
                                              trailing: const Icon(
                                                  Icons.chevron_right),
                                              onTap: () => Navigator.pushNamed(
                                                  context,
                                                  AppRoutes.artisanProfile,
                                                  arguments:
                                                      artisan.artisanUid),
                                            )),
                                        ]),
                        )),
            ]),
          );
        },
      );
}
