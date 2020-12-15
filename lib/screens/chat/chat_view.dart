import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/screens/chat/chat_controller.dart';

class ChatPage extends GetView<ChatController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bee Driver: Juan B.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            Text('0001 - 0000001 - Honda ABNC 123', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12)),
          ],
        ),
        centerTitle: false,
        leading: IconButton(icon: Image.asset(Config.PNG_PATH + 'back_button.png'), onPressed: () => Get.back())
      ),
      body: Container(
        height: Get.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.only(bottom: 10),
              child: Text('Army Navy Burger + Burrito - SM CLARK', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
            Container(color: Colors.grey, width: Get.width, height: 1),
            Flexible(
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildChatItem(type: 'rider'),
                      _buildChatItem(type: 'client'),
                      _buildChatItem(type: 'rider'),
                      _buildChatItem(type: 'rider'),
                      _buildChatItem(type: 'rider'),
                      _buildChatItem(type: 'client'),
                      _buildChatItem(type: 'rider'),
                      _buildChatItem(type: 'client')
                    ],
                  )
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey)
                )
              ),
              padding: EdgeInsets.all(5),
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
                  IconButton(icon: Icon(Icons.send), onPressed: controller.sendMessage)
                ],
              )
            )
          ],
        ),
      ),
    );
  }

  Widget _buildChatItem({String type}) {
    return type == 'rider' ? Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Juan B:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
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
                Text('Test Test Test Test Test Test Test Test Test Test Test Test', style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal), textAlign: TextAlign.left,),
                Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('November 3, 2020 12:00 PM', style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic)),
                )
              ],
            ),
          )
        ],
      ),
    ) : 
    Container(
      padding: EdgeInsets.all(10),
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
                Text('Test Test Test Test Test Test Test Test Test Test Test Test', style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal), textAlign: TextAlign.right),
                Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('November 3, 2020 12:00 PM', style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}