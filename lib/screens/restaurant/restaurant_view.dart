import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/models/restaurant.dart';
import 'package:letsbeeclient/screens/restaurant/restaurant_controller.dart';
import 'package:loading_gifs/loading_gifs.dart';

class RestaurantPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<RestaurantController>(
        builder: (_) {
          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  leading: IconButton(icon: Image.asset(Config.PNG_PATH + 'back_button.png'), onPressed: () => Get.back()),
                  actions: [
                    IconButton(icon: Image.asset(Config.PNG_PATH + 'frame_bee_cart.png'), iconSize: 50, onPressed: () => Get.toNamed(Config.CART_ROUTE), highlightColor: Colors.transparent, splashColor: Colors.transparent)
                  ],
                  expandedHeight: 280.0,
                  floating: true,
                  pinned: true,
                  forceElevated: innerBoxIsScrolled,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  bottom: TabBar(
                    controller: _.tabController,
                    isScrollable: true,
                    indicatorSize: TabBarIndicatorSize.tab,
                    unselectedLabelColor: Colors.grey.shade400,
                    labelColor: Colors.black,
                    indicatorColor: Colors.black,
                    indicatorWeight: 3.5,
                    tabs: _.restaurant.value.menuCategorized.map((element) {
                      return Tab(
                        child: Container(
                          child: Center(child: Text(element.name.capitalizeFirst, style: TextStyle(fontSize: 15)))
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
                                child: Hero(
                                  tag: _.restaurant.value.name,
                                  child: Container(
                                    width: Get.width,
                                    child: CarouselSlider(
                                    options: CarouselOptions(
                                      autoPlay: false,
                                      disableCenter: true,                                    
                                    ),
                                    items: _.restaurant.value.sliders.map((item) => FadeInImage.assetNetwork(placeholder: cupertinoActivityIndicatorSmall, image: item.url, fit: BoxFit.cover)).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20, bottom: 30),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                  Center(child: Text(_.restaurant.value.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),),
                                  Center(child: Text(_.restaurant.value.location.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),)
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 160.0,
                          child: Container(
                            margin: EdgeInsets.only(left: 20),
                            height: 80.0,
                            width: 80.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: Colors.black, width: 1.5)
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(_.restaurant.value.logoUrl),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ];
            },
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _.tabController,
              children: _.restaurant.value.menuCategorized.map((e) => _buildItem(e.menus, restaurantId: _.restaurant.value.id)).toList(),
            ),
          );
        },
      )
    );
  } 

  Widget _buildItem(List<Menu> menus, {int restaurantId}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: SingleChildScrollView(
        child: Container(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: menus.map((menu) =>  _buildAvailableMenu(menu, restaurantId: restaurantId)).toList(),
          ),
        )
      )
    );
  }

  Widget _buildAvailableMenu(Menu menu, {int restaurantId}) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Hero(
                tag: menu.name,
                child: Container(
                  width: 180,
                  height: 200,
                  child: FadeInImage.assetNetwork(placeholder: cupertinoActivityIndicatorSmall, image: menu.image, placeholderScale: 5, imageErrorBuilder: (context, error, stackTrace) => Center(child: Image.asset(Config.PNG_PATH + 'letsbee_logo.png'))),
                ),
              )
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Text(menu.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Text('₱ ${menu.price}', style: TextStyle(fontSize: 13), textAlign: TextAlign.start),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () => Get.toNamed(Config.MENU_ROUTE, arguments: {
        'restaurantId': restaurantId, 
        'menuId': menu.id,
        'menu': menu.toJson()
      })
    );
  }

  // Widget _buildNotAvailableMenu() {
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 20),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Flexible(
  //           child: Container(
  //             width: 180,
  //             height: 200,
  //             decoration: BoxDecoration(
  //               image: DecorationImage(
  //                 image: AssetImage(Config.PNG_PATH + 'burger.png'),
  //                 fit: BoxFit.cover
  //               ),
  //             ),
  //             child: Container(
  //               color: Colors.white.withOpacity(0.5),
  //               alignment: Alignment.center,
  //               child: Container(
  //                 alignment: Alignment.center,
  //                 height: 20,
  //                 width: Get.width,
  //                 color: Colors.black,
  //                 child: Text('Not Available', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(Config.LETSBEE_COLOR).withOpacity(1.0))),
  //               ),
  //             ),
  //           ),
  //         ),
  //         Container(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Container(
  //                 margin: EdgeInsets.only(left: 10, right: 10, top: 10),
  //                 child: Text('Classic Burger', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
  //               ),
  //               Container(
  //                 alignment: Alignment.centerLeft,
  //                 margin: EdgeInsets.only(left: 10, right: 10),
  //                 child: Text('₱ 200.00', style: TextStyle(fontSize: 13), textAlign: TextAlign.start),
  //               )
  //             ],
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildHotMenu() {
  //   return GestureDetector(
  //     child: Container(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Flexible(
  //             child: Stack(
  //               alignment: FractionalOffset.topRight,
  //               children: [
  //                 Hero(
  //                   tag: 'hot_item',
  //                   child: Container(
  //                     width: 180,
  //                     height: 200,
  //                     decoration: BoxDecoration(
  //                       image: DecorationImage(
  //                         image: AssetImage(Config.PNG_PATH + 'burger.png'),
  //                         fit: BoxFit.cover
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 Banner(
  //                   message: 'HOT!',
  //                   textDirection: TextDirection.ltr,
  //                   color: Colors.red,
  //                   location: BannerLocation.topEnd,
  //                 ),
  //               ],
  //             )
  //           ),
  //           Container(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Container(
  //                   margin: EdgeInsets.only(left: 10, right: 10, top: 10),
  //                   child: Text('Classic Burger', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
  //                 ),
  //                 Container(
  //                   alignment: Alignment.centerLeft,
  //                   margin: EdgeInsets.only(left: 10, right: 10),
  //                   child: Text('₱ 200.00', style: TextStyle(fontSize: 13), textAlign: TextAlign.start),
  //                 )
  //               ],
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //     onTap: () => Get.toNamed(Config.MENU_ROUTE),
  //   );
  // }
}