# Buyer Discovery: Stitch comparison and functional audit

Reviewed: 7 October 2026. Branch: `feature/buyer-discovery`.

## Search layout refresh (8 October)

- Reworked Search into a constrained, centered layout with a clear heading, full-width search field, prominent filter button, rounded Products/Artisans tabs and aligned category controls. Desktop results and compact sorting share a row; narrow screens stack them. Product grids use responsive column counts.
- Replaced the sparse empty state with a compact bordered card. When a query or filter is active, Reset search clears both. Artisan controls align with the same content edge. Existing translation mappings render human-readable tab labels in the generated previews.
- **100 automated tests passed**, including English/Sinhala/Tamil search and empty-state layouts at 320px, 390px and 960px. Inspected mobile populated and desktop empty previews in `.dart_tool/polish_previews/`. Mock product images in tests remain placeholders; no production imagery was removed.

## Artisan search completion (8 October)

- Completed the interrupted Products/Artisans search switch with English/Sinhala/Tamil labels. Artisan mode reads public `artisanProfiles` on first entry, searches name/craft/about/location locally, and combines category and verified-only filters. It does not query private account documents or apply product price filters to artisans.
- Selecting a result sends its `artisanUid` to the existing public-profile route. Search text survives mode changes; artisan data and filters remain available during the Search screen session. Refresh/retry reloads profiles. Loading, failure and no-match states are separate.
- Added filter, latest-response, retry, disposal and localized UI/navigation tests, plus six artisan-mode viewport/locale checks. **85 automated tests passed**, including all existing regressions. Static analysis of the artisan-search implementation and new test found no issues. Rendered Tamil layout was visually inspected with the local test font fallback.
- Verification uses controlled data; live signed-in Firebase and phone testing remain pending. The current implementation loads the public profile collection and filters on-device; pagination/indexed search remains future work for a larger catalog. Search matches stored text, without transliteration or automatic translation of artisan-written content.

## Search price sorting (7 October)

- Added Default order, Price: low to high and Price: high to low to the main Search screen, with English/Sinhala/Tamil labels. Default order restores the data source order; it does not claim a relevance ranking.
- Sorting uses the current search results without an extra Firebase request or source-list mutation. Equal-price products retain their source order. The selection survives query/filter changes, filter clearing, refresh/retry and locale changes during the screen session.
- Added stable/reversible sorting and in-flight/filter/retry regression coverage, plus localized dropdown interaction checks. **74 tests passed**, including multilingual 320px/390px layout tests. Analysis of all changed Dart files found no issues. Live Firebase/mobile checks remain pending.

## Core Discovery localization (7 October)

- Connected Home, Search/Filter, Product Details, Public Artisan Profile and Saved Crafts to the existing `context.tr` locale mechanism, including shared cart actions, favorites, gallery, share sheet and Home guidance. English/Sinhala/Tamil strings live in `lib/core/localization/discovery_strings.dart`, merged into `AppStrings`.
- Translated category and known district display labels while preserving query/storage values. Product names, descriptions and artisan-written stories remain unchanged. Share details use translated labels with the original product values. Removed the invented Kelaniya guild fallback from Product Details.
- Fixed narrow-screen wrapping for the sample-report button, review labels and studio action. Added locale-switch/filter-key tests and translation placeholder checks; extended screen layout checks to Sinhala/Tamil at 320px (1.2 text scale) and 390px.
- **72 automated tests passed.** Multilingual render checks used the installed Nirmala font via `DISCOVERY_TEST_SCRIPT_FONT` (test-only, no OS font redistributed); previews are in `.dart_tool/polish_previews/*_si.png` and `*_ta.png`. Actual phone font/rendering and live Firebase checks remain pending. A fluent Sinhala/Tamil speaker should review wording before release.
- This pass covers the core assigned Discovery flow and its shared controls. Separate legacy sample catalog/master-profile/reviews/commission/lab screens and purchase screens are not fully localized by this change.

## Discovery verification follow-up (7 October)

- Re-ran the existing 50 automated tests successfully. Fixed Home refresh handling for a synchronous query-start failure and for a stream that closes before its first snapshot; both now finish loading and expose the retry state. An actual empty snapshot remains a successful empty catalog.
- Added three regression tests covering startup failure/recovery, closure without data, and a valid empty snapshot. The full suite now passes **53 tests**.
- Replaced unsupported Home certification, 88% payout and insured-packaging claims with factual browsing guidance. The link to the preview lab report now explicitly says `View Sample Lab Report`.
- Analysis of the changed Dart files reported no errors or warnings, with 9 informational style/deprecation findings.
- Device discovery found Windows, Chrome and Edge, but no phone/emulator. The user chose automated verification for this pass. No live Firebase/mobile end-to-end verification was performed; tests use controlled data. Translations and the additional reference features remain outstanding.

