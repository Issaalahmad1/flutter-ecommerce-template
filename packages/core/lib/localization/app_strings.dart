/// كل نصوص واجهة التطبيق (مش محتوى المنتجات — ده منفصل وليه آلية
/// ترجمة خاصة بيه، راجع ProductTranslationService). أي نص جديد يتضاف
/// هنا في الـ interface، وبعدين في النسختين العربي والإنجليزي تحت.
abstract class AppStrings {
  // شريط التنقل السفلي
  String get navHome;
  String get navCategory;
  String get navCart;
  String get navProfile;

  // الصفحة الرئيسية
  String get topSelling;
  String get topRated;
  String get discover;
  String get recommendedForYou;
  String get offLabel;
  String get endsTomorrow;
  String endsInDays(int days);

  // شاشة الترحيب
  String get welcomeTo;
  String get welcomeTagline;
  String get getStarted;

  // شاشة الـ Onboarding (السلايدات بعد الترحيب)
  String get onboardingTitle1;
  String get onboardingDescription1;
  String get onboardingTitle2;
  String get onboardingDescription2;
  String get onboardingTitle3;
  String get onboardingDescription3;
  String get next;
  String get skip;

  // البحث
  String get search;
  String get searchHint;
  String get topSearches;
  List<String> get topSearchSuggestions;
  String get noResultsForFilter;
  String noResultsFor(String query);

  // نافذة الفلترة
  String get filterTitle;
  String get priceRange;
  String get upTo;
  String get filterCategories;
  String get filterProducts;
  String get filterColors;
  String get apply;

  // اللغة
  String get languageTitle;
  String get languageArabic;
  String get languageEnglish;

  // ترجمة المحتوى (أسماء وأوصاف المنتجات)
  String get seeTranslation;
  String get showOriginal;
  String get translating;

  // السلة والدفع
  String get cartTitle;
  String get checkOut;
  String get emptyCart;
  String get subtotal;
  String get discount;
  String get taxAndFees;
  String get delivery;
  String get total;
  String get checkoutTitle;
  String get shippingAddress;
  String get chooseShippingType;
  String get orderList;
  String get payment;
  String get shippingEconomical;
  String get shippingExpress;
  String get arrivalEconomical;
  String get arrivalExpress;
  String get paymentMethodTitle;
  String get paypal;
  String get cashMoney;
  String get selectPaymentMethod;
  String get paymentMethodsTitle;
  String get addNewMethod;
  String get paymentComingSoon;
  String get paymentSuccessful;
  String get paymentSuccessDescription;

  // الأمان والإشعارات
  String get securityTitle;
  String get rememberMe;
  String get biometricId;
  String get googleAuthenticator;
  String get changePin;
  String get changePassword;
  String get notificationsTitle;
  String get notifGeneral;
  String get notifSound;
  String get notifSoundCall;
  String get notifVibrate;
  String get notifSpecialOffers;
  String get notifPayments;
  String get notifPromo;
  String get notifCashback;

  // المفضلة والطلبات والحساب
  String get favouriteTitle;
  String get emptyFavourites;
  String get profileTitle;
  String get confirmLogout;
  String get cancel;
  String get logout;
  String get ordersTitle;
  String get noOrders;
  String get trackOrder;
  String get backToHome;
  String get estimatedDelivery;
  String hoursLabel(int hours);

  // تفاصيل المنتج
  String get addToCart;
  String get addedToCart;
  String get userReviews;
  String reviewsCount(int count);
  String get noReviewsYet;
  String get seeAll;
  String get writeReview;
  String get yourRating;
  String get reviewCommentHint;
  String get submitReview;
  String get reviewSubmitted;
  String get pleaseSelectRating;
  String get signInToReview;
  String get editReview;
  String get deleteReview;
  String get confirmDeleteReview;
  String get reviewUpdated;
  String get reviewDeleted;

  // مركز الإشعارات
  String get noNotificationsYet;
  String get notifNewOrderTitle;
  String notifNewOrderBody(String customerName, String amount);
  String get notifOrderStatusTitle;
  String notifOrderStatusBody(String orderId, String status);

