import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/models/order_history_response.dart';
import 'package:letsbeeclient/services/api_service.dart';

class HistoryController extends GetxController {

  Completer<void> refreshCompleter;
  
  final ApiService apiService = Get.find();

  var isLoading = false.obs;
  var history = OrderHistoryResponse().obs;
  var historyMessage = tr('emptyOrderHistory').obs;
  
  StreamSubscription<OrderHistoryResponse> orderHistorySub;
  
  @override
  void onInit() {
    history.nil();
    
    refreshCompleter = Completer();

    super.onInit();
  }

  @override
  void onClose() {
    orderHistorySub?.cancel();
    super.onClose();
  }

  void _setRefreshCompleter() {
    refreshCompleter?.complete();
    refreshCompleter = Completer();
  }

  fetchOrderHistory() {
    isLoading(true);
    orderHistorySub = apiService.orderHistory().asStream().listen((response) {
      isLoading(false);
      _setRefreshCompleter();
      if (response.status == Config.OK) {

        if (response.data.isNotEmpty) {
          history(response);
          history.call().data.sort((b, a) => a.updatedAt.compareTo(b.updatedAt));
        } else {
          historyMessage(tr('emptyOrderHistory'));
          history.nil();
        }

      } else {
        historyMessage(tr('somethingWentWrong'));
      }
      
    })..onError((onError) {
      isLoading(false);
      _setRefreshCompleter();
      if (onError.toString().contains('Connection failed')) {
        historyMessage(tr('noInternetConnection'));
      } else if (onError.toString().contains('Operation timed out')) {
        historyMessage(tr('timedOut'));
      } else {
        historyMessage(tr('somethingWentWrong'));
      }
      print('Error fetch history orders: $onError');
    });
  }
}