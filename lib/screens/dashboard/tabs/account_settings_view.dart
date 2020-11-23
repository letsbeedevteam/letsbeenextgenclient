import 'package:flutter/material.dart';
import 'package:letsbeeclient/controllers/dashboard/dashboard_controller.dart';

class AccountSettingsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(child: RaisedButton(child: Text('Sign out'), onPressed: () => DashboardController.to.signOut()));
  }
}