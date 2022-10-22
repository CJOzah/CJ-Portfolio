import 'package:canaan_portfolio/screens/HomePage.dart';
import 'package:canaan_portfolio/screens/about_screen.dart';
import 'package:flutter/material.dart';

class HomeContentDesktop extends StatefulWidget {
  @override
  _HomeContentDesktopState createState() => _HomeContentDesktopState();
}

class _HomeContentDesktopState extends State<HomeContentDesktop> {
  List<Widget> myWidgets = [
    HomePage(),
    // AboutScreen(),
  ];


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomePage(),
        // AboutScreen(),
      ],
    );
  }
}