  // تسجيل الدخول والتسجيل
  String get signIn;
  String get signUp;
  String get orContinueWith;
  String get alreadyHaveAccount;
  String get emailHint;
  String get passwordHint;
  String get confirmPasswordHint;
  String loginTo(String appName);
  String createAccountTitle(String appName);
  String get emailRequired;
  String get emailInvalid;
  String get passwordTooShort;
  String get passwordsDontMatch;
  String get dontHaveAccount;

  // الفئات
  String get categoriesTitle;
  String get noProductsInCategory;

  // تعديل البروفايل
  String get editProfileTitle;
  String get firstNameHint;
  String get lastNameHint;
  String get dateOfBirthHint;
  String get phoneNumberHint;
  String get genderHint;
  String get male;
  String get female;
  String get continueLabel;
  String get profileUpdated;
  String get fieldRequired;

  // العناوين
  String get addressesTitle;
  String get addAddress;
  String get editAddress;
  String get deleteAddress;
  String get setAsDefault;
  String get defaultLabel;
  String get addressLabelHint;
  String get fullNameHint;
  String get countryHint;
  String get cityHint;
  String get areaHint;
  String get streetHint;
  String get buildingNumberHint;
  String get floorHint;
  String get apartmentHint;
  String get landmarkHint;
  String get noAddressesYet;
  String get addressSaved;
  String get confirmDeleteAddress;
  String get selectAddress;
  String get addAddressToContinue;
}

class AppStringsAr implements AppStrings {
  const AppStringsAr();

  @override
  String get navHome => 'الرئيسية';
  @override
  String get navCategory => 'الفئات';
  @override
  String get navCart => 'السلة';
  @override
  String get navProfile => 'حسابي';

  @override
  String get topSelling => 'الأكثر مبيعًا';
  @override
  String get topRated => 'الأعلى تقييمًا';
  @override
  String get discover => 'اكتشف';
  @override
  String get recommendedForYou => 'مقترح لك';
  @override
  String get offLabel => 'خصم';
  @override
  String get endsTomorrow => 'ينتهي غدًا';
  @override
  String endsInDays(int days) => 'ينتهي خلال $days أيام';

  @override
  String get welcomeTo => 'مرحبًا بك في';
  @override
  String get welcomeTagline => 'صمّم مساحتك وتسوّق كل احتياجات الديكور';
  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get onboardingTitle1 => 'نظّم ديكورك وتسوّقك بكل سهولة مع decoze';
  @override
  String get onboardingDescription1 =>
      'تنقّل بثقة في رحلة تصميم منزلك، ووصولك لمساحة أحلامك بأسلوب عملي وأنيق مع decoze';
  @override
  String get onboardingTitle2 => 'ابقَ على تواصل مع فريق التصميم في أي وقت ومن أي مكان';
  @override
  String get onboardingDescription2 =>
      'في عالم الديكور المتغيّر باستمرار، التواصل مع فريق التصميم هو سر نجاحك مع decoze';
  @override
  String get onboardingTitle3 => 'اكتشف كل المزايا اللي بيقدّمها decoze';
  @override
  String get onboardingDescription3 =>
      'استكشف مجموعة مزايا decoze المتنوعة واستفد منها لأقصى درجة';
  @override
  String get next => 'التالي';
  @override
  String get skip => 'تخطي';

  @override
  String get search => 'البحث';
  @override
  String get searchHint => 'اسأل عن أي حاجة... مثلاً: أثاث غرفة نوم رخيص';
  @override
  String get topSearches => 'كلمات بحث شائعة';
  @override
  List<String> get topSearchSuggestions =>
      const ['سرير', 'لمبة', 'نباتات صناعية', 'سجاد', 'كنب', 'كراسي زرقاء'];
  @override
  String get noResultsForFilter => 'مفيش نتايج مطابقة للفلتر';
  @override
  String noResultsFor(String query) => 'مفيش نتايج لـ "$query"';

