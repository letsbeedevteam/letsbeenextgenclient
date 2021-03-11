class ChangePasswordRequest {
  ChangePasswordRequest({
    this.oldPassword,
    this.newPassword,
    this.confirmPassword
  });

  String oldPassword;
  String newPassword;
  String confirmPassword;

  Map<String, dynamic> toJson() => {
    "old_password": oldPassword,
    "new_password": newPassword,
    "confirm_password": confirmPassword
  };
}