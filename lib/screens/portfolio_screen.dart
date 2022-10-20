// ignore_for_file: unused_local_variable

import 'package:canaan_portfolio/custom%20paint/custom_paint.dart';
import 'package:canaan_portfolio/github_model.dart';
import 'package:canaan_portfolio/onHover.dart';
import 'package:canaan_portfolio/size_config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../constants.dart';
import '../github_api.dart';
import '../random_moving_shapes.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({Key? key}) : super(key: key);

  @override
  _PortfolioScreenState createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
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
            child: Column(
              children: [
                Text(
                  "What i've done",
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                ),
                Text(
                  "My Projects",
                  style: Theme.of(context).textTheme.headline5!,
                ),
                SizedBox(
                  height: 50,
                ),
                sizingInformation.isDesktop
                    ? Provider.of<GithubRepos>(context, listen: true)
                                .getGithubRepo()
                                .length ==
                            0
                        ? LoadingWidget()
                        : Container(
                            alignment: Alignment.center,
                            height: 1100,
                            width: SizeConfig.sW! * 100,
                            child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 100,
                                  childAspectRatio: 2 / 3,
                                  mainAxisSpacing: 100,
                                  mainAxisExtent: SizeConfig.sW! * 25,
                                ),
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: Provider.of<GithubRepos>(context,
                                            listen: true)
                                        .getGithubRepo()
                                        .length -
                                    1,
                                itemBuilder: (context, index) {
                                  GithubRepo githubRepo =
                                      Provider.of<GithubRepos>(context,
                                              listen: true)
                                          .getGithubRepo()[index + 1];
                                  return FancyCard(
                                    height2: 1000,
                                    width: 400,
                                    iconContainer: 80,
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    icon: FontAwesomeIcons.mobileAlt,
                                    iconSize: 40,
                                    title: githubRepo.description == null
                                        ? "No Description"
                                        : githubRepo.description!,
                                    heading: githubRepo.name == null
                                        ? "No Description"
                                        : githubRepo.name!,
                                    url: "${githubRepo.htmlUrl}",
                                  );
                                }),
                          )
                    :

                    ///for Tablet Vieww
                    ///
                    Provider.of<GithubRepos>(context, listen: true)
                                .getGithubRepo()
                                .length ==
                            0
                        ? LoadingWidget()
                        : Container(
                            alignment: Alignment.center,
                            height: 1100,
                            width: SizeConfig.sW! * 100,
                            child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 100,
                                  mainAxisSpacing: 50,
                                  mainAxisExtent: 300,
                                ),
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: Provider.of<GithubRepos>(context,
                                            listen: true)
                                        .getGithubRepo()
                                        .length -
                                    1,
                                itemBuilder: (context, index) {
                                  GithubRepo githubRepo =
                                      Provider.of<GithubRepos>(context,
                                              listen: true)
                                          .getGithubRepo()[index + 1];
                                  return FancyCard(
                                    height2: 500,
                                    width: 280,
                                    iconContainer: 80,
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    icon: FontAwesomeIcons.mobileAlt,
                                    iconSize: 40,
                                    title: githubRepo.description == null
                                        ? "No Description"
                                        : githubRepo.description!,
                                    heading: githubRepo.name == null
                                        ? "No Description"
                                        : githubRepo.name!,
                                    url: "${githubRepo.htmlUrl}",
                                  );
                                }),
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
            maxY: SizeConfig.sH!.toInt() * 140,
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
            maxY: SizeConfig.sH!.toInt() * 140,
            maxX: SizeConfig.sW!.toInt() * 100,
          ),
          RandomMovingShape(
            minX: SizeConfig.sW!.toInt() * 20,
            minY: SizeConfig.sH!.toInt() * 70,
            painter: DrawCircleCircle(
              color1: Theme.of(context).secondaryHeaderColor,
              color2: Theme.of(context).primaryColorLight,
            ),
            radius: BorderRadius.circular(50),
            curve: Curves.decelerate,
            color: Theme.of(context).secondaryHeaderColor,
            maxY: SizeConfig.sH!.toInt() * 140,
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
            maxY: SizeConfig.sH!.toInt() * 140,
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
            maxY: SizeConfig.sH!.toInt() * 140,
            maxX: SizeConfig.sW!.toInt() * 100,
          ),
          RandomMovingShape(
            minX: SizeConfig.sW!.toInt() * 30,
            minY: SizeConfig.sH!.toInt() * 30,
            painter: DrawTriangleShape(
              color: Colors.purple,
            ),
            radius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50)),
            color: Colors.purple,
            curve: Curves.fastOutSlowIn,
            maxY: SizeConfig.sH!.toInt() * 140,
            maxX: SizeConfig.sW!.toInt() * 100,
          ),
          RandomMovingShape(
            minX: SizeConfig.sW!.toInt() * 60,
            minY: SizeConfig.sH!.toInt() * 30,
            painter: Rectangle(
                color: Theme.of(context).secondaryHeaderColor, isFilled: true),
            radius: BorderRadius.circular(50),
            curve: Curves.decelerate,
            color: Theme.of(context).secondaryHeaderColor,
            maxY: SizeConfig.sH!.toInt() * 140,
            maxX: SizeConfig.sW!.toInt() * 100,
          ),
        ],
      );
    });
  }
}

