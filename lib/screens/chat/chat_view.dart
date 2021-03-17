import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/chat_response.dart';
import 'package:letsbeeclient/screens/chat/chat_controller.dart';
import 'package:intl/intl.dart';

class ChatPage extends GetView<ChatController> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => dismissKeyboard(Get.context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(tr('messageRider'), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          centerTitle: true,
          leading: IconButton(icon: Icon(Icons.chevron_left), onPressed: () => controller.goBack()),
          bottom: PreferredSize(
            child: Container(height: 1, color: Colors.grey.shade200),
            preferredSize: Size.fromHeight(4.0)
          ),
        ),
        body: Container(
          height: Get.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildRiderDetails(),
              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              Container(height: 1, color: Colors.grey.shade200),
              GetX<ChatController>(
                builder: (_) {
                  return AnimatedContainer(
                    width: double.infinity,
                    color: _.dashboardController.color.call(),
                    duration: Duration(milliseconds: 500),
                    height: _.dashboardController.isConnected.call() ? 0 : 25,
                    child: Center(
                      child: Text(_.dashboardController.connectMessage.call(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    )
                  );
                },
              ),
              Expanded(
                child: GetX<ChatController>(
                  builder: (_) {
                    return _.isLoading.call() ? Center(child: Text(_.message.call(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))) : 
                    _.chat.call().isEmpty ? Column(
                        children: [
                          Center(child: Text(_.message.call(), style: TextStyle(fontSize: 18))),
                          RaisedButton(
                            color: Color(Config.LETSBEE_COLOR),
                            child: Text(tr('refresh')),
                            onPressed: () => _.fetchOrderChats(),
                          )
                        ],
                      ) : SingleChildScrollView(
                      reverse: true,
                      controller: _.scrollController,
                      child: Column(
                        children: [
                          _.chat.call() == null || _.chat.call().isEmpty ? Container() : Column(
                            children: _.chat.call().map((e) => _buildChatItem(e)).toList(),
                          ),
                          // IconButton(icon: Icon(Icons.arrow_circle_up_outlined), onPressed: () => print('Go back on top'))
                        ],
                      )
                    );
                  },
                ),
              ),
              GetX<ChatController>(
                builder: (_) {
                  return IgnorePointer(
                    ignoring: _.isLoading.call(),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.grey)
                        )
                      ),
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(15)
                              ),
                              child: IgnorePointer(
                                ignoring: _.isSending.call(),
                                child: TextFormField(
                                  controller: controller.replyTF,
                                  decoration: InputDecoration(
                                    hintText: tr('enterMessage'),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(12.0)
                                  ),
                                  autocorrect: false,
                                  cursorColor: Colors.black,
                                  maxLines: 5,
                                  minLines: 1,
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.done,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 10),
                            child: IconButton(icon: Icon(Icons.send, size: 30), onPressed: () => controller.sendMessageToRider()),
                          )
                        ],
                      )
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRiderDetails() {
    return Obx(() {
      return controller.activeOrderData.call().rider != null ? Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('${tr('yourRider')}:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12)),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
                    Text(controller.activeOrderData.call().rider.user.name, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12)),
                  ],
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 3)),
                Row(
                  children: [
                    Text('${controller.activeOrderData.call().rider.motorcycleDetails.brand} -', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12)),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
                    Text('${controller.activeOrderData.call().rider.motorcycleDetails.model} -', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12)),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
                    Text('${controller.activeOrderData.call().rider.motorcycleDetails.plateNumber} -', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12)),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
                    Text('${controller.activeOrderData.call().rider.motorcycleDetails.color}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12)),
                  ],
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 3)),
                Text(controller.activeOrderData.call().rider.user.number, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12)),
              ],
            ),
          ],
        ),
      ) : Container();
    });
  }

  Widget _buildChatItem(ChatData data) {
    return GetX<ChatController>(
      builder: (_) {
        return data.userId == _.activeOrderData.call().rider.userId ? Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                constraints: BoxConstraints(
                  maxWidth: Get.width * 0.7,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15), bottomRight: Radius.circular(15)),
                  color: Color(Config.LETSBEE_COLOR),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.message, style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal), textAlign: TextAlign.left,),
                    Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(DateFormat('MMMM dd, yyyy (hh:mm a)').format(data.createdAt.toUtc().toLocal()), style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic)),
                    )
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 3)),
              Text('${_.activeOrderData.call().rider.user.name}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            ],
          ),
        ) : 
        Container(
          padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
          alignment: Alignment.centerRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                constraints: BoxConstraints(
                  maxWidth: Get.width * 0.7,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.message, style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal), textAlign: TextAlign.left),
                    Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(DateFormat('MMMM dd, yyyy (hh:mm a)').format(data.createdAt.toUtc().toLocal()), style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic)),
                    ),
                    Column(
                      children: [
                        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(data.isSent ? tr('sent') : tr('sending'), style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 3)),
              Text(tr('customer'), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            ],
          ),
        );
      },
    );
  }
}