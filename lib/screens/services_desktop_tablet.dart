// ignore_for_file: unused_local_variable

import 'package:canaan_portfolio/custom%20paint/custom_paint.dart';
import 'package:canaan_portfolio/onHover.dart';
import 'package:canaan_portfolio/random_moving_shapes.dart';
import 'package:canaan_portfolio/size_config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ServicesPageDesktopTab extends StatefulWidget {
  const ServicesPageDesktopTab({Key? key}) : super(key: key);

  @override
  _ServicesPageDesktopTabState createState() => _ServicesPageDesktopTabState();
}

class _ServicesPageDesktopTabState extends State<ServicesPageDesktopTab> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        var textAlignment =
            sizingInformation.deviceScreenType == DeviceScreenType.desktop
                ? TextAlign.left
                : TextAlign.left;
        double titleSize =
            sizingInformation.deviceScreenType == DeviceScreenType.tablet
                ? 50
                : 80;
        double descriptionSize =
            sizingInformation.deviceScreenType == DeviceScreenType.mobile
                ? 16
                : 21;
        return Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 50.0),
              width: SizeConfig.sW! * 160,
              child: Column(
                children: [
                  Text(
                    "What i do",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                  ),
                  Text(
                    "My Services",
                    style: Theme.of(context).textTheme.headline5!,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  //for DesktopView //
                  ///
                  ///
                  sizingInformation.isDesktop
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: FancyCard(
                                height: 300,
                                height2: 290,
                                width: 360,
                                iconContainer: 80,
                                color: Theme.of(context).secondaryHeaderColor,
                                icon: FontAwesomeIcons.mobileAlt,
                                iconSize: 40,
                                title: "Mobile Development",
                                body:
                                    "I use the best frameworks to build beautiful and responsive mobile/ios applications tailored to meet customer's specification as well as attract visitors.",
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: FancyCard(
                                height: 300,
                                height2: 290,
                                width: 360,
                                iconContainer: 80,
                                color: Color(0xFF39BD9C),
                                icon: Icons.web,
                                iconSize: 40,
                                title: "Website Development",
                                body:
                                    "I use various web technologies to develop attractive websites which converts visitors to customers. I develop creative and responsive website layouts.",
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: FancyCard(
                                height: 300,
                                height2: 290,
                                width: 360,
                                iconContainer: 80,
                                color: Color(0xFF8838B4),
                                icon: FontAwesomeIcons.mobile,
                                iconSize: 40,
                                title: "Website Design",
                                body:
                                    "I use various web technologies to develop attractive websites which converts visitors to customers. I develop creative and responsive website layouts.",
                              ),
                            ),
                          ],
                        )
                      :

                      ///for Tablet Vieww
                      Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FancyCard(
                              height: 300,
                              height2: 290,
                              width: 360,
                              iconContainer: 80,
                              color: Theme.of(context).secondaryHeaderColor,
                              icon: FontAwesomeIcons.mobileAlt,
                              iconSize: 40,
                              title: "Mobile Development",
                              body:
                                  "I use the best frameworks to build beautiful and responsive mobile/ios applications tailored to meet customer's specification as well as attract visitors.",
                            ),
                            SizedBox(
                              height: 50.0,
                            ),
                            FancyCard(
                              height: 300,
                              height2: 290,
                              width: 360,
                              iconContainer: 80,
                              color: Color(0xFF39BD9C),
                              icon: Icons.web,
                              iconSize: 40,
                              title: "Website Development",
                              body:
                                  "I use various web technologies to develop attractive websites which converts visitors to customers. I develop creative and responsive website layouts.",
                            ),
                            SizedBox(
                              height: 50.0,
                            ),
                            FancyCard(
                              height: 300,
                              height2: 290,
                              width: 360,
                              iconContainer: 80,
                              color: Color(0xFF8838B4),
                              icon: FontAwesomeIcons.mobile,
                              iconSize: 40,
                              title: "Website Design",
                              body:
                                  "I use various web technologies to develop attractive websites which converts visitors to customers. I develop creative and responsive website layouts.",
                            ),
                          ],
                        ),
                  Container(
                    margin: EdgeInsets.only(top: 120.0, bottom: 100),
                    width: SizeConfig.sW! * 160,
                    child: Column(
                      children: [
                        Text(
                          "Work Flow",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                color: Theme.of(context).secondaryHeaderColor,
                              ),
                        ),
                        Text(
                          "My Work Process",
                          style: Theme.of(context).textTheme.headline5!,
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        //For Desktop View
                        ///
                        ///
                        sizingInformation.isDesktop
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FancyCardSmall(
                                    height: 200,
                                    height2: 200,
                                    width: 210,
                                    iconContainer: 20,
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    icon: FontAwesomeIcons.mobileAlt,
                                    iconSize: 28,
                                    title: "Development",
                                    body:
                                        "I conduct user research to identify the problem I want to solve.",
                                  ),
                                  FancyCardSmall(
                                    height: 200,
                                    height2: 200,
                                    width: 210,
                                    color: Colors.green,
                                    icon: Icons.web,
                                    iconContainer: 20,
                                    iconSize: 28,
                                    title: "Development",
                                    body:
                                        "I conduct user research to identify the problem I want to solve.",
                                  ),
                                  FancyCardSmall(
                                    height: 200,
                                    height2: 200,
                                    width: 210,
                                    iconContainer: 20,
                                    color: Color(0xFF39BD9C),
                                    icon: FontAwesomeIcons.mobile,
                                    iconSize: 28,
                                    title: "Design",
                                    body:
                                        "I conduct user research to identify the problem I want to solve.",
                                  ),
                                  FancyCardSmall(
                                    height: 200,
                                    height2: 200,
                                    width: 210,
                                    color: Colors.green,
                                    icon: Icons.web,
                                    iconContainer: 20,
                                    iconSize: 28,
                                    title: "Development",
                                    body:
                                        "I conduct user research to identify the problem I want to solve.",
                                  ),
                                  FancyCardSmall(
                                    height: 200,
                                    height2: 200,
                                    width: 210,
                                    iconContainer: 20,
                                    color: Color(0xFF8838B4),
                                    icon: FontAwesomeIcons.mobile,
                                    iconSize: 28,
                                    title: "Design",
                                    body:
                                        "I conduct user research to identify the problem I want to solve.",
                                  ),
                                ],
                              )
                            //for Tablet View
                            : GridView(
                                padding: EdgeInsets.only(top: 10),
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      (sizingInformation.screenSize.width >=
                                              700)
                                          ? 3
                                          : 2,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                ),
                                children: [
                                  FancyCardSmall(
                                    height: 200,
                                    height2: 200,
                                    width: 210,
                                    iconContainer: 20,
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    icon: FontAwesomeIcons.mobileAlt,
                                    iconSize: 28,
                                    title: "Development",
                                    body:
                                        "I conduct user research to identify the problem I want to solve.",
                                  ),
                                  FancyCardSmall(
                                    height: 200,
                                    height2: 200,
                                    width: 210,
                                    color: Colors.green,
                                    icon: Icons.web,
                                    iconContainer: 20,
                                    iconSize: 28,
                                    title: "Development",
                                    body:
                                        "I conduct user research to identify the problem I want to solve.",
                                  ),
                                  FancyCardSmall(
                                    height: 200,
                                    height2: 200,
                                    width: 210,
                                    iconContainer: 20,
                                    color: Color(0xFF39BD9C),
                                    icon: FontAwesomeIcons.mobile,
                                    iconSize: 28,
                                    title: "Design",
                                    body:
                                        "I conduct user research to identify the problem I want to solve.",
                                  ),
                                  FancyCardSmall(
                                    height: 200,
                                    height2: 200,
                                    width: 210,
                                    color: Colors.green,
                                    icon: Icons.web,
                                    iconContainer: 20,
                                    iconSize: 28,
                                    title: "Development",
                                    body:
                                        "I conduct user research to identify the problem I want to solve.",
                                  ),
                                  FancyCardSmall(
                                    height: 200,
                                    height2: 200,
                                    width: 210,
                                    iconContainer: 20,
                                    color: Color(0xFF8838B4),
                                    icon: FontAwesomeIcons.mobile,
                                    iconSize: 28,
                                    title: "Design",
                                    body:
                                        "I conduct user research to identify the problem I want to solve.",
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            RandomMovingShape(
              minX: SizeConfig.sW!.toInt() * 70,
              minY: SizeConfig.sH!.toInt() * 20,
              painter: Circle(
                color: Theme.of(context).primaryColor,
              ),
              radius: BorderRadius.zero,
              color: Theme.of(context).primaryColor,
              curve: Curves.slowMiddle,
              maxY: SizeConfig.sH!.toInt() * 140,
              maxX: SizeConfig.sW!.toInt() * 100,
            ),
            RandomMovingShape(
              minX: SizeConfig.sW!.toInt() * 60,
              minY: SizeConfig.sH!.toInt() * 50,
              painter: StarPainter(
                  color: Theme.of(context).primaryColorLight, isFilled: true),
              radius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50)),
              color: Theme.of(context).primaryColorLight,
              curve: Curves.fastOutSlowIn,
              maxY: SizeConfig.sH!.toInt() * 140,
              maxX: SizeConfig.sW!.toInt() * 100,
            ),
            RandomMovingShape(
              minX: SizeConfig.sW!.toInt() * 20,
              minY: SizeConfig.sH!.toInt() * 80,
              painter: Rectangle(
                color: Color(0xFF8838B4),
              ),
              radius: BorderRadius.zero,
              color: Color(0xFF8838B4),
              curve: Curves.slowMiddle,
              maxY: SizeConfig.sH!.toInt() * 140,
              maxX: SizeConfig.sW!.toInt() * 100,
            ),
            RandomMovingShape(
              minX: SizeConfig.sW!.toInt() * 60,
              minY: SizeConfig.sH!.toInt() * 60,
              painter: DrawTriangleShape(
                color: Colors.green,
              ),
              radius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50)),
              color: Colors.green,
              curve: Curves.fastOutSlowIn,
              maxY: SizeConfig.sH!.toInt() * 140,
              maxX: SizeConfig.sW!.toInt() * 100,
            ),
            RandomMovingShape(
              minX: SizeConfig.sW!.toInt() * 60,
              minY: SizeConfig.sH!.toInt() * 30,
              painter: StarPainter(color: Color(0xFF39BD9C), isFilled: false),
              radius: BorderRadius.circular(50),
              curve: Curves.decelerate,
              color: Color(0xFF39BD9C),
              maxY: SizeConfig.sH!.toInt() * 140,
              maxX: SizeConfig.sW!.toInt() * 100,
            ),
          ],
        );
      },
    );
  }
}

