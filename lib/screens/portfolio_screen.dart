import '../constants.dart';
import '../github_api.dart';
import '../random_moving_shapes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:canaan_portfolio/onHover.dart';
import 'package:canaan_portfolio/size_config.dart';
import 'package:canaan_portfolio/github_model.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:canaan_portfolio/custom%20paint/custom_paint.dart';
// ignore_for_file: unused_local_variable

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
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                ),
                Text(
                  "My Projects",
                  style: Theme.of(context).textTheme.headlineSmall!,
                ),
                SizedBox(
                  height: 50,
                ),
                Provider.of<GithubRepos>(context, listen: true)
                            .getGithubRepo()
                            .length ==
                        0
                    ? LoadingWidget()
                    : Container(
                        alignment: Alignment.center,
                        width: SizeConfig.sW! * 100,
                        child: GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 40,
                              mainAxisSpacing: 40,
                              mainAxisExtent: sizingInformation.isDesktop
                                  ? SizeConfig.sW! * 40
                                  : 300,
                            ),
                            shrinkWrap: true,
                            itemCount:
                                Provider.of<GithubRepos>(context, listen: true)
                                    .getGithubRepo()
                                    .length,
                            itemBuilder: (context, index) {
                              GithubRepo githubRepo = Provider.of<GithubRepos>(
                                      context,
                                      listen: true)
                                  .getGithubRepo()[index];
                              return FancyCard(
                                height2:
                                    sizingInformation.isDesktop ? 1500 : 500,
                                width: sizingInformation.isDesktop ? 400 : 280,
                                iconContainer: 80,
                                color: Theme.of(context).secondaryHeaderColor,
                                icon: FontAwesomeIcons.mobileAlt,
                                iconSize: 40,
                                isInvited: Provider.of<GithubRepos>(context,
                                        listen: true)
                                    .isInvitedRepo(githubRepo),
                                projectImageUrl: Provider.of<GithubRepos>(
                                        context,
                                        listen: true)
                                    .getRepoReadmeHeaderImage(githubRepo),
                                title: Provider.of<GithubRepos>(context,
                                        listen: true)
                                    .getRepoProjectDescription(githubRepo),
                                heading: Provider.of<GithubRepos>(context,
                                        listen: true)
                                    .getRepoProjectHeading(githubRepo),
                                url: Provider.of<GithubRepos>(context,
                                        listen: true)
                                    .getRepoProjectUrl(githubRepo),
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
              color: Theme.of(context).secondaryHeaderColor,
            ),
            radius: BorderRadius.zero,
            color: Theme.of(context).secondaryHeaderColor,
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
              color: Theme.of(context).secondaryHeaderColor,
            ),
            radius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50)),
            color: Theme.of(context).secondaryHeaderColor,
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
  final bool isInvited;
  final String? projectImageUrl;
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
    this.isInvited = false,
    this.projectImageUrl,
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
    Color(0xFF0ef782c).withValues(alpha: 0.8),
    Color(0xff072b42).withValues(alpha: 0.8),
  ]);

  @override
  void initState() {
    _controllerA = AnimationController(
        vsync: this,
        lowerBound: -0.6,
        upperBound: 1.75,
        duration: Duration(milliseconds: 300));
    _controllerA!.addListener(() {
      if (!mounted) {
        return;
      }
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
      if (!mounted) {
        return;
      }
      setState(() {
        offset3 = -_controllerB!.value;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _controllerA?.dispose();
    _controllerB?.dispose();
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
                Color(0xFF0ef782c).withValues(alpha: 0.8),
                Color(0xff072b42).withValues(alpha: 0.8),
              ]);
              Future.delayed(Duration(milliseconds: 180)).then((value) {
                if (!mounted) {
                  return;
                }
                color = Color(0xFF262626);
                title = widget.title;
                heading = widget.heading;
                setState(() {
                  showImage = true;
                });
              });
            })
          : _controllerA!.reverse().whenCompleteOrCancel(() {
              gradient1 = LinearGradient(colors: [
                Color(0xFF0ef782c).withValues(alpha: 0.8),
                Color(0xff072b42).withValues(alpha: 0.8), 
              ]);
              Future.delayed(Duration(milliseconds: 50)).then((value) {
                if (!mounted) {
                  return;
                }
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
            if (showImage == false &&
                widget.projectImageUrl != null &&
                widget.projectImageUrl!.isNotEmpty)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.projectImageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.black12,
                      );
                    },
                  ),
                ),
              ),
            if (showImage == false && widget.isInvited)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                  child: Text(
                    "Invited",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontSize: 12, color: Colors.white),
                  ),
                ),
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
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
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
                      .bodyLarge!
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
                          Theme.of(context)
                              .secondaryHeaderColor
                              .withValues(alpha: 0.8),
                          Theme.of(context)
                              .primaryColorLight
                              .withValues(alpha: 0.8),
                        ]),
                      ),
                      child: Text(
                        "View Project",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
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