## Screen polish pass (7 October)

The existing colour palette was preserved as explicitly requested. This pass covers the 10 distinct implemented views represented by the 16 Stitch exports (the Home/Explore/Details/Profile exports include alternative versions). It is a responsive UI and interaction polish pass, not a claim of exact pixel parity or completed backend integration.

- Rendered and inspected Home, Explore, Product Details, Public Profile, Master Profile, Catalog, Reviews, Commission, Lab Report and Checkout. Local QA previews are in `.dart_tool/polish_previews/`. Tests deliberately use missing/offline images to verify fallback layouts; blank/image-error placeholders in those previews do not indicate that production photography was removed.
- Fixed narrow-screen wrapping in headings, prices, metadata, reviews, payment controls and lab metrics. Verified 320px at 1.2 text scale and 390px at normal scale, including scrolling lower sections. Loaded the bundled text and Material icon fonts for visual review.
- Fixed the commission dropdown's invalid initial value and disposed form controllers. Commission now validates fields and copies a usable request draft with an optional reference link; it does not falsely claim to submit a request or upload a file.
- Catalog sorting now changes the sample collection order, empty categories show a message, and the Home profile action opens the profile route.
- Checkout displays real cart lines/counts, charges delivery once, removes sample customer details, validates delivery fields, and opens an order review. It does not claim to place an order. Empty carts cannot proceed.
- Legacy artisan/reviews/catalog/lab sample content is identified as preview content. Certificate actions no longer claim a successful PDF download; no certificate exists for those sample results.

Validation: **50 tests passed**, including 20 screen/width cases and 3 new interaction regressions. Static analysis completed with no errors or warnings, with 91 informational findings. Live phone/Firebase end-to-end testing remains pending. Live review/catalog binding for the legacy preview views, commission delivery, certificates, payment/order submission and cross-device persistence remain separate unfinished functionality.

The earlier audit and implementation notes below describe the historical baseline and previous passes.

Third implementation update: Product Details now has a swipeable image gallery, selectable thumbnails, photo counter and fullscreen pinch zoom, with honest missing/broken-image states. Home and Search open Saved Crafts; all product-card/details hearts use one shared favorites provider. Favorites persist product IDs in SharedPreferences on this device, separately for each account, and the saved list retrieves current product documents rather than retaining stale prices/stock. Missing products can be removed; storage/load failures are surfaced. Share opens a preview and copies real product text to the platform clipboard for pasting into messages. There is no fabricated public product URL or native OS share sheet. Missing ratings/specifications now show unavailable/unreviewed states; the unconditional product verification badge was removed.

Third-update validation: all 27 discovery state/widget tests passed, including favorites recreation/account separation/write failure, shared hearts, missing saved products, gallery swiping/thumbnails/zoom, and the platform Clipboard.setData call. Flutter device discovery found Windows, Chrome and Edge, but no connected mobile phone/emulator; live mobile/Firebase end-to-end verification remains outstanding. Favorites are device-local and do not sync between devices; live review aggregation is still pending. These updates supersede corresponding outstanding items in the earlier notes below.

Second implementation update: product-card quick-add and product-details Add to Cart now use the existing shared cart. Details offer quantity controls, reject unavailable/over-stock additions including quantities already in the cart, and Buy Now adds the selected quantity before navigating to the existing checkout. Home/details show the live cart count and link to the cart; cart quantity changes respect the stock limit captured when the product was added. The Home spotlight now derives its maker/product from loaded products. Public artisan profiles now read `artisanProfiles`, query products by `artisanId`, render the stored verification flag, and expose loading/retry/not-found/empty states instead of sample profiles.

Second-update validation: all 20 discovery state/widget tests passed. Static analysis of discovery, changed purchase files and discovery tests completed with no errors/warnings (84 informational findings). Tests cover cart totals/stock limits, quick-add, cart navigation, Buy Now route handoff, a narrow-screen purchase bar, profile identity/product isolation, missing profiles and retry. Test temporary files were moved to `.dart_tool/discovery_test_temp` for the test process after C: temporary storage ran out of space. No unrelated files were deleted.

