import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/models/store_response.dart';
import 'package:letsbeeclient/screens/food/store_menu/store_menu_controller.dart';
import 'package:flutter/material.dart';
import 'package:loading_gifs/loading_gifs.dart';

class StoreMenuPage extends GetView<StoreMenuController> {
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => controller.onWillPopBack(),
      child: Scaffold(
        body: GetX<StoreMenuController>(
          builder: (_) {
            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    leading: IconButton(icon: Image.asset(Config.PNG_PATH + 'back_button.png'), onPressed: () => Get.back(closeOverlays: true)),
                    expandedHeight: 280.0,
                    floating: true,
                    pinned: true,
                    forceElevated: innerBoxIsScrolled,
                    backgroundColor: Color(Config.WHITE),
                    elevation: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: _.product.call() != null ? Column(
                        children: [
                         Container(
                            margin: EdgeInsets.only(top: 40),
                            alignment: Alignment.center,
                            child: Hero(
                              tag: _.product.call().name,
                              child: Container(
                                alignment: Alignment.center,
                                child: Container(
                                  width: 140,
                                  height: 150,
                                  child: FadeInImage.assetNetwork(placeholder: cupertinoActivityIndicatorSmall, image: _.product.call().image, fit: BoxFit.fitWidth, placeholderScale: 5, imageErrorBuilder: (context, error, stackTrace) => Center(child: Icon(Icons.image_not_supported_outlined, size: 35))),
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
                                  child: Text(_.product.call().name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text('₱ ${_.product.call().customerPrice}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),textAlign: TextAlign.start),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  child: Text(_.product.call().description, style: TextStyle(fontSize: 15),textAlign: TextAlign.start),
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
              body: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: _.product.call() != null ? Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: [
                            _.product.call().choices.isNotEmpty ? Column(
                              children: _.product.call().choices.map((e) => _buildRequiredItem(e)).toList()
                            ) : Container(),
                            _.product.call().additionals.isNotEmpty ? Column(
                              children: [
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Adds-On:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
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
                              Column(
                                  children: _.product.call().additionals.map((e) => _buildOptionalItem(e)).toList()
                                ),
                              ],
                            ) : Container()
                          ],  
                        ),
                      ),
                      _.product.call().id != 0 ?
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
                ) : Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CupertinoActivityIndicator(radius: 20),
                      Text(_.message.call()),
                      _.hasError.call() ? RaisedButton(
                        color: Color(Config.LETSBEE_COLOR),
                        child: Text('Refresh'),
                        onPressed: () => _.fetchProductById(),
                      ) : Container()
                    ],
                  ),
                )
              ) 
            );
          },
        )
      ),
    );
  }

  Widget _buildRequiredItem(Choice choice) {
    return GetX<StoreMenuController>(
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
                            Text(e.price == 0.00 ? '' : '(₱ ${e.customerPrice})', style: TextStyle(color: Colors.black.withOpacity(0.35)),)
                          ],
                        ),
                        value: e.name,
                        groupValue: choice.choiceDefault,
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
    return GetX<StoreMenuController>(
      builder: (_) {
        return Container(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: IgnorePointer(
              ignoring: _.isAddToCartLoading.call(),
              child: CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Text(additional.name)),
                  Text('(₱ ${additional.customerPrice})', style: TextStyle(color: Colors.black.withOpacity(0.35)),)
                ],
              ),
                value: !additional.status, 
                onChanged: (value) => _.updateSelectedAdditional(additional.id, additional.name),
              ),
            ),
          ),
        );
      },
    );
  }
}