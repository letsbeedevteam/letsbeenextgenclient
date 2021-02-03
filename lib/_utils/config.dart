class Config {

  // Base URLs
  // static const BASE_URL = 'http://192.168.100.14:8000';
  // static const BASE_URL = 'https://serene-caverns-10194.herokuapp.com'; 
  static const BASE_URL = 'https://quiet-meadow-89567.herokuapp.com';

  static const CUSTOMER_NAMESPACE = '/customer';

  // Routes
  static const SPLASH_ROUTE = '/splash';
  static const AUTH_ROUTE = '/auth';
  static const SIGNUP_ROUTE = '/signup';
  static const SETUP_LOCATION_ROUTE = '/setup_location';
  static const MAP_ROUTE = '/map';
  static const VERIFY_NUMBER_ROUTE = '/verify_number';
  static const DASHBOARD_ROUTE = '/dashboard';
  static const CART_ROUTE = '/cart';
  static const RESTAURANT_ROUTE = '/restaurant';
  static const MENU_ROUTE = '/menu';
  static const REVIEW_DETAIL_ROUTE = '/review_detail';
  static const WEBVIEW_ROUTE = '/webview';
  static const CHAT_ROUTE = '/chat';
  static const RIDER_LOCATION_ROUTE = '/rider_location';
  static const HISTORY_DETAIL_ROUTE = '/history_detail';
  static const ACTIVE_ORDER_DETAIL_ROUTE = '/active_order_detail';
  static const ACTIVE_ORDER_ROUTE = '/active_order';

  // Storage keys
  static const USER_ID = 'user_id';
  static const USER_NAME = 'user_name';
  static const USER_EMAIL = 'user_email';
  static const USER_TOKEN = 'user_token';
  static const USER_MOBILE_NUMBER = 'user_mobile_number';
  static const USER_CURRENT_NAME_OF_LOCATION = 'user_current_name_of_location';
  static const USER_CURRENT_LATITUDE = 'user_latitude';
  static const USER_CURRENT_LONGITUDE = 'user_longitude'; 
  static const USER_CURRENT_ADDRESS = 'user_current_address';
  static const USER_CURRENT_STREET = 'user_current_street';
  static const USER_CURRENT_COUNTRY = 'user_current_country';
  static const USER_CURRENT_STATE = 'user_current_state';
  static const USER_CURRENT_CITY = 'user_current_city';
  static const USER_CURRENT_IS_CODE = 'user_current_iso_code';
  static const USER_CURRENT_BARANGAY = 'user_current_barangay';


  static const LETSBEE_STORAGE = 'LetsBeeStorage';
  static const SOCIAL_LOGIN_TYPE = 'social_login_type';

  static const IS_SETUP_LOCATION = 'is_setup_location';
  static const IS_VERIFY_NUMBER = 'is_verify_number';
  static const IS_LOGGED_IN = 'is_logged_in';

  // Paths
  static const JSONS_PATH = 'assets/jsons/';
  static const SVG_PATH = 'assets/svg/';
  static const PNG_PATH = 'assets/png/';
  static const GIF_PATH = 'assets/gifs/';

  // Error message
  static const NO_INTERNET_CONNECTION = 'No internet connection';
  static const SOMETHING_WENT_WRONG = 'Something went wrong. Please try again';
  static const TIMED_OUT = 'Operation timed out. Please try again';
  static const TOKEN_EXPIRED = 'Token Expired!';

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
  static const SETUP_ADDRESS = 'setup_address';

  // Colors 
  static const LETSBEE_COLOR = 0xFBD10B;
  static const WHITE = 0xD8DFE3;
}