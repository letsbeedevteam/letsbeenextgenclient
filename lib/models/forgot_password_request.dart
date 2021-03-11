class ForgotPasswordRequest {
  ForgotPasswordRequest({
    this.token,
    this.code,
    this.newPassword
  });

  String token;
  String code;
  String newPassword;

  Map<String, dynamic> toJson() => {
    "token": token,
    "code": code,
    "new_password": newPassword
  };
}