  @override
  String get filterTitle => 'الفلترة';
  @override
  String get priceRange => 'نطاق السعر';
  @override
  String get upTo => 'حتى';
  @override
  String get filterCategories => 'الفئات';
  @override
  String get filterProducts => 'المنتجات';
  @override
  String get filterColors => 'الألوان';
  @override
  String get apply => 'تطبيق';

  @override
  String get languageTitle => 'اللغة';
  @override
  String get languageArabic => 'العربية';
  @override
  String get languageEnglish => 'English';

  @override
  String get seeTranslation => 'ترجمة';
  @override
  String get showOriginal => 'عرض النص الأصلي';
  @override
  String get translating => 'جاري الترجمة...';

  @override
  String get cartTitle => 'سلة التسوق';
  @override
  String get checkOut => 'إتمام الشراء';
  @override
  String get emptyCart => 'السلة فاضية.';
  @override
  String get subtotal => 'الإجمالي الفرعي';
  @override
  String get discount => 'الخصم';
  @override
  String get taxAndFees => 'الضرائب والرسوم';
  @override
  String get delivery => 'التوصيل';
  @override
  String get total => 'الإجمالي';
  @override
  String get checkoutTitle => 'الدفع';
  @override
  String get shippingAddress => 'عنوان الشحن';
  @override
  String get chooseShippingType => 'اختر نوع الشحن';
  @override
  String get orderList => 'قائمة الطلب';
  @override
  String get payment => 'الدفع';
  @override
  String get shippingEconomical => 'اقتصادي';
  @override
  String get shippingExpress => 'سريع';
  @override
  String get arrivalEconomical => 'الوصول المتوقع: 5-7 أيام';
  @override
  String get arrivalExpress => 'الوصول المتوقع: 1-2 يوم';
  @override
  String get paymentMethodTitle => 'طريقة الدفع';
  @override
  String get paypal => 'PayPal';
  @override
  String get cashMoney => 'الدفع نقدًا';
  @override
  String get selectPaymentMethod => 'اختر طريقة الدفع اللي عايز تستخدمها.';
  @override
  String get paymentMethodsTitle => 'طرق الدفع';
  @override
  String get addNewMethod => 'إضافة طريقة جديدة';
  @override
  String get paymentComingSoon => 'هتتفعّل مع بوابة دفع حقيقية لاحقًا.';
  @override
  String get paymentSuccessful => 'تم بنجاح!';
  @override
  String get paymentSuccessDescription => 'تم الدفع بنجاح لعملية الشراء بتاعتك.';

  @override
  String get securityTitle => 'الأمان';
  @override
  String get rememberMe => 'تذكرني';
  @override
  String get biometricId => 'بصمة الدخول';
  @override
  String get googleAuthenticator => 'Google Authenticator';
  @override
  String get changePin => 'تغيير الرقم السري';
  @override
  String get changePassword => 'تغيير كلمة المرور';
  @override
  String get notificationsTitle => 'الإشعارات';
  @override
  String get notifGeneral => 'الإشعارات العامة';
  @override
  String get notifSound => 'الصوت';
  @override
  String get notifSoundCall => 'صوت المكالمات';
  @override
  String get notifVibrate => 'الاهتزاز';
  @override
  String get notifSpecialOffers => 'عروض خاصة';
  @override
  String get notifPayments => 'المدفوعات';
  @override
  String get notifPromo => 'العروض والخصومات';
  @override
  String get notifCashback => 'الكاش باك';

  @override
  String get favouriteTitle => 'المفضلة';
  @override
  String get emptyFavourites => 'قائمة المفضلة\nفاضية';
  @override
  String get profileTitle => 'حسابي';
  @override
  String get confirmLogout => 'متأكد إنك عايز تسجّل خروج؟';
  @override
  String get cancel => 'إلغاء';
  @override
  String get logout => 'تسجيل خروج';
  @override
  String get ordersTitle => 'الطلبات';
  @override
  String get noOrders => 'لا توجد طلبات سابقة.';
  @override
  String get trackOrder => 'تتبع الطلب';
  @override
  String get backToHome => 'العودة للرئيسية';
  @override
  String get estimatedDelivery => 'الوصول المتوقع';
  @override
  String hoursLabel(int hours) => '$hours ساعة';

