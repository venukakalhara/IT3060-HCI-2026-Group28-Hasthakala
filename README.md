# Hasthakala (හස්තකලා) - Artisan & Handicraft Marketplace

> **IT3060 - Human-Computer Interaction (HCI) - Group 28**  
> A mobile marketplace platform empowering traditional Sri Lankan artisans to showcase, preserve, and sell authentic cultural handicrafts directly to local and international craft enthusiasts.

---

## Team Members & Feature Ownership

| # | Feature Scope | Git Feature Branch | Assigned Member | Directory Path |
|---|---|---|---|---|
| **1** | **Buyer Discovery** (Home, Search, Filter, Product Details, Public Artisan Profile) | `feature/buyer-discovery` | **JAYAWARDANA V. K. A.** | `lib/features/discovery/` |
| **2** | **Buyer Purchase & Orders** (Cart, Checkout, Order Tracking, Buyer Chat) | `feature/buyer-purchase` | **DISSANAYAKE D. M. S. D.** | `lib/features/purchase/` |
| **3** | **Artisan Management** (Artisan Dashboard, Product CRUD, Order Fulfillment, Artisan Chat) | `feature/artisan-management` | **KUMARI R. P. G. D.** | `lib/features/artisan/` |
| **4** | **Account & Family Support** (Firebase Auth, Profile Management, Family Assisted Permissions) | `feature/account-support` | **WANIGATHUNGA Y. J.** | `lib/features/account/` |

---

## ▶️ Run the app

**Download the app:** the Android APK is attached to the latest GitHub Release (or the link in the report). Install it on an Android phone (allow "install unknown apps").

**Build from source**

What you need: Flutter 3.47.x (Dart 3.13), Android Studio with an Android emulator that has Google Play, and Git.

```bash
git clone https://github.com/venukakalhara/IT3060-HCI-2026-Group28-Hasthakala.git
cd IT3060-HCI-2026-Group28-Hasthakala
git checkout developer
flutter pub get
flutter run                      # with the emulator or a phone connected
```

Release APK: `flutter build apk --release` -> `build/app/outputs/flutter-apk/app-release.apk`

Checks: `flutter analyze` and `flutter test`

The Firebase config (`android/app/google-services.json`) is in the repo, so the app connects to our Firebase project (`hasthakala-group28`) without extra setup. Google sign-in works in the release APK and on laptops whose SHA-1 is added in Firebase; email sign-in works everywhere.

**Test accounts** (test data only, password `Test@1234`)

| Account | Use it as |
|---|---|
| `nadeesha.test@hasthakala.lk` | Artisan (Nadeesha Silva) - choose Artisan or Buyer on "Continue as" |
| `kavindu2.test@hasthakala.lk` | Buyer (Kavindu) |

You can also create your own account from the app (Create Account, then Shop or Sell).

**Languages:** English, Sinhala and Tamil - picked on first launch, changed later in Profile > Language.

---

## Architecture Overview: Feature-First Clean Pattern

The project is structured under **Feature-First Architecture** to completely isolate each team member's workspace and prevent merge conflicts across branches:

```text
lib/
├── app.dart                   # MaterialApp, MultiProvider & Theme root
├── main.dart                  # App entrypoint & Service Locator initialization
│
├── config/                    # Global app configuration
│   ├── routes/                # Route strings & generator
│   └── service_locator.dart   # Firebase service instances
│
├── core/                      # Shared code across all 4 features
│   ├── constants/             # AppColors, Typography, FirestoreCollections
│   ├── theme/                 # Light/Dark Material 3 ThemeData
│   ├── services/              # FirebaseAuth, Firestore, Storage helpers
│   ├── errors/                # App Exceptions & Failures
│   ├── utils/                 # CurrencyFormatter (LKR), DateTime, Validators
│   ├── widgets/               # CustomButton, CustomTextField, LoadingIndicator
│   └── shared_models/         # Canonical schemas (Product, Order, User, Chat)
│
└── features/                  # 1-to-1 branch mapping
    ├── discovery/             # JAYAWARDANA V. K. A. (feature/buyer-discovery)
    ├── purchase/              # DISSANAYAKE D. M. S. D. (feature/buyer-purchase)
    ├── artisan/               # KUMARI R. P. G. D. (feature/artisan-management)
    └── account/               # WANIGATHUNGA Y. J. (feature/account-support)
```

---

## Git Branching Workflow for Team Members

### 1. Initial Setup on `developer` branch
Ensure you are on the updated `developer` branch:
```bash
git checkout developer
git pull origin developer
```

### 2. Creating your Feature Branch
Each member creates their designated branch from `developer`:
```bash
# Member 1 
git checkout -b feature/buyer-discovery

# Member 2 
git checkout -b feature/buyer-purchase

# Member 3 
git checkout -b feature/artisan-management

# Member 4 
git checkout -b feature/account-support
```

### 3. Syncing with `developer` before Submitting a Pull Request
Before submitting a PR to merge back into `developer`, always pull the latest changes from `developer` to resolve conflicts locally:
```bash
git checkout feature/<your-feature-name>
git fetch origin
git merge origin/developer
git push origin feature/<your-feature-name>
```

---

## Firebase Setup & Collections Reference

Collection names live in `lib/core/constants/firestore_collections.dart`; the full structure is in `docs/FIREBASE_SCHEMA.md`.
- `users` (with `users/{uid}/cart`): accounts, language, saved address, cart
- `artisanProfiles`, `profilePhotos`: artisan profiles and small profile photos
- `products`: crafts listed by artisans
- `orders`: one order per artisan, with status history
- `conversations` (with `messages`): order chats between buyer and artisan
- `reviews`: product reviews
- `supportInvites`, `supportGrants`: family supporter invitations and permissions

Security rules are in `firestore.rules` (v2.2): people can only read and change their own data, artisans their own shop, and supporters only what the artisan allowed. Deploy with `firebase deploy --only firestore:rules --project hasthakala-group28`.

More project notes: `docs/DECISIONS.md`, `docs/DEVIATIONS.md`, `docs/TRANSLATION.md`, `docs/PURCHASE_NOTES.md`.
