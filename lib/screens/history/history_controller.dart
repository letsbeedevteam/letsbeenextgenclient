import 'dart:async';

import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/models/orderHistoryResponse.dart';
import 'package:letsbeeclient/services/api_service.dart';

class HistoryController extends GetxController {

  Completer<void> refreshCompleter;
  
  final ApiService apiService = Get.find();

  var isLoading = false.obs;
  var history = OrderHistoryResponse().obs;
  var historyMessage = Config.emptyOrderHistory.obs;
  
  @override
    void onInit() {
      history.nil();
      
      refreshCompleter = Completer();

      super.onInit();
    }

  void _setRefreshCompleter() {
    refreshCompleter?.complete();
    refreshCompleter = Completer();
  }

  fetchOrderHistory() {
    isLoading(true);
    apiService.orderHistory().then((response) {
      isLoading(false);
      _setRefreshCompleter();
      if (response.status == 200) {

        if (response.data.isNotEmpty) {
          history(response);
          history.call().data.sort((b, a) => a.updatedAt.compareTo(b.updatedAt));
        } else {
          historyMessage(Config.emptyOrderHistory);
          history.nil();
        }

      } else {
        historyMessage(Config.somethingWentWrong);
      }
      
    }).catchError((onError) {
      isLoading(false);
      _setRefreshCompleter();
      if (onError.toString().contains('Connection failed')) {
        historyMessage(Config.noInternetConnection);
      } else if (onError.toString().contains('Operation timed out')) {
        historyMessage(Config.timedOut);
      } else {
        historyMessage(Config.somethingWentWrong);
      }
      print('Error fetch history orders: $onError');
    });
  }
}