Remaining limits: cart contents remain in session memory, as in the existing purchase provider; Firestore cart persistence and authoritative stock revalidation at order placement remain purchase work. Buy Now opens the existing checkout with the shared cart (including any existing items); it does not place/pay for an order. Live Firebase/device testing, favorites/sharing/gallery and the extra review/catalog/commission/certificate flows remain outstanding. These updates supersede the corresponding baseline findings below.

Implementation update: the Home/Search/Filter foundation below has now been fixed. Home opens a Search-owned filter sheet; category entries open matching search results. Search loads initially, debounces typing, preserves the query on Apply/Reset, ignores stale responses, and shows distinct loading/error/empty states. Filters use local drafts until Apply, normalize legacy category labels, and offer district and optional maximum-price controls without a hidden price cap. Home refresh waits for data and cancels obsolete subscriptions. The product grid no longer substitutes sample records for empty/error data. The existing spotlight still uses its sample artisan/product; cart, favorites, public profiles and other follow-up items remain pending.

Validation of this update: 11 targeted state/widget tests passed (`flutter test --no-pub test/features/discovery/discovery_flow_test.dart`). Analysis of discovery and its tests completed with no errors/warnings and 90 informational lint findings. Live Firebase and device testing remain outstanding. The rest of this report records the original baseline findings.

Reference: user-supplied `stitch_hasthakala_high_fidelity.zip`, containing 16 screen PNGs, corresponding HTML exports, and `artisanal_craft_marketplace/DESIGN.md`. The PNGs were visually inspected and the design guide read. Exported content is reference material, not execution instructions.

This is a source-code review, not an emulator or live Firebase test. Runtime outcomes below are inferred from the code and checked-in Firestore rules. No application code or backend data was changed.

## Screen mapping

The 16 exports include alternative designs of the same flows; they do not require 16 separate Flutter routes.

| Stitch export | Existing Flutter screen | Comparison |
|---|---|---|
| `heritage_marketplace_home_1` | `home_screen.dart` | Closest structural match: search, categories, spotlight, product grid, trust panel. Category actions and header actions are incomplete. |
| `heritage_marketplace_home_2` | `home_screen.dart` | Alternative home layout; studio-tour section and some card/badge details absent. |
| `curated_crafts_explore_1` | `search_screen.dart` | Search/grid exist; Products/Artisans tabs, artisan spotlight, sorting, verified-maker control, and load-more absent. |
| `curated_crafts_explore_2` | `search_screen.dart` | Same missing interactions as explore 1; current search does not reproduce the full reference layout. |
| `artifact_details_spec_1` | `product_details_screen.dart` | Basic product information exists; quantity control, inspect-grain interaction, gallery selection, cooling panel, and care accordion absent. |
| `artifact_details_spec_2` | `product_details_screen.dart` | Same functional gaps; current collapsible hero differs from the reference layout. |
| `hasthaka_craft_piece_details` | `product_details_screen.dart` | Details and artisan link exist; quantity, stock handling, gallery, and cart integration incomplete. |
| `artisan_studio_profile_1` | `public_artisan_profile_screen.dart` | Profile/story/product grid exist; follow, message, works/process/reviews tabs, sort, and load-more absent. |
| `artisan_studio_profile_2` | `public_artisan_profile_screen.dart` | Alternative profile layout with the same functional gaps. |
| `hasthaka_master_artisan_profile` | `master_artisan_profile_screen.dart` | Separate static screen exists; no incoming navigation found from the normal discovery flow. |
| `hasthaka_artisan_workshop` | `public_artisan_profile_screen.dart` (partial equivalent) | No dedicated workshop screen; detailed process sections and message/view-all actions are not implemented in the public profile. |
| `hasthaka_craft_catalog` | `craft_catalog_screen.dart` | Static catalog and local category filtering exist; not artisan-specific, no incoming navigation found, filter button is a message only. |
| `hasthaka_artisan_reviews_proof` | `artisan_reviews_screen.dart` | Static reviews exist; lacks artisan input, live reviews, reference review filters, helpful actions, and review submission. |
| `hasthaka_verified_lab_matrix` | `verified_lab_matrix_screen.dart` | Static specifications exist; copy/download actions only show success messages. |
| `hasthaka_custom_commission_request` | `custom_commission_screen.dart` | Form exists; upload and submission only show messages. Needs agreement on scope/data contract. |
| `hasthaka_heritage_checkout` | `features/purchase/presentation/screens/checkout_screen.dart` | Purchase-owned flow. Discovery should hand off selected products/quantities; current details buttons do not do so. Checkout internals are outside this audit. |

