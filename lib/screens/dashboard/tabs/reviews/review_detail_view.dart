import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';

class ReviewDetailPage extends GetView<DashboardController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(icon: Image.asset(Config.PNG_PATH + 'back_button.png'), onPressed: () => Get.back())
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(height: 1, color: Colors.grey.shade300, margin: EdgeInsets.only(bottom: 10)),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Posted by: ', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text('Let\'s Bee', textAlign: TextAlign.start, style: TextStyle(fontStyle: FontStyle.italic, fontSize: 18))
                ],
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                border: Border.all(
                  color: Colors.black
                )
              ),
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Hero(
                    tag: Get.arguments.toString(), 
                    child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)
                      ),
                      image: DecorationImage(
                          image: AssetImage(Config.PNG_PATH + 'default.png'),
                          fit: BoxFit.cover
                        )
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('Lorem IpsumLorem IpsumLorem IpsumLorem IpsumLorem IpsumLorem IpsumLorem IpsumLorem IpsumLorem IpsumLorem IpsumLorem Ipsum', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('November 20, 2020'),
                        Container(
                          child: Row(
                            children: [
                              Text('500', style: TextStyle(fontWeight: FontWeight.bold)),
                              IconButton(icon: Icon(Icons.thumb_up_off_alt), onPressed: () => print('Like')),
                              Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                              Text('100', style: TextStyle(fontWeight: FontWeight.bold)),
                              IconButton(icon: Icon(Icons.thumb_down_off_alt), onPressed: () => print('Dislike')),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlatButton(onPressed: () => print('Like'), child: Text('Like'), minWidth: 0.2),
                  FlatButton(onPressed: () => print('Dislike'), child: Text('Dislike'), minWidth: 0.2),
                  FlatButton(onPressed: () => _buildCommentBottomSheet(postedName: 'Let\'s Bee'), child: Text('Comment'), minWidth: 0.2)
                ],
              )
            ),
            Column(
              children: [
                _buildCommentItem(name: 'Chai', message: 'Sana all!'),
                _buildCommentItem(name: 'Abner', message: 'China oil!'),
                _buildCommentItem(name: 'Gervene', message: 'Sana owl!'),
                _buildCommentItem(name: 'Matthew', message: 'China owl!'),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCommentItem({String name, String message}) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$name:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Container(
            width: Get.width,
            margin: EdgeInsets.only(top: 10, bottom: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.black)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message, style: TextStyle(fontSize: 18)),
                Align(alignment: Alignment.bottomRight, child: Text('November 20, 2020', style: TextStyle(fontSize: 13)))
              ],
            )
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlatButton(onPressed: () => print('Like'), child: Text('Like'), minWidth: 0.2),
                FlatButton(onPressed: () => print('Dislike'), child: Text('Dislike'), minWidth: 0.2),
                FlatButton(onPressed: () => _buildReplyBottomSheet(name: name), child: Text('Reply'), minWidth: 0.2)
              ],
            )
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        ],
      ),
    );
  }

  _buildCommentBottomSheet({@required String postedName}) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15)
          ),
          color: Colors.white
        ),
        height: 200,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Comment to $postedName', style: TextStyle(fontSize:  18, fontWeight: FontWeight.bold)),
              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              TextField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Colors.black
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Colors.black
                    )
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  hintText: 'Type something...'
                ),
                cursorColor: Colors.black,
              )
            ],
          ),
        )
      ),
    );
  }

  _buildReplyBottomSheet({@required String name}) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15)
          ),
          color: Colors.white
        ),
        height: 200,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Replying to: $name', style: TextStyle(fontSize:  18, fontWeight: FontWeight.bold)),
              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              TextField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Colors.black
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Colors.black
                    )
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  hintText: 'Type something...'
                ),
                cursorColor: Colors.black,
              )
            ],
          ),
        )
      ),
    );
  }
}