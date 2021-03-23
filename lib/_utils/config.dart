class Config {

  // Base URLs
  static const BASE_URL = 'http://192.168.0.100:8000'; // develop
  // static const BASE_URL = 'http://18.166.234.218:8080'; // staging

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
  static const USER_PASSWORD = 'user_password';
  static const USER_TOKEN = 'user_token';
  static const USER_MOBILE_NUMBER = 'user_mobile_number';
  static const USER_CURRENT_NAME_OF_LOCATION = 'user_current_name_of_location';
  static const USER_CURRENT_LATITUDE = 'user_latitude';
  static const USER_CURRENT_LONGITUDE = 'user_longitude'; 
  static const USER_CURRENT_ADDRESS = 'user_current_address';
  static const IS_REMEMBER_ME = 'is_remember_me';
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
  static const OK = 'OK';
  static const NOT_FOUND = 'NOT_FOUND';
  static const INVALID = 'INVALID';
  static const UNAUTHORIZED = 'UNAUTHORIZED';

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
  static const LETSBEE_COLOR = 0xFFF5D247;
  static const WHITE = 0xFFF5F5F5;
  static const RED = 0xFFDE5842;
  static const SEARCH_TEXT_COLOR = 0xFF999999;
  static const USER_CURRENT_ADDRESS_TEXT_COLOR = 0xFF666666;
  static const YELLOW_TEXT_COLOR = 0xFFD9BB64;
  static const GREY_TEXT_COLOR = 0xFF666666;
}