import '../constants.dart';
import '../github_api.dart';
import '../random_moving_shapes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:canaan_portfolio/size_config.dart';
import 'package:canaan_portfolio/github_model.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:canaan_portfolio/custom%20paint/custom_paint.dart';
// ignore_for_file: unused_local_variable



class MobilePortfolioScreen extends StatefulWidget {
  const MobilePortfolioScreen({Key? key}) : super(key: key);

  @override
  _MobilePortfolioScreenState createState() => _MobilePortfolioScreenState();
}

class _MobilePortfolioScreenState extends State<MobilePortfolioScreen> {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "What i've done",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "My Projects",
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),

                ///for Tablet Vieww
                ///
                Provider.of<GithubRepos>(context, listen: true)
                            .getGithubRepo()
                            .length ==
                        0
                    ? LoadingWidgetMobile()
                    : Container(
                        alignment: Alignment.center,
                        height: 250,
                        width: SizeConfig.sW! * 100,
                        child: ListView.separated(
                            separatorBuilder: ((context, index) => SizedBox(
                                  width: 40,
                                )),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount:
                                Provider.of<GithubRepos>(context, listen: true)
                                        .getGithubRepo()
                                        .length -
                                    1,
                            itemBuilder: (context, index) {
                              GithubRepo githubRepo = Provider.of<GithubRepos>(
                                      context,
                                      listen: true)
                                  .getGithubRepo()[index + 1];
                              return FancyCard(
                                height2: 250,
                                width: 280,
                                iconContainer: 80,
                                color: Theme.of(context).secondaryHeaderColor,
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
                SizedBox(
                  height: 60,
                ),
                Center(
                  child: Text(
                    "People Talk About Me",
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Center(
                  child: Text(
                    "I always wanted my works to be part of what will make people's daily lives and complex apps simple to use",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText2!,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 20,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Transform.translate(
                        offset: Offset(0, -22),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            height: 50,
                            width: 50,
                            color: Theme.of(context).primaryColorLight,
                            child: Icon(Icons.person, size: 30),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          "\" I always wanted my works to be part of what will make people's daily lives and complex apps simple to use\"",
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyText2!.copyWith(
                                    height: 2,
                                  ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Zino Etemire",
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        "CEO Rentoll",
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
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
            maxY: SizeConfig.sH!.toInt() * 95,
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
            maxY: SizeConfig.sH!.toInt() * 95,
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
            maxY: SizeConfig.sH!.toInt() * 95,
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
            maxY: SizeConfig.sH!.toInt() * 95,
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
            maxY: SizeConfig.sH!.toInt() * 95,
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
            maxY: SizeConfig.sH!.toInt() * 95,
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
            maxY: SizeConfig.sH!.toInt() * 95,
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

  double offset3 = 2.15;

  double offset4 = 0.0;
  double offset1 = -0.75;
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
        lowerBound: -0.75,
        upperBound: 2.15,
        duration: Duration(milliseconds: 300));
    _controllerA!.addListener(() {
      setState(() {
        offset1 = _controllerA!.value;
      });
    });
    _controllerB = AnimationController(
        vsync: this,
        lowerBound: -2.15,
        upperBound: 0.75,
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
    final containerColor = color;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (showImage == false) {
            _controllerA!.forward().whenCompleteOrCancel(() {
              gradient1 = LinearGradient(colors: [
                Colors.purple.withOpacity(0.8),
                Theme.of(context).primaryColorLight.withOpacity(0.8),
              ]);
              Future.delayed(Duration(milliseconds: 50)).then((value) {
                title = getWordsExceptFirst(widget.title);
                heading = widget.heading;
                setState(() {
                  showImage = true;
                  color = Color(0xFF262626);
                });
              });
            });
            _controllerB!.reverse();
          } else {
            showImage = false;
            title = "";
            heading = "";
            _controllerA!.reverse().whenCompleteOrCancel(() {
              gradient1 = LinearGradient(colors: [
                Theme.of(context).primaryColorLight.withOpacity(0.8),
                Colors.purple.withOpacity(0.8),
              ]);
              Future.delayed(Duration(milliseconds: 50)).then((value) {
                setState(() {
                  showImage = false;
                  color = Colors.transparent;
                });
              });
            });
            _controllerB!.forward();
          }
        });
      },

      // isHovered ?  :
      child: Container(
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
            if (showImage == false)
              Text(
                heading,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            const SizedBox(
              height: 30,
            ),
            Transform(
              alignment: FractionalOffset(0.0, offset3),
              transform: new Matrix4.identity()..rotateZ(-32 * 3.1415927 / 180),
              child: OverflowBox(
                maxHeight: 800,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: gradient1,
                  ),
                  width: 50,
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
                  width: 50,
                  height: double.infinity,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                      child: InkWell(
                        onTap: () {
                           launchInBrowser(Uri.parse(widget.url!));
                        },
                        child: Text(
                          "View Project",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