  @override
  String get addToCart => 'أضف إلى السلة';
  @override
  String get addedToCart => 'تمت الإضافة إلى السلة.';
  @override
  String get userReviews => 'تقييمات المستخدمين';
  @override
  String reviewsCount(int count) => '+$count تقييم';
  @override
  String get noReviewsYet => 'لا توجد تقييمات بعد.';
  @override
  String get seeAll => 'عرض الكل';
  @override
  String get writeReview => 'اكتب تقييمًا';
  @override
  String get yourRating => 'تقييمك';
  @override
  String get reviewCommentHint => 'شاركنا رأيك في المنتج...';
  @override
  String get submitReview => 'إرسال التقييم';
  @override
  String get reviewSubmitted => 'تم إرسال تقييمك بنجاح.';
  @override
  String get pleaseSelectRating => 'من فضلك اختر تقييمًا أولًا.';
  @override
  String get signInToReview => 'سجّل الدخول لإضافة تقييم.';
  @override
  String get editReview => 'تعديل التقييم';
  @override
  String get deleteReview => 'حذف التقييم';
  @override
  String get confirmDeleteReview => 'متأكد إنك عايز تحذف تقييمك؟';
  @override
  String get reviewUpdated => 'تم تحديث تقييمك.';
  @override
  String get reviewDeleted => 'تم حذف تقييمك.';

  @override
  String get noNotificationsYet => 'لا توجد إشعارات حتى الآن.';
  @override
  String get notifNewOrderTitle => 'طلب جديد';
  @override
  String notifNewOrderBody(String customerName, String amount) =>
      'طلب جديد من $customerName — $amount';
  @override
  String get notifOrderStatusTitle => 'تحديث على طلبك';
  @override
  String notifOrderStatusBody(String orderId, String status) =>
      'طلبك #${orderId.substring(0, orderId.length < 6 ? orderId.length : 6)} بقى: $status';

  @override
  String get signIn => 'تسجيل الدخول';
  @override
  String get signUp => 'إنشاء حساب';
  @override
  String get orContinueWith => 'أو تابع باستخدام';
  @override
  String get alreadyHaveAccount => 'عندك حساب بالفعل؟ سجّل دخول';
  @override
  String get emailHint => 'البريد الإلكتروني';
  @override
  String get passwordHint => 'كلمة المرور';
  @override
  String get confirmPasswordHint => 'تأكيد كلمة المرور';
  @override
  String loginTo(String appName) => 'تسجيل الدخول لـ $appName';
  @override
  String createAccountTitle(String appName) => 'أنشئ حسابك في\n$appName';
  @override
  String get emailRequired => 'من فضلك أدخل البريد الإلكتروني';
  @override
  String get emailInvalid => 'صيغة البريد الإلكتروني غير صحيحة';
  @override
  String get passwordTooShort => 'كلمة المرور لازم تكون 6 أحرف على الأقل';
  @override
  String get passwordsDontMatch => 'كلمة المرور غير متطابقة';
  @override
  String get dontHaveAccount => 'معندكش حساب؟ إنشاء حساب';

  @override
  String get categoriesTitle => 'الفئات';
  @override
  String get noProductsInCategory => 'لا توجد منتجات في هذا القسم.';

  @override
  String get editProfileTitle => 'تعديل الملف الشخصي';
  @override
  String get firstNameHint => 'الاسم الأول';
  @override
  String get lastNameHint => 'اسم العائلة';
  @override
  String get dateOfBirthHint => 'تاريخ الميلاد';
  @override
  String get phoneNumberHint => 'رقم الهاتف';
  @override
  String get genderHint => 'النوع';
  @override
  String get male => 'ذكر';
  @override
  String get female => 'أنثى';
  @override
  String get continueLabel => 'متابعة';
  @override
  String get profileUpdated => 'تم تحديث الملف الشخصي.';
  @override
  String get fieldRequired => 'الحقل ده مطلوب.';