class FancyCard extends StatelessWidget {
  final double? height;
  final double? height2;
  final double? width;
  final IconData? icon;
  final Color? color;
  final String title;
  final String body;
  final double? iconContainer;
  final double? iconSize;
  FancyCard({
    Key? key,
    this.height,
    this.height2,
    this.width,
    this.icon,
    this.color,
    required this.title,
    required this.body,
    this.iconSize,
    this.iconContainer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OnHover(builder: (isHovered) {
      final containerColor = isHovered
          ? Theme.of(context).primaryColorLight
          : Theme.of(context).backgroundColor;
      return Stack(
        alignment: Alignment.center,
        children: [
          Card(
            elevation: 10,
            semanticContainer: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                  10.0,
                ),
                topRight: Radius.circular(
                  10.0,
                ),
                bottomLeft: Radius.circular(
                  10.0,
                ),
                bottomRight: Radius.circular(
                  10.0,
                ),
              ),
            ),
            child: Container(
              height: height,
              width: width!,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: color,
              ),
            ),
          ),
          InkWell(
            hoverColor: Theme.of(context).primaryColorLight,
            child: Container(
              padding:
                  EdgeInsets.only(left: 25, top: 16, bottom: 35, right: 25),
              height: height2,
              width: width! - 12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    10.0,
                  ),
                  topRight: Radius.circular(
                    10.0,
                  ),
                  bottomLeft: Radius.circular(
                    10.0,
                  ),
                  bottomRight: Radius.circular(
                    10.0,
                  ),
                ),
                color: containerColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: iconContainer,
                    width: iconContainer,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(80)),
                      color: color!.withOpacity(0.3),
                    ),
                    child: Icon(
                      icon,
                      size: iconSize,
                      color: color,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    body,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}

class FancyCardSmall extends StatelessWidget {
  final double? height;
  final double? height2;
  final double? width;
  final IconData? icon;
  final Color? color;
  final String title;
  final String body;
  final double? iconContainer;
  final double? iconSize;
  FancyCardSmall({
    Key? key,
    this.height,
    this.height2,
    this.width,
    this.icon,
    this.color,
    required this.title,
    required this.body,
    this.iconSize,
    this.iconContainer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OnHover(builder: (isHovered) {
      final containerColor = isHovered
          ? Theme.of(context).primaryColorLight
          : Theme.of(context).backgroundColor;
      return Stack(
        alignment: Alignment.center,
        children: [
          Card(
            elevation: 10,
            semanticContainer: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                  10.0,
                ),
                topRight: Radius.circular(
                  10.0,
                ),
                bottomLeft: Radius.circular(
                  10.0,
                ),
                bottomRight: Radius.circular(
                  10.0,
                ),
              ),
            ),
            child: Container(
              height: height,
              width: width!,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: color,
              ),
            ),
          ),
          InkWell(
            hoverColor: Theme.of(context).primaryColorLight,
            child: Container(
              padding:
                  EdgeInsets.only(left: 15, top: 16, bottom: 30, right: 15),
              height: height2! - 4,
              width: width! - 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    10.0,
                  ),
                  topRight: Radius.circular(
                    10.0,
                  ),
                  bottomLeft: Radius.circular(
                    10.0,
                  ),
                  bottomRight: Radius.circular(
                    10.0,
                  ),
                ),
                color: containerColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    icon,
                    size: iconSize,
                    color: color,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    body,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
