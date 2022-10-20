// ignore_for_file: unused_local_variable

import 'package:canaan_portfolio/constants.dart';
import 'package:canaan_portfolio/custom%20paint/custom_paint.dart';
import 'package:canaan_portfolio/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../github_api.dart';
import '../random_moving_shapes.dart';

class MobileAboutScreen extends StatefulWidget {
  const MobileAboutScreen({Key? key}) : super(key: key);

  @override
  _MobileAboutScreenState createState() => _MobileAboutScreenState();
}

class _MobileAboutScreenState extends State<MobileAboutScreen> {
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
            height: MediaQuery.of(context).size.height * 1.15,
            margin: EdgeInsets.only(top: 50.0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 20, left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "Who I am",
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                      ),
                      Text(
                        "About Me",
                        style: Theme.of(context).textTheme.headline3!,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                          "I am a Mobile/Website Developer with a strong focus in UI/UX design, Top Notch Backend Performances and Clean Architecture. I love getting new experiences and also a fast learner.",
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.bodyText1!),
                      SizedBox(
                        height: 20.0,
                      ),
                      Provider.of<GithubRepos>(context, listen: true)
                              .getGithubRepo()
                              .isEmpty
                          ? LoadingTextWidget()
                          : Text(
                              getWordsExceptFirst(Provider.of<GithubRepos>(
                                      context,
                                      listen: true)
                                  .getGithubRepo()[0]
                                  .description!),
                              textAlign: textAlignment,
                              style: Theme.of(context).textTheme.bodyText1!),
                      SizedBox(
                        height: 50.0,
                      ),
                      ElevatedButton(
                          onPressed: () {}, child: Text("Download CV",
                          style: TextStyle(color: Colors.white),
                          )),
                      SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  "images/cj4.jpg",
                  fit: BoxFit.cover,
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
