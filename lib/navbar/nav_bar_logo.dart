import 'package:flutter/material.dart';

class NavBarLogo extends StatelessWidget {
  const NavBarLogo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Image.asset(
        "images/jsondecodes_icon.png",
        fit: BoxFit.contain,
      ),
    );
  }
}
