import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/models/restaurant.dart';
import 'package:letsbeeclient/screens/food/menu/menu_controller.dart';
import 'package:loading_gifs/loading_gifs.dart';

class MenuPage extends GetView<MenuController> {
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => controller.onWillPopBack(),
      child: Scaffold(
        body: GetX<MenuController>(
          builder: (_) {
            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    leading: IconButton(icon: Image.asset(Config.PNG_PATH + 'back_button.png'), onPressed: () => Get.back()),
                    expandedHeight: 280.0,
                    floating: true,
                    pinned: true,
                    forceElevated: innerBoxIsScrolled,
                    backgroundColor: Color(Config.WHITE),
                    elevation: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: _.menu.call() != null ? Column(
                        children: [
                         Container(
                            margin: EdgeInsets.only(top: 40),
                            alignment: Alignment.center,
                            child: Hero(
                              tag: _.menu.call().name.toString(),
                              child: Container(
                                alignment: Alignment.center,
                                child: Container(
                                  width: 140,
                                  height: 150,
                                  child: FadeInImage.assetNetwork(placeholder: cupertinoActivityIndicatorSmall, image: _.menu.call().image.toString(), fit: BoxFit.fitWidth, placeholderScale: 5, imageErrorBuilder: (context, error, stackTrace) => Center(child: Icon(Icons.image_not_supported_outlined, size: 35))),
                                ),
                              ),
                            )
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(_.menu.call().name.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text('₱ ${_.menu.call().price}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),textAlign: TextAlign.start),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  child: Text(_.menu.call().description.toString(), style: TextStyle(fontSize: 15),textAlign: TextAlign.start),
                                ),
                                Container(width: Get.width, height: 3,color: Colors.grey.withOpacity(0.3), margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5)),
                              ],
                            ),
                          )
                        ],
                      ) : Container(),
                    ),
                  ),
                ];
              },
              body: RefreshIndicator(
                onRefresh: () {
                  if (_.argument['type'] == 'edit') {
                    _.fetchMenuById();
                    return _.refreshCompleter.future;
                  } else {
                    return Future.value(false);
                  }
                },
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: _.menu.call() != null ? Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Column(
                            children: [
                              _.menu.call().choices != null ? Column(
                                children: _.menu.call().choices.map((e) => _buildRequiredItem(e)).toList()
                              ) : Container(),
                              _.menu.call().additionals != null ? Column(
                                children: _.menu.call().additionals.map((e) => _buildOptionalItem(e)).toList()
                              ) : Container()
                            ],  
                          ),
                        ),
                        _.menu.call().id != 0 ?
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                child: Text('Special Request:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: TextFormField(
                                  controller: _.tFRequestController,
                                  enabled: !_.isAddToCartLoading.call(),
                                  decoration: InputDecoration(
                                    hintText: 'Type something...',
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
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                     Text('Quantity:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                                     IgnorePointer(
                                       ignoring: _.isAddToCartLoading.call(),
                                       child: Container(
                                        child: Row(
                                          children: [
                                            IconButton(icon: Icon(Icons.remove), onPressed: () =>_.decrement()),
                                            Container(
                                              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.symmetric(horizontal: 12),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color: Colors.grey.shade200
                                              ),
                                              child: Text('${_.countQuantity.call()}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                            ),
                                            IconButton(icon: Icon(Icons.add), onPressed: () => _.increment()),
                                          ],
                                        ),
                                      ),
                                     )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ) : Container(),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                          width: Get.width,
                          child: RaisedButton(
                            color: Color(Config.LETSBEE_COLOR),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: _.isAddToCartLoading.call() ? Container(height: 10, width: 10, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black))) : Text(_.argument['type'] == 'edit' ? 'DONE EDITING' : 'ADD TO CART', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15))
                            ),
                            onPressed: () => _.isAddToCartLoading.call() ? null : _.addToCart(),
                          ),
                        )
                      ],
                    ),
                  ) : Container(alignment: Alignment.topCenter, child: Center(child: _.isLoading.call() ? CupertinoActivityIndicator() : Text(_.message.call(), style: TextStyle(fontSize: 20))))
                ) 
              )
            );
          },
        )
      ),
    );
  }


  Widget _buildRequiredItem(Choice choice) {
    return GetX<MenuController>(
      builder: (_) {
        return Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${choice.name}:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(Config.LETSBEE_COLOR),
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Text('Required', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: choice.options.map((e) {
                    return IgnorePointer(
                        ignoring: _.isAddToCartLoading.call(),
                        child: RadioListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: Text(e.name)),
                            Text(e.price == '0.00' ? '' : '(₱ ${e.price})', style: TextStyle(color: Colors.black.withOpacity(0.35)),)
                          ],
                        ),
                        value: e.name,
                        groupValue: e.selectedValue,
                        onChanged: (value) => controller.updateSelectedChoice(choice.id, e.name)
                      ),
                    );
                  }).toList(),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionalItem(Additional additional) {
    return GetX<MenuController>(
      builder: (_) {
        return Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${additional.name}:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Text('Optional', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: additional.options.map((e) {
                    return IgnorePointer(
                      ignoring: _.isAddToCartLoading.call(),
                      child: CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: Text(e.name)),
                            Text('(₱ ${e.price})', style: TextStyle(color: Colors.black.withOpacity(0.35)),)
                          ],
                        ),
                        value: e.selectedValue, 
                        onChanged: (value) {
                          controller.updateSelectedAdditional(additional.id, e.name);
                        },
                      ),
                    );
                  }).toList(),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}