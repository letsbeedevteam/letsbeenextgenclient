import 'package:flutter/material.dart';
import 'package:letsbeeclient/controllers/dashboard/dashboard_controller.dart';

class ReviewsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('${DashboardController.to.pageIndex.value}'));
  }
}