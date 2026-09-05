
// Theme
export 'theme/brand_config.dart';
export 'theme/app_theme.dart';

// Entities
export 'entities/product_entity.dart';
export 'entities/category_entity.dart';
export 'entities/user_entity.dart';
export 'entities/address_entity.dart';
export 'entities/order_entity.dart';
export 'entities/cart_item_entity.dart';
export 'entities/review_entity.dart';
export 'entities/notification_entity.dart';

// Repository contracts
export 'repositories/product_repository.dart';
export 'repositories/category_repository.dart';
export 'repositories/auth_repository.dart';
export 'repositories/cart_repository.dart';
export 'repositories/order_repository.dart';
export 'repositories/favourite_repository.dart';
export 'repositories/address_repository.dart';
export 'repositories/notification_repository.dart';
export 'repositories/recently_viewed_repository.dart';
// Data sources (للاستخدام في الاختبارات بشكل أساسي)
export 'datasources/auth_remote_datasource.dart';
export 'datasources/category_remote_datasource.dart';
export 'datasources/product_remote_datasource.dart';
export 'datasources/cart_remote_datasource.dart';
export 'datasources/order_remote_datasource.dart';
export 'datasources/favourite_remote_datasource.dart';
export 'datasources/address_remote_datasource.dart';
export 'datasources/notification_remote_datasource.dart';
export 'datasources/recently_viewed_remote_datasource.dart';

// Repository implementations — التنفيذ الفعلي المشترك بين customer_app وadmin_app
export 'repositories_impl/auth_repository_impl.dart';
export 'repositories_impl/category_repository_impl.dart';
export 'repositories_impl/product_repository_impl.dart';
export 'repositories_impl/cart_repository_impl.dart';
export 'repositories_impl/order_repository_impl.dart';
export 'repositories_impl/favourite_repository_impl.dart';
export 'repositories_impl/address_repository_impl.dart';
export 'repositories_impl/notification_repository_impl.dart';
export 'repositories_impl/recently_viewed_repository_impl.dart';

export 'entities/banner_entity.dart';
export 'repositories/banner_repository.dart';
export 'datasources/banner_remote_datasource.dart';
export 'repositories_impl/banner_repository_impl.dart';
export 'repositories/storage_repository.dart';
export 'repositories_impl/storage_repository_impl.dart';

export 'entities/onboarding_slide_entity.dart';
export 'repositories/onboarding_slide_repository.dart';
export 'datasources/onboarding_slide_remote_datasource.dart';
export 'repositories_impl/onboarding_slide_repository_impl.dart';

export 'utils/discount_calculator.dart';
export 'utils/category_icon_library.dart';
export 'utils/product_color_palette.dart';
export 'utils/recommendation_engine.dart';
export 'utils/responsive.dart';
export 'widgets/responsive_content.dart';

export 'repositories/search_repository.dart';
export 'repositories_impl/search_repository_impl.dart';
export 'repositories_impl/product_translation_service.dart';

// Localization
export 'localization/app_strings.dart';
export 'localization/app_strings_delegate.dart';