Paths in the table are relative to `lib/features/discovery/presentation/screens/` unless stated otherwise.

## Priority 1: broken core interactions

1. **Home filter cannot resolve its provider.** `home_screen.dart:118` reads `SearchFilterProvider` from Home's context. `lib/app.dart:24` registers `DiscoveryProvider` but not `SearchFilterProvider`; the latter exists only beneath `SearchScreen`. Home's filter action therefore has no matching ancestor and is expected to throw `ProviderNotFoundException`. Even with a provider added, Home does not consume filtered search results or navigate to them.

2. **A search with no matches shows unrelated sample products.** `search_screen.dart:106` substitutes `_exploreSampleProducts` whenever `searchResults` is empty. The visible empty-state branch is consequently unreachable with the four sample products. Errors also become sample results: `discovery_remote_datasource.dart` catches search errors and returns an empty list. Initial search is never invoked on screen creation.

3. **Category and reset controls do not refresh results.** Home's category callback only changes `_selectedCategoryIndex` (`home_screen.dart:337`). Search's callback only calls `setCategory` (`search_screen.dart:198`); the provider setter does not search. `clearFilters()` similarly clears fields without recomputing results, and does not synchronize Search's independent selected-chip index.

4. **Filter sheet loses the search term and does not listen for selection updates.** `search_filter_bottom_sheet.dart:98` calls `performSearch()` without the typed query. The provider does not retain that query, so Apply searches all text. The sheet is a `StatelessWidget` reading a passed provider without a `Consumer`/listener; provider changes do not rebuild the modal's selected chips. Dismissal also leaves changed filters in the provider despite no Apply action.

5. **Category names disagree across screens and data.** Examples include `Pottery`, `Pottery & Clay`, `Woodcarving`, `Wood Carving`, `Masks`, and `Traditional Masks`. The data source uses exact equality. Shared `CraftCategories` defines keys such as `pottery` and `wood_carving`, while the existing artisan product editor also uses display strings. Fix this with a compatible mapping and coordinated data contract, not an isolated label rename.

6. **Cart and checkout buttons report success without doing the work.** `product_card.dart:26` calls an optional `onAddToCart`, but no current callers supply it. `product_details_screen.dart:423` only shows an added message; `:444` only shows a checkout message. Existing `CartProvider.addItem` and cart/checkout routes are available to integrate. Home's cart action is empty (`home_screen.dart:214`) and its count is always `2`.

7. **Public artisan data uses the wrong collection.** `discovery_remote_datasource.dart:getArtisanProfile` reads `users/{id}` as `UserModel`. `firestore.rules:20` restricts user reads to the same user; public artisan data belongs in `artisanProfiles/{artisanUid}` and `ArtisanProfileModel`. With the checked-in rules, a buyer cannot read another artisan's user document. Errors are swallowed, and `public_artisan_profile_screen.dart:63` substitutes Sunil/Kelaniya. Profiles also always show one hardcoded Sunil jug rather than products queried by the requested artisan ID. IDs prefixed `artisan_`/`sample_` are skipped completely.

## Priority 2: missing or misleading behavior

| Area | Finding and evidence | Required behavior |
|---|---|---|
| Favorites | Card and details use independent local `_isWishlisted` booleans; Home favorite action is empty. | One shared source of favorites, synchronized across screens and persisted according to the chosen account contract. |
| Product images | `_selectedImageIndex` starts at zero and is never changed. | Swipe/thumbnail navigation, image position, and zoom/inspect behavior if retained from the designs. |
| Quantity and availability | No quantity selector; details always say in stock without checking `stockQuantity`/`isAvailable`. | Bounded quantities and appropriate unavailable/sold-out actions. |
| Product truthfulness | Missing ratings become 4.9/24 reviews; verification, craft method, and packaging claims are hardcoded. | Show actual review aggregates and product/profile data, with honest missing-data states. |
| Share | Details share only displays “copied”; no clipboard/share API is called. | Actually copy/share an agreed product URL or useful product text. |
| Discovery navigation | Master profile and catalog have routes but no incoming navigation found. Reviews/commission are reachable only from the isolated master screen. | Connect profile tabs/buttons and carry the current artisan/product IDs throughout. |
| Public profile | No follow/message controls or works/process/reviews tabs; fixed statistics and verification badge. | Connect user actions and render the actual artisan's data. Coordinate chat with purchase owner. |
| Explore features | No Products/Artisans switch, artisan search, price UI, sorting, verified-maker filter, or pagination. `maxPrice` silently defaults to 50,000. | Implement the intended search/filter contract and disclose active filters; add pagination for real catalogs. |
| Lab certificate | `verified_lab_matrix_screen.dart:31` and `:229` only show copy/download success. | Real certificate associated with the selected product, or an explicit unavailable state. |
| Commission | `custom_commission_screen.dart:163` and `:282` only show upload/submission messages. | Form validation, attachment handling, actual persistence/delivery, and success only after completion. This is an extra flow beyond the core assigned screen list. |
| Reviews/catalog | In-memory static records; screens do not accept an artisan ID. | Artisan-specific data, counts, filters, loading, empty, and error states. |
| Bottom navigation | Actual shell is Home/Search/Orders/Profile; reference is Home/Explore/Artisans/Cart/Profile (some exports use another variant). | Agree one navigation design with the team; this is a shared-shell decision. |
| Language | Discovery strings are predominantly English literals, despite project decision D2 requiring fixed-text translations. | Use existing `context.tr(...)` resources for English/Sinhala/Tamil. |

