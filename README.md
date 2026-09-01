# decoze — Flutter E-commerce Template

A production-quality, full-stack e-commerce starter kit built with **Flutter**, **Firebase**, and **Clean Architecture** — a customer-facing mobile app and a web-based admin dashboard that share a single codebase.

> This repository is a **template**, not a live store. `decoze` is the example brand shown throughout — every screen, entity, and Firebase collection is generic enough to rebrand for clothing, furniture, electronics, a hotel/room catalog, or any other product-based business. See [Use as your own template](#use-as-your-own-template) below. Nothing in this repo is wired to any specific person's Firebase project or API keys — every credential is supplied by whoever sets it up, following the steps below.

## Tech Stack

- **Flutter** (mobile + web) — single monorepo, two apps
- **Firebase** — Authentication (Email/Password, Google, X/Twitter), Cloud Firestore, Cloud Storage, App Check
- **Firebase AI Logic (Gemini)** — semantic product search and on-demand UI/content translation
- **Bloc/Cubit** — state management, consistent across every feature
- **go_router** — declarative routing with auth-based redirects
- **Melos** — monorepo workspace management (Dart native workspaces)

## Features

**Customer app**
- Onboarding, email/password auth, Google and X (Twitter) sign-in (auto-fills name + photo from the provider, with an Edit Profile screen for the rest)
- AI-powered product search (Gemini) — understands intent/synonyms, not just literal substring matches — plus a filter sheet (price range, category, subcategory, color)
- Full Arabic/English localization with RTL/LTR-aware layout, and on-demand AI translation of product name/description (translated once, then cached back to Firestore — same idea as Instagram's "See Translation")
- Home feed: featured products, a horizontally-scrolling "Top selling" row, a "Discover" grid of the full catalog, and admin-managed promotional banners with expiry dates — loads instantly from a local cache with a silent background refresh
- Product browsing by category/subcategory, product detail with an image gallery, optional per-product color
- Real-time cart and favourites, both optimistic (instant local UI, background Firestore sync, debounced so rapid taps don't fight each other)
- Structured, multi-field address book (own Firestore subcollection) used at checkout
- Checkout → shipping method → payment method (mock) → order tracking, order history

**Admin dashboard** (Flutter Web)
- Role-gated authentication — only accounts with `role: "admin"` on their Firestore user doc can sign in
- Live revenue/orders/product stats
- Full CRUD for products and categories, with image upload to Cloud Storage, primary-image selection, and an interactive multi-image gallery
- Promotional banner management (image upload, expiry date/time)
- Order management with inline status updates

## Architecture

Clean Architecture, feature-first, with a shared `core` package:

```
decoze/
├── packages/
│   └── core/                  # Shared entities, repository contracts + implementations, theming
│       └── lib/
│           ├── entities/
│           ├── repositories/          # abstract contracts
│           ├── repositories_impl/     # concrete Firestore/Storage/AI implementations (shared)
│           ├── datasources/
│           ├── localization/          # AppStrings (ar/en) + delegate
│           ├── config/                # per-project credentials not covered by flutterfire configure
│           └── theme/                 # BrandConfig + AppTheme
│
├── firebase/                  # starter Firestore/Storage security rules (paste into your own project)
│
├── apps/
│   ├── customer_app/          # Mobile app — the customer-facing storefront
│   │   └── lib/features/{onboarding, auth, home, category, product, search, cart, checkout, order, favourite, address, profile, settings}/
│   │
│   └── admin_app/             # Flutter Web — the admin dashboard
│       └── lib/features/{auth, dashboard, products, categories, banners, orders}/
```

Both apps depend on `packages/core` as a local path dependency, so every Firestore query, entity, and repository implementation is written **once** and shared. There is zero duplication of data-access code between the two apps.

Each feature inside `customer_app`/`admin_app` follows the same three-layer split where applicable:

```
feature/
├── presentation/   # screens, widgets, cubit (Bloc)
├── domain/         # (lives in core) entities, repository contracts
└── data/           # (lives in core) repository implementations, datasources
```

## Getting Started

### Prerequisites

- Flutter SDK (stable channel)
- A Google account and a **Firebase project on the Blaze (pay-as-you-go) plan** — required for Firebase AI Logic (Gemini). Blaze still has a free monthly quota; you won't be charged unless you exceed it.
- [Firebase CLI](https://firebase.google.com/docs/cli) (`npm install -g firebase-tools`, then `firebase login`)
- [FlutterFire CLI](https://firebase.google.com/docs/flutter/setup) (`dart pub global activate flutterfire_cli`)

### 1. Clone and get packages

```bash
git clone https://github.com/Issaalahmad1/flutter-ecommerce-template.git
cd flutter-ecommerce-template

# Root workspace uses native Dart pub workspaces (Dart 3.6+)
dart pub get
```

### 2. Create your own Firebase project

In the [Firebase Console](https://console.firebase.google.com/):

1. Create a new project (or use an existing one) and put it on the **Blaze plan**.
2. **Authentication** → Sign-in method → enable:
   - **Email/Password**
   - **Google** — Firebase auto-generates a Web OAuth client for you here (needed in step 4).
   - **X (Twitter)** — you'll need a Twitter/X Developer app; enter its API Key and API Secret Key in this provider's settings. No app code changes are needed — Firebase handles the OAuth flow.
3. **Firestore Database** → create a database (production mode is fine — you'll paste in rules in step 6).
4. **Storage** → create a default bucket.
5. **App Check** → register the apps once you've connected them in step 3 (Debug provider for local development, Play Integrity/App Attest for release — already wired up in `main.dart`, nothing to code).
6. **Build → Firebase AI Logic** → enable it and pick **Gemini Developer API** (or Vertex AI, either works) so `firebase_ai` can call Gemini.

### 3. Connect the apps

```bash
cd apps/customer_app
flutterfire configure     # pick the project you just created; select all platforms you need

cd ../admin_app
flutterfire configure     # select the SAME Firebase project
```

This generates `lib/firebase_options.dart` and platform config files (`google-services.json`, `GoogleService-Info.plist`) in each app — these are git-ignored on purpose since they're specific to your project.

### 4. Google Sign-In client ID

```bash
cp packages/core/lib/config/app_config.example.dart packages/core/lib/config/app_config.dart
```

Open the new `app_config.dart` and set `googleSignInServerClientId` to your **Web client ID**: Firebase Console → Authentication → Sign-in method → Google → Web SDK configuration (or Google Cloud Console → APIs & Services → Credentials, the OAuth 2.0 Client ID of type "Web application"). This file is git-ignored, so your ID never gets committed.

### 5. App Check debug tokens (local development only)

The first time you run the app in debug mode, it'll print a debug token in the console (`adb logcat` on Android, or the Xcode/run console on iOS). Copy it into Firebase Console → App Check → your app → Manage debug tokens. Without this, App Check will reject requests (including AI search/translation) from your dev device.

### 6. Firestore & Storage security rules

Copy the contents of [`firebase/firestore.rules`](firebase/firestore.rules) and [`firebase/storage.rules`](firebase/storage.rules) into Firebase Console → Firestore Database → Rules, and Storage → Rules, respectively (or deploy them with the Firebase CLI if you prefer). They match this template's data model out of the box — review them before going to production with real user data.

### 7. Create your first admin account

Sign up normally through the customer app (or admin app), then in Firestore Console open that user's document under `users/{uid}` and add a field `role` (string) = `admin`. That account can now sign into the admin dashboard.

### 8. Run the apps

```bash
# Customer app (mobile)
cd apps/customer_app
flutter run

# Admin dashboard (web)
cd apps/admin_app
flutter run -d chrome
```

### Running tests

```bash
cd apps/customer_app
flutter test
```

## Use as your own template

This isn't specific to "decoze" or even to general retail — `ProductEntity` is just a name, description, price, images, a category/subcategory, and an *optional* color, so it maps cleanly onto clothing, furniture, electronics, rooms/amenities for a hotel, or any other catalog of things people browse and buy.

1. Fork or clone this repository and follow **Getting Started** above with your own Firebase project.
2. Edit `packages/core/lib/theme/brand_config.dart` — add your own `BrandConfig` (app name, colors, logo path) instead of `BrandConfig.decoze`, and point both apps' `main.dart` to it.
3. Rename the Android/iOS/web app identifiers (application ID / bundle ID, display name, launcher icon) in each app's platform folders to your own.
4. Replace the placeholder product/category/banner images with your own (upload through the admin dashboard once it's running — no code changes needed for catalog content).
5. `packages/core/lib/localization/app_strings.dart` holds every UI string in Arabic and English; add a new `AppStrings` subclass for another language, or edit the existing ones to match your brand's tone/vertical (e.g. "products" → "rooms").
6. Categories and subcategories are freeform strings you create from the admin dashboard — there's no hardcoded list to change in code.

The entity models, repository contracts, and UI are otherwise brand- and vertical-agnostic.

## Requirements

- Flutter SDK, stable channel
- A Firebase project on the Blaze plan (for Firebase AI Logic / Gemini)
- Android Studio / Xcode for building to a device, or Chrome for the admin web app

## Support

This is a template repository — see the setup steps above for configuration help. For bugs or questions specific to your fork, open an issue against your own copy.

## License

See [LICENSE](LICENSE). If you're distributing this template commercially (e.g. via a marketplace), replace this section and the LICENSE file with the terms that fit that distribution channel before publishing.
