# decoze — Flutter E-commerce Template

A production-quality, full-stack e-commerce starter kit built with **Flutter**, **Firebase**, and **Clean Architecture** — featuring a customer-facing mobile app and a web-based admin dashboard that share a single codebase.

> This repository is designed to be used as a **template**. `decoze` is the example brand used throughout — swap it for your own in minutes (see [Use as your own template](#use-as-your-own-template) below).

## Tech Stack

- **Flutter** (mobile + web) — single monorepo, two apps
- **Firebase** — Authentication, Cloud Firestore, Storage
- **Bloc/Cubit** — state management, consistent across every feature
- **go_router** — declarative routing with auth-based redirects
- **Melos** — monorepo workspace management (Dart native workspaces)

## Architecture

Clean Architecture, feature-first, with a shared `core` package:

```
decoze/
├── packages/
│   └── core/                  # Shared entities, repository contracts + implementations, theming
│       └── lib/
│           ├── entities/
│           ├── repositories/          # abstract contracts
│           ├── repositories_impl/     # concrete Firestore implementations (shared)
│           ├── datasources/
│           └── theme/                 # BrandConfig + AppTheme
│
├── apps/
│   ├── customer_app/          # Mobile app — the customer-facing storefront
│   │   └── lib/features/{onboarding, auth, home, category, product, cart, checkout, order, favourite, profile, settings}/
│   │
│   └── admin_app/             # Flutter Web — the admin dashboard
│       └── lib/features/{auth, dashboard, products, categories, orders}/
```

Both apps depend on `packages/core` as a local path dependency, so every Firestore query, entity, and repository implementation is written **once** and shared. There is zero duplication of data-access code between the two apps.

Each feature inside `customer_app`/`admin_app` follows the same three-layer split where applicable:

```
feature/
├── presentation/   # screens, widgets, cubit (Bloc)
├── domain/         # (lives in core) entities, repository contracts
└── data/           # (lives in core) repository implementations, datasources
```

## Features

**Customer app**
- Onboarding, email/password authentication, profile setup
- Product browsing by category, subcategory filtering, search
- Real-time shopping cart with Firestore transactions (race-condition safe)
- Checkout → mock payment → order tracking
- Favourites, order history, account settings

**Admin dashboard**
- Role-gated authentication (only accounts with `role: admin` can sign in)
- Live revenue / orders / product stats
- Full CRUD for products and categories
- Order management with inline status updates

## Getting Started

### Prerequisites
- Flutter SDK (stable channel)
- A Firebase project (Firestore + Authentication enabled)
- [FlutterFire CLI](https://firebase.google.com/docs/flutter/setup)

### Setup

```bash
git clone https://github.com/Issaalahmad1/flutter-ecommerce-template.git
cd flutter-ecommerce-template

# Root workspace uses native Dart pub workspaces (Dart 3.6+)
dart pub get
```

Connect each app to your own Firebase project:

```bash
cd apps/customer_app
flutterfire configure

cd ../admin_app
flutterfire configure   # select the same Firebase project
```

Run either app:

```bash
# Customer app (mobile)
cd apps/customer_app
flutter run

# Admin dashboard (web)
cd apps/admin_app
flutter run -d chrome
```

To grant a user admin access, set `role: "admin"` on their document in the `users` collection in Firestore Console.

### Running tests

```bash
cd apps/customer_app
flutter test
```

## Use as your own template

1. Fork or clone this repository.
2. Edit `packages/core/lib/theme/brand_config.dart` — add your own `BrandConfig` (app name, colors, logo path) instead of `BrandConfig.decoze`.
3. Point `customer_app`'s and `admin_app`'s `main.dart` to your new `BrandConfig`.
4. Replace the placeholder product images with your own (or your own royalty-free source).
5. Run `flutterfire configure` against your own Firebase project.

That's it — the entity models, repository contracts, and UI are all brand-agnostic.

## Live demo

_Coming soon — currently runnable locally via the steps above._

## License

MIT — free to use for personal or commercial projects.