import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeeclient/models/orderHistoryResponse.dart';

class HistoryDetailController extends GetxController {

  final argument = Get.arguments;
  GetStorage box = Get.find();

  var data = OrderHistoryData().obs;
  var title = ''.obs;

  @override
  void onInit() {
    data(OrderHistoryData.fromJson(argument));
    
    if(data.call().restaurant.locationName.isBlank) {
      this.title("${data.call().restaurant.name}");
    } else {
      this.title("${data.call().restaurant.name} (${data.call().restaurant.locationName})");
    }

    super.onInit();
  }
}