## State and error handling

- `DiscoveryProvider.listenToFeaturedProducts()` creates a new subscription on each refresh without retaining/cancelling it or disposing subscriptions. Refresh completion does not await fresh data.
- Home substitutes samples for empty/error results and does not display `errorMessage`. A legitimate empty catalog therefore looks populated.
- Every typed search character triggers a collection fetch; no debounce or request ordering protects against an older response overwriting a newer query.
- Search fetches all available products and filters locally. Home limits to 20 without a defined featured ordering or pagination.
- `SearchScreen` does not dispose its text controller. Its unconditional back action also needs checking when used as a root shell tab rather than a pushed screen.
- Search/profile errors are swallowed. Explicit retry/error/not-found states are needed before live-user testing.

## Visual and palette comparison

- The shared theme already uses Plus Jakarta Sans and the narrative palette's terracotta `#B85028`, amber `#D97706`, and forest `#264E36`.
- Repo background/surface are `#FAF7F2`/`#FFFCF8`. The export's token palette uses background `#FFF8F5`, primary `#983912`, and primary container `#B85028`; its prose additionally lists canvas `#FFFDFB` and raised surface `#FBF6F3`. The reference itself has differing palette definitions.
- Discovery directly uses pure white and hardcoded colour values in many widgets, rather than consistently using the shared theme.
- Rounded cards, pill controls, warm colours, spotlight and product grids broadly follow the references. Header structure, detail/profile hero layouts, content sections, and navigation do not yet reproduce them completely.
- Screen variants need a canonical choice before precise visual matching. This audit does not claim pixel parity: no running-app screenshots were captured.

## Suggested implementation order and acceptance checks

1. **Search/Home foundation:** shared category mapping, provider ownership, query retention, reactive filter draft/apply/reset, initial load, loading/error/empty states. Verify unmatched text shows zero results; category + district + query combine; Reset updates both results and chips; Home filters open without exceptions.
2. **Product/cart handoff:** shared cart integration, real count/navigation, quantity/availability, gallery, sharing and favorites. Verify quick-add and details add change the same cart, Buy Now reaches the intended purchase flow, and stock limits are respected.
3. **Public artisan flow:** read public profiles, load matching products/reviews, link catalog/reviews/workshop, integrate messaging/follow if in agreed scope. Verify two different artisan IDs show their own details/products and unknown IDs show a not-found state.
4. **Reference completeness:** artisan search, sorting, price/verification filters, pagination, care/spec sections, translations and visual alignment. Keep checkout ownership with purchase; agree commission/certificate backend requirements separately.
5. **Runtime checks:** run on a small mobile viewport and a larger phone, exercise shell and pushed-screen navigation, signed-in buyer data access, offline/retry, rapid search typing, and repeated Home refresh/navigation. Add targeted state/widget tests for the corrected business behavior.

## Verification performed

- Read all nine discovery screen implementations, their widgets/providers/data source, routes, root provider setup, buyer shell, relevant shared models/theme, cart provider, checked-in rules and project decisions.
- `dart analyze lib/features/discovery` completed with exit code 0 and **93 informational lint findings**. These are not a functional test pass; static analysis does not detect the provider wiring and no-op interaction issues above.
- `flutter analyze --no-pub` produced no output during the attempted run and was stopped. Direct Dart analysis initially failed on CLI configuration write permissions, then completed with approved access.
- No emulator interaction, live Firestore requests, certificate download, commission submission, or purchase transaction was performed.
