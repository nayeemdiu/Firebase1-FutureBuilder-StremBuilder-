import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  String name, img;
   DetailsPage({Key? key,required this.name,required this.img}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar( title:Text(name),centerTitle: true,),
      body: Container(
        height: 500,
        child: Column(
          children: [
                Image.network(img),
          ],
        ),
      ),

    );
  }
}
