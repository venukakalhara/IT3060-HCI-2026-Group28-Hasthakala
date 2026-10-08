import 'discovery_strings.dart';
import 'purchase_strings.dart';

// All fixed on-screen text in English, Sinhala and Tamil.
// Use  in a widget with:  context.tr('sign_in')
// Adding a new key here with all three languages; missing ones fall back to English.

class AppStrings {
  static const supported = ['en', 'si', 'ta'];

  static const Map<String, Map<String, String>> values = {
    ...discoveryStrings,
    ...purchaseStrings,
    // ---- general ----
    'continue': {'en': 'Continue', 'si': 'ඉදිරියට', 'ta': 'தொடரவும்'},
    'skip': {'en': 'Skip', 'si': 'මඟ හරින්න', 'ta': 'தவிர்'},
    'app_tagline': {
      'en': 'Handmade. Heritage. Heart.',
      'si': 'අතින් තැනූ. උරුමය. හදවත.',
      'ta': 'கைவினை. பாரம்பரியம். இதயம்.',
    },

    // ---- language ----
    'choose_language': {
      'en': 'Choose Language',
      'si': 'භාෂාව තෝරන්න',
      'ta': 'மொழியைத் தேர்ந்தெடுக்கவும்',
    },
    'choose_language_sub': {
      'en': 'Select your preferred language to continue.',
      'si': 'ඉදිරියට යාමට ඔබ කැමති භාෂාව තෝරන්න.',
      'ta': 'தொடர உங்களுக்கு விருப்பமான மொழியைத் தேர்ந்தெடுக்கவும்.',
    },
    'language_change_later': {
      'en': 'You can change this later in Profile.',
      'si': 'පසුව පැතිකඩ තුළින් මෙය වෙනස් කළ හැක.',
      'ta': 'இதை பின்னர் சுயவிவரத்தில் மாற்றலாம்.',
    },
    'language': {'en': 'Language', 'si': 'භාෂාව', 'ta': 'மொழி'},
    'language_sub': {
      'en': 'Change the app language',
      'si': 'යෙදුමේ භාෂාව වෙනස් කරන්න',
      'ta': 'செயலியின் மொழியை மாற்றவும்',
    },
    'language_saved': {
      'en': 'Language updated',
      'si': 'භාෂාව යාවත්කාලීන කළා',
      'ta': 'மொழி புதுப்பிக்கப்பட்டது',
    },

    // ---- intro ----
    'get_started': {
      'en': 'Get Started',
      'si': 'ආරම්භ කරන්න',
      'ta': 'தொடங்குங்கள்'
    },
    'intro_title': {
      'en': 'Discover authentic handmade crafts and empower local artisans.',
      'si': 'සැබෑ අත්කම් නිර්මාණ සොයාගෙන දේශීය ශිල්පීන් සවිබල ගන්වන්න.',
      'ta':
          'உண்மையான கைவினைப் பொருட்களைக் கண்டறிந்து உள்ளூர் கைவினைஞர்களுக்கு வலுவூட்டுங்கள்.',
    },
    'intro_line1': {
      'en': 'Unique stories. Real people.',
      'si': 'අද්විතීය කතා. සැබෑ මිනිසුන්.',
      'ta': 'தனித்துவமான கதைகள். உண்மையான மனிதர்கள்.',
    },
    'intro_line2': {
      'en': 'Empowering local artisans across Sri Lanka.',
      'si': 'ශ්‍රී ලංකාව පුරා දේශීය ශිල්පීන් සවිබල ගැන්වීම.',
      'ta': 'இலங்கை முழுவதும் உள்ளூர் கைவினைஞர்களுக்கு வலுவூட்டல்.',
    },

    'intro2_title': {
      'en': 'Shop from verified artisans',
      'si': 'සත්‍යාපිත ශිල්පීන්ගෙන් මිලදී ගන්න',
      'ta': 'சரிபார்க்கப்பட்ட கைவினைஞர்களிடம் வாங்குங்கள்',
    },
    'intro2_line': {
      'en': 'See who made it, read reviews and buy with confidence.',
      'si': 'එය සෑදුවේ කවුදැයි බලා, සමාලෝචන කියවා විශ්වාසයෙන් මිලදී ගන්න.',
      'ta': 'யார் செய்தார்கள் என்று பார்த்து, மதிப்புரைகளைப் படித்து நம்பிக்கையுடன் வாங்குங்கள்.',
    },
    'intro3_title': {
      'en': 'Order, chat and track in one place',
      'si': 'ඇණවුම, කතාබහ සහ නිරීක්ෂණය කරන්න එකම තැනක',
      'ta': 'ஆர்டர், உரையாடல், கண்காணிப்பு ஒரே இடத்தில்',
    },
    'intro3_line': {
      'en': 'Clear prices, order updates and messages with the artisan.',
      'si': 'පැහැදිලි මිල, ඇණවුම් යාවත්කාලීන සහ ශිල්පියා සමඟ පණිවිඩ.',
      'ta': 'தெளிவான விலைகள், ஆர்டர் புதுப்பிப்புகள், கைவினைஞருடன் செய்திகள்.',
    },
    'next': {'en': 'Next', 'si': 'ඊළඟ', 'ta': 'அடுத்து'},
    'intro_chip1': {
      'en': 'Handmade in Sri Lanka',
      'si': 'ශ්‍රී ලංකාවේ අතින් තැනූ',
      'ta': 'இலங்கையில் கையால் செய்யப்பட்டது',
    },
    'intro_chip2': {
      'en': 'Verified artisans',
      'si': 'සත්‍යාපිත ශිල්පීන්',
      'ta': 'சரிபார்க்கப்பட்ட கைவினைஞர்கள்',
    },
    'intro_chip3': {
      'en': 'Order updates and chat',
      'si': 'ඇණවුම් යාවත්කාලීන සහ කතාබහ',
      'ta': 'ஆர்டர் புதுப்பிப்புகள் மற்றும் உரையாடல்',
    },

    // ---- sign in ----
    'welcome_back': {
      'en': 'Welcome Back',
      'si': 'නැවත සාදරයෙන් පිළිගනිමු',
      'ta': 'மீண்டும் வருக',
    },
    'sign_in_sub': {
      'en': 'Sign in to continue your journey',
      'si': 'ඔබේ ගමන දිගටම කරගෙන යාමට පුරනය වන්න',
      'ta': 'உங்கள் பயணத்தைத் தொடர உள்நுழையவும்',
    },
    'email': {
      'en': 'Email Address',
      'si': 'විද්‍යුත් තැපැල් ලිපිනය',
      'ta': 'மின்னஞ்சல் முகவரி'
    },
    'password': {'en': 'Password', 'si': 'මුරපදය', 'ta': 'கடவுச்சொல்'},
    'show_password': {
      'en': 'Show password',
      'si': 'මුරපදය පෙන්වන්න',
      'ta': 'கடவுச்சொல்லைக் காட்டு',
    },
    'hide_password': {
      'en': 'Hide password',
      'si': 'මුරපදය සඟවන්න',
      'ta': 'கடவுச்சொல்லை மறை',
    },
    'forgot_password': {
      'en': 'Forgot password?',
      'si': 'මුරපදය අමතකද?',
      'ta': 'கடவுச்சொல் மறந்துவிட்டதா?',
    },
    'sign_in': {'en': 'Sign In', 'si': 'පුරනය වන්න', 'ta': 'உள்நுழைக'},
    'new_here': {
      'en': 'New to HASTHAKALA?',
      'si': 'HASTHAKALA වෙත අලුත්ද?',
      'ta': 'HASTHAKALA-வுக்கு புதியவரா?',
    },
    'create_account': {
      'en': 'Create Account',
      'si': 'ගිණුමක් සාදන්න',
      'ta': 'கணக்கை உருவாக்கவும்',
    },
    'signing_in': {
      'en': 'Signing you in...',
      'si': 'ඔබව පුරනය කරමින්...',
      'ta': 'உள்நுழைகிறது...',
    },
    'signing_in_sub': {
      'en': 'Please wait while we verify your account.',
      'si': 'අපි ඔබේ ගිණුම තහවුරු කරන තුරු රැඳී සිටින්න.',
      'ta': 'உங்கள் கணக்கைச் சரிபார்க்கும் வரை காத்திருக்கவும்.',
    },
    'checking_access': {
      'en': 'Checking your available access...',
      'si': 'ඔබට ඇති ප්‍රවේශය පරීක්ෂා කරමින්...',
      'ta': 'உங்களுக்கான அணுகலைச் சரிபார்க்கிறது...',
    },
    'checking_access_sub': {
      'en': 'Verifying your account and loading your workspace.',
      'si': 'ඔබේ ගිණුම තහවුරු කර වැඩ අවකාශය පූරණය කරමින්.',
      'ta': 'உங்கள் கணக்கைச் சரிபார்த்து பணியிடத்தை ஏற்றுகிறது.',
    },

    // ---- create account ----
    'create_account_title': {
      'en': 'Create Your Account',
      'si': 'ඔබේ ගිණුම සාදන්න',
      'ta': 'உங்கள் கணக்கை உருவாக்குங்கள்',
    },
    'create_account_sub': {
      'en': 'Join our community of artisans and craft lovers.',
      'si': 'ශිල්පීන් සහ අත්කම් ලෝලීන්ගේ ප්‍රජාවට එක්වන්න.',
      'ta': 'கைவினைஞர்கள் மற்றும் கைவினை ஆர்வலர்களின் சமூகத்தில் சேருங்கள்.',
    },
    'full_name': {'en': 'Full Name', 'si': 'සම්පූර්ණ නම', 'ta': 'முழுப் பெயர்'},
    'full_name_hint': {
      'en': 'Enter your full name',
      'si': 'ඔබේ සම්පූර්ණ නම ඇතුළත් කරන්න',
      'ta': 'உங்கள் முழுப் பெயரை உள்ளிடவும்',
    },
    'email_hint': {
      'en': 'Enter your email',
      'si': 'ඔබේ විද්‍යුත් තැපෑල ඇතුළත් කරන්න',
      'ta': 'உங்கள் மின்னஞ்சலை உள்ளிடவும்',
    },
    'password_hint': {
      'en': 'Enter your password',
      'si': 'ඔබේ මුරපදය ඇතුළත් කරන්න',
      'ta': 'உங்கள் கடவுச்சொல்லை உள்ளிடவும்',
    },
    'confirm_password': {
      'en': 'Confirm Password',
      'si': 'මුරපදය තහවුරු කරන්න',
      'ta': 'கடவுச்சொல்லை உறுதிப்படுத்தவும்',
    },
    'confirm_password_hint': {
      'en': 'Enter your password again',
      'si': 'මුරපදය නැවත ඇතුළත් කරන්න',
      'ta': 'கடவுச்சொல்லை மீண்டும் உள்ளிடவும்',
    },
    'password_rule': {
      'en': 'At least 6 characters',
      'si': 'අවම වශයෙන් අකුරු 6ක්',
      'ta': 'குறைந்தது 6 எழுத்துகள்',
    },
    'passwords_match': {
      'en': 'Passwords match',
      'si': 'මුරපද ගැළපේ',
      'ta': 'கடவுச்சொற்கள் பொருந்துகின்றன',
    },
    'agree_terms': {
      'en': 'I agree to the Terms & Conditions',
      'si': 'නියම සහ කොන්දේසිවලට මම එකඟ වෙමි',
      'ta': 'விதிமுறைகள் மற்றும் நிபந்தனைகளை ஏற்கிறேன்',
    },
    'view': {'en': 'View', 'si': 'බලන්න', 'ta': 'பார்க்க'},
    'close': {'en': 'Close', 'si': 'වසන්න', 'ta': 'மூடு'},
    'terms_title': {
      'en': 'Terms & Conditions',
      'si': 'නියම සහ කොන්දේසි',
      'ta': 'விதிமுறைகள் மற்றும் நிபந்தனைகள்',
    },
    'terms_body': {
      'en': 'HASTHAKALA is a student project (IT3060, Group 28).\n\n'
          '- Use accurate information about yourself and your products.\n'
          '- Only share support access with people you trust.\n'
          '- Test accounts and data may be removed when the project ends.\n'
          '- Your data is stored in Firebase and only used for this app.',
      'si': 'HASTHAKALA ශිෂ්‍ය ව්‍යාපෘතියකි (IT3060, කණ්ඩායම 28).\n\n'
          '- ඔබ සහ ඔබේ නිෂ්පාදන ගැන නිවැරදි තොරතුරු භාවිතා කරන්න.\n'
          '- සහාය ප්‍රවේශය ඔබ විශ්වාස කරන අය සමඟ පමණක් බෙදාගන්න.\n'
          '- ව්‍යාපෘතිය අවසානයේ පරීක්ෂණ ගිණුම් සහ දත්ත ඉවත් කළ හැක.\n'
          '- ඔබේ දත්ත Firebase හි ගබඩා කර මෙම යෙදුම සඳහා පමණක් භාවිතා වේ.',
      'ta': 'HASTHAKALA ஒரு மாணவர் திட்டம் (IT3060, குழு 28).\n\n'
          '- உங்களைப் பற்றியும் உங்கள் தயாரிப்புகள் பற்றியும் சரியான தகவலைப் பயன்படுத்துங்கள்.\n'
          '- நீங்கள் நம்பும் நபர்களுடன் மட்டுமே உதவி அணுகலைப் பகிருங்கள்.\n'
          '- திட்டம் முடிந்ததும் சோதனைக் கணக்குகளும் தரவும் நீக்கப்படலாம்.\n'
          '- உங்கள் தரவு Firebase-இல் சேமிக்கப்பட்டு இந்த செயலிக்கு மட்டுமே பயன்படுத்தப்படும்.',
    },
    'have_account': {
      'en': 'Already have an account?',
      'si': 'දැනටමත් ගිණුමක් තිබේද?',
      'ta': 'ஏற்கனவே கணக்கு உள்ளதா?',
    },

    // ---- messages (validation and sign-in errors) ----
    'err_email_required': {
      'en': 'Email address is required',
      'si': 'විද්‍යුත් තැපැල් ලිපිනය අවශ්‍යයි',
      'ta': 'மின்னஞ்சல் முகவரி தேவை',
    },
    'err_email_invalid': {
      'en': 'Enter a valid email address',
      'si': 'වලංගු විද්‍යුත් තැපැල් ලිපිනයක් ඇතුළත් කරන්න',
      'ta': 'சரியான மின்னஞ்சல் முகவரியை உள்ளிடவும்',
    },
    'err_password_required': {
      'en': 'Password is required',
      'si': 'මුරපදය අවශ්‍යයි',
      'ta': 'கடவுச்சொல் தேவை',
    },
    'err_password_short': {
      'en': 'Password must be at least 6 characters',
      'si': 'මුරපදයේ අවම වශයෙන් අකුරු 6ක් තිබිය යුතුය',
      'ta': 'கடவுச்சொல் குறைந்தது 6 எழுத்துகள் இருக்க வேண்டும்',
    },
    'err_name_required': {
      'en': 'Please enter your full name',
      'si': 'කරුණාකර ඔබේ සම්පූර්ණ නම ඇතුළත් කරන්න',
      'ta': 'உங்கள் முழுப் பெயரை உள்ளிடவும்',
    },
    'err_password_mismatch': {
      'en': 'Passwords do not match',
      'si': 'මුරපද නොගැළපේ',
      'ta': 'கடவுச்சொற்கள் பொருந்தவில்லை',
    },
    'err_terms': {
      'en': 'Please agree to the Terms & Conditions to continue.',
      'si': 'ඉදිරියට යාමට නියම සහ කොන්දේසිවලට එකඟ වන්න.',
      'ta': 'தொடர விதிமுறைகள் மற்றும் நிபந்தனைகளை ஏற்கவும்.',
    },
    'err_wrong_login': {
      'en': 'Email or password is incorrect. Please try again.',
      'si': 'විද්‍යුත් තැපෑල හෝ මුරපදය වැරදියි. නැවත උත්සාහ කරන්න.',
      'ta': 'மின்னஞ்சல் அல்லது கடவுச்சொல் தவறானது. மீண்டும் முயற்சிக்கவும்.',
    },
    'err_email_in_use': {
      'en': 'An account already exists with this email. Try signing in instead.',
      'si': 'මෙම විද්‍යුත් තැපෑලෙන් දැනටමත් ගිණුමක් ඇත. ඒ වෙනුවට පුරනය වන්න.',
      'ta': 'இந்த மின்னஞ்சலுடன் ஏற்கனவே ஒரு கணக்கு உள்ளது. உள்நுழைய முயற்சிக்கவும்.',
    },
    'err_offline': {
      'en': 'No internet connection. Check your connection and try again.',
      'si': 'අන්තර්ජාල සම්බන්ධතාවක් නැත. සම්බන්ධතාව පරීක්ෂා කර නැවත උත්සාහ කරන්න.',
      'ta': 'இணைய இணைப்பு இல்லை. இணைப்பைச் சரிபார்த்து மீண்டும் முயற்சிக்கவும்.',
    },
    'err_too_many': {
      'en': 'Too many attempts. Please wait a moment and try again.',
      'si': 'උත්සාහයන් ඉක්මවා යයි. මොහොතක් රැඳී නැවත උත්සාහ කරන්න.',
      'ta': 'அதிக முயற்சிகள். சிறிது நேரம் காத்திருந்து மீண்டும் முயற்சிக்கவும்.',
    },
    'err_disabled': {
      'en': 'This account has been disabled. Please contact support.',
      'si': 'මෙම ගිණුම අක්‍රිය කර ඇත. සහාය අමතන්න.',
      'ta': 'இந்தக் கணக்கு முடக்கப்பட்டுள்ளது. உதவியைத் தொடர்பு கொள்ளவும்.',
    },
    'err_generic': {
      'en': 'Something went wrong. Please try again.',
      'si': 'යම් දෝෂයක් සිදුවිය. නැවත උත්සාහ කරන්න.',
      'ta': 'ஏதோ தவறு நடந்தது. மீண்டும் முயற்சிக்கவும்.',
    },
    'err_create_account': {
      'en': 'We could not create your account. Please try again.',
      'si': 'ඔබේ ගිණුම සෑදීමට නොහැකි විය. නැවත උත්සාහ කරන්න.',
      'ta': 'உங்கள் கணக்கை உருவாக்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.',
    },
    'err_load_account': {
      'en': 'We could not load your account. Check your connection and try again.',
      'si': 'ඔබේ ගිණුම පූරණය කළ නොහැකි විය. සම්බන්ධතාව පරීක්ෂා කර නැවත උත්සාහ කරන්න.',
      'ta': 'உங்கள் கணக்கை ஏற்ற முடியவில்லை. இணைப்பைச் சரிபார்த்து மீண்டும் முயற்சிக்கவும்.',
    },

    // ---- account setup, reset password, contexts ----
    'account_created_title': {
      'en': 'Account Created!',
      'si': 'ගිණුම සාදන ලදී!',
      'ta': 'கணக்கு உருவாக்கப்பட்டது!',
    },
    'account_created_sub': {
      'en': 'Welcome to HASTHAKALA. Let\'s get started on your journey.',
      'si': 'HASTHAKALA වෙත සාදරයෙන් පිළිගනිමු. ඔබේ ගමන ආරම්භ කරමු.',
      'ta': 'HASTHAKALA-வுக்கு வரவேற்கிறோம். உங்கள் பயணத்தைத் தொடங்குவோம்.',
    },
    'purpose_title': {
      'en': 'How will you start using HASTHAKALA?',
      'si': 'ඔබ HASTHAKALA භාවිතා කිරීම ආරම්භ කරන්නේ කෙසේද?',
      'ta': 'HASTHAKALA-வை எப்படிப் பயன்படுத்தத் தொடங்குவீர்கள்?',
    },
    'purpose_sub': {
      'en': 'Choose how you want to begin. Sellers can still shop too.',
      'si': 'ආරම්භ කිරීමට අවශ්‍ය ආකාරය තෝරන්න. විකුණන අයටත් මිලදී ගත හැක.',
      'ta': 'எப்படித் தொடங்க வேண்டும் என்பதைத் தேர்ந்தெடுங்கள். விற்பவர்களும் வாங்கலாம்.',
    },
    'purpose_shop': {
      'en': 'Shop for Crafts',
      'si': 'අත්කම් මිලදී ගන්න',
      'ta': 'கைவினைப் பொருட்களை வாங்குங்கள்',
    },
    'purpose_shop_sub': {
      'en': 'Discover and support local artisans',
      'si': 'දේශීය ශිල්පීන් සොයාගෙන ඔවුන්ට සහාය වන්න',
      'ta': 'உள்ளூர் கைவினைஞர்களைக் கண்டறிந்து ஆதரியுங்கள்',
    },
    'purpose_sell': {
      'en': 'Sell My Crafts',
      'si': 'මගේ අත්කම් විකුණන්න',
      'ta': 'என் கைவினைப் பொருட்களை விற்கவும்',
    },
    'purpose_sell_sub': {
      'en': 'Create and manage your artisan presence',
      'si': 'ඔබේ ශිල්පී පැතිකඩ සාදා කළමනාකරණය කරන්න',
      'ta': 'உங்கள் கைவினைஞர் இருப்பை உருவாக்கி நிர்வகிக்கவும்',
    },
    'sign_out': {
      'en': 'Sign out',
      'si': 'ඉවත් වන්න',
      'ta': 'வெளியேறு',
    },
    'all_set_title': {
      'en': 'You\'re all set!',
      'si': 'සියල්ල සූදානම්!',
      'ta': 'எல்லாம் தயார்!',
    },
    'all_set_sub': {
      'en': 'Start exploring handmade crafts from across Sri Lanka.',
      'si': 'ශ්‍රී ලංකාව පුරා අත්කම් නිර්මාණ ගවේෂණය කිරීම අරඹන්න.',
      'ta': 'இலங்கை முழுவதிலுமிருந்து கைவினைப் பொருட்களை ஆராயத் தொடங்குங்கள்.',
    },
    'continue_home': {
      'en': 'Continue to Home',
      'si': 'මුල් පිටුවට යන්න',
      'ta': 'முகப்புக்குச் செல்லவும்',
    },
    'artisan_started_title': {
      'en': 'Your artisan setup has started!',
      'si': 'ඔබේ ශිල්පී සැකසුම ආරම්භ විය!',
      'ta': 'உங்கள் கைவினைஞர் அமைப்பு தொடங்கியது!',
    },
    'artisan_started_sub': {
      'en': 'Next, let\'s complete your profile to showcase your crafts.',
      'si': 'ඊළඟට, ඔබේ නිර්මාණ පෙන්වීමට ප්‍රොෆයිල්/profile සම්පූර්ණ කරමු.',
      'ta': 'அடுத்து, உங்கள் கைவினைகளைக் காட்ட சுயவிவரத்தை நிறைவு செய்வோம்.',
    },
    'continue_profile': {
      'en': 'Continue to Profile',
      'si': 'පැතිකඩට/ප්‍රොෆයිල් යන්න',
      'ta': 'சுயவிவரத்துக்குச் செல்லவும்',
    },
    'reset_title': {
      'en': 'Reset Your Password',
      'si': 'ඔබේ මුරපදය යළි සකසන්න',
      'ta': 'உங்கள் கடவுச்சொல்லை மீட்டமைக்கவும்',
    },
    'reset_sub': {
      'en': 'We\'ll send you a link to reset your password.',
      'si': 'මුරපදය යළි සැකසීමට අපි ඔබට සබැඳියක් එවන්නෙමු.',
      'ta': 'கடவுச்சொல்லை மீட்டமைக்க ஒரு இணைப்பை அனுப்புவோம்.',
    },
    'send_reset_link': {
      'en': 'Send Reset Link',
      'si': 'යළි සැකසීමේ සබැඳිය යවන්න',
      'ta': 'மீட்டமைப்பு இணைப்பை அனுப்பு',
    },
    'back_to_sign_in': {
      'en': 'Back to Sign In',
      'si': 'පුරනය වීමට ආපසු',
      'ta': 'உள்நுழைவுக்குத் திரும்பு',
    },
    'check_email_title': {
      'en': 'Check your email',
      'si': 'ඔබේ විද්‍යුත් තැපෑල පරීක්ෂා කරන්න',
      'ta': 'உங்கள் மின்னஞ்சலைச் சரிபார்க்கவும்',
    },
    'check_email_sub': {
      'en': 'If an account exists for {email}, we sent password recovery instructions to it.',
      'si': '{email} සඳහා ගිණුමක් තිබේ නම්, මුරපදය ප්‍රතිසාධනය කිරීමේ උපදෙස් එයට යවා ඇත.',
      'ta': '{email} க்கு கணக்கு இருந்தால், கடவுச்சொல் மீட்பு வழிமுறைகளை அனுப்பியுள்ளோம்.',
    },
    'resend': {
      'en': 'Resend',
      'si': 'නැවත යවන්න',
      'ta': 'மீண்டும் அனுப்பு',
    },
    'continue_as': {
      'en': 'Continue as {name}',
      'si': '{name} ලෙස ඉදිරියට',
      'ta': '{name} ஆக தொடரவும்',
    },
    'continue_as_sub': {
      'en': 'You have more than one way to use HASTHAKALA. Choose how you\'d like to continue.',
      'si': 'ඔබට HASTHAKALA භාවිතා කිරීමට ක්‍රම කිහිපයක් ඇත. ඉදිරියට යන ආකාරය තෝරන්න.',
      'ta': 'HASTHAKALA-வைப் பயன்படுத்த உங்களுக்குப் பல வழிகள் உள்ளன. எப்படித் தொடர வேண்டும் என்பதைத் தேர்ந்தெடுங்கள்.',
    },
    'ctx_buyer': {
      'en': 'Buyer',
      'si': 'ගැනුම්කරු',
      'ta': 'வாங்குபவர்',
    },
    'ctx_buyer_sub': {
      'en': 'Shop for unique handmade crafts from local artisans',
      'si': 'දේශීය ශිල්පීන්ගෙන් අද්විතීය අත්කම් මිලදී ගන්න',
      'ta': 'உள்ளூர் கைவினைஞர்களிடமிருந்து தனித்துவமான கைவினைப் பொருட்களை வாங்குங்கள்',
    },
    'ctx_artisan': {
      'en': 'Artisan',
      'si': 'ශිල්පියා',
      'ta': 'கைவினைஞர்',
    },
    'ctx_artisan_sub': {
      'en': 'Manage your crafts, orders and business',
      'si': 'ඔබේ නිර්මාණ, ඇණවුම් සහ ව්‍යාපාරය කළමනාකරණය කරන්න',
      'ta': 'உங்கள் கைவினைகள், ஆர்டர்கள் மற்றும் வணிகத்தை நிர்வகிக்கவும்',
    },
    'ctx_supporting': {
      'en': 'Supporting {name}',
      'si': '{name} ට සහාය වෙමින්',
      'ta': '{name} க்கு உதவுகிறீர்கள்',
    },
    'ctx_supporting_sub': {
      'en': 'Help with the activities you were allowed',
      'si': 'ඔබට අවසර දුන් කටයුතුවලට උදව් කරන්න',
      'ta': 'உங்களுக்கு அனுமதிக்கப்பட்ட செயல்களில் உதவுங்கள்',
    },
    'check_verified': {
      'en': 'Account verified',
      'si': 'ගිණුම තහවුරු විය',
      'ta': 'கணக்கு சரிபார்க்கப்பட்டது',
    },
    'check_profiles': {
      'en': 'Checking your profiles...',
      'si': 'ඔබේ පැතිකඩ/ප්‍රොෆයිල් පරීක්ෂා කරමින්...',
      'ta': 'உங்கள் சுயவிவரங்களைச் சரிபார்க்கிறது...',
    },
    'check_workspace': {
      'en': 'Loading your workspace...',
      'si': 'ඔබේ වැඩ අවකාශය පූරණය කරමින්...',
      'ta': 'உங்கள் பணியிடத்தை ஏற்றுகிறது...',
    },
    'sign_out_title': {
      'en': 'Sign out?',
      'si': 'ඉවත් වන්නද?',
      'ta': 'வெளியேறவா?',
    },
    'sign_out_body': {
      'en': 'You will need to sign in again to access your account.',
      'si': 'ඔබේ ගිණුමට පිවිසීමට නැවත පුරනය වීමට සිදුවේ.',
      'ta': 'உங்கள் கணக்கை அணுக மீண்டும் உள்நுழைய வேண்டும்.',
    },
    'cancel': {
      'en': 'Cancel',
      'si': 'අවලංගු කරන්න',
      'ta': 'ரத்துசெய்',
    },
    'support_removed_title': {
      'en': 'Support access is no longer available',
      'si': 'සහාය ප්‍රවේශය තවදුරටත් නොමැත',
      'ta': 'உதவி அணுகல் இனி கிடைக்காது',
    },
    'support_removed_sub': {
      'en': 'Your access to {name}\'s business has changed or been removed.',
      'si': '{name} ගේ ව්‍යාපාරයට ඔබේ ප්‍රවේශය වෙනස් කර හෝ ඉවත් කර ඇත.',
      'ta': '{name} இன் வணிகத்துக்கான உங்கள் அணுகல் மாற்றப்பட்டது அல்லது நீக்கப்பட்டது.',
    },
    'err_save_choice': {
      'en': 'We could not save your choice. Check your connection and try again.',
      'si': 'ඔබේ තේරීම සුරැකීමට නොහැකි විය. සම්බන්ධතාව පරීක්ෂා කර නැවත උත්සාහ කරන්න.',
      'ta': 'உங்கள் தேர்வைச் சேமிக்க முடியவில்லை. இணைப்பைச் சரிபார்த்து மீண்டும் முயற்சிக்கவும்.',
    },
    'err_reset_failed': {
      'en': 'We could not send the reset link. Please try again.',
      'si': 'යළි සැකසීමේ සබැඳිය යැවිය නොහැකි විය. නැවත උත්සාහ කරන්න.',
      'ta': 'மீட்டமைப்பு இணைப்பை அனுப்ப முடியவில்லை. மீண்டும் முயற்சிக்கவும்.',
    },

    // ---- profile tab (I05 / I13) ----
    'profile_section_business': {'en': 'My business', 'si': 'මගේ ව්‍යාපාරය', 'ta': 'எனது வணிகம்'},
    'profile_section_help': {
      'en': 'Help an artisan',
      'si': 'ශිල්පියෙකුට උදව් කරන්න',
      'ta': 'கைவினைஞருக்கு உதவுங்கள்',
    },
    'profile_section_access': {
      'en': 'Your support access',
      'si': 'ඔබේ සහාය ප්‍රවේශය',
      'ta': 'உங்கள் உதவி அணுகல்',
    },
    'profile_section_settings': {'en': 'Settings', 'si': 'සැකසුම්', 'ta': 'அமைப்புகள்'},
    'profile_my_artisan': {
      'en': 'My Artisan Profile',
      'si': 'මගේ ශිල්පී පැතිකඩ',
      'ta': 'எனது கைவினைஞர் சுயவிவரம்',
    },
    'profile_my_artisan_sub': {
      'en': 'View and manage your public artisan information',
      'si': 'ඔබේ පොදු ශිල්පී තොරතුරු බලන්න සහ කළමනාකරණය කරන්න',
      'ta': 'உங்கள் பொது கைவினைஞர் தகவலைப் பார்த்து நிர்வகிக்கவும்',
    },
    'family_assistance': {'en': 'Family Assistance', 'si': 'පවුලේ සහාය', 'ta': 'குடும்ப உதவி'},
    'family_assistance_sub': {
      'en': 'Manage authorized support',
      'si': 'බලයලත් සහාය කළමනාකරණය කරන්න',
      'ta': 'அங்கீகரிக்கப்பட்ட உதவியை நிர்வகிக்கவும்',
    },
    'accept_invite': {
      'en': 'Accept support invitation',
      'si': 'සහාය ආරාධනාව පිළිගන්න',
      'ta': 'உதவி அழைப்பை ஏற்கவும்',
    },
    'accept_invite_sub': {
      'en': 'Help an artisan with their business using a code',
      'si': 'කේතයක් භාවිතයෙන් ශිල්පියෙකුගේ ව්‍යාපාරයට උදව් කරන්න',
      'ta': 'ஒரு குறியீட்டைப் பயன்படுத்தி கைவினைஞரின் வணிகத்திற்கு உதவுங்கள்',
    },
    'profile_supporting_sub': {
      'en': 'Allowed: {scopes}. Account settings stay with the owner.',
      'si': 'අවසර ඇති දේ: {scopes}. ගිණුම් සැකසුම් හිමිකරු සතුව පවතී.',
      'ta': 'அனுமதி: {scopes}. கணக்கு அமைப்புகள் உரிமையாளரிடமே இருக்கும்.',
    },
    'scope_messages': {
      'en': 'Customer messages',
      'si': 'පාරිභෝගික පණිවිඩ',
      'ta': 'வாடிக்கையாளர் செய்திகள்',
    },
    'scope_none': {'en': 'No permissions', 'si': 'අවසර නැත', 'ta': 'அனுமதிகள் இல்லை'},
    'switch_context': {
      'en': 'Switch context',
      'si': 'භාවිත ආකාරය මාරු කරන්න',
      'ta': 'பயன்முறையை மாற்றவும்',
    },
    'switch_context_sub': {
      'en': 'Now using: {ctx}',
      'si': 'දැන් භාවිතා කරන්නේ: {ctx}',
      'ta': 'இப்போது: {ctx}',
    },
    'ctx_supporter': {'en': 'Supporter', 'si': 'සහායක', 'ta': 'உதவியாளர்'},
    'craft_artisan': {'en': '{craft} Artisan', 'si': '{craft} ශිල්පී', 'ta': '{craft} கைவினைஞர்'},

    // ---- craft names (keys from craft_categories.dart) ----
    'craft_pottery': {'en': 'Pottery', 'si': 'මැටි බඩු', 'ta': 'மட்பாண்டம்'},
    'craft_batik': {'en': 'Batik', 'si': 'බතික්', 'ta': 'பத்திக்'},
    'craft_wood_carving': {'en': 'Wood Carving', 'si': 'ලී කැටයම්', 'ta': 'மரச் செதுக்கல்'},
    'craft_masks': {'en': 'Masks', 'si': 'වෙස් මුහුණු', 'ta': 'முகமூடிகள்'},
    'craft_handloom_textiles': {
      'en': 'Handloom & Textiles',
      'si': 'අත්යන්ත්‍ර සහ රෙදි',
      'ta': 'கைத்தறி மற்றும் துணிகள்',
    },
    'craft_jewellery': {'en': 'Jewellery', 'si': 'ආභරණ', 'ta': 'நகைகள்'},
    'craft_brassware': {'en': 'Brassware', 'si': 'පිත්තල භාණ්ඩ', 'ta': 'பித்தளைப் பொருட்கள்'},
    'craft_cane_bamboo': {
      'en': 'Cane & Bamboo',
      'si': 'වේවැල් සහ උණ',
      'ta': 'பிரம்பு மற்றும் மூங்கில்',
    },
    'craft_coconut_shell': {
      'en': 'Coconut Shell Craft',
      'si': 'පොල්කටු නිර්මාණ',
      'ta': 'தேங்காய் ஓட்டுக் கைவினை',
    },
    'craft_home_decor': {'en': 'Home Decor', 'si': 'නිවාස අලංකරණ', 'ta': 'வீட்டு அலங்காரம்'},
    'craft_other': {'en': 'Other', 'si': 'වෙනත්', 'ta': 'மற்றவை'},

    // ---- my artisan profile (I05) ----
    'profile_load_error': {
      'en': 'Your profile could not be loaded. Check your connection.',
      'si': 'ඔබේ පැතිකඩ පූරණය කළ නොහැකි විය. සම්බන්ධතාව පරීක්ෂා කරන්න.',
      'ta': 'உங்கள் சுயவிவரத்தை ஏற்ற முடியவில்லை. இணைப்பைச் சரிபார்க்கவும்.',
    },
    'profile_verified': {
      'en': 'Verified artisan',
      'si': 'තහවුරු කළ ශිල්පී',
      'ta': 'சரிபார்க்கப்பட்ட கைவினைஞர்',
    },
    'profile_not_verified': {
      'en': 'Not verified yet',
      'si': 'තවම තහවුරු කර නැත',
      'ta': 'இன்னும் சரிபார்க்கப்படவில்லை',
    },
    'profile_buyers_see': {
      'en': 'This is what buyers see on your public profile.',
      'si': 'ඔබේ පොදු පැතිකඩේ ගැනුම්කරුවන් දකින්නේ මෙයයි.',
      'ta': 'உங்கள் பொது சுயவிவரத்தில் வாங்குபவர்கள் பார்ப்பது இதுதான்.',
    },
    'about_my_craft': {
      'en': 'About My Craft',
      'si': 'මගේ කලාව ගැන',
      'ta': 'எனது கைவினை பற்றி',
    },
    'profile_about_empty': {
      'en': 'Not added yet.',
      'si': 'තවම එක් කර නැත.',
      'ta': 'இன்னும் சேர்க்கப்படவில்லை.',
    },
    'profile_member_since': {'en': 'Member since', 'si': 'සාමාජිකත්වය ලැබූ දිනය', 'ta': 'உறுப்பினரான நாள்'},
    'profile_last_updated': {'en': 'Last updated', 'si': 'අවසන් වරට යාවත්කාලීන කළේ', 'ta': 'கடைசியாகப் புதுப்பிக்கப்பட்டது'},
    'edit_profile': {'en': 'Edit Profile', 'si': 'පැතිකඩ සංස්කරණය', 'ta': 'சுயவிவரத்தைத் திருத்து'},
    'preview_public_profile': {
      'en': 'Preview Public Profile',
      'si': 'පොදු පැතිකඩ පෙරදසුන',
      'ta': 'பொது சுயவிவர முன்னோட்டம்',
    },

    // ---- edit / complete artisan profile (I05) ----
    'edit_title': {
      'en': 'Edit Artisan Profile',
      'si': 'ශිල්පී පැතිකඩ/ප්‍රොෆයිල් සංස්කරණය',
      'ta': 'கைவினைஞர் சுயவிவரத்தைத் திருத்து',
    },
    'sec_photo': {'en': 'Profile Photo', 'si': 'පැතිකඩ ඡායාරූපය', 'ta': 'சுயவிவரப் படம்'},
    'sec_basic': {'en': 'Basic Information', 'si': 'මූලික තොරතුරු', 'ta': 'அடிப்படைத் தகவல்'},
    'sec_location': {'en': 'Location', 'si': 'ස්ථානය', 'ta': 'இருப்பிடம்'},
    'photo_soon': {
      'en': 'Photo upload will be available soon.',
      'si': 'ඡායාරූප උඩුගත කිරීම ඉක්මනින් ලැබෙනු ඇත.',
      'ta': 'படம் பதிவேற்றும் வசதி விரைவில் கிடைக்கும்.',
    },
    'label_artisan_name': {'en': 'Artisan Name', 'si': 'ශිල්පී නම', 'ta': 'கைவினைஞர் பெயர்'},
    'hint_artisan_name': {
      'en': 'Enter your artisan name',
      'si': 'ඔබේ ශිල්පී නම ඇතුළත් කරන්න',
      'ta': 'உங்கள் கைவினைஞர் பெயரை உள்ளிடவும்',
    },
    'label_craft': {'en': 'Craft Type', 'si': 'කලා වර්ගය', 'ta': 'கைவினை வகை'},
    'hint_craft': {
      'en': 'Select craft type',
      'si': 'කලා වර්ගය තෝරන්න',
      'ta': 'கைவினை வகையைத் தேர்ந்தெடுக்கவும்',
    },
    'label_about': {'en': 'Short description', 'si': 'කෙටි විස්තරය', 'ta': 'சிறு விளக்கம்'},
    'hint_about': {
      'en': 'Tell buyers what you make and how you make it',
      'si': 'ඔබ සාදන දේ සහ එය සාදන ආකාරය ගැනුම්කරුවන්ට කියන්න',
      'ta': 'நீங்கள் என்ன செய்கிறீர்கள், எப்படிச் செய்கிறீர்கள் என்று வாங்குபவர்களுக்குச் சொல்லுங்கள்',
    },
    'about_count': {
      'en': 'Write at least 10 characters ({count} so far)',
      'si': 'අවම වශයෙන් අකුරු 10ක් ලියන්න (දැනට {count})',
      'ta': 'குறைந்தது 10 எழுத்துகள் எழுதவும் (இதுவரை {count})',
    },
    'about_ok': {'en': 'Looks good', 'si': 'හොඳයි', 'ta': 'சரியாக உள்ளது'},
    'label_location': {'en': 'General Location', 'si': 'පොදු ස්ථානය', 'ta': 'பொது இருப்பிடம்'},
    'hint_location': {
      'en': 'e.g. Colombo, Sri Lanka',
      'si': 'උදා: කොළඹ, ශ්‍රී ලංකාව',
      'ta': 'எ.கா. கொழும்பு, இலங்கை',
    },
    'location_help': {
      'en': 'Town or district only, not your home address.',
      'si': 'නගරය හෝ දිස්ත්‍රික්කය පමණි, ඔබේ නිවසේ ලිපිනය නොවේ.',
      'ta': 'நகரம் அல்லது மாவட்டம் மட்டும், உங்கள் வீட்டு முகவரி அல்ல.',
    },
    'save_changes': {'en': 'Save Changes', 'si': 'වෙනස්කම් සුරකින්න', 'ta': 'மாற்றங்களைச் சேமி'},
    'saving_title': {
      'en': 'Saving your profile...',
      'si': 'ඔබේ ප්‍රොෆයිල් සුරකිමින්...',
      'ta': 'உங்கள் சுயவிவரம் சேமிக்கப்படுகிறது...',
    },
    'saving_sub': {
      'en': 'Please wait while we update your information.',
      'si': 'ඔබේ තොරතුරු යාවත්කාලීන කරන තෙක් රැඳී සිටින්න.',
      'ta': 'உங்கள் தகவலைப் புதுப்பிக்கும் வரை காத்திருக்கவும்.',
    },
    'save_failed_title': {
      'en': "We couldn't save your changes",
      'si': 'ඔබේ වෙනස්කම් සුරැකීමට නොහැකි විය',
      'ta': 'உங்கள் மாற்றங்களைச் சேமிக்க முடியவில்லை',
    },
    'save_failed_body': {
      'en': 'Your information has not been lost. Please try again.',
      'si': 'ඔබේ තොරතුරු නැති වී නැත. නැවත උත්සාහ කරන්න.',
      'ta': 'உங்கள் தகவல் இழக்கப்படவில்லை. மீண்டும் முயற்சிக்கவும்.',
    },
    'offline_title': {'en': "You're offline", 'si': 'ඔබ නොබැඳි ය', 'ta': 'நீங்கள் இணைப்பில் இல்லை'},
    'offline_body': {
      'en': "Changes can't be saved right now. Your edits are still here.",
      'si': 'දැන් වෙනස්කම් සුරැකිය නොහැක. ඔබේ සංස්කරණ තවමත් මෙහි ඇත.',
      'ta': 'இப்போது மாற்றங்களைச் சேமிக்க முடியாது. உங்கள் திருத்தங்கள் இங்கேயே உள்ளன.',
    },
    'try_again': {'en': 'Try Again', 'si': 'නැවත උත්සාහ කරන්න', 'ta': 'மீண்டும் முயற்சி'},
    'keep_editing': {'en': 'Keep Editing', 'si': 'දිගටම සංස්කරණය', 'ta': 'தொடர்ந்து திருத்து'},
    'discard_title': {
      'en': 'Discard changes?',
      'si': 'වෙනස්කම් ඉවත දමන්නද?',
      'ta': 'மாற்றங்களை நிராகரிக்கவா?',
    },
    'discard_body': {
      'en': 'You have unsaved profile changes. Are you sure you want to leave?',
      'si': 'ඔබේ පැතිකඩේ/ප්‍රොෆයිල් සුරැකී නැති වෙනස්කම් ඇත. ඔබට ඉවත් වීමට අවශ්‍යද?',
      'ta': 'சேமிக்கப்படாத சுயவிவர மாற்றங்கள் உள்ளன. நிச்சயமாக வெளியேற வேண்டுமா?',
    },
    'discard': {'en': 'Discard', 'si': 'ඉවත දමන්න', 'ta': 'நிராகரி'},
    'err_artisan_name': {
      'en': 'Artisan name is required.',
      'si': 'ශිල්පී නම අවශ්‍යයි.',
      'ta': 'கைவினைஞர் பெயர் தேவை.',
    },
    'err_craft_type': {
      'en': 'Please select a craft type.',
      'si': 'කරුණාකර කලා වර්ගයක් තෝරන්න.',
      'ta': 'கைவினை வகையைத் தேர்ந்தெடுக்கவும்.',
    },
    'err_about_short': {
      'en': 'Please write a short description (10+ characters).',
      'si': 'කරුණාකර කෙටි විස්තරයක් ලියන්න (අකුරු 10+).',
      'ta': 'சிறு விளக்கம் ஒன்றை எழுதவும் (10+ எழுத்துகள்).',
    },
    'err_location': {
      'en': 'Please enter your location.',
      'si': 'කරුණාකර ඔබේ ස්ථානය ඇතුළත් කරන්න.',
      'ta': 'உங்கள் இருப்பிடத்தை உள்ளிடவும்.',
    },

    // ---- first-time artisan + status screens (I05) ----
    'setup_title': {
      'en': 'Complete Your Artisan Profile',
      'si': 'ඔබේ ශිල්පී පැතිකඩ සම්පූර්ණ කරන්න',
      'ta': 'உங்கள் கைவினைஞர் சுயவிவரத்தை நிறைவு செய்யுங்கள்',
    },
    'setup_intro': {
      'en': 'Tell buyers about your craft and story.',
      'si': 'ඔබේ කලාව සහ කතාව ගැනුම්කරුවන්ට කියන්න.',
      'ta': 'உங்கள் கைவினை மற்றும் கதையை வாங்குபவர்களுக்குச் சொல்லுங்கள்.',
    },
    'save_profile': {'en': 'Save Profile', 'si': 'පැතිකඩ සුරකින්න', 'ta': 'சுயவிவரத்தைச் சேமி'},
    'created_title': {
      'en': 'Artisan profile created!',
      'si': 'ශිල්පී පැතිකඩ සාදන ලදී!',
      'ta': 'கைவினைஞர் சுயவிவரம் உருவாக்கப்பட்டது!',
    },
    'created_body': {
      'en': 'Your profile is ready. You can now start showcasing your craft to buyers.',
      'si': 'ඔබේ පැතිකඩ සූදානම්. දැන් ඔබට ඔබේ කලාව ගැනුම්කරුවන්ට පෙන්වීම ආරම්භ කළ හැක.',
      'ta': 'உங்கள் சுயவிவரம் தயார். இப்போது உங்கள் கைவினையை வாங்குபவர்களுக்குக் காட்டத் தொடங்கலாம்.',
    },
    'updated_title': {
      'en': 'Profile updated',
      'si': 'පැතිකඩ යාවත්කාලීන විය',
      'ta': 'சுயவிவரம் புதுப்பிக்கப்பட்டது',
    },
    'updated_body': {
      'en': 'Your artisan profile changes have been saved.',
      'si': 'ඔබේ ශිල්පී පැතිකඩේ වෙනස්කම් සුරකින ලදී.',
      'ta': 'உங்கள் கைவினைஞர் சுயவிவர மாற்றங்கள் சேமிக்கப்பட்டன.',
    },
    'view_my_profile': {'en': 'View My Profile', 'si': 'මගේ පැතිකඩ බලන්න', 'ta': 'எனது சுயவிவரத்தைப் பார்'},

    // ---- profile cover (I05) ----
    'cover_change': {'en': 'Change cover', 'si': 'කවරය වෙනස් කරන්න', 'ta': 'அட்டையை மாற்று'},
    'cover_title': {'en': 'Choose a cover', 'si': 'කවරයක් තෝරන්න', 'ta': 'அட்டையைத் தேர்ந்தெடுக்கவும்'},
    'cover_sub': {
      'en': 'Buyers see this at the top of your profile.',
      'si': 'ගැනුම්කරුවන් මෙය ඔබේ පැතිකඩේ ඉහළින් දකිති.',
      'ta': 'வாங்குபவர்கள் இதை உங்கள் சுயவிவரத்தின் மேலே பார்ப்பார்கள்.',
    },
    'cover_photo': {'en': 'Hasthakala crafts', 'si': 'හස්තකලා නිර්මාණ', 'ta': 'ஹஸ்தகலா கைவினைகள்'},
    'cover_collage': {'en': 'Crafts collage', 'si': 'නිර්මාණ එකතුව', 'ta': 'கைவினைத் தொகுப்பு'},
    'cover_clay': {'en': 'Terracotta clay', 'si': 'මැටි රතු', 'ta': 'சுடுமண் சிவப்பு'},
    'cover_sunset': {'en': 'Golden sunset', 'si': 'රන්වන් සැන්දෑව', 'ta': 'பொன் அந்தி'},
    'cover_paddy': {'en': 'Paddy field', 'si': 'කුඹුර', 'ta': 'நெல் வயல்'},
    'cover_linen': {'en': 'Raw linen', 'si': 'ලිනන් රෙදි', 'ta': 'லினன் துணி'},
    'cover_saving': {'en': 'Changing cover...', 'si': 'කවරය වෙනස් කරමින්...', 'ta': 'அட்டை மாற்றப்படுகிறது...'},
    'cover_saved': {'en': 'Cover updated', 'si': 'කවරය යාවත්කාලීන විය', 'ta': 'அட்டை புதுப்பிக்கப்பட்டது'},
    'cover_offline': {
      'en': "You're offline. The cover will change when you're connected again.",
      'si': 'ඔබ නොබැඳි ය. නැවත සම්බන්ධ වූ විට කවරය වෙනස් වේ.',
      'ta': 'நீங்கள் இணைப்பில் இல்லை. மீண்டும் இணைந்ததும் அட்டை மாறும்.',
    },
    'cover_failed': {
      'en': "We couldn't change the cover. Please try again.",
      'si': 'කවරය වෙනස් කිරීමට නොහැකි විය. නැවත උත්සාහ කරන්න.',
      'ta': 'அட்டையை மாற்ற முடியவில்லை. மீண்டும் முயற்சிக்கவும்.',
    },

    // ---- family assistance (I13) ----
    'rel_family': {'en': 'Family Member', 'si': 'පවුලේ සාමාජිකයෙක්', 'ta': 'குடும்ப உறுப்பினர்'},
    'rel_child': {'en': 'Son / Daughter', 'si': 'පුතා / දුව', 'ta': 'மகன் / மகள்'},
    'rel_spouse': {'en': 'Spouse', 'si': 'කලත්‍රයා', 'ta': 'வாழ்க்கைத் துணை'},
    'rel_sibling': {'en': 'Sibling', 'si': 'සහෝදරයා / සහෝදරිය', 'ta': 'உடன்பிறப்பு'},
    'rel_relative': {'en': 'Relative', 'si': 'ඥාතියෙක්', 'ta': 'உறவினர்'},
    'fa_intro': {
      'en': 'Authorize trusted family members to support your business.',
      'si': 'ඔබේ ව්‍යාපාරයට සහාය වීමට විශ්වාසවන්ත පවුලේ සාමාජිකයින්ට බලය දෙන්න.',
      'ta': 'உங்கள் வணிகத்திற்கு உதவ நம்பகமான குடும்ப உறுப்பினர்களுக்கு அனுமதி வழங்குங்கள்.',
    },
    'fa_sec_users': {
      'en': 'Authorized Support Users',
      'si': 'බලයලත් සහායකයින්',
      'ta': 'அங்கீகரிக்கப்பட்ட உதவியாளர்கள்',
    },
    'fa_sec_pending': {
      'en': 'Pending Invitations',
      'si': 'පොරොත්තු ආරාධනා',
      'ta': 'நிலுவையிலுள்ள அழைப்புகள்',
    },
    'fa_empty_title': {
      'en': 'No support users yet',
      'si': 'තවම සහායකයින් නැත',
      'ta': 'இன்னும் உதவியாளர்கள் இல்லை',
    },
    'fa_empty_sub': {
      'en': 'Tap Add Support User to invite someone.',
      'si': 'කෙනෙකුට ආරාධනා කිරීමට සහායකයෙක් එක් කරන්න ඔබන්න.',
      'ta': 'ஒருவரை அழைக்க உதவியாளரைச் சேர் என்பதைத் தட்டவும்.',
    },
    'fa_load_error': {
      'en': 'Support users could not be loaded. Check your connection.',
      'si': 'සහායකයින් පූරණය කළ නොහැකි විය. සම්බන්ධතාව පරීක්ෂා කරන්න.',
      'ta': 'உதவியாளர்களை ஏற்ற முடியவில்லை. இணைப்பைச் சரிபார்க்கவும்.',
    },
    'fa_trust': {
      'en': 'Support users can help only in areas you authorize.',
      'si': 'සහායකයින්ට උදව් කළ හැක්කේ ඔබ අවසර දෙන කටයුතුවලට පමණි.',
      'ta': 'நீங்கள் அனுமதிக்கும் பகுதிகளில் மட்டுமே உதவியாளர்கள் உதவ முடியும்.',
    },
    'add_support_user': {
      'en': 'Add Support User',
      'si': 'සහායකයෙක් එක් කරන්න',
      'ta': 'உதவியாளரைச் சேர்',
    },
    'status_active': {'en': 'Active', 'si': 'සක්‍රියයි', 'ta': 'செயலில்'},
    'status_pending': {'en': 'Pending', 'si': 'පොරොත්තුවෙන්', 'ta': 'நிலுவையில்'},
    'status_expired': {'en': 'Expired', 'si': 'කල් ඉකුත් වී ඇත', 'ta': 'காலாவதியானது'},
    'invite_code_line': {
      'en': 'Code {code}, valid until {date}',
      'si': 'කේතය {code}, {date} දක්වා වලංගුයි',
      'ta': 'குறியீடு {code}, {date} வரை செல்லும்',
    },
    'invite_expired_hint': {
      'en': 'This code has expired. Cancel it and invite again.',
      'si': 'මෙම කේතය කල් ඉකුත් වී ඇත. එය අවලංගු කර නැවත ආරාධනා කරන්න.',
      'ta': 'இந்தக் குறியீடு காலாவதியானது. அதை ரத்துசெய்து மீண்டும் அழைக்கவும்.',
    },
    'invite_share': {'en': 'Share code', 'si': 'කේතය බෙදාගන්න', 'ta': 'குறியீட்டைப் பகிர்'},
    'invite_cancel': {'en': 'Cancel', 'si': 'අවලංගු කරන්න', 'ta': 'ரத்துசெய்'},
    'invite_for': {
      'en': 'Invitation for {name}',
      'si': '{name} සඳහා ආරාධනාව',
      'ta': '{name} க்கான அழைப்பு',
    },
    'cancel_invite_title': {
      'en': 'Cancel invitation?',
      'si': 'ආරාධනාව අවලංගු කරන්නද?',
      'ta': 'அழைப்பை ரத்துசெய்யவா?',
    },
    'cancel_invite_body': {
      'en': '{name} will no longer be able to use code {code}.',
      'si': '{name} ට තවදුරටත් {code} කේතය භාවිතා කළ නොහැක.',
      'ta': '{name} இனி {code} குறியீட்டைப் பயன்படுத்த முடியாது.',
    },
    'keep': {'en': 'Keep', 'si': 'තබාගන්න', 'ta': 'வைத்திரு'},
    'cancel_invitation': {
      'en': 'Cancel invitation',
      'si': 'ආරාධනාව අවලංගු කරන්න',
      'ta': 'அழைப்பை ரத்துசெய்',
    },
    'invite_cancelled': {
      'en': 'Invitation cancelled',
      'si': 'ආරාධනාව අවලංගු කළා',
      'ta': 'அழைப்பு ரத்துசெய்யப்பட்டது',
    },
    'sec_person': {'en': 'Who is helping?', 'si': 'උදව් කරන්නේ කවුද?', 'ta': 'யார் உதவுகிறார்?'},
    'label_full_name': {'en': 'Full Name', 'si': 'සම්පූර්ණ නම', 'ta': 'முழுப் பெயர்'},
    'hint_full_name': {
      'en': 'Enter their full name',
      'si': 'ඔවුන්ගේ සම්පූර්ණ නම ඇතුළත් කරන්න',
      'ta': 'அவர்களின் முழுப் பெயரை உள்ளிடவும்',
    },
    'label_relationship': {'en': 'Relationship', 'si': 'සම්බන්ධතාවය', 'ta': 'உறவுமுறை'},
    'label_phone': {
      'en': 'Contact / Phone Number',
      'si': 'දුරකථන අංකය',
      'ta': 'தொலைபேசி எண்',
    },
    'sec_support_access': {'en': 'Support Access', 'si': 'සහාය ප්‍රවේශය', 'ta': 'உதவி அணுகல்'},
    'perm_products': {'en': 'Manage products', 'si': 'නිෂ්පාදන කළමනාකරණය', 'ta': 'தயாரிப்புகளை நிர்வகி'},
    'perm_products_sub': {
      'en': 'Add, edit and update products',
      'si': 'නිෂ්පාදන එක් කිරීම, සංස්කරණය සහ යාවත්කාලීන කිරීම',
      'ta': 'தயாரிப்புகளைச் சேர்க்க, திருத்த, புதுப்பிக்க',
    },
    'perm_orders': {'en': 'Manage orders', 'si': 'ඇණවුම් කළමනාකරණය', 'ta': 'ஆர்டர்களை நிர்வகி'},
    'perm_orders_sub': {
      'en': 'View and update order status',
      'si': 'ඇණවුම් තත්ත්වය බැලීම සහ යාවත්කාලීන කිරීම',
      'ta': 'ஆர்டர் நிலையைப் பார்க்க, புதுப்பிக்க',
    },
    'perm_messages': {
      'en': 'Respond to customers',
      'si': 'පාරිභෝගිකයින්ට පිළිතුරු දීම',
      'ta': 'வாடிக்கையாளர்களுக்குப் பதிலளி',
    },
    'perm_messages_sub': {
      'en': 'Reply to messages about orders',
      'si': 'ඇණවුම් ගැන පණිවිඩවලට පිළිතුරු දීම',
      'ta': 'ஆர்டர்கள் பற்றிய செய்திகளுக்குப் பதிலளிக்க',
    },
    'perm_sensitive': {
      'en': 'Sensitive account functions',
      'si': 'සංවේදී ගිණුම් කටයුතු',
      'ta': 'முக்கியமான கணக்கு செயல்பாடுகள்',
    },
    'perm_owner_only': {'en': 'Owner only', 'si': 'හිමිකරුට පමණි', 'ta': 'உரிமையாளருக்கு மட்டும்'},
    'sensitive_note': {
      'en': 'Sensitive owner account settings remain restricted.',
      'si': 'සංවේදී හිමිකරු ගිණුම් සැකසුම් සීමා කර ඇත.',
      'ta': 'முக்கியமான உரிமையாளர் கணக்கு அமைப்புகள் கட்டுப்படுத்தப்பட்டுள்ளன.',
    },
    'scope_summary': {
      'en': '{name} will be able to help with: {scopes}',
      'si': '{name} ට උදව් කළ හැකි දේ: {scopes}',
      'ta': '{name} உதவக்கூடியவை: {scopes}',
    },
    'scope_none_hint': {
      'en': 'Turn on at least one activity.',
      'si': 'අවම වශයෙන් එක් කටයුත්තක් සක්‍රිය කරන්න.',
      'ta': 'குறைந்தது ஒரு செயலையாவது இயக்கவும்.',
    },
    'this_person': {'en': 'This person', 'si': 'මෙම පුද්ගලයා', 'ta': 'இவர்'},
    'send_invitation': {'en': 'Send Invitation', 'si': 'ආරාධනාව යවන්න', 'ta': 'அழைப்பை அனுப்பு'},

    // ---- family assistance messages from code (I13) ----
    'err_full_name': {
      'en': 'Please enter their full name',
      'si': 'කරුණාකර ඔවුන්ගේ සම්පූර්ණ නම ඇතුළත් කරන්න',
      'ta': 'அவர்களின் முழுப் பெயரை உள்ளிடவும்',
    },
    'err_phone_required': {
      'en': 'Please enter a phone number',
      'si': 'කරුණාකර දුරකථන අංකයක් ඇතුළත් කරන්න',
      'ta': 'தொலைபேசி எண்ணை உள்ளிடவும்',
    },
    'err_phone_invalid': {
      'en': 'Enter a valid number, e.g. 077 123 4567',
      'si': 'වලංගු අංකයක් ඇතුළත් කරන්න, උදා: 077 123 4567',
      'ta': 'சரியான எண்ணை உள்ளிடவும், எ.கா. 077 123 4567',
    },
    'err_scope_none': {
      'en': 'Turn on at least one activity this person may help with',
      'si': 'මෙම පුද්ගලයාට උදව් කළ හැකි අවම වශයෙන් එක් කටයුත්තක් සක්‍රිය කරන්න',
      'ta': 'இவர் உதவக்கூடிய குறைந்தது ஒரு செயலையாவது இயக்கவும்',
    },
    'err_invite_send': {
      'en': 'The invitation could not be sent. Please try again.',
      'si': 'ආරාධනාව යැවිය නොහැකි විය. නැවත උත්සාහ කරන්න.',
      'ta': 'அழைப்பை அனுப்ப முடியவில்லை. மீண்டும் முயற்சிக்கவும்.',
    },
    'err_invite_create': {
      'en': 'Could not create an invitation. Please try again.',
      'si': 'ආරාධනාවක් සෑදිය නොහැකි විය. නැවත උත්සාහ කරන්න.',
      'ta': 'அழைப்பை உருவாக்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.',
    },
    'err_invite_cancel': {
      'en': 'The invitation could not be cancelled. Please try again.',
      'si': 'ආරාධනාව අවලංගු කළ නොහැකි විය. නැවත උත්සාහ කරන්න.',
      'ta': 'அழைப்பை ரத்துசெய்ய முடியவில்லை. மீண்டும் முயற்சிக்கவும்.',
    },
    'err_access_update': {
      'en': 'Access could not be updated. Please try again.',
      'si': 'ප්‍රවේශය යාවත්කාලීන කළ නොහැකි විය. නැවත උත්සාහ කරන්න.',
      'ta': 'அணுகலைப் புதுப்பிக்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.',
    },
    'err_access_revoke': {
      'en': 'Access could not be revoked. Please try again.',
      'si': 'ප්‍රවේශය ඉවත් කළ නොහැකි විය. නැවත උත්සාහ කරන්න.',
      'ta': 'அணுகலை நீக்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.',
    },
    'err_invite_accept': {
      'en': 'The invitation could not be accepted. Please try again.',
      'si': 'ආරාධනාව පිළිගත නොහැකි විය. නැවත උත්සාහ කරන්න.',
      'ta': 'அழைப்பை ஏற்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.',
    },
    'err_invite_mismatch': {
      'en': 'This code and phone number do not match a pending invitation. Check both with the artisan who invited you.',
      'si': 'මෙම කේතය සහ දුරකථන අංකය පොරොත්තු ආරාධනාවකට නොගැළපේ. ඔබට ආරාධනා කළ ශිල්පියා සමඟ දෙකම පරීක්ෂා කරන්න.',
      'ta': 'இந்தக் குறியீடும் தொலைபேசி எண்ணும் நிலுவையிலுள்ள அழைப்புடன் பொருந்தவில்லை. உங்களை அழைத்த கைவினைஞரிடம் இரண்டையும் சரிபார்க்கவும்.',
    },
    'err_invite_notfound': {
      'en': 'Invitation not found. Check the code.',
      'si': 'ආරාධනාව හමු නොවීය. කේතය පරීක්ෂා කරන්න.',
      'ta': 'அழைப்பு கிடைக்கவில்லை. குறியீட்டைச் சரிபார்க்கவும்.',
    },
    'err_invite_expired': {
      'en': 'This invitation has expired. Ask the artisan to send a new one.',
      'si': 'මෙම ආරාධනාව කල් ඉකුත් වී ඇත. නව එකක් එවන ලෙස ශිල්පියාගෙන් ඉල්ලන්න.',
      'ta': 'இந்த அழைப்பு காலாவதியானது. புதிய ஒன்றை அனுப்புமாறு கைவினைஞரிடம் கேளுங்கள்.',
    },
    'err_invite_own': {
      'en': 'You cannot accept your own invitation.',
      'si': 'ඔබට ඔබේම ආරාධනාව පිළිගත නොහැක.',
      'ta': 'உங்கள் சொந்த அழைப்பை ஏற்க முடியாது.',
    },
    'err_try_again': {'en': 'Please try again.', 'si': 'නැවත උත්සාහ කරන්න.', 'ta': 'மீண்டும் முயற்சிக்கவும்.'},

    // ---- invitation sent / support user details / revoked (I13) ----
    'inv_sent_title': {'en': 'Invitation sent', 'si': 'ආරාධනාව යවන ලදී', 'ta': 'அழைப்பு அனுப்பப்பட்டது'},
    'inv_sent_body': {
      'en': 'Send this code to {name} so they can join as your support user.',
      'si': '{name} ට ඔබේ සහායකයා ලෙස එක්වීමට මෙම කේතය යවන්න.',
      'ta': '{name} உங்கள் உதவியாளராகச் சேர இந்தக் குறியீட்டை அனுப்புங்கள்.',
    },
    'back_to_fa': {
      'en': 'Back to Family Assistance',
      'si': 'පවුලේ සහාය වෙත ආපසු',
      'ta': 'குடும்ப உதவிக்குத் திரும்பு',
    },
    'add_another_user': {
      'en': 'Add Another User',
      'si': 'තවත් අයෙක් එක් කරන්න',
      'ta': 'மற்றொருவரைச் சேர்',
    },
    'invite_code_title': {'en': 'Invitation code', 'si': 'ආරාධනා කේතය', 'ta': 'அழைப்புக் குறியீடு'},
    'valid_until': {'en': 'Valid until {date}', 'si': '{date} දක්වා වලංගුයි', 'ta': '{date} வரை செல்லும்'},
    'copy_invite': {
      'en': 'Copy invitation message',
      'si': 'ආරාධනා පණිවිඩය පිටපත් කරන්න',
      'ta': 'அழைப்புச் செய்தியை நகலெடு',
    },
    'invite_copied': {
      'en': 'Invitation copied. Paste it into WhatsApp or SMS.',
      'si': 'ආරාධනාව පිටපත් කළා. WhatsApp හෝ SMS එකට අලවන්න.',
      'ta': 'அழைப்பு நகலெடுக்கப்பட்டது. WhatsApp அல்லது SMS-இல் ஒட்டுங்கள்.',
    },
    'how_joins': {'en': 'How {name} joins:', 'si': '{name} එක්වන ආකාරය:', 'ta': '{name} எப்படிச் சேர்வது:'},
    'join_step1': {
      'en': 'Sign in to HASTHAKALA with their own account.',
      'si': 'තමන්ගේම ගිණුමෙන් HASTHAKALA වෙත පුරනය වන්න.',
      'ta': 'தங்கள் சொந்தக் கணக்கில் HASTHAKALA-வில் உள்நுழையவும்.',
    },
    'join_step2': {
      'en': 'Open {profile} > {accept}.',
      'si': '{profile} > {accept} විවෘත කරන්න.',
      'ta': '{profile} > {accept} என்பதைத் திறக்கவும்.',
    },
    'join_step3': {
      'en': 'Enter this code and the phone number {phone}.',
      'si': 'මෙම කේතය සහ {phone} දුරකථන අංකය ඇතුළත් කරන්න.',
      'ta': 'இந்தக் குறியீட்டையும் {phone} தொலைபேசி எண்ணையும் உள்ளிடவும்.',
    },
    'invite_message': {
      'en': 'Hi {name}, {artisan} invited you to help with their shop on HASTHAKALA. Sign in with your own account, go to {profile} > {accept}, and enter code {code} with your phone number {phone}. The code works until {date}.',
      'si': 'ආයුබෝවන් {name}, HASTHAKALA හි ඔවුන්ගේ වෙළඳසැලට උදව් කිරීමට {artisan} ඔබට ආරාධනා කර ඇත. ඔබේම ගිණුමෙන් පුරනය වී, {profile} > {accept} වෙත ගොස්, {code} කේතය සහ ඔබේ {phone} දුරකථන අංකය ඇතුළත් කරන්න. කේතය {date} දක්වා වලංගුයි.',
      'ta': 'வணக்கம் {name}, HASTHAKALA-வில் தங்கள் கடைக்கு உதவ {artisan} உங்களை அழைத்துள்ளார். உங்கள் சொந்தக் கணக்கில் உள்நுழைந்து, {profile} > {accept} சென்று, {code} குறியீட்டையும் உங்கள் {phone} தொலைபேசி எண்ணையும் உள்ளிடவும். குறியீடு {date} வரை செல்லும்.',
    },
    'details_title': {
      'en': 'Support User Details',
      'si': 'සහායක විස්තර',
      'ta': 'உதவியாளர் விவரங்கள்',
    },
    'details_note': {
      'en': 'Owner controls access. Sensitive account functions remain owner-only.',
      'si': 'ප්‍රවේශය පාලනය කරන්නේ හිමිකරුය. සංවේදී ගිණුම් කටයුතු හිමිකරුට පමණි.',
      'ta': 'அணுகலை உரிமையாளர் கட்டுப்படுத்துகிறார். முக்கியமான கணக்கு செயல்பாடுகள் உரிமையாளருக்கு மட்டும்.',
    },
    'details_unsaved': {
      'en': 'You have changed the access. Tap Update Access to save it.',
      'si': 'ඔබ ප්‍රවේශය වෙනස් කර ඇත. සුරැකීමට ප්‍රවේශය යාවත්කාලීන කරන්න ඔබන්න.',
      'ta': 'அணுகலை மாற்றியுள்ளீர்கள். சேமிக்க அணுகலைப் புதுப்பி என்பதைத் தட்டவும்.',
    },
    'update_access': {'en': 'Update Access', 'si': 'ප්‍රවේශය යාවත්කාලීන කරන්න', 'ta': 'அணுகலைப் புதுப்பி'},
    'revoke_access': {'en': 'Revoke Access', 'si': 'ප්‍රවේශය ඉවත් කරන්න', 'ta': 'அணுகலை நீக்கு'},
    'access_updated': {'en': 'Access updated', 'si': 'ප්‍රවේශය යාවත්කාලීන විය', 'ta': 'அணுகல் புதுப்பிக்கப்பட்டது'},
    'keep_one_on': {
      'en': 'Keep at least one activity on, or use Revoke Access instead.',
      'si': 'අවම වශයෙන් එක් කටයුත්තක් සක්‍රියව තබන්න, නැතහොත් ප්‍රවේශය ඉවත් කරන්න භාවිතා කරන්න.',
      'ta': 'குறைந்தது ஒரு செயலையாவது இயக்கத்தில் வைக்கவும், அல்லது அணுகலை நீக்கு என்பதைப் பயன்படுத்தவும்.',
    },
    'revoke_title': {'en': 'Revoke access?', 'si': 'ප්‍රවේශය ඉවත් කරන්නද?', 'ta': 'அணுகலை நீக்கவா?'},
    'revoke_body': {
      'en': "{name} will no longer be able to access {artisan}'s authorized business functions.",
      'si': '{name} ට තවදුරටත් {artisan} ගේ බලයලත් ව්‍යාපාර කටයුතුවලට ප්‍රවේශ විය නොහැක.',
      'ta': '{name} இனி {artisan} இன் அங்கீகரிக்கப்பட்ட வணிகச் செயல்பாடுகளை அணுக முடியாது.',
    },
    'revoked_title': {'en': 'Access revoked', 'si': 'ප්‍රවේශය ඉවත් කළා', 'ta': 'அணுகல் நீக்கப்பட்டது'},
    'revoked_body': {
      'en': "{name}'s support access has been removed.",
      'si': '{name} ගේ සහාය ප්‍රවේශය ඉවත් කර ඇත.',
      'ta': '{name} இன் உதவி அணுகல் நீக்கப்பட்டது.',
    },
    'revoked_hint': {
      'en': 'You can invite them again at any time from Family Assistance.',
      'si': 'පවුලේ සහාය හරහා ඕනෑම වේලාවක ඔවුන්ට නැවත ආරාධනා කළ හැක.',
      'ta': 'குடும்ப உதவியிலிருந்து எப்போது வேண்டுமானாலும் அவர்களை மீண்டும் அழைக்கலாம்.',
    },
    'status_revoked': {'en': 'Revoked', 'si': 'ඉවත් කළා', 'ta': 'நீக்கப்பட்டது'},

    // ---- supporter side (I13) ----
    'accept_intro': {
      'en': 'An artisan can invite you to help with their business. Ask them for the 6-digit invitation code and enter the phone number they used for you.',
      'si': 'ශිල්පියෙකුට ඔවුන්ගේ ව්‍යාපාරයට උදව් කිරීමට ඔබට ආරාධනා කළ හැක. ඉලක්කම් 6ක ආරාධනා කේතය ඔවුන්ගෙන් ලබාගෙන, ඔවුන් ඔබ සඳහා භාවිතා කළ දුරකථන අංකය ඇතුළත් කරන්න.',
      'ta': 'ஒரு கைவினைஞர் தங்கள் வணிகத்திற்கு உதவ உங்களை அழைக்கலாம். 6 இலக்க அழைப்புக் குறியீட்டை அவர்களிடம் கேட்டு, அவர்கள் உங்களுக்காகப் பயன்படுத்திய தொலைபேசி எண்ணை உள்ளிடவும்.',
    },
    'label_your_phone': {'en': 'Your phone number', 'si': 'ඔබේ දුරකථන අංකය', 'ta': 'உங்கள் தொலைபேசி எண்'},
    'label_invite_code': {'en': 'Invitation code', 'si': 'ආරාධනා කේතය', 'ta': 'அழைப்புக் குறியீடு'},
    'accept_invitation': {'en': 'Accept Invitation', 'si': 'ආරාධනාව පිළිගන්න', 'ta': 'அழைப்பை ஏற்கவும்'},
    'accept_note': {
      'en': 'You will keep your own account. You can only help in the areas the artisan allows, and they can change or remove this at any time.',
      'si': 'ඔබේම ගිණුම ඔබට තිබේ. ඔබට උදව් කළ හැක්කේ ශිල්පියා අවසර දෙන කටයුතුවලට පමණක් වන අතර, ඔවුන්ට එය ඕනෑම වේලාවක වෙනස් කිරීමට හෝ ඉවත් කිරීමට හැක.',
      'ta': 'உங்கள் சொந்தக் கணக்கு அப்படியே இருக்கும். கைவினைஞர் அனுமதிக்கும் பகுதிகளில் மட்டுமே நீங்கள் உதவ முடியும், அவர்கள் இதை எப்போது வேண்டுமானாலும் மாற்றலாம் அல்லது நீக்கலாம்.',
    },
    'now_supporting': {
      'en': 'You are now supporting {name}',
      'si': 'ඔබ දැන් {name} ට සහාය වේ',
      'ta': 'நீங்கள் இப்போது {name} க்கு உதவுகிறீர்கள்',
    },
    'can_help_with': {'en': 'You can help with:', 'si': 'ඔබට උදව් කළ හැකි දේ:', 'ta': 'நீங்கள் உதவக்கூடியவை:'},
    'choose_to_start': {
      'en': 'Choose "{ctx}" to start.',
      'si': 'ආරම්භ කිරීමට "{ctx}" තෝරන්න.',
      'ta': 'தொடங்க "{ctx}" என்பதைத் தேர்ந்தெடுக்கவும்.',
    },
    'err_code': {
      'en': 'Enter the 6-digit code',
      'si': 'ඉලක්කම් 6ක කේතය ඇතුළත් කරන්න',
      'ta': '6 இலக்கக் குறியீட்டை உள்ளிடவும்',
    },
    'hello_name': {'en': 'Hello {name}', 'si': 'ආයුබෝවන් {name}', 'ta': 'வணக்கம் {name}'},
    'supporting_label': {'en': 'SUPPORTING', 'si': 'සහාය දක්වන්නේ', 'ta': 'உதவுவது'},
    'sh_intro': {
      'en': 'You can help with the following authorized activities:',
      'si': 'ඔබට පහත බලයලත් කටයුතුවලට උදව් කළ හැක:',
      'ta': 'பின்வரும் அங்கீகரிக்கப்பட்ட செயல்களில் நீங்கள் உதவலாம்:',
    },
    'act_comm': {
      'en': 'Order Communication',
      'si': 'ඇණවුම් සන්නිවේදනය',
      'ta': 'ஆர்டர் தொடர்பு',
    },
    'act_comm_sub': {
      'en': 'Reply to customer queries related to authorized orders',
      'si': 'බලයලත් ඇණවුම් පිළිබඳ පාරිභෝගික විමසීම්වලට පිළිතුරු දෙන්න',
      'ta': 'அங்கீகரிக்கப்பட்ட ஆர்டர்கள் தொடர்பான வாடிக்கையாளர் கேள்விகளுக்குப் பதிலளிக்கவும்',
    },
    'act_account': {'en': 'Account settings', 'si': 'ගිණුම් සැකසුම්', 'ta': 'கணக்கு அமைப்புகள்'},
    'not_included': {
      'en': 'Not included in your access',
      'si': 'ඔබේ ප්‍රවේශයට ඇතුළත් නැත',
      'ta': 'உங்கள் அணுகலில் சேர்க்கப்படவில்லை',
    },
    'sh_note': {
      'en': 'Some account functions are not available in support mode.',
      'si': 'සහාය ආකාරයේදී සමහර ගිණුම් කටයුතු ලබාගත නොහැක.',
      'ta': 'உதவி முறையில் சில கணக்கு செயல்பாடுகள் கிடைக்காது.',
    },
    'signed_in_as': {'en': 'Signed in as {name}', 'si': '{name} ලෙස පුරනය වී ඇත', 'ta': '{name} ஆக உள்நுழைந்துள்ளீர்கள்'},
    'restricted_title': {
      'en': 'Not part of your support access',
      'si': 'මෙය ඔබේ සහාය ප්‍රවේශයට අයත් නැත',
      'ta': 'இது உங்கள் உதவி அணுகலில் இல்லை',
    },
    'restricted_body': {
      'en': 'Ask {artisan} to allow "{feature}" in Family Assistance if you need it.',
      'si': 'අවශ්‍ය නම්, පවුලේ සහාය තුළ "{feature}" සඳහා අවසර දෙන ලෙස {artisan} ගෙන් ඉල්ලන්න.',
      'ta': 'தேவைப்பட்டால், குடும்ப உதவியில் "{feature}" அனுமதிக்குமாறு {artisan} இடம் கேளுங்கள்.',
    },

    // ---- profile photo (I05) ----
    'photo_add': {'en': 'Add Photo', 'si': 'ඡායාරූපයක් එක් කරන්න', 'ta': 'படம் சேர்'},
    'photo_change': {'en': 'Change Photo', 'si': 'ඡායාරූපය වෙනස් කරන්න', 'ta': 'படத்தை மாற்று'},
    'photo_hint': {
      'en': 'Saved straight away. Shown on your profile.',
      'si': 'වහාම සුරැකේ. ඔබේ පැතිකඩේ පෙන්වයි.',
      'ta': 'உடனே சேமிக்கப்படும். உங்கள் சுயவிவரத்தில் காட்டப்படும்.',
    },
    'photo_sheet_title': {'en': 'Profile photo', 'si': 'පැතිකඩ ඡායාරූපය', 'ta': 'சுயவிவரப் படம்'},
    'photo_gallery': {'en': 'Choose from gallery', 'si': 'ගැලරියෙන් තෝරන්න', 'ta': 'கேலரியிலிருந்து தேர்ந்தெடு'},
    'photo_camera': {'en': 'Take a photo', 'si': 'ඡායාරූපයක් ගන්න', 'ta': 'படம் எடு'},
    'photo_remove': {'en': 'Remove photo', 'si': 'ඡායාරූපය ඉවත් කරන්න', 'ta': 'படத்தை நீக்கு'},
    'photo_uploading': {'en': 'Saving photo...', 'si': 'ඡායාරූපය සුරකිමින්...', 'ta': 'படம் சேமிக்கப்படுகிறது...'},
    'photo_saved': {'en': 'Photo updated', 'si': 'ඡායාරූපය යාවත්කාලීන විය', 'ta': 'படம் புதுப்பிக்கப்பட்டது'},
    'photo_removed': {'en': 'Photo removed', 'si': 'ඡායාරූපය ඉවත් කළා', 'ta': 'படம் நீக்கப்பட்டது'},
    'photo_offline': {
      'en': "You're offline. The photo will be saved when you're connected again.",
      'si': 'ඔබ නොබැඳි ය. නැවත සම්බන්ධ වූ විට ඡායාරූපය සුරැකේ.',
      'ta': 'நீங்கள் இணைப்பில் இல்லை. மீண்டும் இணைந்ததும் படம் சேமிக்கப்படும்.',
    },
    'photo_failed': {
      'en': "We couldn't save the photo. Please try again.",
      'si': 'ඡායාරූපය සුරැකීමට නොහැකි විය. නැවත උත්සාහ කරන්න.',
      'ta': 'படத்தைச் சேமிக்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.',
    },
    'photo_too_big': {
      'en': 'That photo is too large. Please choose another one.',
      'si': 'එම ඡායාරූපය විශාල වැඩියි. වෙනත් එකක් තෝරන්න.',
      'ta': 'அந்தப் படம் மிகப் பெரியது. வேறொன்றைத் தேர்ந்தெடுக்கவும்.',
    },

    // ---- bottom navigation ----
    'nav_home': {'en': 'Home', 'si': 'මුල් පිටුව', 'ta': 'முகப்பு'},
    'nav_search': {'en': 'Search', 'si': 'සොයන්න', 'ta': 'தேடல்'},
    'nav_orders': {'en': 'Orders', 'si': 'ඇණවුම්', 'ta': 'ஆர்டர்கள்'},
    'nav_products': {'en': 'Products', 'si': 'නිෂ්පාදන', 'ta': 'தயாரிப்புகள்'},
    'nav_profile': {'en': 'Profile', 'si': 'ප්‍රොෆයිල්', 'ta': 'சுயவிவரம்'},
  };