  @override
  String get addressesTitle => 'العناوين';
  @override
  String get addAddress => 'إضافة عنوان جديد';
  @override
  String get editAddress => 'تعديل العنوان';
  @override
  String get deleteAddress => 'حذف العنوان';
  @override
  String get setAsDefault => 'تعيين كافتراضي';
  @override
  String get defaultLabel => 'افتراضي';
  @override
  String get addressLabelHint => 'اسم العنوان (المنزل، العمل...)';
  @override
  String get fullNameHint => 'الاسم الكامل لاستلام الطلب';
  @override
  String get countryHint => 'الدولة';
  @override
  String get cityHint => 'المدينة';
  @override
  String get areaHint => 'الحي / المنطقة';
  @override
  String get streetHint => 'الشارع';
  @override
  String get buildingNumberHint => 'رقم المبنى';
  @override
  String get floorHint => 'الدور (اختياري)';
  @override
  String get apartmentHint => 'رقم الشقة (اختياري)';
  @override
  String get landmarkHint => 'علامة مميزة قريبة (اختياري)';
  @override
  String get noAddressesYet => 'لسه مفيش عناوين محفوظة.';
  @override
  String get addressSaved => 'تم حفظ العنوان.';
  @override
  String get confirmDeleteAddress => 'متأكد إنك عايز تحذف العنوان ده؟';
  @override
  String get selectAddress => 'اختر عنوان الشحن';
  @override
  String get addAddressToContinue => 'أضف عنوان شحن عشان تكمل الطلب.';
}

class AppStringsEn implements AppStrings {
  const AppStringsEn();

  @override
  String get navHome => 'Home';
  @override
  String get navCategory => 'Category';
  @override
  String get navCart => 'Cart';
  @override
  String get navProfile => 'Profile';

  @override
  String get topSelling => 'Top selling';
  @override
  String get topRated => 'Top Rated';
  @override
  String get discover => 'Discover';
  @override
  String get recommendedForYou => 'Recommended for you';
  @override
  String get offLabel => 'off';
  @override
  String get endsTomorrow => 'Ends tomorrow';
  @override
  String endsInDays(int days) => 'Ends in $days days';

  @override
  String get welcomeTo => 'Welcome to';
  @override
  String get welcomeTagline => 'Style your spaces & shop for all your decor needs';
  @override
  String get getStarted => 'Get Started';

  @override
  String get onboardingTitle1 => 'Effortlessly organize your decor and shopping with decoze';
  @override
  String get onboardingDescription1 =>
      'Confidently navigate your decor journey, ensuring a stylish and productive path to your dream space with decoze';
  @override
  String get onboardingTitle2 => 'Stay connected with your design team anytime, anywhere';
  @override
  String get onboardingDescription2 =>
      "In today's dynamic decor world, staying connected with your design team is key to success with decoze.";
  @override
  String get onboardingTitle3 => 'Discover all the features decoze has to offer';
  @override
  String get onboardingDescription3 =>
      "Dive into decoze's multitude of features by exploring its diverse functionalities.";
  @override
  String get next => 'Next';
  @override
  String get skip => 'Skip';

  @override
  String get search => 'Search';
  @override
  String get searchHint => 'Ask for anything... e.g. cheap bedroom furniture';
  @override
  String get topSearches => 'Top Searches';
  @override
  List<String> get topSearchSuggestions =>
      const ['Bed', 'Lamp', 'Plastic Plants', 'Carpet', 'Sofa', 'Blue Chairs'];
  @override
  String get noResultsForFilter => 'No results match this filter';
  @override
  String noResultsFor(String query) => 'No results for "$query"';

  @override
  String get filterTitle => 'Filter';
  @override
  String get priceRange => 'Price Range';
  @override
  String get upTo => 'Up to';
  @override
  String get filterCategories => 'Categories';
  @override
  String get filterProducts => 'Products';
  @override
  String get filterColors => 'Colors';
  @override
  String get apply => 'Apply';

