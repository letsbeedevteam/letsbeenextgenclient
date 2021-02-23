import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/store_response.dart';
import 'package:letsbeeclient/screens/mart/store/store_controller.dart';
import 'package:letsbeeclient/screens/mart/store_cart/store_cart_controller.dart';
import 'package:loading_gifs/loading_gifs.dart';

class StorePage extends GetView<StoreController> {

  @override Widget build(BuildContext context) {
    return GetX<StoreController>(
      initState: controller.fetchStore(),
      builder: (_) {
        return _.store.call() == null ? Container(
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
                    child: Text('Refresh'),
                    onPressed: () => _.fetchStore(),
                  ) : Container()
                ],
              ),
            ),
          ),
        ) : GestureDetector(
          onTap: () => dismissKeyboard(Get.context),
          child: Scaffold(
            body: NestedScrollView(
              controller: _.nestedScrollViewController,
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
                          GetX<StoreCartController>(
                            builder: (cart) {
                              return Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    IconButton(
                                      icon: Image.asset(cart.updatedProducts.call().isEmpty ? Config.PNG_PATH + 'jar-empty.png' : Config.PNG_PATH + 'jar-full.png', height: 30, width: 30), 
                                      onPressed: () => Get.toNamed(Config.STORE_CART_ROUTE, arguments: controller.store.call().data.id)
                                    ),
                                    Badge(
                                      badgeContent: Text(cart.updatedProducts.call().isEmpty ? '' : cart.updatedProducts.call().map((e) => e.quantity).reduce((value, element) => value+element).toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                      showBadge: cart.updatedProducts.call().isNotEmpty,
                                      borderSide: BorderSide(color: Colors.black, width: 1.5),
                                      padding: EdgeInsets.all(5),
                                    )
                                  ]
                                ),
                              );
                            }
                          )
                        ],
                        expandedHeight: 330.0,
                        floating: true,
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
                          onTap: (data) => _.selectedName(_.store.call().data.categorized[data].name),
                          tabs: _.store.call().data.categorized.map((data) {
                            return Obx(() => Tab(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(data.name.capitalizeFirst, style: const TextStyle(fontSize: 15)),
                                  const Padding(padding: const EdgeInsets.symmetric(vertical: 3)),
                                  _.selectedName.call() == data.name ? Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(topLeft: const Radius.circular(8), topRight: const Radius.circular(8)),
                                      color: _.selectedName.call() == data.name ? Colors.black : Colors.transparent,
                                    ),
                                    height: 4,
                                    child: Text(data.name, style: const TextStyle(fontSize: 15)),
                                  ) : Container()
                                ],
                              )
                            ));
                          }).toList(), 
                        ),
                        flexibleSpace: FlexibleSpaceBar(
                          collapseMode: CollapseMode.pin,
                          background: Column(
                            children: [
                              Container(
                                  height: 200,
                                  child: Center(
                                    child: FadeInImage.assetNetwork(placeholder: cupertinoActivityIndicatorSmall, width: Get.width, image: _.store.call().data.photoUrl, fit: BoxFit.fill, placeholderScale: 5, imageErrorBuilder: (context, error, stackTrace) => Center(child: Icon(Icons.image_not_supported_outlined, size: 35)))
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
                                    _.store.call().data.location.name != '' ?
                                    Text('${_.store.call().data.name} - ${_.store.call().data.location.name}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)
                                    : Text(_.store.call().data.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                                    Padding(padding: EdgeInsets.symmetric(vertical: 3)),
                                    Text('No address', style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal), overflow: TextOverflow.ellipsis),
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
                                              Text('10.8KM', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
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
                                              Image.asset(Config.PNG_PATH + 'address.png', height: 15, width: 15, color: Colors.black),
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
              body: GetX<StoreController>(
                builder: (_) {
                  return _.store.call() != null ? TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _.tabController,
                    children: _.store.call().data.categorized.map((categorize) => _buildCategoryItem(categorize)).toList(),
                  ) : Container();
                },
              ),
            )
          ),
        );
      },
    );
  }

  Widget _buildCategoryItem(Categorized categorize) {
    return Container(
      child: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 10)),
          GetX<StoreController>(
            builder: (_) {
              return Container(
                height: 35,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  readOnly: _.readOnly.call(),
                  onTap: () {
                    if(controller.nestedScrollViewController.hasClients) controller.nestedScrollViewController.jumpTo(controller.nestedScrollViewController.position.maxScrollExtent);
                    _.readOnly(false);
                  },
                  onChanged: controller.searchProduct,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10),
                    hintText: 'Search...',
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
              );
            },
          ),
          Expanded(
            child: GetX<StoreController>(
              builder: (_) {
                final products = categorize.products.where((data) => data.name.toLowerCase().contains(_.productName.call().toLowerCase()));
                return products.isNotEmpty ? ListView(
                  physics: NeverScrollableScrollPhysics(),
                  children: products.map((product) => _buildItem(product)).toList()
                ) : Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text('Your search not found...', style: TextStyle(fontSize: 18))
                );
              },  
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(Product product) {
    return GestureDetector(
      onTap: () {
        controller.readOnly(true);
        Future.delayed(Duration(milliseconds: 500)).then((data) {
          if (Get.isDialogOpen) Get.back();
          addCartDialog(product);
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10, right: 10, left: 10),
        padding: EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300, width: 2)
          )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
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
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(top: 10),
                    child: Text('₱ ${product.customerPrice}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal), textAlign: TextAlign.start),
                  )
                ],
              ),
            ),
            Hero(
              tag: product.name,
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
            )
          ],
        ),
      ),
    );
  }

  addCartDialog(Product product) {
    controller.quantity(1);
    Get.defaultDialog(
      title: '',
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: FadeInImage.assetNetwork(
                placeholder: cupertinoActivityIndicatorSmall, 
                image: product.image, 
                fit: BoxFit.fitHeight,
                height: 150, 
                placeholderScale: 5, 
                imageErrorBuilder: (context, error, stackTrace) => Container(
                  width: 140,
                  height: 120,
                  child: Center(child: Icon(Icons.image_not_supported_outlined, size: 35)),
                )
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            Text(product.name, style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.normal)),
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            GetX<StoreController>(
              builder: (_) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                    IconButton(icon: Icon(Icons.remove_circle_outline_rounded, size: 30), onPressed: () =>_.decrement()),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey.shade200
                      ),
                      child: Text('${_.quantity.call()}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    IconButton(icon: Icon(Icons.add_circle_outline_rounded, size: 30), onPressed: () => _.increment()),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                  ],
                );
              },
            ),            
          ],
        ),
      ),
      confirm: GetX<StoreController>(
        builder: (_) {
          return RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            ),
            color: Color(Config.LETSBEE_COLOR).withOpacity(1.0),
            child: _.isAddToCartLoading.call() ? Container(height: 10, width: 10, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black))) : Text('Add to cart', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
            // onPressed: () => _.isAddToCartLoading.call() ? null : _.addTocart(product),
            onPressed: () => _.storeCartToStorage(product),
          );
        },
      ),
      cancel: GetX<StoreController>(
        builder: (_) {
          return IgnorePointer(
            ignoring: _.isAddToCartLoading.call(),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              color: Color(Config.LETSBEE_COLOR).withOpacity(1.0),
              child: Text('Back', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
              onPressed: () {
                if (Get.isSnackbarOpen) {
                  Get.back();
                  Future.delayed(Duration(milliseconds: 500));
                  Get.back();
                } else {
                  Get.back();
                }
              },
            ),
          );
        },
      ),
      barrierDismissible: false
    );
  }
}