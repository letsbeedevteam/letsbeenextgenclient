class SocialSignUpRequest {
  SocialSignUpRequest({
    this.token,
    this.name,
    this.cellphoneNumber
  });

  String name;
  String token;
  String cellphoneNumber;

  Map<String, dynamic> toJson() => {
    "token": token,
    "name": name,
    "cellphone_number": cellphoneNumber
  };
}