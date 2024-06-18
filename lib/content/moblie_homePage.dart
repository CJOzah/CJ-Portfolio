import '../random_moving_shapes.dart';
import 'package:flutter/material.dart';
import 'package:canaan_portfolio/size_config.dart';
import 'package:canaan_portfolio/custom%20paint/custom_paint.dart';
// ignore_for_file: unused_local_variable



class MobileHomePage extends StatefulWidget {
  const MobileHomePage({Key? key}) : super(key: key);

  @override
  _MobileHomePageState createState() => _MobileHomePageState();
}

class _MobileHomePageState extends State<MobileHomePage>   {



  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Expanded(
                    flex: 5,
                    child: Image.asset(
                      "images/header.gif",
                      fit: BoxFit.cover,
                    )),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: SizeConfig.sH! * 3,
                        ),
                        Text(
                          "WELCOME TO MY WORLD",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        SizedBox(
                          height: SizeConfig.sH! * 2,
                        ),
                        Text(
                          "Hey there,",
                          style:
                              Theme.of(context).textTheme.headline3!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          "I'm CJ",
                          style:
                              Theme.of(context).textTheme.headline3!.copyWith(
                                    color: Theme.of(context).primaryColorLight,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        SizedBox(
                          height: SizeConfig.sH! * 3,
                        ),
                        Text(
                            "I'm a Professional Mobile/Web Developer and i love what i do",
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      fontWeight: FontWeight.bold,
                                    )),
                        // Padding(
                        //   padding: EdgeInsets.only(right: 80, left: 80),
                        //   child: Text(
                        //     "I'm a Cross Platform Software Developer with over 3 years of experience. I'm proficient in UI/UX designs, user experience,researching, Mobile Development and Web Development.",
                        //     textAlign: TextAlign.center,
                        //     style: Theme.of(context).textTheme.bodyText1,
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 50,
                        // ),
                        // Padding(
                        //   padding: EdgeInsets.only(
                        //       right: SizeConfig.sW! * 6, left: SizeConfig.sW! * 6),
                        //   //Arrange the icons on columns for tablet and row for desktop
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     mainAxisSize: MainAxisSize.max,
                        //     children: [
                        //       Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //         children: [
                        //           Text(
                        //             "FIND ME",
                        //             textAlign: TextAlign.center,
                        //             style: Theme.of(context).textTheme.bodyText1,
                        //           ),
                        //           Row(
                        //             mainAxisAlignment:
                        //                 MainAxisAlignment.spaceEvenly,
                        //             children: [
                        //               SocialButton(
                        //                 icon: FontAwesomeIcons.facebookF,
                        //                 function: () {
                        //                   launchInBrowser(Uri.parse(
                        //                       "https://facebook.com/canaan.ozah"));
                        //                   debugPrint("Facebook Url Launched");
                        //                 },
                        //               ),
                        //               SizedBox(
                        //                 width: 15.0,
                        //               ),
                        //               SocialButton(
                        //                 icon: LineIcons.twitter,
                        //                 function: () {
                        //                   launchInBrowser(Uri.parse(
                        //                       "https://twitter.com/cjozah"));
                        //                   debugPrint("Twitter Url Launched");
                        //                 },
                        //               ),
                        //               SizedBox(
                        //                 width: 15.0,
                        //               ),
                        //               SocialButton(
                        //                 icon: LineIcons.linkedinIn,
                        //                 function: () {
                        //                   launchInBrowser(Uri.parse(
                        //                       "https://linkedin.com/mwlite/in/canaan-ozah-909399211"));
                        //                   debugPrint("Linked In Url Launched");
                        //                 },
                        //               ),
                        //             ],
                        //           ),
                        //         ],
                        //       ),
                        //       SizedBox(
                        //         height: 10.0,
                        //       ),
                        //       Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //         children: [
                        //           Text(
                        //             "BEST SKILL ON",
                        //             style: Theme.of(context).textTheme.bodyText1,
                        //           ),
                        //           Row(
                        //             mainAxisAlignment:
                        //                 MainAxisAlignment.spaceEvenly,
                        //             children: [
                        //               SkillsButton(
                        //                 text: "flutter_logo.png",
                        //                 function: () {
                        //                   launchInBrowser(
                        //                       Uri.parse("https://flutter.dev"));
                        //                   debugPrint("flutter Url Launched");
                        //                 },
                        //               ),
                        //               SizedBox(
                        //                 width: 15.0,
                        //               ),
                        //               SkillsButton(
                        //                 text: "vs_code_logo.png",
                        //                 function: () {
                        //                   launchInBrowser(Uri.parse(
                        //                       "https://code.visualstudio.com"));
                        //                   debugPrint("VS code Url Launched");
                        //                 },
                        //               ),
                        //               SizedBox(
                        //                 width: 15.0,
                        //               ),
                        //               SkillsButton(
                        //                 text: "wordpress_logo.png",
                        //                 function: () {
                        //                   launchInBrowser(
                        //                       Uri.parse("https://wordpress.com/"));
                        //                   debugPrint("WordPress Url Launched");
                        //                 },
                        //               ),
                        //             ],
                        //           ),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          RandomMovingShape(
            minX: SizeConfig.sW!.toInt() * 10,
            minY: SizeConfig.sH!.toInt() * 30,
            painter: Rectangle(
              color: Colors.purple,
            ),
            radius: BorderRadius.zero,
            color: Colors.purple,
            curve: Curves.slowMiddle,
            maxY: SizeConfig.sH!.toInt() * 70,
            maxX: SizeConfig.sW!.toInt() * 100,
          ),
          RandomMovingShape(
            minX: SizeConfig.sW!.toInt() * 60,
            minY: SizeConfig.sH!.toInt() * 70,
            painter: Circle(
              color: Theme.of(context).primaryColorLight,
            ),
            radius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50)),
            color: Theme.of(context).primaryColorLight,
            curve: Curves.fastOutSlowIn,
            maxY: SizeConfig.sH!.toInt() * 70,
            maxX: SizeConfig.sW!.toInt() * 100,
          ),
          RandomMovingShape(
            minX: SizeConfig.sW!.toInt() * 20,
            minY: SizeConfig.sH!.toInt() * 80,
            painter: DrawCircleCircle(
              color1: Theme.of(context).secondaryHeaderColor,
              color2: Theme.of(context).primaryColorLight,
            ),
            radius: BorderRadius.circular(50),
            curve: Curves.decelerate,
            color: Theme.of(context).secondaryHeaderColor,
            maxY: SizeConfig.sH!.toInt() * 70,
            maxX: SizeConfig.sW!.toInt() * 100,
          ),
          RandomMovingShape(
            minX: SizeConfig.sW!.toInt() * 40,
            minY: SizeConfig.sH!.toInt() * 30,
            painter: StarPainter(
                color: Theme.of(context).primaryColor, isFilled: false),
            radius: BorderRadius.zero,
            color: Theme.of(context).primaryColor,
            curve: Curves.slowMiddle,
            maxY: SizeConfig.sH!.toInt() * 70,
            maxX: SizeConfig.sW!.toInt() * 100,
          ),
          RandomMovingShape(
            minX: SizeConfig.sW!.toInt() * 60,
            minY: SizeConfig.sH!.toInt() * 50,
            painter: StarPainter(
                color: Theme.of(context).secondaryHeaderColor, isFilled: true),
            radius: BorderRadius.circular(50),
            curve: Curves.decelerate,
            color: Theme.of(context).secondaryHeaderColor,
            maxY: SizeConfig.sH!.toInt() * 70,
            maxX: SizeConfig.sW!.toInt() * 100,
          ),
        ],
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final IconData? icon;
  final Function()? function;
  const SocialButton({
    Key? key,
    this.icon,
    this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(top: SizeConfig.sW! * 2),
      semanticContainer: true,
      elevation: 12,
      child: Container(
        height: 40.0,
        width: 40.0,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
        ),
        child: InkWell(onTap: function, child: Icon(icon)),
      ),
    );
  }
}

class SkillsButton extends StatelessWidget {
  final String? text;
  final Function()? function;
  const SkillsButton({
    Key? key,
    this.text,
    this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(top: SizeConfig.sW! * 2),
      semanticContainer: true,
      elevation: 12,
      child: Container(
        padding: EdgeInsets.all(5),
        height: 40.0,
        width: 40.0,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
        ),
        child: InkWell(onTap: function, child: Image.asset("images/$text")),
      ),
    );
  }
}
