class EditProfileRequest {
  EditProfileRequest({
    this.name,
    this.email,
    this.number
  });  

  String name;
  String email;
  String number;

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "cellphone_number": number
  };
}