  @override
  String get languageTitle => 'Language';
  @override
  String get languageArabic => 'العربية';
  @override
  String get languageEnglish => 'English';

  @override
  String get seeTranslation => 'See translation';
  @override
  String get showOriginal => 'Show original';
  @override
  String get translating => 'Translating...';

  @override
  String get cartTitle => 'My Cart';
  @override
  String get checkOut => 'Check Out';
  @override
  String get emptyCart => 'Your cart is empty.';
  @override
  String get subtotal => 'Subtotal';
  @override
  String get discount => 'Discount';
  @override
  String get taxAndFees => 'Tax and Fees';
  @override
  String get delivery => 'Delivery';
  @override
  String get total => 'Total';
  @override
  String get checkoutTitle => 'Checkout';
  @override
  String get shippingAddress => 'Shipping Address';
  @override
  String get chooseShippingType => 'Choose Shipping Type';
  @override
  String get orderList => 'Order List';
  @override
  String get payment => 'Payment';
  @override
  String get shippingEconomical => 'Economical';
  @override
  String get shippingExpress => 'Express';
  @override
  String get arrivalEconomical => 'Estimated arrival: 5-7 days';
  @override
  String get arrivalExpress => 'Estimated arrival: 1-2 days';
  @override
  String get paymentMethodTitle => 'Payment Method';
  @override
  String get paypal => 'PayPal';
  @override
  String get cashMoney => 'Cash Money';
  @override
  String get selectPaymentMethod => 'Select the payment method you want to use.';
  @override
  String get paymentMethodsTitle => 'Payments Methods';
  @override
  String get addNewMethod => 'Add New Method';
  @override
  String get paymentComingSoon => 'Will be enabled with a real payment gateway later.';
  @override
  String get paymentSuccessful => 'Successful!';
  @override
  String get paymentSuccessDescription => 'Payment successful for your purchase.';

  @override
  String get securityTitle => 'Security';
  @override
  String get rememberMe => 'Remember me';
  @override
  String get biometricId => 'Biometric ID';
  @override
  String get googleAuthenticator => 'Google Authenticator';
  @override
  String get changePin => 'Change PIN';
  @override
  String get changePassword => 'Change Password';
  @override
  String get notificationsTitle => 'Notifications';
  @override
  String get notifGeneral => 'General Notification';
  @override
  String get notifSound => 'Sound';
  @override
  String get notifSoundCall => 'Sound Call';
  @override
  String get notifVibrate => 'Vibrate';
  @override
  String get notifSpecialOffers => 'Special Offers';
  @override
  String get notifPayments => 'Payments';
  @override
  String get notifPromo => 'Promo and discount';
  @override
  String get notifCashback => 'Cashback';

  @override
  String get favouriteTitle => 'Favourite';
  @override
  String get emptyFavourites => 'Your favourite list\nis empty';
  @override
  String get profileTitle => 'Profile';
  @override
  String get confirmLogout => 'Are you sure you want to log out?';
  @override
  String get cancel => 'Cancel';
  @override
  String get logout => 'Logout';
  @override
  String get ordersTitle => 'Orders';
  @override
  String get noOrders => 'No previous orders.';
  @override
  String get trackOrder => 'Track Order';
  @override
  String get backToHome => 'Back To Home';
  @override
  String get estimatedDelivery => 'Estimated Delivery';
  @override
  String hoursLabel(int hours) => '$hours Hours';