  // English messages from validators / Firebase - key, so they can be shown
  // in the chosen language without changing where they come from
  static const Map<String, String> messageKeys = {
    'Enter the 6-digit code': 'err_code',
    'Manage products': 'perm_products',
    'Manage orders': 'perm_orders',
    'Please enter their full name': 'err_full_name',
    'Please enter a phone number': 'err_phone_required',
    'Enter a valid number, e.g. 077 123 4567': 'err_phone_invalid',
    'Turn on at least one activity this person may help with': 'err_scope_none',
    'The invitation could not be sent. Please try again.': 'err_invite_send',
    'Could not create an invitation. Please try again.': 'err_invite_create',
    'The invitation could not be cancelled. Please try again.': 'err_invite_cancel',
    'Access could not be updated. Please try again.': 'err_access_update',
    'Access could not be revoked. Please try again.': 'err_access_revoke',
    'The invitation could not be accepted. Please try again.': 'err_invite_accept',
    'This code and phone number do not match a pending invitation. Check both with the artisan who invited you.': 'err_invite_mismatch',
    'Invitation not found. Check the code.': 'err_invite_notfound',
    'This invitation has expired. Ask the artisan to send a new one.': 'err_invite_expired',
    'You cannot accept your own invitation.': 'err_invite_own',
    'Please try again.': 'err_try_again',
    'Artisan name is required.': 'err_artisan_name',
    'Please select a craft type.': 'err_craft_type',
    'Please write a short description (10+ characters).': 'err_about_short',
    'Please enter your location.': 'err_location',
    'We could not save your choice. Check your connection and try again.': 'err_save_choice',
    'We could not send the reset link. Please try again.': 'err_reset_failed',
    'Please enter your full name': 'err_name_required',
    'Passwords do not match': 'err_password_mismatch',
    'Email address is required': 'err_email_required',
    'Enter a valid email address': 'err_email_invalid',
    'Please enter a valid email address.': 'err_email_invalid',
    'Password is required': 'err_password_required',
    'Password must be at least 6 characters': 'err_password_short',
    'Password must be at least 6 characters.': 'err_password_short',
    'Email or password is incorrect. Please try again.': 'err_wrong_login',
    'An account already exists with this email. Try signing in instead.': 'err_email_in_use',
    'No internet connection. Check your connection and try again.': 'err_offline',
    'Too many attempts. Please wait a moment and try again.': 'err_too_many',
    'This account has been disabled. Please contact support.': 'err_disabled',
    'Something went wrong. Please try again.': 'err_generic',
    'We could not create your account. Please try again.': 'err_create_account',
    'We could not load your account. Check your connection and try again.': 'err_load_account',
  };

  static String get(String key, String lang) {
    final entry = values[key];
    if (entry == null)
      return key; // shows the key so missing text is easy to spot
    return entry[lang] ?? entry['en'] ?? key;
  }
}
