# Hasthakala (හස්තකලා) - Artisan & Handicraft Marketplace

> **IT3060 - Human-Computer Interaction (HCI) - Group 28**  
> A mobile marketplace platform empowering traditional Sri Lankan artisans to showcase, preserve, and sell authentic cultural handicrafts directly to local and international craft enthusiasts.

---

## 🏛 Team Members & Feature Ownership

| # | Feature Scope | Git Feature Branch | Assigned Member | Directory Path |
|---|---|---|---|---|
| **1** | **Buyer Discovery** (Home, Search, Filter, Product Details, Public Artisan Profile) | `feature/buyer-discovery` | **JAYAWARDANA V. K. A.** | `lib/features/discovery/` |
| **2** | **Buyer Purchase & Orders** (Cart, Checkout, Order Tracking, Buyer Chat) | `feature/buyer-purchase` | **DISSANAYAKE D. M. S. D.** | `lib/features/purchase/` |
| **3** | **Artisan Management** (Artisan Dashboard, Product CRUD, Order Fulfillment, Artisan Chat) | `feature/artisan-management` | **KUMARI R. P. G. D.** | `lib/features/artisan/` |
| **4** | **Account & Family Support** (Firebase Auth, Profile Management, Family Assisted Permissions) | `feature/account-support` | **WANIGATHUNGA Y. J.** | `lib/features/account/` |

---

## 🏗 Architecture Overview: Feature-First Clean Pattern

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

## 🚀 Git Branching Workflow for Team Members

### 1. Initial Setup on `developer` branch
Ensure you are on the updated `developer` branch:
```bash
git checkout developer
git pull origin developer
```

### 2. Creating your Feature Branch
Each member creates their designated branch from `developer`:
```bash
# Member 1 (JAYAWARDANA V. K. A.)
git checkout -b feature/buyer-discovery

# Member 2 (DISSANAYAKE D. M. S. D.)
git checkout -b feature/buyer-purchase

# Member 3 (KUMARI R. P. G. D.)
git checkout -b feature/artisan-management

# Member 4 (WANIGATHUNGA Y. J.)
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

## 🔥 Firebase Setup & Collections Reference

All Firestore collection names are standardized inside `lib/core/constants/firestore_collections.dart`:
- `users`: User profiles (Buyers, Artisans, Admins)
- `products`: Handicraft items created by artisans
- `orders`: Purchase orders created by buyers
- `chats`: Direct buyer-artisan communication channels
- `family_permissions`: Delegated helper permissions for elderly artisans
