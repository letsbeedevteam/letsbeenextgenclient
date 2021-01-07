import 'package:get/get.dart';
import 'package:letsbeeclient/models/orderHistoryResponse.dart';

class HistoryDetailController extends GetxController {

  final argument = Get.arguments;

  var data = OrderHistoryData().obs;
  var title = ''.obs;

  @override
  void onInit() {
    data(OrderHistoryData.fromJson(argument));
    
    if(data.call().restaurant.locationName.isNullOrBlank) {
      this.title("${data.call().restaurant.name}");
    } else {
      this.title("${data.call().restaurant.name} (${data.call().restaurant.locationName})");
    }

    super.onInit();
  }
}