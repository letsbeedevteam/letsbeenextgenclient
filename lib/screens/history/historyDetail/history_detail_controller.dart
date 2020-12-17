import 'package:get/get.dart';
import 'package:letsbeeclient/models/orderHistoryResponse.dart';

class HistoryDetailController extends GetxController {

  final argument = Get.arguments;

  var data = OrderHistoryData().obs;

  @override
  void onInit() {
    data(OrderHistoryData.fromJson(argument));
    super.onInit();
  }
}