  @override
  String get addToCart => 'Add To Cart';
  @override
  String get addedToCart => 'Added to cart.';
  @override
  String get userReviews => 'User Reviews';
  @override
  String reviewsCount(int count) => '$count+ Reviews';
  @override
  String get noReviewsYet => 'No reviews yet.';
  @override
  String get seeAll => 'See all';
  @override
  String get writeReview => 'Write a Review';
  @override
  String get yourRating => 'Your Rating';
  @override
  String get reviewCommentHint => 'Share your thoughts about this product...';
  @override
  String get submitReview => 'Submit Review';
  @override
  String get reviewSubmitted => 'Your review has been submitted.';
  @override
  String get pleaseSelectRating => 'Please select a rating first.';
  @override
  String get signInToReview => 'Sign in to write a review.';
  @override
  String get editReview => 'Edit Review';
  @override
  String get deleteReview => 'Delete Review';
  @override
  String get confirmDeleteReview => 'Are you sure you want to delete your review?';
  @override
  String get reviewUpdated => 'Your review has been updated.';
  @override
  String get reviewDeleted => 'Your review has been deleted.';

  @override
  String get noNotificationsYet => 'No notifications yet.';
  @override
  String get notifNewOrderTitle => 'New order';
  @override
  String notifNewOrderBody(String customerName, String amount) =>
      'New order from $customerName — $amount';
  @override
  String get notifOrderStatusTitle => 'Update on your order';
  @override
  String notifOrderStatusBody(String orderId, String status) =>
      'Order #${orderId.substring(0, orderId.length < 6 ? orderId.length : 6)} is now: $status';

  @override
  String get signIn => 'Sign in';
  @override
  String get signUp => 'Sign up';
  @override
  String get orContinueWith => 'or continue with';
  @override
  String get alreadyHaveAccount => 'Already have an account? Sign in';
  @override
  String get emailHint => 'Email';
  @override
  String get passwordHint => 'Password';
  @override
  String get confirmPasswordHint => 'Confirm password';
  @override
  String loginTo(String appName) => 'Login to $appName';
  @override
  String createAccountTitle(String appName) => 'Create your \n$appName account';
  @override
  String get emailRequired => 'Please enter your email';
  @override
  String get emailInvalid => 'Invalid email format';
  @override
  String get passwordTooShort => 'Password must be at least 6 characters';
  @override
  String get passwordsDontMatch => "Passwords don't match";
  @override
  String get dontHaveAccount => "Don't have an account? Sign up";

  @override
  String get categoriesTitle => 'Categories';
  @override
  String get noProductsInCategory => 'No products in this category.';

  @override
  String get editProfileTitle => 'Edit Profile';
  @override
  String get firstNameHint => 'First Name';
  @override
  String get lastNameHint => 'Last Name';
  @override
  String get dateOfBirthHint => 'Date of Birth';
  @override
  String get phoneNumberHint => 'Phone Number';
  @override
  String get genderHint => 'Gender';
  @override
  String get male => 'Male';
  @override
  String get female => 'Female';
  @override
  String get continueLabel => 'Continue';
  @override
  String get profileUpdated => 'Profile updated.';
  @override
  String get fieldRequired => 'This field is required.';

  @override
  String get addressesTitle => 'Addresses';
  @override
  String get addAddress => 'Add New Address';
  @override
  String get editAddress => 'Edit Address';
  @override
  String get deleteAddress => 'Delete Address';
  @override
  String get setAsDefault => 'Set as Default';
  @override
  String get defaultLabel => 'Default';
  @override
  String get addressLabelHint => 'Address label (Home, Work...)';
  @override
  String get fullNameHint => 'Full name for delivery';
  @override
  String get countryHint => 'Country';
  @override
  String get cityHint => 'City';
  @override
  String get areaHint => 'Area / District';
  @override
  String get streetHint => 'Street';
  @override
  String get buildingNumberHint => 'Building Number';
  @override
  String get floorHint => 'Floor (optional)';
  @override
  String get apartmentHint => 'Apartment (optional)';
  @override
  String get landmarkHint => 'Nearby landmark (optional)';
  @override
  String get noAddressesYet => 'No saved addresses yet.';
  @override
  String get addressSaved => 'Address saved.';
  @override
  String get confirmDeleteAddress => 'Are you sure you want to delete this address?';
  @override
  String get selectAddress => 'Select shipping address';
  @override
  String get addAddressToContinue => 'Add a shipping address to continue.';
}
