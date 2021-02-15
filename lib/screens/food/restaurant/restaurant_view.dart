// import 'package:badges/badges.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/store_response.dart';
import 'package:letsbeeclient/screens/food/cart/cart_controller.dart';
// import 'package:letsbeeclient/models/restaurant.dart';
// import 'package:letsbeeclient/screens/food/cart/cart_controller.dart';
import 'package:letsbeeclient/screens/food/restaurant/restaurant_controller.dart';
import 'package:loading_gifs/loading_gifs.dart';

class RestaurantPage extends GetView<RestaurantController> {
  
  @override
    Widget build(BuildContext context) {
      return GetX<RestaurantController>(
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
                    CupertinoActivityIndicator(),
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
              resizeToAvoidBottomPadding: false,
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
                          expandedHeight: 300.0,
                          floating: true,
                          pinned: true,
                          backgroundColor: Color(Config.WHITE),
                          elevation: 0,
                          bottom: TabBar(
                            controller: _.tabController,
                            isScrollable: true,
                            indicatorSize: TabBarIndicatorSize.tab,
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey,
                            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),
                            indicatorWeight: 5,
                            tabs:  _.store.call().data.categorized.map((data) {
                              return  Tab(
                                child: Container(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(data.name.capitalizeFirst),
                                  ),
                                )
                              );
                            }).toList(),
                          ),
                          flexibleSpace: FlexibleSpaceBar(
                            collapseMode: CollapseMode.pin,
                            background: Stack(
                              alignment: Alignment.centerLeft,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      height: 200,
                                      child: Center(
                                        child: FadeInImage.assetNetwork(placeholder: cupertinoActivityIndicatorSmall, width: Get.width, image: _.store.call().data.photoUrl, fit: BoxFit.fill, placeholderScale: 5, imageErrorBuilder: (context, error, stackTrace) => Center(child: Icon(Icons.image_not_supported_outlined, size: 35)))
                                    ),
                                  ),
                                  Flexible(
                                    child: Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(bottom: 30),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                            Container(height: 10),
                                            Text(_.store.call().data.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                            Text(_.store.call().data.location.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal))
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                // Positioned(
                                //   top: 160.0,
                                //   child: Container(
                                //     margin: EdgeInsets.only(left: 20),
                                //     height: 70.0,
                                //     width: 70.0,
                                //     decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.circular(50),
                                //       border: Border.all(width: 2),
                                //       color: Colors.white
                                //     ),
                                //     child: ClipOval(
                                //       child: FadeInImage.assetNetwork(placeholder: cupertinoActivityIndicatorSmall, width: Get.width, image: _.store.call().data.logoUrl, fit: BoxFit.fitWidth, placeholderScale: 5, imageErrorBuilder: (context, error, stackTrace) => Center(child: Icon(Icons.image_not_supported_outlined, size: 35)))
                                //     ),
                                //   ),
                                // )
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
                    return Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        _.store.call() != null ? TabBarView(
                          physics: NeverScrollableScrollPhysics(),
                          controller: restaurant.tabController,
                          children: restaurant.store.call().data.categorized.map((categorize) => _buildCategoryItem(categorize)).toList(),
                        ) : Container(),
                        GetX<CartController>(
                          builder: (activeCart) {
                            return activeCart.cart.call() == null ? Container() : Container(
                              margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                              child: SizedBox(
                                width: Get.width,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)
                                  ),
                                  color: Color(Config.LETSBEE_COLOR).withOpacity(1.0),
                                  child: Stack(
                                    alignment: Alignment.centerRight,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('VIEW YOUR CART', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
                                        ],
                                      ),
                                      Badge(
                                        badgeContent: Text(activeCart.cart.call() == null ? '' : activeCart.cart.call().data.map((e) => e.quantity).reduce((value, element) => value+element).toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                        showBadge: CartController.to.cart.call() != null,
                                        padding: EdgeInsets.all(10),
                                      )
                                    ],
                                  ),
                                  onPressed: () => Get.toNamed(Config.CART_ROUTE, arguments: controller.store.call().data.id),
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    );
                  },
                ),
              ),
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
          GetX<RestaurantController>(
            builder: (_) {
              return Container(
                height: 35,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  cursorColor: Colors.black,
                  readOnly: _.readOnly.call(),
                  onTap: () {
                    if(controller.nestedScrollViewController.hasClients) controller.nestedScrollViewController.jumpTo(controller.nestedScrollViewController.position.maxScrollExtent);
                    _.readOnly(false);
                  },
                  onChanged: controller.searchProduct,
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
            child: GetX<RestaurantController>(
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
        Get.toNamed(Config.STORE_MENU_ROUTE, arguments: {'product': product.toJson()}).whenComplete(() => controller.readOnly(true));
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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: GetX<RestaurantController>(
  //       builder: (_) {
  //         return NestedScrollView(
  //           physics: _.restaurant.call().menuCategorized.map((e) => e.menus).length == 1 ? AlwaysScrollableScrollPhysics() : NeverScrollableScrollPhysics(),
  //           headerSliverBuilder: (context, innerBoxIsScrolled) {
  //             return [
  //               SliverOverlapAbsorber(
  //                 handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
  //                 sliver: SliverSafeArea(
  //                   top: false,
  //                   bottom: false,
  //                   sliver: SliverAppBar(
  //                     leading: IconButton(icon: Image.asset(Config.PNG_PATH + 'back_button.png'), onPressed: () => Get.back()),
  //                     expandedHeight: 300.0,
  //                     floating: true,
  //                     pinned: true,
  //                     backgroundColor: Color(Config.WHITE),
  //                     elevation: 0,
  //                     bottom: TabBar(
  //                       controller: _.tabController,
  //                       isScrollable: true,
  //                       indicatorSize: TabBarIndicatorSize.tab,
  //                       labelColor: Colors.black,
  //                       unselectedLabelColor: Colors.grey,
  //                       unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
  //                       labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),
  //                       indicatorWeight: 5,
  //                       tabs: _.restaurant.call().menuCategorized.map((element) {
  //                         return Tab(
  //                           child: Container(
  //                             child: Align(
  //                               alignment: Alignment.center,
  //                               child: Text(element.name.capitalizeFirst),
  //                             ),
  //                           )
  //                         );
  //                       }).toList(),
  //                     ),
  //                     flexibleSpace: FlexibleSpaceBar(
  //                       collapseMode: CollapseMode.pin,
  //                       background: Stack(
  //                         alignment: Alignment.centerLeft,
  //                         children: [
  //                           Column(
  //                             children: [
  //                               Container(
  //                                 height: 200,
  //                                 child: Center(
  //                                   child: _.restaurant.call().photoUrl != null ? FadeInImage.assetNetwork(placeholder: cupertinoActivityIndicatorSmall, width: Get.width, image: _.restaurant.call().photoUrl, fit: BoxFit.fill, placeholderScale: 5, imageErrorBuilder: (context, error, stackTrace) => Center(child: Icon(Icons.image_not_supported_outlined, size: 35))) 
  //                                   : Container(child: Center(child: Center(child: Icon(Icons.image_not_supported_outlined, size: 60)))),
  //                               ),
  //                             ),
  //                             Flexible(
  //                               child: Container(
  //                                 alignment: Alignment.center,
  //                                 margin: EdgeInsets.only(bottom: 30),
  //                                 child: Column(
  //                                   mainAxisAlignment: MainAxisAlignment.center,
  //                                   crossAxisAlignment: CrossAxisAlignment.center,
  //                                   mainAxisSize: MainAxisSize.min,
  //                                   children: [
  //                                       Container(height: 10),
  //                                       Text(_.restaurant.call().name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  //                                       Text(_.restaurant.call().location.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal))
  //                                     ],
  //                                   ),
  //                                 ),
  //                               )
  //                             ],
  //                           ),
  //                           Positioned(
  //                             top: 160.0,
  //                             child: Container(
  //                               margin: EdgeInsets.only(left: 20),
  //                               height: 70.0,
  //                               width: 70.0,
  //                               decoration: BoxDecoration(
  //                                 borderRadius: BorderRadius.circular(50),
  //                                 border: Border.all(width: 2),
  //                                 color: Colors.white
  //                               ),
  //                               child: ClipOval(
  //                                 child: FadeInImage.assetNetwork(placeholder: cupertinoActivityIndicatorSmall, image: _.restaurant.call().logoUrl, placeholderScale: 5, imageErrorBuilder: (context, error, stackTrace) => Center(child: Icon(Icons.image_not_supported_outlined, size: 35)))
  //                               ),
  //                             ),
  //                           )
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               )
  //             ];
  //           },
            // body: Stack(
            //   alignment: Alignment.bottomCenter,
            //   children: [
            //     TabBarView(
            //       physics: NeverScrollableScrollPhysics(),
            //       controller: _.tabController,
            //       children: _.restaurant.call().menuCategorized.map((e) => _buildItem(e.menus, restaurantId: _.restaurant.call().id)).toList(),
            //     ),
            //     GetX<CartController>(
            //       builder: (_) {
            //         return Container(
            //           margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            //           child: SizedBox(
            //             width: Get.width,
            //             child: RaisedButton(
            //               shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(20)
            //               ),
            //               color: Color(Config.LETSBEE_COLOR).withOpacity(1.0),
            //               child: Stack(
            //                 alignment: Alignment.centerRight,
            //                 children: [
            //                   Row(
            //                     mainAxisAlignment: MainAxisAlignment.center,
            //                     children: [
            //                       Text('VIEW YOUR CART', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
            //                     ],
            //                   ),
            //                   Badge(
            //                     badgeContent: Text(_.cart.call() == null ? '' : _.cart.call().data.map((e) => e.quantity).reduce((value, element) => value+element).toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            //                     showBadge: CartController.to.cart.call() != null,
            //                     padding: EdgeInsets.all(10),
            //                   )
            //                 ],
            //               ),
            //               onPressed: () => Get.toNamed(Config.CART_ROUTE, arguments: controller.restaurant.call().id),
            //             ),
            //           ),
            //         );
            //       },
            //     )
            //   ],
            // ),
  //         );
  //       },
  //     ),
  //   );
  // } 

  // Widget _buildItem(List<Menu> menus, {int restaurantId}) {
  //   return Container(
  //     child: ListView(
  //       physics: NeverScrollableScrollPhysics(),
  //       children: menus.map((menu) =>  _buildAvailableMenu(menu, restaurantId: restaurantId)).toList()
  //     ),
  //   );
  // }

  // Widget _buildAvailableMenu(Menu menu, {int restaurantId}) {
  //   return GestureDetector(
  //     child: Container(
  //       margin: EdgeInsets.all(10),
  //       padding: EdgeInsets.only(bottom: 5),
  //       decoration: BoxDecoration(
  //         border: Border(
  //           bottom: BorderSide(color: Colors.grey.shade300, width: 2)
  //         )
  //       ),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Expanded(
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                      Container(
  //                       child: Text(menu.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
  //                     ),
  //                     Container(
  //                       alignment: Alignment.centerLeft,
  //                       child: Text(menu.description, style: TextStyle(fontSize: 13 ,fontWeight: FontWeight.normal), textAlign: TextAlign.start),
  //                     )
  //                   ],
  //                 ),
  //                 Container(
  //                   alignment: Alignment.centerLeft,
  //                   margin: EdgeInsets.only(top: 10),
  //                   child: Text('₱ ${double.tryParse(menu.price).toStringAsFixed(2)}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal), textAlign: TextAlign.start),
  //                 )
  //               ],
  //             ),
  //           ),
  //           SizedBox(
  //             child: Hero(
  //               tag: menu.name,
  //               child: FadeInImage.assetNetwork(placeholder: cupertinoActivityIndicatorSmall, image: menu.image, height: 120, width: 140, fit: BoxFit.fitWidth, placeholderScale: 5, imageErrorBuilder: (context, error, stackTrace) => Center(child: Icon(Icons.image_not_supported_outlined, size: 35))), 
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //     onTap: () => Get.toNamed(Config.MENU_ROUTE, arguments: {
  //       'restaurantId': restaurantId, 
  //       'menu': menu.toJson(),
  //     })
  //   );
  // }
}