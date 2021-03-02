class SignUpRequest {
  SignUpRequest({
    this.name,
    this.email,
    this.password,
    this.confirmPassword,
    this.cellphoneNumber
  });

  String name;
  String email;
  String password;
  String confirmPassword;
  String cellphoneNumber;

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "password": password,
    "confirm_password": confirmPassword,
    "cellphone_number": cellphoneNumber
  };
}