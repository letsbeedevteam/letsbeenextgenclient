// import 'package:badges/badges.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:badges/badges.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/store_response.dart';
// import 'package:letsbeeclient/screens/food/cart/cart_controller.dart';
// import 'package:letsbeeclient/screens/food/cart/cart_controller.dart';
import 'package:letsbeeclient/screens/food/restaurant/restaurant_controller.dart';
import 'package:loading_gifs/loading_gifs.dart';

class RestaurantPage extends GetView<RestaurantController> {
  
  @override
    Widget build(BuildContext context) {
      return GetX<RestaurantController>(
        initState: controller.fetchStore(),
        builder: (_) {
          return _.storeResponse.call() == null ? Container(
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(icon: Image.asset(Config.PNG_PATH + 'back_button.png'), onPressed: () => Get.back()),
                elevation: 0,
                backgroundColor: Colors.transparent,
              ),
              body: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _.hasError.call() ? Container() : CupertinoActivityIndicator(),
                    Text(_.message.call()),
                    _.hasError.call() ? RaisedButton(
                      color: Color(Config.LETSBEE_COLOR),
                      child: Text(tr('refresh')),
                      onPressed: () => _.fetchStore(),
                    ) : Container()
                  ],
                ),
              ),
            ),
          ) : GestureDetector(
            onTap: () => dismissKeyboard(Get.context),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: NestedScrollView(
                controller: controller.nestedScrollViewController,
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                      sliver: SliverSafeArea(
                        top: false,
                        bottom: false,
                        sliver: SliverAppBar(
                          leading: IconButton(icon: Image.asset(Config.PNG_PATH + 'back_button.png'), onPressed: () => Get.back()),
                          actions: [
                            Obx(() {
                              final filtered = controller.list.call().where((data) => !data.isRemove && data.storeId == controller.store.call().id && data.userId == controller.box.read(Config.USER_ID));
                              return GestureDetector(
                                onTap: () => Get.toNamed(Config.CART_ROUTE, arguments: controller.store.call().id),
                                child: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        child: Image.asset(filtered.isEmpty ? Config.PNG_PATH + 'jar-empty.png' : Config.PNG_PATH + 'jar-full.png', height: 30, width: 30),
                                      ),
                                      Badge(
                                        badgeContent: Text(filtered.isEmpty ? '' : filtered.map((e) => e.quantity).reduce((value, element) => value+element).toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                        showBadge: filtered.isNotEmpty,
                                        borderSide: BorderSide(color: Colors.black, width: 1.5),
                                        padding: EdgeInsets.all(5),
                                      )
                                    ]
                                  ),
                                ),
                              );
                            })
                          ],
                          expandedHeight: 330.0,
                          floating: false,
                          pinned: true,
                          backgroundColor: Color(Config.WHITE),
                          elevation: 0,
                          bottom: TabBar(
                            controller: _.tabController,
                            isScrollable: true,
                            labelColor: Colors.black,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorColor: Colors.transparent,
                            unselectedLabelColor: Colors.grey,
                            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                            onTap: (value) => _.selectedName(_.storeResponse.call().data[value].name),
                            tabs: _.storeResponse.call().data.map((data) {
                              return Obx(() => Tab(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(data.name.capitalizeFirst, style: const TextStyle(fontSize: 15)),
                                    const Padding(padding: const EdgeInsets.symmetric(vertical: 3)),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(topLeft: const Radius.circular(8), topRight: const Radius.circular(8)),
                                        color: _.selectedName.call() == data.name ? Colors.black : Colors.transparent,
                                      ),
                                      height: 4,
                                      padding: EdgeInsets.symmetric(horizontal: data.name.length.toDouble() * 5),
                                    )
                                  ],
                                )
                              ));
                            }).toList(), 
                          ),
                          flexibleSpace: FlexibleSpaceBar(
                            collapseMode: CollapseMode.pin,
                            background: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                    height: 200,
                                    child: Center(
                                      child: FadeInImage.assetNetwork(placeholder: cupertinoActivityIndicatorSmall, width: Get.width, image: _.store.call().photoUrl, fit: BoxFit.fill, placeholderScale: 5, imageErrorBuilder: (context, error, stackTrace) => Center(child: Icon(Icons.image_not_supported_outlined, size: 35)))
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(height: 10),
                                      _.store.call().location.name != '' ?
                                      Text('${_.store.call().name} - ${_.store.call().location.name}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)
                                      : Text(_.store.call().name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                                      Padding(padding: EdgeInsets.symmetric(vertical: 3)),
                                      Text('${_.store.call().address.barangay} ${_.store.call().address.city} ${_.store.call().address.state} ${_.store.call().address.country}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal), overflow: TextOverflow.ellipsis),
                                      Padding(padding: EdgeInsets.symmetric(vertical: 3)),
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: Colors.white
                                            ),
                                            child: Row(
                                              children: [
                                                Image.asset(Config.PNG_PATH + 'address.png', height: 15, width: 15, color: Colors.black),
                                                Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
                                                Text('${_.store.call().distance?.toStringAsFixed(2)}KM', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                              ],
                                            ),
                                          ),
                                          Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: Colors.white
                                            ),
                                            child: Row(
                                              children: [
                                                Image.asset(Config.PNG_PATH + 'delivery-time.png', height: 15, width: 15, color: Colors.black),
                                                Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
                                                Text("37'", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Divider(thickness: 0.3)
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ];
                },
                body: GetX<RestaurantController>(
                  builder: (restaurant) {
                    return _.storeResponse.call() != null ? TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: restaurant.tabController,
                      children: restaurant.storeResponse.call().data.map((data) => _buildCategoryItem(data)).toList(),
                    ) : Container();
                  },
                ),
              ),
            ),
          );
        },
      );
    }

  Widget _buildCategoryItem(Data data) {
    return Container(
      child: Obx(() {
        final products = data.products.where((data) => data.name.toLowerCase().contains(controller.productName.call().toLowerCase()));
        return Column(
          children: [
            Container(
              height: 35,
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                cursorColor: Colors.black,
                readOnly: controller.readOnly.call(),
                onTap: () {
                  if(controller.nestedScrollViewController.hasClients) controller.nestedScrollViewController.jumpTo(controller.nestedScrollViewController.position.maxScrollExtent);
                  controller.readOnly(false);
                },
                onChanged: controller.searchProduct,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 10),
                  hintText: tr('search'),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide.none
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ),
            Expanded(
              child: products.isNotEmpty ? RefreshIndicator(
                onRefresh: () => controller.refreshStore(),
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  children: products.map((product) => _buildItem(product)).toList()
                ),
              ) : Container(
                margin: EdgeInsets.only(top: 20),
                child: Text('Your search not found...', style: TextStyle(fontSize: 18))
              )
            ),
          ],
        );
      })
    );
  }

  Widget _buildItem(Product product) {
    return GestureDetector(
      onTap: () {
        controller.readOnly(true);
        _bottomSheet(product);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10, right: 10, left: 10),
        padding: EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Color(Config.WHITE)
        ),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(product.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(product.description, style: TextStyle(fontSize: 13 ,fontWeight: FontWeight.normal), textAlign: TextAlign.start),
                      )
                    ],
                  ),
                ),
                FadeInImage.assetNetwork(
                  placeholder: cupertinoActivityIndicatorSmall, 
                  image: product.image, 
                  fit: BoxFit.fitWidth, 
                  height: 120, 
                  width: 140, 
                  placeholderScale: 5, 
                  imageErrorBuilder: (context, error, stackTrace) {
                    return error.toString().contains(product?.image) ? Container(
                      width: 140,
                      height: 120,
                      child: Center(child: Icon(Icons.image_not_supported_outlined, size: 35)),
                    ) : FadeInImage.assetNetwork(
                      placeholder: cupertinoActivityIndicatorSmall, 
                      image: product.image, 
                      fit: BoxFit.fitWidth, 
                      height: 120, 
                      width: 140, 
                      placeholderScale: 5
                    ); 
                  }
                ),
              ],
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 10),
              child: Text('₱ ${product.customerPrice}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRequiredItem(Variants choice) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${choice.type}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 18)),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(Config.LETSBEE_COLOR),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Text(tr('required'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: choice.options.map((e) {
                return RadioListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: Text(e.name, style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500))),
                      Text(e.customerPrice == 0.00 ? '+ ₱0.00' : '+ ₱${e.customerPrice}', style: TextStyle(color: Colors.black.withOpacity(0.35), fontSize: 14))
                    ],
                  ),
                  value: e.name,
                  groupValue: e.selectedValue,
                  onChanged: (value) => controller.updateChoices(choice.id, e)
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildOptionalItem(Additional additional) {
    return Container(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(additional.name, style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500))),
              Text(additional.customerPrice == 0.00 ? '+ ₱0.00' : '+ ₱${additional.customerPrice}', style: TextStyle(color: Colors.black.withOpacity(0.35), fontSize: 14))
            ],
          ),
          value: !additional.selectedValue, 
          onChanged: (value) =>controller.updateAdditionals(additional.id, additional),
        ),
      ),
    );
  }

  Widget _storeProductBuild(Product product) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Text(product.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(product.description, style: TextStyle(fontSize: 13 ,fontWeight: FontWeight.normal), textAlign: TextAlign.start),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 30),
                          child: Text('₱ ${product.customerPrice}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
                        )
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: FadeInImage.assetNetwork(
                        placeholder: cupertinoActivityIndicatorSmall, 
                        image: product.image, 
                        fit: BoxFit.fitWidth, 
                        height: 120, 
                        width: 140, 
                        placeholderScale: 5, 
                        imageErrorBuilder: (context, error, stackTrace) => Container(
                          width: 140,
                          height: 120,
                          child: Center(child: Icon(Icons.image_not_supported_outlined, size: 35)),
                        )
                      ),
                    ),
                  )
                ]
              ),
            ),
            Divider(),
            product.variants.isNotEmpty ? Column(
              mainAxisSize: MainAxisSize.min,
              children: product.variants.map((e) => _buildRequiredItem(e)).toList()
            ) : Container(),
            product.additionals.isNotEmpty ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(tr('addsOn'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 18)),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Text(tr('optional'), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              product.additionals.length == 1 ? Container() :
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('${tr('selectUpTo')} ${product.additionals.length}', style: TextStyle(color: Colors.black.withOpacity(0.35), fontSize: 14)),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                  children: product.additionals.map((e) => _buildOptionalItem(e)).toList()
                ),
              ],
            ) : Container(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(tr('specialInstructions'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 18)),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Text(tr('optional'), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: TextFormField(
                    controller: controller.tFRequestController,
                    decoration: InputDecoration(
                      hintText: tr('exampleInstruction'),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 0, 
                          color: Colors.black
                        )
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 0, 
                          color: Colors.black
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      contentPadding: EdgeInsets.only(top: 10, left: 10, bottom: 10)
                    ),
                    keyboardType: TextInputType.text,
                    enableSuggestions: false,
                    textAlign: TextAlign.start,
                    cursorColor: Colors.black,
                  )
                ),
              ],
            ) ,
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(tr('proceedIfNotAvail'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 18)),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                  child: GetX<RestaurantController>(
                    builder: (_) {
                      return Column(
                        children: [
                          RadioListTile(
                            title: Text(tr('removeThisTime'), style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
                            value: true,
                            groupValue: _.isSelectedProceed.call(),
                            onChanged: (value) =>  _.isSelectedProceed(value)
                          ),
                          RadioListTile(
                            title: Text(tr('cancelEntireOrder'), style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
                            value: false,
                            groupValue: _.isSelectedProceed.call(),
                            onChanged: (value) => _.isSelectedProceed(value)
                          )
                        ],
                      );
                    }
                  )
                ),
              ],
            ) 
          ],
        ),
      ),
    );
  }

  _bottomSheet(Product product) {
    controller.product.nil();
    Get.bottomSheet(
      GetX<RestaurantController>(
        initState: (state) => controller.refreshProduct(product),
        builder: (_) {          
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                flex: 1,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    color: Colors.transparent,
                    width: Get.width
                  ),
                ),
              ),
              Flexible(
                flex: 5,
                child: Container(
                    height: Get.height * 0.85,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                      color: Color(Config.WHITE)
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(child: _storeProductBuild(_.product.call())),
                        Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: Container(
                            width: Get.width,
                            color: Colors.white,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Color(Config.WHITE)
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                                            Container(
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color: Colors.white
                                              ),
                                              child: IconButton(icon: Icon(Icons.remove, size: 15), onPressed: () => _.decrement())
                                            ),
                                            Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                                            Text('${_.quantity.call()}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                            Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                                            Container(
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color: Color(Config.LETSBEE_COLOR)
                                              ),
                                              child: IconButton(icon: Icon(Icons.add, size: 15), onPressed: () => _.increment())
                                            ),
                                            Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                                          ],
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () => controller.addToCart(controller.product.call()),
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: Color(Config.LETSBEE_COLOR)
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(tr('addToCart'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                                Text('₱ ${((_.totalPriceOfChoice.call() + _.totalPriceOfAdditional.call() + double.tryParse(_.product.call().customerPrice)) * _.quantity.call()).toStringAsFixed(2)}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                              ],
                                            )
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ),
            ],
          );
        },
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: false,
    );
  }
}