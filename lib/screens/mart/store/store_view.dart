import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/screens/mart/store/store_controller.dart';

class StorePage extends GetView<StoreController> {

  @override Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<StoreController>(
        builder: (_) {
          return NestedScrollView(
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
                      backgroundColor: Colors.white,
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
                        tabs: [
                          Tab(
                            child: Container(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text('Shampoo'),
                              ),
                            )
                          ),
                          Tab(
                            child: Container(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text('Soap'),
                              ),
                            )
                          ),
                          Tab(
                            child: Container(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text('Liquor'),
                              ),
                            )
                          )
                        ],
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
                                    child: Image.asset(Config.PNG_PATH + 'banner.png', fit: BoxFit.cover, width: Get.width),
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
                                        Text('Puregold Jr.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                        Text('Balibago', style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal))
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Positioned(
                              top: 160.0,
                              child: Container(
                                margin: EdgeInsets.only(left: 20),
                                height: 70.0,
                                width: 70.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(width: 2),
                                  color: Colors.white
                                ),
                                child: ClipOval(
                                  child: Image.asset(Config.PNG_PATH + 'banner.png', fit: BoxFit.cover)
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ];
            },
            body: GetBuilder<StoreController>(
              builder: (_) {
                return Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _.tabController,
                      children: [
                        _buildCategoryItem(0),
                        _buildCategoryItem(1),
                        _buildCategoryItem(2)
                      ],
                    ),
                    Container(
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
                                badgeContent: Text('1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                showBadge: true,
                                padding: EdgeInsets.all(10),
                              )
                            ],
                          ),
                          onPressed: () => print('CART'),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryItem(int index) {
    return Container(
      child: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 10)),
          Container(
            height: 35,
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
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
          ),
          Expanded(
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                index == 0 ? _buildItem(itemName: 'Palmolive') : index != 2 ? _buildItem(itemName: 'Safeguard') :  Container(),
                index == 0 ? _buildItem(itemName: 'Dove Shampoo') : index != 2 ? _buildItem(itemName: 'Lux') :  Container(),
                index == 0 ? _buildItem(itemName: 'Sunsilk') : index == 2 ? _buildItem(itemName: 'Henessy') :  Container(),
                index == 0 ? Container() : index == 2 ? _buildItem(itemName: 'Jack Daniel') :  Container(),
                index == 0 ? Container() : index == 2 ? _buildItem(itemName: 'Red Horse') :  Container(),
                index == 0 ? Container() : index == 2 ? _buildItem(itemName: 'San Miguel') :  Container(),
                index == 0 ? Container() : index == 2 ? _buildItem(itemName: 'Smirnoff') :  Container(),
              ]
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem({String itemName}) {
    return GestureDetector(
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
                        child: Text(itemName, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text('Lorem Ipsum', style: TextStyle(fontSize: 13 ,fontWeight: FontWeight.normal), textAlign: TextAlign.start),
                      )
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(top: 10),
                    child: Text('₱ 100.0', style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal), textAlign: TextAlign.start),
                  )
                ],
              ),
            ),
            Image.asset(Config.PNG_PATH + 'banner.png', fit: BoxFit.fitWidth, height: 120, width: 140)
          ],
        ),
      ),
      onTap: () => addCartDialog(itemName: itemName)
    );
  }

  addCartDialog({String itemName}) {
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
              child: Image.asset(Config.PNG_PATH + 'banner.png', fit: BoxFit.fitHeight),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            Text(itemName, style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.normal)),
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
      confirm: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        color: Color(Config.LETSBEE_COLOR).withOpacity(1.0),
        child: Text('Add to cart', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
        onPressed: () => Get.back(),
      ),
      cancel: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        color: Color(Config.LETSBEE_COLOR).withOpacity(1.0),
        child: Text('Back', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
        onPressed: () => Get.back(),
      ),
    );
  }
}