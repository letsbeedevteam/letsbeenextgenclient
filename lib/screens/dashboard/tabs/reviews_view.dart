import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';

class ReviewsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SafeArea(
          minimum: EdgeInsets.only(top: 35),
          child: SizedBox(
            height: 35,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 15),
                  hintText: 'Search...',
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide.none
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(height: 1, color: Colors.grey.shade300, margin: EdgeInsets.only(top: 10)),
        Flexible(
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('TOP VIEWS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    height: 200,
                    child:  ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildTopViewItem('1'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('RECENTLY UPLOAD', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    height: 200,
                    child:  ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildRecentlyUploadItem('4'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('UPLOADED PHOTO', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    height: 200,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildUploadedPhotoItem('7'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopViewItem(String tag) {
    return GestureDetector(
      child: Container(
        width: 300,
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Color(Config.LETSBEE_COLOR).withOpacity(1.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Hero(
              tag: tag, 
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Config.PNG_PATH + 'default.png'),
                    fit: BoxFit.cover
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)
                  ),
                ),
              ),
            ),
            Expanded(child: Padding(
              padding: EdgeInsets.all(10),
              child: Text('Vlog with the Team Payaman', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18), overflow: TextOverflow.ellipsis, textAlign: TextAlign.start))
            )
          ],
        )
      ),
      onTap: () => Get.toNamed(Config.REVIEW_DETAIL_ROUTE, arguments: tag),
    );
  }

  Widget _buildRecentlyUploadItem(String tag) {
    return GestureDetector(
      child: Container(
        width: 300,
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Color(Config.LETSBEE_COLOR).withOpacity(1.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: tag, 
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Config.PNG_PATH + 'default.png'),
                    fit: BoxFit.cover
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)
                  ),
                  color: Color(Config.LETSBEE_COLOR).withOpacity(1.0),
                ),
              ),
            ),
            Expanded(child: Padding(
                padding: EdgeInsets.all(10),
                child:  Text('Team Payaman at Let\'s Bee', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18), overflow: TextOverflow.ellipsis, textAlign: TextAlign.start),
              ),
            )
          ],
        )
      ),
      onTap: () => Get.toNamed(Config.REVIEW_DETAIL_ROUTE, arguments: tag),
    );
  }

  Widget _buildUploadedPhotoItem(String tag) {
    return GestureDetector(
      child: Container(
        width: 300,
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Color(Config.LETSBEE_COLOR).withOpacity(1.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: tag, 
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Config.PNG_PATH + 'default.png'),
                    fit: BoxFit.cover
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10, left: 10, top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Team Payaman Dancing budots', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18), overflow: TextOverflow.ellipsis, textAlign: TextAlign.start),
                  Text('November 27, 2020', style: TextStyle(color: Colors.black, fontSize: 15))
                ],
              )
            ),
          ],
        )
      ),
      onTap: () => Get.toNamed(Config.REVIEW_DETAIL_ROUTE, arguments: tag),
    );
  }
}