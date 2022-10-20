import 'package:canaan_portfolio/navbar/nav_bar_item.dart';
import 'package:canaan_portfolio/navbar/nav_bar_logo.dart';
import 'package:canaan_portfolio/size_config.dart';
import 'package:flutter/material.dart';

class NavigationBarTabletDesktop extends StatelessWidget {
  final Function()? function;
  const NavigationBarTabletDesktop({Key? key, this.function}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            NavBarLogo(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                
                NavBarItem(
                  text: "Home",
                  function: () {},
                ),
                SizedBox(
                  width: SizeConfig.sW! * 2,
                ),
                NavBarItem(
                  text: "About",
                  function: () {},
                ),
                SizedBox(
                  width: SizeConfig.sW! * 2,
                ),
                NavBarItem(
                  text: "Services",
                  function: () {},
                ),
                SizedBox(
                  width: SizeConfig.sW! * 2,
                ),
                NavBarItem(
                  text: "Portfolio",
                  function: () {},
                ),
                SizedBox(
                  width: SizeConfig.sW! * 2,
                ),
                NavBarItem(
                  text: "Contact",
                  function: () {},
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                "Hire Me",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ));
  }
}
