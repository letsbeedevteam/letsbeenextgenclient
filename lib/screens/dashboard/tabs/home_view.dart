import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    return Column(
      children: [
        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        Text('Search field'),
        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        Flexible(
          child: ListView(
            children: [
              Center(child:  Padding(padding: EdgeInsets.all(10), child:  Text('ITEM'))),
              Center(child:  Padding(padding: EdgeInsets.all(10), child:  Text('ITEM'))),
              Center(child:  Padding(padding: EdgeInsets.all(10), child:  Text('ITEM'))),
              Center(child:  Padding(padding: EdgeInsets.all(10), child:  Text('ITEM'))),
              Center(child:  Padding(padding: EdgeInsets.all(10), child:  Text('ITEM'))),
            ],
          ),
        )
      ],
    );
  }
}