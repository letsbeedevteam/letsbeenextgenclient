import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/models/orderHistoryResponse.dart';
import 'package:letsbeeclient/screens/history/historyDetail/history_detail_controller.dart';
import 'package:loading_gifs/loading_gifs.dart';

class HistoryDetailPage extends GetView<HistoryDetailController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                leading: IconButton(icon: Image.asset(Config.PNG_PATH + 'back_button.png'), onPressed: () => Get.back()),
                expandedHeight: 280.0,
                floating: true,
                pinned: true,
                backgroundColor: Colors.white,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  title: GetX<HistoryDetailController>(
                    builder: (_) => Text('${_.data.call().restaurant.name} - ${_.data.call().restaurant.location.name}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                  centerTitle: true,
                  background: GetX<HistoryDetailController>(
                    builder: (_) {
                      return Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Column(
                            children: [
                              Container(
                                height: 200,
                                  child: Center(
                                    child: Container(
                                      width: Get.width,
                                      child: CarouselSlider(
                                      options: CarouselOptions(
                                        autoPlay: false,
                                        disableCenter: true,                                    
                                      ),
                                      items: _.data.call().restaurant.slider.map((item) => FadeInImage.assetNetwork(placeholder: cupertinoActivityIndicatorSmall, image: item.url, fit: BoxFit.fitWidth, placeholderScale: 5, imageErrorBuilder: (context, error, stackTrace) => Center(child: Image.asset(Config.PNG_PATH + 'letsbee_logo.png')))).toList(),
                                    ),
                                  )
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
                                border: Border.all(width: 2),
                                color: Colors.white
                              ),
                              child: ClipOval(
                                child: FadeInImage.assetNetwork(placeholder: cupertinoActivityIndicatorSmall, image: _.data.call().restaurant.logoUrl, placeholderScale: 5, imageErrorBuilder: (context, error, stackTrace) => Center(child: Image.asset(Config.PNG_PATH + 'letsbee_logo.png')))
                              )
                            ),
                          )
                        ],
                      );
                    },
                  )
                ),
              )
            ),
          ];
        },
        body: Builder(builder: (context) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverOverlapInjector(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverToBoxAdapter(
                child: GetX<HistoryDetailController>(
                  builder: (_) {
                    return Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Items', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                          Column(
                            children: _.data.call().menus.map((e) => _buildMenu(e)).toList(),
                          ),
                           _.data.call().fee.discountCode.isNullOrBlank ? Container() :
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Promo Code Used', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                              Align(
                                alignment: Alignment.center,
                                child: Text(_.data.call().fee.discountCode.toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Divider(thickness: 5, color: Colors.grey.shade200),
                              ),
                            ],
                          ),
                          Container(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Sub Total', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Text('₱ ${_.data.call().fee.subTotal.toStringAsFixed(2)}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15))
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Delivery Fee', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Text('₱ ${_.data.call().fee.delivery.toStringAsFixed(2)}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15))
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Promo Code Discount', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Text('₱ ${_.data.call().fee.discountPrice.toStringAsFixed(2)}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15))
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('TOTAL', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                      Text('₱ ${_.data.call().fee.total.toStringAsFixed(2)}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Divider(thickness: 5, color: Colors.grey.shade200),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Mode of Payment', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                              Text('${_.data.call().payment.method.capitalizeFirst}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15))
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Divider(thickness: 5, color: Colors.grey.shade200),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Status', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                _buildStatus()
                              ],
                            ),
                          ),
                          _.data.call().reason.isNullOrBlank ? Container() : Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Divider(thickness: 5, color: Colors.grey.shade200),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Reason', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Text(_.data.call().reason, style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 15))
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Divider(thickness: 5, color: Colors.grey.shade200),
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Delivery Details', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Address: ${_.data.call().address.street} ${_.data.call().address.barangay} ${_.data.call().address.city} ${_.data.call().address.state}', 
                                        style: TextStyle(color: Colors.black, fontSize: 14)
                                      ),
                                      Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                                      Text('Contact Number: +23542345345345', style: TextStyle(color: Colors.black, fontSize: 14))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Divider(thickness: 5, color: Colors.grey.shade200),
                          ),
                        ],
                      ),
                    );
                  },
                )
              ),
            ],
          );
        }),
      )
    );
  }

  Widget _buildStatus() {
    switch (controller.data.call().status) {
      case 'pending': return Text('Pending', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 15));
        break;
      case 'restaurant-accepted': return Text('Restaurant Accepted', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 15));
        break;
      case 'restaurant-declined': return Text('Restaurant Declined', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15));
        break;
      case 'rider-accepted': return Text('Rider Accepted', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 15));
        break;
      case 'rider-picked-up': return Text('Rider picked up', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 15));
        break;
      case 'delivered': return Text('Delivered', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 15));
        break;
      case 'cancelled': return Text('Cancelled', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15));
        break;
      default: return Text('Pending', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 15));
    }
  }

  Widget _buildMenu(OrderHistoryMenu menu) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
              Expanded(
                child: Container(
                  child: Text('${menu.quantity}x ${menu.name}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                ),
              ),
              Text('₱ ${(menu.price * menu.quantity).toStringAsFixed(2)}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18))
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 5, left: 20),
            child: Column(
              children: [
                Column(
                  children: menu.additionals.map((e) => _buildAdditional(e, menu.quantity)).toList()
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                Column(
                  children: menu.choices.map((e) => _buildChoice(e, menu.quantity)).toList(),
                ),
              ],
            )
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            child: Divider(thickness: 5, color: Colors.grey.shade200),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditional(Additional additional, int quantity) {
    return additional.picks.isNotEmpty ? Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${additional.name}:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
        Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
        Expanded(
          child: Column(
            children: additional.picks.map((e) => _buildAddsOn(e, quantity)).toList()
          ),
        ),
      ],
    ) : Container();
  }

  Widget _buildAddsOn(Pick pick, int quantity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            child: Text(pick.name, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13)),
          ),
        ),
        Text('₱ ' + double.parse('${(pick.price * quantity).toStringAsFixed(2)}').toStringAsFixed(2), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
      ],
    );
  }

  Widget _buildChoice(Choice choice, int quantity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: [
              Text('${choice.name}:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
              Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
              Text('${choice.pick}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
            ],
          )
        ),
        Text('₱ ' + double.parse('${(choice.price * quantity).toStringAsFixed(2)}').toStringAsFixed(2), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
      ],
    );
  }
}