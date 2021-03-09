import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/get_address_response.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'package:letsbeeclient/services/api_service.dart';

class AddressController extends GetxController {

  final ApiService apiService = Get.find();

  var addresses = GetAllAddressResponse().obs;
  var isLoading = false.obs;
  var addressErrorMessage = ''.obs;

  static AddressController get to => Get.find();

  @override
  void onInit() {
    addresses.nil();
    fetchAllAddresses();
    super.onInit();
  }
  
  Future<Null> refreshAddress() async => fetchAllAddresses();

  updateSelectedAddress({AddressData data}) {
    successSnackBarTop(title: 'Your selected location is:', message: data.address, seconds: 1);
    DashboardController.to.updateCurrentLocation(data);
  }

  addAddress() => Get.toNamed(Config.MAP_ROUTE, arguments: {'type': Config.ADD_NEW_ADDRESS});

  editAddress(AddressData data) => Get.toNamed(Config.MAP_ROUTE, arguments: {'type': Config.EDIT_NEW_ADDRESS, 'data': data.toJson()});

  fetchAllAddresses() {
    isLoading(true);
    apiService.getAllAddress().then((response) {
      isLoading(false);
      if (response.status == 200) {
        if (response.data.isNotEmpty) {
          addresses(response);
          addresses.call().data.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        } else {
          addresses.nil();
          addressErrorMessage('No list of address');
        }

      } else {
        addresses.nil();
        addressErrorMessage(Config.somethingWentWrong);
      }
      
    }).catchError((onError) {
      addresses.nil();
      isLoading(false);
      addressErrorMessage(Config.somethingWentWrong);
      // message(Config.SOMETHING_WENT_WRONG);
      print('Error fetch all address: $onError');
    });
  }
}