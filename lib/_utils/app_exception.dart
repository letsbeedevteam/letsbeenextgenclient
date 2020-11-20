class AppException implements Exception {
  
  final _message;
  final _prefix;

  AppException([this._prefix, this._message]);

  String toString() => "$_prefix $_message";
}