class FancyCard extends StatefulWidget {
  final double? height;
  final double? height2;
  final double? width;
  final IconData? icon;
  final Color? color;
  final String title;
  final String heading;
  final double? iconContainer;
  final double? iconSize;
  final String? url;
  FancyCard({
    Key? key,
    this.height,
    this.height2,
    this.width,
    this.icon,
    this.color,
    required this.title,
    required this.heading,
    this.iconSize,
    this.iconContainer,
    this.url,
  }) : super(key: key);

  @override
  _FancyCardState createState() => _FancyCardState();
}

class _FancyCardState extends State<FancyCard> with TickerProviderStateMixin {
  AnimationController? _controllerA;

  AnimationController? _controllerB;

  double offset3 = 1.75;

  double offset4 = 0.0;
  double offset1 = -0.6;
  double offset2 = 0.0;
  bool showImage = false;
  Color color = Colors.transparent;
  LinearGradient? gradient1 = LinearGradient(colors: [
    Color(0xFF0000FF).withOpacity(0.8),
    Colors.purple.withOpacity(0.8),
  ]);

  @override
  void initState() {
    _controllerA = AnimationController(
        vsync: this,
        lowerBound: -0.6,
        upperBound: 1.75,
        duration: Duration(milliseconds: 300));
    _controllerA!.addListener(() {
      setState(() {
        offset1 = _controllerA!.value;
      });
    });
    _controllerB = AnimationController(
        vsync: this,
        lowerBound: -1.75,
        upperBound: 0.6,
        duration: Duration(milliseconds: 300));
    _controllerB!.addListener(() {
      setState(() {
        offset3 = -_controllerB!.value;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _controllerA!.dispose();
    _controllerB!.dispose();
    super.dispose();
  }

  String title = "";
  String heading = "";

  @override
  Widget build(BuildContext context) {
    return OnHover(builder: (isHovered) {
      final containerColor = color;

      isHovered
          ? _controllerA!.forward().whenCompleteOrCancel(() {
              gradient1 = LinearGradient(colors: [
                Colors.purple.withOpacity(0.8),
                Theme.of(context).primaryColorLight.withOpacity(0.8),
              ]);
              Future.delayed(Duration(milliseconds: 180)).then((value) {
                color = Color(0xFF262626);
                title = getWordsExceptFirst(widget.title);
                heading = widget.heading;
                setState(() {
                  showImage = true;
                });
              });
            })
          : _controllerA!.reverse().whenCompleteOrCancel(() {
              gradient1 = LinearGradient(colors: [
                Theme.of(context).primaryColorLight.withOpacity(0.8),
                Colors.purple.withOpacity(0.8),
              ]);
              Future.delayed(Duration(milliseconds: 50)).then((value) {
                color = Colors.transparent;
                title = "";
                heading = "";
                setState(() {
                  showImage = false;
                });
              });
            });
      isHovered ? _controllerB!.forward() : _controllerB!.reverse();
      return Container(
        padding: EdgeInsets.all(20),
        clipBehavior: Clip.hardEdge,
        height: widget.height2,
        width: widget.width,
        decoration: BoxDecoration(
          image: showImage == false
              ? DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    "${getFirstWord(widget.title)}",
                  ))
              : null,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                10.0,
              ),
              bottomLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
              topRight: Radius.circular(
                10.0,
              )),
          color: containerColor,
        ),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Transform(
              alignment: FractionalOffset(0.0, offset3),
              transform: new Matrix4.identity()..rotateZ(-32 * 3.1415927 / 180),
              child: OverflowBox(
                maxHeight: 800,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: gradient1,
                  ),
                  width: 200,
                  height: double.infinity,
                ),
              ),
            ),
            Transform(
              alignment: FractionalOffset(0.0, offset1),
              transform: new Matrix4.identity()..rotateZ(-32 * 3.1415927 / 180),
              child: OverflowBox(
                maxHeight: 800,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: gradient1,
                  ),
                  width: 200,
                  height: double.infinity,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  heading,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(
                  height: 30,
                ),
                if (title != "")
                  InkWell(
                    onTap: () {
                      launchInBrowser(Uri.parse(widget.url!));
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        gradient: LinearGradient(colors: [
                          Colors.purple.withOpacity(0.8),
                          Theme.of(context).primaryColorLight.withOpacity(0.8),
                        ]),
                      ),
                      child: Text(
                        "View Project",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
