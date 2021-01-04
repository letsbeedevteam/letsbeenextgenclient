import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/models/chatResponse.dart';
import 'package:letsbeeclient/screens/chat/chat_controller.dart';
import 'package:intl/intl.dart';

class ChatPage extends GetView<ChatController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: GetX<ChatController>(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bee Driver: ${_.activeOrderData.call().rider.user.name}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text('0001 - 0000001 - Honda ABNC 123', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12)),
              ],
            );
          },
        ),
        centerTitle: false,
        leading: IconButton(icon: Image.asset(Config.PNG_PATH + 'back_button.png'), onPressed: () => controller.goBack())
      ),
      body: Container(
        height: Get.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GetX<ChatController>(
              builder: (_) => Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(15),
                child: Text('${_.activeOrderData.call().activeRestaurant.name} - ${_.activeOrderData.call().activeRestaurant.locationName}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
            Container(color: Colors.grey,width: Get.width, height: 1),
            Expanded(
              child: GetX<ChatController>(
                builder: (_) {
                  return SingleChildScrollView(
                    reverse: true,
                    controller: _.scrollController,
                    child: Column(
                      children: [
                        _.chat.call().isNullOrBlank || _.chat.call().isEmpty ? Container() : Column(
                          children: _.chat.call().map((e) => _buildChatItem(e)).toList(),
                        ),
                        // IconButton(icon: Icon(Icons.arrow_circle_up_outlined), onPressed: () => print('Go back on top'))
                      ],
                    )
                  );
                },
              ),
            ),
            Container(
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
                      child: TextFormField(
                        controller: controller.replyTF,
                        decoration: InputDecoration(
                          hintText: 'Enter your message',
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
                  IconButton(icon: Icon(Icons.send), onPressed: controller.sendMessageToRider)
                ],
              )
            ),
          ],
        ),
      ),
    );
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
              Text('${_.activeOrderData.call().rider.user.name}:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              Container(
                padding: EdgeInsets.all(10),
                constraints: BoxConstraints(
                  maxWidth: Get.width * 0.7,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.yellow.shade200,
                  border: Border.all(color: Colors.grey),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 2.0,
                      offset: Offset(3.0, 3.0)
                    )
                  ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.message, style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal), textAlign: TextAlign.left,),
                    Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(DateFormat('MMMM dd, yyyy HH:mm a').format(data.createdAt), style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic)),
                    )
                  ],
                ),
              )
            ],
          ),
        ) : 
        Container(
          padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
          alignment: Alignment.centerRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Me:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              Container(
                padding: EdgeInsets.all(10),
                constraints: BoxConstraints(
                  maxWidth: Get.width * 0.7,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 2.0,
                      offset: Offset(3.0, 3.0)
                    )
                  ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.message, style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal), textAlign: TextAlign.right),
                    Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(DateFormat('MMMM dd, yyyy HH:mm a').format(data.createdAt), style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic)),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}