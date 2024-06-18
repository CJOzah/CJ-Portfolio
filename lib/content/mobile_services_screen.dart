import 'package:flutter/material.dart';
import 'package:canaan_portfolio/size_config.dart';
import 'package:canaan_portfolio/random_moving_shapes.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:canaan_portfolio/custom%20paint/custom_paint.dart';
// ignore_for_file: unused_local_variable


class MobileServicesScreen extends StatefulWidget {
  const MobileServicesScreen({Key? key}) : super(key: key);

  @override
  _MobileServicesScreenState createState() => _MobileServicesScreenState();
}

class _MobileServicesScreenState extends State<MobileServicesScreen> {
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FancyCardMobile(
                        height: 300,
                        height2: 290,
                        width: 360,
                        color: Theme.of(context).secondaryHeaderColor,
                        icon: FontAwesomeIcons.mobileAlt,
                        iconSize: 20,
                        iconContainer: 40,
                        title: "Mobile Development",
                        body:
                            "I use the best frameworks to build beautiful and responsive mobile/ios applications tailored to meet customer's specification as well as attract visitors.",
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      FancyCardMobile(
                        height: 300,
                        height2: 290,
                        width: 360,
                        color: Color(0xFF39BD9C),
                        icon: Icons.web,
                        iconSize: 20,
                        iconContainer: 40,
                        title: "Website Development",
                        body:
                            "I use various web technologies to develop attractive websites which converts visitors to customers. I develop creative and responsive website layouts.",
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      FancyCardMobile(
                        height: 300,
                        height2: 290,
                        width: 360,
                        color: Color(0xFF8838B4),
                        icon: FontAwesomeIcons.mobile,
                        iconSize: 20,
                        iconContainer: 40,
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
                        Column(
                          children: [
                            FancyCardSmallMobile(
                              height: 200,
                              height2: 200,
                              width: 210,
                              iconContainer: 20,
                              color: Theme.of(context).secondaryHeaderColor,
                              icon: FontAwesomeIcons.mobileAlt,
                              iconSize: 28,
                              title: "Development",
                              body:
                                  "I conduct user research to identify the problem I want to solve.",
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            FancyCardSmallMobile(
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
                            SizedBox(
                              height: 20,
                            ),
                            FancyCardSmallMobile(
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
                            SizedBox(
                              height: 20,
                            ),
                            FancyCardSmallMobile(
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
                            SizedBox(
                              height: 20,
                            ),
                            FancyCardSmallMobile(
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

class FancyCardMobile extends StatefulWidget {
  final double? height;
  final double? height2;
  final double? width;
  final IconData? icon;
  final Color? color;
  final String title;
  final String body;
  final double? iconContainer;
  final double? iconSize;
  FancyCardMobile({
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
  State<FancyCardMobile> createState() => _FancyCardMobileState();
}

class _FancyCardMobileState extends State<FancyCardMobile> {
  bool isTapped = true;

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: isTapped
              ? isExpanded
                  ? 80
                  : 80
              : isExpanded
                  ? 210
                  : 200,
          margin: EdgeInsets.only(left: 15, right: 15),
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    isTapped = !isTapped;
                  });
                },
                onHighlightChanged: (value) {
                  setState(() {
                    isExpanded = value;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  curve: Curves.fastLinearToSlowEaseIn,
                  height: isTapped
                      ? isExpanded
                          ? 65
                          : 70
                      : isExpanded
                          ? 200
                          : 190,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff6f12e8).withOpacity(0.5),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: isTapped
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Icon(
                                  isTapped
                                      ? Icons.keyboard_arrow_down
                                      : Icons.keyboard_arrow_up,
                                  color: Colors.white,
                                  size: 27,
                                ),
                              ],
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Icon(
                                  isTapped
                                      ? Icons.keyboard_arrow_down
                                      : Icons.keyboard_arrow_up,
                                  color: Colors.white,
                                  size: 27,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Flexible(
                              child: Text(
                                isTapped ? "" : widget.body,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class FancyCardSmallMobile extends StatefulWidget {
  final double? height;
  final double? height2;
  final double? width;
  final IconData? icon;
  final Color? color;
  final String title;
  final String body;
  final double? iconContainer;
  final double? iconSize;
  FancyCardSmallMobile({
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
  State<FancyCardSmallMobile> createState() => _FancyCardSmallMobileState();
}

class _FancyCardSmallMobileState extends State<FancyCardSmallMobile> {
  bool isTapped = true;

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: isTapped
              ? isExpanded
                  ? 80
                  : 80
              : isExpanded
                  ? 130
                  : 160,
          margin: EdgeInsets.only(left: 15, right: 15),
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    isTapped = !isTapped;
                  });
                },
                onHighlightChanged: (value) {
                  setState(() {
                    isExpanded = value;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  curve: Curves.fastLinearToSlowEaseIn,
                  height: isTapped
                      ? isExpanded
                          ? 65
                          : 70
                      : isExpanded
                          ? 130
                          : 150,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff6f12e8).withOpacity(0.5),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: isTapped
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Icon(
                                  isTapped
                                      ? Icons.keyboard_arrow_down
                                      : Icons.keyboard_arrow_up,
                                  color: Colors.white,
                                  size: 27,
                                ),
                              ],
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Icon(
                                  isTapped
                                      ? Icons.keyboard_arrow_down
                                      : Icons.keyboard_arrow_up,
                                  color: Colors.white,
                                  size: 27,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Flexible(
                              child: Text(
                                isTapped ? "" : widget.body,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
