
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

// Repository contracts
export 'repositories/product_repository.dart';
export 'repositories/category_repository.dart';
export 'repositories/auth_repository.dart';
export 'repositories/cart_repository.dart';
export 'repositories/order_repository.dart';
export 'repositories/favourite_repository.dart';
// Data sources (للاستخدام في الاختبارات بشكل أساسي)
export 'datasources/auth_remote_datasource.dart';
export 'datasources/category_remote_datasource.dart';
export 'datasources/product_remote_datasource.dart';
export 'datasources/cart_remote_datasource.dart';
export 'datasources/order_remote_datasource.dart';
export 'datasources/favourite_remote_datasource.dart';

// Repository implementations — التنفيذ الفعلي المشترك بين customer_app وadmin_app
export 'repositories_impl/auth_repository_impl.dart';
export 'repositories_impl/category_repository_impl.dart';
export 'repositories_impl/product_repository_impl.dart';
export 'repositories_impl/cart_repository_impl.dart';
export 'repositories_impl/order_repository_impl.dart';
export 'repositories_impl/favourite_repository_impl.dart';