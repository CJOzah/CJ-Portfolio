
import 'package:canaan_portfolio/navbar/nav_bar_logo.dart';
import 'package:flutter/material.dart';

class NavigationBarMobile extends StatelessWidget {
  const NavigationBarMobile({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(icon: Icon(Icons.menu), onPressed: () {},
              // => Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         // builder: (context) => NavigationBar(controller: null,),
              //       ),
              // )
              ),
          NavBarLogo()
        ],
      ),
    );
  }
}
