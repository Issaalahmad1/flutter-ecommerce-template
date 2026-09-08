# decoze_core

The shared package behind the `decoze` monorepo — everything the `customer_app` and `admin_app` have in common lives here, so data access and domain logic are written **once** and consumed by both. See the [root README](../../README.md) for the full project overview and setup guide.

## What's in here

```
lib/
├── entities/           # Domain models (Product, Category, Order, User, Banner, Review, ...)
├── repositories/        # Abstract repository contracts
├── repositories_impl/   # Concrete Firestore / Storage / Firebase AI implementations
├── datasources/          # Low-level Firestore/Storage/Auth data sources
├── localization/         # AppStrings (Arabic/English) + the localization delegate
├── theme/                # BrandConfig and AppTheme
├── widgets/              # Shared UI widgets used by both apps
├── utils/                # Shared helpers
└── config/               # Per-project credentials not covered by `flutterfire configure`
                           # (app_config.dart is git-ignored; see app_config.example.dart)
```

## Usage

Both apps depend on this package as a local path dependency:

```yaml
dependencies:
  decoze_core:
    path: ../../packages/core
```

There's no independent versioning or publishing story — it's an internal workspace package, not published to pub.dev.
