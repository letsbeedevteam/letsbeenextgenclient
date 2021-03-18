class Config {

  // Base URLs
  // static const BASE_URL = 'https://quiet-meadow-89567.herokuapp.com'; // develop
  static const BASE_URL = 'http://18.166.234.218:8000'; // staging

  static const CUSTOMER_NAMESPACE = '/customer';

  // Routes
  static const SPLASH_ROUTE = '/splash';
  static const AUTH_ROUTE = '/auth';
  static const SIGNUP_ROUTE = '/signup';
  static const MAP_ROUTE = '/map';
  static const VERIFY_NUMBER_ROUTE = '/verify_number';
  static const DASHBOARD_ROUTE = '/dashboard';
  static const CART_ROUTE = '/cart';
  static const RESTAURANT_ROUTE = '/restaurant';
  static const WEBVIEW_ROUTE = '/webview';
  static const CHAT_ROUTE = '/chat';
  static const RIDER_LOCATION_ROUTE = '/rider_location';
  static const HISTORY_ROUTE = '/history';
  static const HISTORY_DETAIL_ROUTE = '/history_detail';
  static const ACTIVE_ORDER_ROUTE = '/active_order';
  static const MART_ROUTE = '/mart';
  static const MART_CART_ROUTE = '/mart_cart';
  static const ADDRESS_ROUTE = '/address';
  static const USER_DETAILS_ROUTE = '/user_details';
  static const ACCOUNT_INFO_ROUTE = '/account_info';
  static const CHANGE_PASS_ROUTE = '/change_pass';
  static const FORGOT_PASS_ROUTE = '/forgot_pass';

  // Storage keys
  static const USER_ID = 'user_id';
  static const USER_ADDRESS_ID = 'user_address_id';
  static const USER_NAME = 'user_name';
  static const USER_EMAIL = 'user_email';
  static const USER_TOKEN = 'user_token';
  static const USER_MOBILE_NUMBER = 'user_mobile_number';
  static const USER_CURRENT_NAME_OF_LOCATION = 'user_current_name_of_location';
  static const USER_CURRENT_LATITUDE = 'user_latitude';
  static const USER_CURRENT_LONGITUDE = 'user_longitude'; 
  static const USER_CURRENT_ADDRESS = 'user_current_address';
  static const NOTE_TO_RIDER = 'note_to_rider';
  static const PRODUCTS = 'products';
  static const LANGUAGE = 'language';
  static const SEARCH_HISTORY = 'search_history';


  static const LETSBEE_STORAGE = 'LetsBeeStorage';
  static const SOCIAL_LOGIN_TYPE = 'social_login_type';

  // static const IS_SETUP_LOCATION = 'is_setup_location';
  // static const IS_VERIFY_NUMBER = 'is_verify_number';
  static const IS_LOGGED_IN = 'is_logged_in';

  // Paths
  static const JSONS_PATH = 'assets/jsons/';
  static const TRANSLATION_PATH = 'assets/translations';
  static const SVG_PATH = 'assets/svg/';
  static const PNG_PATH = 'assets/png/';
  static const GIF_PATH = 'assets/gifs/';

  // Error message
  // static final noInternetConnection = tr('noInternetConnection');
  // static final somethingWentWrong = tr('somethingWentWrong');
  // static final timedOut = tr('timedOut');
  // static final tokenExpired = tr('tokenExpired');
  // static final oops = tr('oops');
  // static final inputFields = tr('inputFields');
  // static final signInFailed = tr('signInFailed');
  // static final accountNotExist = tr('accountNotExist');
  // static final emailInvalid = tr('emailInvalid');
  // static final incorrectRepeatPassword = tr('incorrectRepeatPassword');
  // static final registeredSuccess = tr('registeredSuccess');
  // static final yay = tr('yay');
  // static final invalidCode = tr('invalidCode');
  // static final inputAddressDetail = tr('inputAddressDetail');
  // static final home = tr('home');
  // static final searchLocation = tr('searchLocation');
  // static final requiredChoice = tr('requiredChoice');
  // static final deletedItem = tr('deletedItem');
  // static final minimumTransaction = tr('minimumTransaction');
  // static final storeClosed = tr('storeClosed');
  // static final successOrder = tr('successOrder');
  // static final updatedItem = tr('updatedItem');
  // static final accountInfoUpdated = tr('accountInfoUpdated');
  // static final emptyOrderHistory = tr('emptyOrderHistory');
  // static final connected = tr('connected');
  // static final disconnected = tr('disconnected');
  // static final connecting = tr('connecting');
  // static final reconnecting = tr('reconnecting');
  // static final notSent = tr('notSent');
  // static final messageEmpty = tr('messageEmpty');
  // static final noMessages = tr('noMessages');
  // static final loadingConversation = tr('loadingConversation');
  // static final loadingMap = tr('loadingMap');
  // static final trackingRider = tr('trackingRider');
  // static final yourRider = tr('yourRider');
  // static final you = tr('you');
  // static final enterYourNumber = tr('enterYourNumber');
  // static final invalidNumber = tr('invalidNumber');
  // static final resendCodeSuccess = tr('resendCodeSuccess');
  // static final inputSearchField = tr('inputSearchField');
  // static final addedSuccessfully = tr('addedSuccessfully');
  // static final updatedSuccessfully = tr('updatedSuccessfully');

  // Google error code
  static const NETWORK_ERROR = 'network_error';

  // Names 
  static const FACEBOOK = 'Facebook';
  static const GOOGLE = 'Google';
  static const KAKAO = 'Kakao';
  static const APPLE = 'Apple';
  static const EMAIL = 'Email';
  static const CUSTOMER_PIN = 'customer_pin';
  static const YOU = 'You';
  static const LETS_BEE = 'Let\'s Bee';
  static const ADD_NEW_ADDRESS = 'add_new_address';
  static const EDIT_NEW_ADDRESS = 'edit_new_address';
  static const SETUP_ADDRESS = 'setup_address';
  static const NEXT_DAY = 'next_day';
  static const RESTAURANT = 'restaurant';
  static const MART = 'mart';

  // Colors 
  static const LETSBEE_COLOR = 0xFFFCD000;
  static const WHITE = 0xFFF8F8FA;
  static const RED = 0xFFDE5842;
  static const SEARCH_TEXT_COLOR = 0xFF999999;
  static const USER_CURRENT_ADDRESS_TEXT_COLOR = 0xFF666666;
  static const YELLOW_TEXT_COLOR = 0xFFD9BB64;
  static const GREY_TEXT_COLOR = 0xFF666666;
}