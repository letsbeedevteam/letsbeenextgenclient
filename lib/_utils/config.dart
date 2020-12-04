class Config {

  // Base URLs
  static const BASE_URL = 'http://192.168.0.2:8000';

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

  // Storage keys
  static const USER_NAME = 'user_name';
  static const USER_EMAIL = 'user_email';
  static const USER_TOKEN = 'user_token';
  static const USER_MOBILE_NUMBER = 'user_mobile_number';
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
  static const IS_LOGGED_IN = 'is_logged_in';

  // Paths
  static const JSONS_PATH = 'assets/jsons/';
  static const SVG_PATH = 'assets/svg/';
  static const PNG_PATH = 'assets/png/';

  // Error message
  static const NO_INTERNET_CONNECTION = 'No internet connection';
  static const SOMETHING_WENT_WRONG = 'Something went wrong';

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

  // Colors 
  static const LETSBEE_COLOR = 0xFBD10B;
  static const WHITE = 0xD8DFE3;
}