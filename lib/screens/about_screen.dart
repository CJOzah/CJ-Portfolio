// ignore_for_file: unused_local_variable

import 'package:canaan_portfolio/constants.dart';
import 'package:canaan_portfolio/custom%20paint/custom_paint.dart';
import 'package:canaan_portfolio/size_config.dart';
import 'package:canaan_portfolio/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../github_api.dart';
import '../random_moving_shapes.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ResponsiveBuilder(builder: (context, sizingInformation) {
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
            child: sizingInformation.isDesktop
                ? Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          height: 500,
                          decoration: BoxDecoration(
                            boxShadow: ThemeProvider().isDarkMode
                                ? [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 1,
                                      blurRadius: 10,
                                      offset: Offset(
                                          2, 2), // changes position of shadow
                                    )
                                  ]
                                : [],
                            gradient: !ThemeProvider().isDarkMode
                                ? LinearGradient(
                                    colors: [
                                      Colors.white,
                                      Colors.white,
                                      Colors.white,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : LinearGradient(
                                    colors: [
                                      Color(0xff14181E),
                                      Color(0xff272B30),
                                      Color(0xff21252A),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                "images/cj4.jpg",
                              ),
                            ),
                          ),
                          child: Container(),
                        ),
                      ),
                      SizedBox(
                        width: 60,
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Who I am",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                  ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              "About Me",
                              style: Theme.of(context).textTheme.headline5!,
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                                "I am a Mobile/Website Developer with a strong focus in UI/UX design, Top Notch Backend Performances and Clean Architecture. I love getting new experiences and also a fast learner.",
                                textAlign: textAlignment,
                                style: Theme.of(context).textTheme.bodyText1!),
                            SizedBox(
                              height: 20.0,
                            ),
                            Provider.of<GithubRepos>(context, listen: true)
                                    .getGithubRepo()
                                    .isEmpty
                                ? LoadingTextWidget()
                                : Text(
                                    getWordsExceptFirst(
                                        Provider.of<GithubRepos>(context,
                                                listen: true)
                                            .getGithubRepo()[0]
                                            .description!),
                                    textAlign: textAlignment,
                                    style:
                                        Theme.of(context).textTheme.bodyText1!),
                            SizedBox(
                              height: 50.0,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  print(getFirstWord(Provider.of<GithubRepos>(
                                          context,
                                          listen: false)
                                      .getGithubRepo()[0]
                                      .description!));
                                  launchInBrowser(Uri.parse(getFirstWord(
                                      Provider.of<GithubRepos>(context,
                                              listen: false)
                                          .getGithubRepo()[0]
                                          .description!)));
                                  debugPrint("url launched");
                                },
                                child: Text(
                                  "Download CV",
                                  style: Theme.of(context).textTheme.bodyText1,
                                ))
                          ],
                        ),
                      ),
                    ],
                    //For Tablet View//
                    //
                    //
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        height: SizeConfig.sW! * 65,
                        decoration: BoxDecoration(
                          boxShadow: ThemeProvider().isDarkMode
                              ? [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                    offset: Offset(
                                        2, 2), // changes position of shadow
                                  )
                                ]
                              : [],
                          gradient: !ThemeProvider().isDarkMode
                              ? LinearGradient(
                                  colors: [
                                    Colors.white,
                                    Colors.white,
                                    Colors.white,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : LinearGradient(
                                  colors: [
                                    Color(0xff14181E),
                                    Color(0xff272B30),
                                    Color(0xff21252A),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              "images/cj4.jpg",
                            ),
                          ),
                        ),
                        child: Container(),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 80, left: 80),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Who I am",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                  ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              "About Me",
                              style: Theme.of(context).textTheme.headline5!,
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                                "I am a Mobile/Website Developer with a strong focus in UI/UX design, Top Notch Backend Performances and Clean Architecture. I love getting new experiences and also a fast learner.",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyText1!),
                            SizedBox(
                              height: 20.0,
                            ),
                            Provider.of<GithubRepos>(context, listen: true)
                                    .getGithubRepo()
                                    .isEmpty
                                ? LoadingTextWidget()
                                : Text(
                                    getWordsExceptFirst(
                                        Provider.of<GithubRepos>(context,
                                                listen: true)
                                            .getGithubRepo()[0]
                                            .description!),
                                    textAlign: textAlignment,
                                    style:
                                        Theme.of(context).textTheme.bodyText1!),
                            SizedBox(
                              height: 50.0,
                            ),
                            ElevatedButton(
                                onPressed: () {}, child: Text("Download CV"))
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
          RandomMovingShape(
            minX: SizeConfig.sW!.toInt() * 60,
            minY: SizeConfig.sH!.toInt() * 30,
            painter: Circle(color: Theme.of(context).primaryColor),
            radius: BorderRadius.zero,
            color: Theme.of(context).primaryColor,
            curve: Curves.slowMiddle,
            maxY: SizeConfig.sH!.toInt() * 70,
            maxX: SizeConfig.sW!.toInt() * 100,
          ),
          RandomMovingShape(
            minX: SizeConfig.sW!.toInt() * 30,
            minY: SizeConfig.sH!.toInt() * 70,
            painter: Rectangle(color: Theme.of(context).primaryColorLight),
            radius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50)),
            color: Theme.of(context).primaryColorLight,
            curve: Curves.fastOutSlowIn,
            maxY: SizeConfig.sH!.toInt() * 70,
            maxX: SizeConfig.sW!.toInt() * 100,
          ),
          RandomMovingShape(
            minX: SizeConfig.sW!.toInt() * 60,
            minY: SizeConfig.sH!.toInt() * 30,
            painter: Rectangle(
                color: Theme.of(context).primaryColorLight, isFilled: true),
            radius: BorderRadius.circular(50),
            curve: Curves.decelerate,
            color: Theme.of(context).secondaryHeaderColor,
            maxY: SizeConfig.sH!.toInt() * 70,
            maxX: SizeConfig.sW!.toInt() * 100,
          ),
        ],
      );
    });
  }
}
