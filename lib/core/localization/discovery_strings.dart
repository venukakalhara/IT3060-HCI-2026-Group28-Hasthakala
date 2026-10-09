// Fixed text for the core Buyer Discovery flow.
const discoveryStrings = <String, Map<String, String>>{
  'discovery_explore_title': {
    'en': 'Discover local craft',
    'si': 'දේශීය අත්කම් සොයාගන්න',
    'ta': 'உள்ளூர் கைவினைகளை அறியுங்கள்'
  },
  'discovery_explore_subtitle': {
    'en': 'Thoughtful creations. Talented makers. Find something with a story.',
    'si': 'අගනා නිර්මාණ සහ දක්ෂ ශිල්පීන් හඳුනාගන්න.',
    'ta': 'அழகிய படைப்புகளையும் திறமையான கைவினைஞர்களையும் கண்டறியுங்கள்.'
  },
  'discovery_reset_search': {
    'en': 'Reset search',
    'si': 'සෙවුම යළි සකසන්න',
    'ta': 'தேடலை மீட்டமைக்கவும்'
  },
  'discovery_products_tab': {
    'en': 'Products',
    'si': 'නිෂ්පාදන',
    'ta': 'தயாரிப்புகள்'
  },
  'discovery_artisans_tab': {
    'en': 'Artisans',
    'si': 'ශිල්පීන්',
    'ta': 'கைவினைஞர்கள்'
  },
  'discovery_artisans_hint': {
    'en': 'Search artisans or places...',
    'si': 'ශිල්පීන් හෝ ප්‍රදේශ සොයන්න...',
    'ta': 'கைவினைஞர்கள் அல்லது இடங்களைத் தேடுக...'
  },
  'discovery_verified_only': {
    'en': 'Verified artisans only',
    'si': 'තහවුරු කළ ශිල්පීන් පමණයි',
    'ta': 'சரிபார்க்கப்பட்ட கைவினைஞர்கள் மட்டும்'
  },
  'discovery_artisans_loading': {
    'en': 'Loading artisans...',
    'si': 'ශිල්පීන් පූරණය වෙමින්...',
    'ta': 'கைவினைஞர்கள் ஏற்றப்படுகின்றனர்...'
  },
  'discovery_artisans_error': {
    'en': 'Unable to load artisans',
    'si': 'ශිල්පීන් පූරණය කළ නොහැක',
    'ta': 'கைவினைஞர்களை ஏற்ற முடியவில்லை'
  },
  'discovery_artisans_empty': {
    'en': 'No artisans found',
    'si': 'ශිල්පීන් හමු නොවීය',
    'ta': 'கைவினைஞர்கள் கிடைக்கவில்லை'
  },
  'discovery_artisans_count': {
    'en': 'Artisans ({count})',
    'si': 'ශිල්පීන් ({count})',
    'ta': 'கைவினைஞர்கள் ({count})'
  },
  'discovery_refresh': {
    'en': 'Refresh',
    'si': 'නැවත පූරණය කරන්න',
    'ta': 'புதுப்பிக்கவும்'
  },
  'discovery_sort': {'en': 'Sort by', 'si': 'පිළිවෙළ', 'ta': 'வரிசைப்படுத்தல்'},
  'discovery_sort_defaultOrder': {
    'en': 'Default order',
    'si': 'සාමාන්‍ය පිළිවෙළ',
    'ta': 'இயல்புநிலை வரிசை'
  },
  'discovery_sort_priceLowToHigh': {
    'en': 'Price: low to high',
    'si': 'මිල: අඩු සිට වැඩි',
    'ta': 'விலை: குறைவிலிருந்து அதிகம்'
  },
  'discovery_sort_priceHighToLow': {
    'en': 'Price: high to low',
    'si': 'මිල: වැඩි සිට අඩු',
    'ta': 'விலை: அதிகத்திலிருந்து குறைவு'
  },
  'discovery_my_profile': {
    'en': 'My profile',
    'si': 'මගේ පැතිකඩ',
    'ta': 'எனது சுயவிவரம்'
  },
  'discovery_home_search': {
    'en': 'Search pottery, masks, cane, brass...',
    'si': 'මැටි භාණ්ඩ, වෙස් මුහුණු සොයන්න...',
    'ta': 'மட்பாண்டங்கள், முகமூடிகள் தேடுங்கள்...'
  },
  'discovery_all_crafts': {
    'en': 'All Crafts',
    'si': 'සියලු අත්කම්',
    'ta': 'அனைத்து கைவினைகள்'
  },
  'discovery_rare': {
    'en': 'RARE & HANDCRAFTED',
    'si': 'සුවිශේෂී අත්කම්',
    'ta': 'தனித்துவமான கைவினைகள்'
  },
  'discovery_curated': {
    'en': 'Curated Masterpieces',
    'si': 'තෝරාගත් නිර්මාණ',
    'ta': 'தேர்ந்தெடுத்த படைப்புகள்'
  },
  'discovery_explore': {
    'en': 'Explore all',
    'si': 'සියල්ල බලන්න',
    'ta': 'அனைத்தையும் காண்க'
  },
  'discovery_loading': {
    'en': 'Loading authentic crafts...',
    'si': 'අත්කම් පූරණය වෙමින්...',
    'ta': 'கைவினைகள் ஏற்றப்படுகின்றன...'
  },
  'discovery_load_error': {
    'en': 'Unable to load crafts',
    'si': 'අත්කම් පූරණය කළ නොහැක',
    'ta': 'கைவினைகளை ஏற்ற முடியவில்லை'
  },
  'discovery_retry_help': {
    'en': 'Check your connection and try again.',
    'si': 'සම්බන්ධතාව පරීක්ෂා කර නැවත උත්සාහ කරන්න.',
    'ta': 'இணைப்பைச் சரிபார்த்து மீண்டும் முயலுங்கள்.'
  },
  'discovery_retry': {
    'en': 'Retry',
    'si': 'නැවත උත්සාහ කරන්න',
    'ta': 'மீண்டும் முயல்க'
  },
  'discovery_empty': {
    'en': 'No crafts yet',
    'si': 'තවම අත්කම් නැහැ',
    'ta': 'இன்னும் கைவினைகள் இல்லை'
  },
  'discovery_empty_help': {
    'en': 'New artisan creations will appear here.',
    'si': 'නව අත්කම් නිර්මාණ මෙහි දිස්වනු ඇත.',
    'ta': 'புதிய கைவினைப் படைப்புகள் இங்கே தோன்றும்.'
  },
  'discovery_search': {
    'en': 'Search crafts...',
    'si': 'අත්කම් සොයන්න...',
    'ta': 'கைவினைகளைத் தேடுங்கள்...'
  },
  'discovery_clear_search': {
    'en': 'Clear search',
    'si': 'සෙවුම මකන්න',
    'ta': 'தேடலை அழிக்கவும்'
  },
  'discovery_saved_action': {
    'en': 'Saved crafts',
    'si': 'සුරැකි අත්කම්',
    'ta': 'சேமித்த கைவினைகள்'
  },
  'discovery_filter_action': {
    'en': 'Filter crafts',
    'si': 'අත්කම් පෙරන්න',
    'ta': 'கைவினைகளை வடிகட்டுக'
  },
  'discovery_searching': {
    'en': 'Searching crafts...',
    'si': 'අත්කම් සොයමින්...',
    'ta': 'கைவினைகள் தேடப்படுகின்றன...'
  },
  'discovery_clear_filters': {
    'en': 'Clear Filters',
    'si': 'පෙරහන් ඉවත් කරන්න',
    'ta': 'வடிகட்டிகளை அகற்றுக'
  },
  'discovery_searching_long': {
    'en': 'Searching authentic crafts...',
    'si': 'අත්කම් සොයමින්...',
    'ta': 'கைவினைகள் தேடப்படுகின்றன...'
  },
  'discovery_no_results': {
    'en': 'No crafts found',
    'si': 'අත්කම් හමු නොවීය',
    'ta': 'கைவினைகள் கிடைக்கவில்லை'
  },
  'discovery_no_results_help': {
    'en': 'Try another search or clear your filters.',
    'si': 'වෙනත් සෙවුමක් කරන්න හෝ පෙරහන් ඉවත් කරන්න.',
    'ta': 'வேறு தேடலை முயலுங்கள் அல்லது வடிகட்டிகளை அகற்றுங்கள்.'
  },
  'discovery_filter_title': {
    'en': 'Filter Handicrafts',
    'si': 'අත්කම් පෙරහන්',
    'ta': 'கைவினை வடிகட்டிகள்'
  },
  'discovery_reset': {
    'en': 'Reset',
    'si': 'යළි සකසන්න',
    'ta': 'மீட்டமைக்கவும்'
  },
  'discovery_category': {
    'en': 'Craft Category',
    'si': 'අත්කම් වර්ගය',
    'ta': 'கைவினை வகை'
  },
  'discovery_origin': {
    'en': 'Artisan origin / district',
    'si': 'ශිල්පියාගේ ප්‍රදේශය / දිස්ත්‍රික්කය',
    'ta': 'கைவினைஞரின் ஊர் / மாவட்டம்'
  },
  'discovery_any_origin': {
    'en': 'Any origin',
    'si': 'ඕනෑම ප්‍රදේශයක්',
    'ta': 'எந்த ஊரும்'
  },
  'discovery_max_price': {
    'en': 'Maximum price (LKR)',
    'si': 'උපරිම මිල (LKR)',
    'ta': 'அதிகபட்ச விலை (LKR)'
  },
  'discovery_any_price': {
    'en': 'Any price',
    'si': 'ඕනෑම මිලක්',
    'ta': 'எந்த விலையும்'
  },
  'discovery_invalid_price': {
    'en': 'Enter a valid price of zero or more',
    'si': 'බිංදුව හෝ ඊට වැඩි වලංගු මිලක් ඇතුළත් කරන්න',
    'ta': 'பூஜ்ஜியம் அல்லது அதற்கு மேற்பட்ட விலையை உள்ளிடுங்கள்'
  },
  'discovery_apply': {
    'en': 'Apply Filters',
    'si': 'පෙරහන් යොදන්න',
    'ta': 'வடிகட்டிகளைப் பயன்படுத்து'
  },
  'discovery_share_tooltip': {
    'en': 'Share product details',
    'si': 'නිෂ්පාදන විස්තර බෙදාගන්න',
    'ta': 'தயாரிப்பு விவரங்களைப் பகிர்க'
  },
  'discovery_no_reviews': {
    'en': 'No reviews yet',
    'si': 'තවම සමාලෝචන නැහැ',
    'ta': 'இன்னும் மதிப்புரைகள் இல்லை'
  },
  'discovery_fair_price': {
    'en': 'FAIR PRICE FOR ARTISAN',
    'si': 'ශිල්පියාගේ මිල',
    'ta': 'கைவினைஞரின் விலை'
  },
  'discovery_in_stock': {
    'en': 'In stock',
    'si': 'තොග ඇත',
    'ta': 'இருப்பில் உள்ளது'
  },
  'discovery_out_stock': {
    'en': 'Out of stock',
    'si': 'තොග අවසන්',
    'ta': 'இருப்பில் இல்லை'
  },
  'discovery_meet_maker': {
    'en': 'Meet the maker',
    'si': 'ශිල්පියා හඳුනාගන්න',
    'ta': 'கைவினைஞரை அறியுங்கள்'
  },
  'discovery_studio': {
    'en': 'View Studio',
    'si': 'වැඩපොළ බලන්න',
    'ta': 'பட்டறையைக் காண்க'
  },
  'discovery_story': {
    'en': 'Craft Story & Heritage',
    'si': 'නිර්මාණයේ කතාව සහ උරුමය',
    'ta': 'படைப்பின் கதையும் பாரம்பரியமும்'
  },
  'discovery_no_description': {
    'en': 'The artisan has not added a description yet.',
    'si': 'ශිල්පියා තවම විස්තරයක් එක් කර නැහැ.',
    'ta': 'கைவினைஞர் இன்னும் விளக்கம் சேர்க்கவில்லை.'
  },
  'discovery_specs': {
    'en': 'SPECIFICATIONS & MATERIALS',
    'si': 'පිරිවිතර සහ අමුද්‍රව්‍ය',
    'ta': 'விவரக்குறிப்புகள் மற்றும் மூலப்பொருட்கள்'
  },
  'discovery_materials': {
    'en': 'Raw Materials',
    'si': 'අමුද්‍රව්‍ය',
    'ta': 'மூலப்பொருட்கள்'
  },
  'discovery_unavailable_details': {
    'en': 'Details unavailable',
    'si': 'විස්තර නොමැත',
    'ta': 'விவரங்கள் இல்லை'
  },
  'discovery_technique': {
    'en': 'Craft Technique',
    'si': 'නිර්මාණ ක්‍රමය',
    'ta': 'கைவினை நுட்பம்'
  },
  'discovery_packaging': {
    'en': 'Packaging',
    'si': 'ඇසුරුම්',
    'ta': 'பொதியிடல்'
  },
  'discovery_profile_title': {
    'en': 'Artisan Studio',
    'si': 'ශිල්පියාගේ වැඩපොළ',
    'ta': 'கைவினைஞரின் பட்டறை'
  },
  'discovery_profile_loading': {
    'en': 'Loading artisan studio...',
    'si': 'ශිල්පියාගේ වැඩපොළ පූරණය වෙමින්...',
    'ta': 'கைவினைஞரின் பட்டறை ஏற்றப்படுகிறது...'
  },
  'discovery_profile_error': {
    'en': 'Unable to load artisan',
    'si': 'ශිල්පියාගේ විස්තර පූරණය කළ නොහැක',
    'ta': 'கைவினைஞர் விவரங்களை ஏற்ற முடியவில்லை'
  },
  'discovery_profile_missing': {
    'en': 'Artisan not found',
    'si': 'ශිල්පියා හමු නොවීය',
    'ta': 'கைவினைஞர் கிடைக்கவில்லை'
  },
  'discovery_profile_missing_help': {
    'en': 'This public studio is not available.',
    'si': 'මෙම පොදු වැඩපොළ දැනට ලබාගත නොහැක.',
    'ta': 'இந்தப் பொதுப் பட்டறை கிடைக்கவில்லை.'
  },
  'discovery_profile_fallback': {
    'en': 'Artisan studio',
    'si': 'ශිල්පියාගේ වැඩපොළ',
    'ta': 'கைவினைஞரின் பட்டறை'
  },
  'discovery_verified': {
    'en': 'Verified artisan',
    'si': 'තහවුරු කළ ශිල්පියා',
    'ta': 'சரிபார்க்கப்பட்ட கைவினைஞர்'
  },
  'discovery_journey': {
    'en': 'Artisan Journey & Heritage',
    'si': 'ශිල්පියාගේ ගමන සහ උරුමය',
    'ta': 'கைவினைஞரின் பயணமும் பாரம்பரியமும்'
  },
  'discovery_no_story': {
    'en': 'This artisan has not added a story yet.',
    'si': 'මෙම ශිල්පියා තවම කතාවක් එක් කර නැහැ.',
    'ta': 'இந்தக் கைவினைஞர் இன்னும் கதையைச் சேர்க்கவில்லை.'
  },
  'discovery_no_listings': {
    'en': 'No crafts listed yet',
    'si': 'තවම අත්කම් ලැයිස්තුගත කර නැහැ',
    'ta': 'இன்னும் கைவினைகள் பட்டியலிடப்படவில்லை'
  },
  'discovery_check_back': {
    'en': 'Check back for new creations from this artisan.',
    'si': 'මෙම ශිල්පියාගේ නව නිර්මාණ සඳහා නැවත බලන්න.',
    'ta': 'இந்தக் கைவினைஞரின் புதிய படைப்புகளுக்காக மீண்டும் பாருங்கள்.'
  },
  'discovery_saved_title': {
    'en': 'Saved Crafts',
    'si': 'සුරැකි අත්කම්',
    'ta': 'சேமித்த கைவினைகள்'
  },
  'discovery_favorites_error': {
    'en': 'Unable to load favorites',
    'si': 'ප්‍රියතම දෑ පූරණය කළ නොහැක',
    'ta': 'விருப்பமானவற்றை ஏற்ற முடியவில்லை'
  },
  'discovery_favorites_empty': {
    'en': 'No saved crafts yet',
    'si': 'තවම සුරැකි අත්කම් නැහැ',
    'ta': 'இன்னும் சேமித்த கைவினைகள் இல்லை'
  },
  'discovery_favorites_help': {
    'en': 'Tap a heart on a craft to save it here.',
    'si': 'අත්කමක් සුරැකීමට එහි හදවත් සලකුණ ඔබන්න.',
    'ta': 'கைவினையைச் சேமிக்க அதன் இதயக் குறியைத் தொடுங்கள்.'
  },
  'discovery_favorites_offline': {
    'en': 'Your favorites are saved. Check your connection and retry.',
    'si': 'ඔබේ ප්‍රියතම දෑ සුරැකී ඇත. සම්බන්ධතාව පරීක්ෂා කර නැවත උත්සාහ කරන්න.',
    'ta':
        'விருப்பங்கள் சேமிக்கப்பட்டுள்ளன. இணைப்பைச் சரிபார்த்து மீண்டும் முயலுங்கள்.'
  },
  'discovery_craft_unavailable': {
    'en': 'Craft unavailable',
    'si': 'අත්කම ලබාගත නොහැක',
    'ta': 'கைவினை கிடைக்கவில்லை'
  },
  'discovery_remove_favorite': {
    'en': 'Remove from favorites',
    'si': 'ප්‍රියතම දෑ වෙතින් ඉවත් කරන්න',
    'ta': 'விருப்பங்களிலிருந்து அகற்றுக'
  },
  'discovery_save_favorite': {
    'en': 'Save to favorites',
    'si': 'ප්‍රියතම දෑ වෙත සුරකින්න',
    'ta': 'விருப்பங்களில் சேமிக்கவும்'
  },
  'discovery_save_error': {
    'en': 'Could not save favorites. Try again.',
    'si': 'ප්‍රියතම දෑ සුරැකිය නොහැක. නැවත උත්සාහ කරන්න.',
    'ta': 'விருப்பங்களைச் சேமிக்க முடியவில்லை. மீண்டும் முயலுங்கள்.'
  },
  'discovery_load_favorites_error': {
    'en': 'Could not load saved crafts. Try again.',
    'si': 'සුරැකි අත්කම් පූරණය කළ නොහැක. නැවත උත්සාහ කරන්න.',
    'ta': 'சேமித்த கைவினைகளை ஏற்ற முடியவில்லை. மீண்டும் முயலுங்கள்.'
  },
  'discovery_cart_stock': {
    'en':
        'Not enough stock available. Check the quantity already in your cart.',
    'si': 'ප්‍රමාණවත් තොග නොමැත. කරත්තයේ ඇති ප්‍රමාණය බලන්න.',
    'ta': 'போதுமான இருப்பு இல்லை. கூடையிலுள்ள அளவைச் சரிபாருங்கள்.'
  },
  'discovery_view_cart': {
    'en': 'View cart',
    'si': 'කරත්තය බලන්න',
    'ta': 'கூடையைக் காண்க'
  },
  'discovery_stock_in_cart': {
    'en': 'Available stock is in your cart',
    'si': 'පවතින තොගය ඔබේ කරත්තයේ ඇත',
    'ta': 'கிடைக்கும் இருப்பு உங்கள் கூடையில் உள்ளது'
  },
  'discovery_decrease': {
    'en': 'Decrease quantity',
    'si': 'ප්‍රමාණය අඩු කරන්න',
    'ta': 'அளவைக் குறைக்கவும்'
  },
  'discovery_increase': {
    'en': 'Increase quantity',
    'si': 'ප්‍රමාණය වැඩි කරන්න',
    'ta': 'அளவை அதிகரிக்கவும்'
  },
  'discovery_add_cart': {
    'en': 'Add to Cart',
    'si': 'කරත්තයට එක් කරන්න',
    'ta': 'கூடையில் சேர்க்கவும்'
  },
  'discovery_buy_now': {
    'en': 'Buy Now',
    'si': 'දැන් මිලදී ගන්න',
    'ta': 'இப்போது வாங்கவும்'
  },
  'discovery_close_photo': {
    'en': 'Close photo',
    'si': 'ඡායාරූපය වසන්න',
    'ta': 'படத்தை மூடவும்'
  },
  'discovery_no_photos': {
    'en': 'No product photos available',
    'si': 'නිෂ්පාදන ඡායාරූප නොමැත',
    'ta': 'தயாரிப்புப் படங்கள் இல்லை'
  },
  'discovery_share_title': {
    'en': 'Share this craft',
    'si': 'මෙම අත්කම බෙදාගන්න',
    'ta': 'இந்தக் கைவினையைப் பகிர்க'
  },
  'discovery_copy_help': {
    'en': 'Copy these details to paste into a message.',
    'si': 'පණිවිඩයකට ඇලවීමට මෙම විස්තර පිටපත් කරන්න.',
    'ta': 'செய்தியில் ஒட்ட இந்த விவரங்களை நகலெடுங்கள்.'
  },
  'discovery_copy_details': {
    'en': 'Copy product details',
    'si': 'නිෂ්පාදන විස්තර පිටපත් කරන්න',
    'ta': 'தயாரிப்பு விவரங்களை நகலெடுக்கவும்'
  },
  'discovery_copied': {
    'en': 'Product details copied',
    'si': 'නිෂ්පාදන විස්තර පිටපත් විය',
    'ta': 'தயாரிப்பு விவரங்கள் நகலெடுக்கப்பட்டன'
  },
  'discovery_copy_error': {
    'en': 'Could not copy. Select the text and try again.',
    'si': 'පිටපත් කළ නොහැක. පෙළ තෝරා නැවත උත්සාහ කරන්න.',
    'ta': 'நகலெடுக்க முடியவில்லை. உரையைத் தேர்ந்தெடுத்து மீண்டும் முயலுங்கள்.'
  },
  'discovery_spotlight': {
    'en': 'ARTISAN SPOTLIGHT',
    'si': 'විශේෂ ශිල්පියා',
    'ta': 'சிறப்புக் கைவினைஞர்'
  },
  'discovery_workshop': {
    'en': 'View Workshop',
    'si': 'වැඩපොළ බලන්න',
    'ta': 'பட்டறையைக் காண்க'
  },
  'discovery_view_craft': {
    'en': 'View Craft',
    'si': 'අත්කම බලන්න',
    'ta': 'கைவினையைக் காண்க'
  },
  'discovery_country': {'en': 'Sri Lanka', 'si': 'ශ්‍රී ලංකාව', 'ta': 'இலங்கை'},
  'discovery_artisan': {
    'en': 'Master Artisan',
    'si': 'අත්කම් ශිල්පියා',
    'ta': 'கைவினைஞர்'
  },
  'discovery_price': {'en': 'PRICE', 'si': 'මිල', 'ta': 'விலை'},
  'discovery_discover': {
    'en': 'Discover Sri Lankan Craft',
    'si': 'ශ්‍රී ලාංකීය අත්කම් හඳුනාගන්න',
    'ta': 'இலங்கைக் கைவினைகளை அறியுங்கள்'
  },
  'discovery_discover_help': {
    'en': 'Explore the people and stories behind each craft',
    'si': 'සෑම නිර්මාණයක් පිටුපසම සිටින අය සහ කතා හඳුනාගන්න',
    'ta': 'ஒவ்வொரு படைப்பின் பின்னுள்ள மனிதர்களையும் கதைகளையும் அறியுங்கள்'
  },
  'discovery_meet': {
    'en': 'Meet the Maker',
    'si': 'ශිල්පියා හඳුනාගන්න',
    'ta': 'கைவினைஞரை அறியுங்கள்'
  },
  'discovery_meet_help': {
    'en': 'Visit artisan profiles to learn about their craft and story.',
    'si': 'ශිල්පීන්ගේ නිර්මාණ සහ කතා දැනගැනීමට ඔවුන්ගේ පැතිකඩ බලන්න.',
    'ta':
        'கைவினைஞர்களின் படைப்புகளையும் கதைகளையும் அறிய அவர்களின் சுயவிவரங்களைப் பாருங்கள்.'
  },
  'discovery_local': {
    'en': 'Explore Local Crafts',
    'si': 'දේශීය අත්කම් බලන්න',
    'ta': 'உள்ளூர் கைவினைகளைக் காண்க'
  },
  'discovery_local_help': {
    'en': 'Browse crafts by category, location and price.',
    'si': 'වර්ගය, ප්‍රදේශය සහ මිල අනුව අත්කම් බලන්න.',
    'ta': 'வகை, இடம் மற்றும் விலைப்படி கைவினைகளைப் பாருங்கள்.'
  },
  'discovery_check_details': {
    'en': 'Check Product Details',
    'si': 'නිෂ්පාදන විස්තර බලන්න',
    'ta': 'தயாரிப்பு விவரங்களைப் பாருங்கள்'
  },
  'discovery_check_details_help': {
    'en':
        'Review the listed materials, dimensions and availability before buying.',
    'si': 'මිලදී ගැනීමට පෙර දක්වා ඇති අමුද්‍රව්‍ය, මාන සහ තොග බලන්න.',
    'ta':
        'வாங்குமுன் பட்டியலிட்ட மூலப்பொருட்கள், அளவுகள் மற்றும் இருப்பைப் பாருங்கள்.'
  },
  'discovery_sample_report': {
    'en': 'View Sample Lab Report',
    'si': 'ආදර්ශ පරීක්ෂණ වාර්තාව බලන්න',
    'ta': 'மாதிரிப் பரிசோதனை அறிக்கையைக் காண்க'
  },
  'discovery_results': {
    'en': 'Curated Crafts ({count})',
    'si': 'තෝරාගත් අත්කම් ({count})',
    'ta': 'தேர்ந்தெடுத்த கைவினைகள் ({count})'
  },
  'discovery_up_to': {
    'en': 'Up to LKR {price}',
    'si': 'LKR {price} දක්වා',
    'ta': 'LKR {price} வரை'
  },
  'discovery_reviews': {
    'en': ' ({count} customer reviews)',
    'si': ' (පාරිභෝගික සමාලෝචන {count})',
    'ta': ' ({count} வாடிக்கையாளர் மதிப்புரைகள்)'
  },
  'discovery_works': {
    'en': 'Workshop Masterpieces ({count})',
    'si': 'වැඩපොළේ නිර්මාණ ({count})',
    'ta': 'பட்டறைப் படைப்புகள் ({count})'
  },
  'discovery_added': {
    'en': '{name} added to cart',
    'si': '{name} කරත්තයට එක් විය',
    'ta': '{name} கூடையில் சேர்க்கப்பட்டது'
  },
  'discovery_cart_count': {
    'en': 'Cart ({count})',
    'si': 'කරත්තය ({count})',
    'ta': 'கூடை ({count})'
  },
  'discovery_photo': {
    'en': 'Photo {index} of {count}',
    'si': 'ඡායාරූප {count} න් {index}',
    'ta': 'படம் {index} / {count}'
  },
  'discovery_view_photo': {
    'en': 'View photo {index}',
    'si': 'ඡායාරූප {index} බලන්න',
    'ta': 'படம் {index} ஐக் காண்க'
  },
  'discovery_by': {
    'en': 'By {name}',
    'si': 'ශිල්පියා: {name}',
    'ta': 'படைப்பாளர்: {name}'
  },
  'discovery_origin_value': {
    'en': 'Origin: {place}',
    'si': 'ප්‍රදේශය: {place}',
    'ta': 'ஊர்: {place}'
  },
  'discovery_product_id': {
    'en': 'Product ID: {id}',
    'si': 'නිෂ්පාදන අංකය: {id}',
    'ta': 'தயாரிப்பு எண்: {id}'
  },
  'discovery_category_pottery': {
    'en': 'Pottery',
    'si': 'මැටි භාණ්ඩ',
    'ta': 'மட்பாண்டங்கள்'
  },
  'discovery_category_batik': {'en': 'Batik', 'si': 'බතික්', 'ta': 'பத்திக்'},
  'discovery_category_wood_carving': {
    'en': 'Wood Carving',
    'si': 'ලී කැටයම්',
    'ta': 'மரச் செதுக்கல்கள்'
  },
  'discovery_category_masks': {
    'en': 'Masks',
    'si': 'වෙස් මුහුණු',
    'ta': 'முகமூடிகள்'
  },
  'discovery_category_handloom_textiles': {
    'en': 'Handloom & Textiles',
    'si': 'අත්යන්ත්‍ර සහ රෙදිපිළි',
    'ta': 'கைத்தறி மற்றும் துணிகள்'
  },
  'discovery_category_jewellery': {
    'en': 'Jewellery',
    'si': 'ආභරණ',
    'ta': 'நகைகள்'
  },
  'discovery_category_brassware': {
    'en': 'Brassware',
    'si': 'පිත්තල භාණ්ඩ',
    'ta': 'பித்தளைப் பொருட்கள்'
  },
  'discovery_category_cane_bamboo': {
    'en': 'Cane & Bamboo',
    'si': 'වේවැල් සහ උණ',
    'ta': 'பிரம்பு மற்றும் மூங்கில்'
  },
  'discovery_category_coconut_shell': {
    'en': 'Coconut Shell Craft',
    'si': 'පොල්කටු අත්කම්',
    'ta': 'தேங்காய்ச் சிரட்டைக் கைவினைகள்'
  },
  'discovery_category_home_decor': {
    'en': 'Home Decor',
    'si': 'නිවසේ සැරසිලි',
    'ta': 'வீட்டு அலங்காரம்'
  },
  'discovery_category_other': {'en': 'Other', 'si': 'වෙනත්', 'ta': 'மற்றவை'},
  'discovery_origin_ampara': {'en': 'Ampara', 'si': 'අම්පාර', 'ta': 'அம்பாறை'},
  'discovery_origin_anuradhapura': {
    'en': 'Anuradhapura',
    'si': 'අනුරාධපුරය',
    'ta': 'அனுராதபுரம்'
  },
  'discovery_origin_badulla': {'en': 'Badulla', 'si': 'බදුල්ල', 'ta': 'பதுளை'},
  'discovery_origin_batticaloa': {
    'en': 'Batticaloa',
    'si': 'මඩකලපුව',
    'ta': 'மட்டக்களப்பு'
  },
  'discovery_origin_colombo': {'en': 'Colombo', 'si': 'කොළඹ', 'ta': 'கொழும்பு'},
  'discovery_origin_galle': {'en': 'Galle', 'si': 'ගාල්ල', 'ta': 'காலி'},
  'discovery_origin_gampaha': {'en': 'Gampaha', 'si': 'ගම්පහ', 'ta': 'கம்பஹா'},
  'discovery_origin_hambantota': {
    'en': 'Hambantota',
    'si': 'හම්බන්තොට',
    'ta': 'அம்பாந்தோட்டை'
  },
  'discovery_origin_jaffna': {
    'en': 'Jaffna',
    'si': 'යාපනය',
    'ta': 'யாழ்ப்பாணம்'
  },
  'discovery_origin_kalutara': {
    'en': 'Kalutara',
    'si': 'කළුතර',
    'ta': 'களுத்துறை'
  },
  'discovery_origin_kandy': {'en': 'Kandy', 'si': 'මහනුවර', 'ta': 'கண்டி'},
  'discovery_origin_kegalle': {'en': 'Kegalle', 'si': 'කෑගල්ල', 'ta': 'கேகாலை'},
  'discovery_origin_kilinochchi': {
    'en': 'Kilinochchi',
    'si': 'කිලිනොච්චිය',
    'ta': 'கிளிநொச்சி'
  },
  'discovery_origin_kurunegala': {
    'en': 'Kurunegala',
    'si': 'කුරුණෑගල',
    'ta': 'குருநாகல்'
  },
  'discovery_origin_mannar': {'en': 'Mannar', 'si': 'මන්නාරම', 'ta': 'மன்னார்'},
  'discovery_origin_matale': {'en': 'Matale', 'si': 'මාතලේ', 'ta': 'மாத்தளை'},
  'discovery_origin_matara': {'en': 'Matara', 'si': 'මාතර', 'ta': 'மாத்தறை'},
  'discovery_origin_monaragala': {
    'en': 'Monaragala',
    'si': 'මොනරාගල',
    'ta': 'மொனராகலை'
  },
  'discovery_origin_mullaitivu': {
    'en': 'Mullaitivu',
    'si': 'මුලතිව්',
    'ta': 'முல்லைத்தீவு'
  },
  'discovery_origin_nuwara_eliya': {
    'en': 'Nuwara Eliya',
    'si': 'නුවරඑළිය',
    'ta': 'நுவரெலியா'
  },
  'discovery_origin_polonnaruwa': {
    'en': 'Polonnaruwa',
    'si': 'පොළොන්නරුව',
    'ta': 'பொலன்னறுவை'
  },
  'discovery_origin_puttalam': {
    'en': 'Puttalam',
    'si': 'පුත්තලම',
    'ta': 'புத்தளம்'
  },
  'discovery_origin_ratnapura': {
    'en': 'Ratnapura',
    'si': 'රත්නපුරය',
    'ta': 'இரத்தினபுரி'
  },
  'discovery_origin_trincomalee': {
    'en': 'Trincomalee',
    'si': 'ත්‍රිකුණාමලය',
    'ta': 'திருகோணமலை'
  },
  'discovery_origin_vavuniya': {
    'en': 'Vavuniya',
    'si': 'වවුනියාව',
    'ta': 'வவுனியா'
  },
  'discovery_origin_ambalangoda': {
    'en': 'Ambalangoda',
    'si': 'අම්බලන්ගොඩ',
    'ta': 'அம்பலாங்கொடை'
  },
  'discovery_origin_kelaniya': {'en': 'Kelaniya', 'si': 'කැලණිය', 'ta': 'களனி'},
};
