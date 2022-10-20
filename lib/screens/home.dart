import 'package:animate_do/animate_do.dart';
import 'package:canaan_portfolio/content/home_content_mobile.dart';
import 'package:canaan_portfolio/nav_drawer/nav_drawer.dart';
import 'package:canaan_portfolio/navbar/nav_bar_item.dart';
import 'package:canaan_portfolio/navbar/nav_bar_logo.dart';
import 'package:canaan_portfolio/screens/HomePage.dart';
import 'package:canaan_portfolio/screens/about_screen.dart';
import 'package:canaan_portfolio/screens/portfolio_screen.dart';
import 'package:canaan_portfolio/screens/services_desktop_tablet.dart';
import 'package:canaan_portfolio/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../content/mobile_about_screen.dart';
import '../content/mobile_contacts_screen.dart';
import '../content/mobile_portfolio_screen.dart';
import '../content/mobile_services_screen.dart';
import '../content/moblie_homePage.dart';
import '../github_api.dart';
import 'contact.dart';

class Home extends StatefulWidget {
  static String id = 'Home';
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  ScrollController? controller;

  final PageController pageController = PageController();
  final ScrollController mobileController = ScrollController();
   AnimationController? _drawerController;
  double drawerOffset = 0;

  @override
  void initState() {
     _drawerController = AnimationController(
        vsync: this,
        lowerBound: 0,
        upperBound: 100,
        duration: Duration(milliseconds: 1500));
    _drawerController!.addListener(() {
      setState(() {
        drawerOffset = -_drawerController!.value;
      });
    });
    Provider.of<GithubRepos>(context, listen: false).getGithubRepos();
    mobileController.addListener(() {
      if (mobileController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() {
          _drawerController!.forward();
        });
      } else if (mobileController.position.userScrollDirection ==
          ScrollDirection.forward) {
        setState(() {
          _drawerController!.reverse();
        });
      }
    });

   
    super.initState();
  }

  @override
  void dispose() {
    _drawerController!.dispose();
    mobileController.dispose();
    super.dispose();
  }

  bool hideDrawer = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return ResponsiveBuilder(
      builder: (context, sizingInformation) => Scaffold(
        drawer: sizingInformation.deviceScreenType == DeviceScreenType.mobile
            ? NavigationDrawer()
            : null,
        appBar: sizingInformation.deviceScreenType == DeviceScreenType.mobile
            ? null
            : AppBar(
                toolbarHeight: 80,
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: sizingInformation.deviceScreenType ==
                        DeviceScreenType.mobile
                    ? Text("CJOzah")
                    : Container(
                        margin: EdgeInsets.only(
                          top: SizeConfig.sW! * 1,
                          bottom: SizeConfig.sW! * 1,
                          left: sizingInformation.isTablet
                              ? SizeConfig.sW! * 3
                              : SizeConfig.sW! * 7,
                          right: sizingInformation.isTablet
                              ? 0
                              : SizeConfig.sW! * 7,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            NavBarLogo(),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                NavBarItem(
                                    text: "Home",
                                    function: () {
                                      pageController.animateTo(SizeConfig.sH!,
                                          duration:
                                              Duration(milliseconds: 1500),
                                          curve: Curves.easeIn);
                                    }
                                    //=> Scrollable.ensureVisible(
                                    //     dataKey!.currentContext!,
                                    //     duration: Duration(seconds: 2),
                                    //     curve: Curves.easeIn),
                                    ),
                                SizedBox(
                                  width: SizeConfig.sW! * 2,
                                ),
                                NavBarItem(
                                    text: "About",
                                    function: () {
                                      pageController.animateTo(
                                          sizingInformation.isDesktop
                                              ? SizeConfig.sH! * 90
                                              : SizeConfig.sH! * 150,
                                          duration:
                                              Duration(milliseconds: 1500),
                                          curve: Curves.easeIn);
                                    }
                                    // => Scrollable.ensureVisible(
                                    //     dataKey1!.currentContext!,
                                    //     duration: Duration(seconds: 2),
                                    //     curve: Curves.easeIn),
                                    ),
                                SizedBox(
                                  width: SizeConfig.sW! * 2,
                                ),
                                NavBarItem(
                                    text: "Services",
                                    function: () {
                                      pageController.animateTo(
                                          sizingInformation.isDesktop
                                              ? SizeConfig.sH! * 170
                                              : SizeConfig.sH! * 280,
                                          duration:
                                              Duration(milliseconds: 1500),
                                          curve: Curves.easeIn);
                                    }
                                    // => Scrollable.ensureVisible(
                                    //     dataKey2!.currentContext!,
                                    //     duration: Duration(seconds: 2),
                                    //     curve: Curves.easeIn),
                                    ),
                                SizedBox(
                                  width: SizeConfig.sW! * 2,
                                ),
                                NavBarItem(
                                    text: "Portfolio",
                                    function: () {
                                      pageController.animateTo(
                                          sizingInformation.isDesktop
                                              ? SizeConfig.sH! * 320
                                              : SizeConfig.sH! * 640,
                                          duration:
                                              Duration(milliseconds: 1500),
                                          curve: Curves.easeIn);
                                    }
                                    //=> Scrollable.ensureVisible(
                                    //     dataKey3!.currentContext!,
                                    //     duration: Duration(seconds: 2),
                                    //     curve: Curves.easeIn),
                                    ),
                                SizedBox(
                                  width: SizeConfig.sW! * 2,
                                ),
                                NavBarItem(
                                    text: "Contact",
                                    function: () {
                                      pageController.animateTo(
                                          sizingInformation.isDesktop
                                              ? SizeConfig.sH! * 520
                                              : SizeConfig.sH! * 870,
                                          duration:
                                              Duration(milliseconds: 1500),
                                          curve: Curves.easeIn);
                                    }
                                    // => Scrollable.ensureVisible(
                                    //     dataKey4!.currentContext!,
                                    //     duration: Duration(seconds: 2),
                                    //     curve: Curves.easeIn),
                                    ),
                              ],
                            ),
                            // if (!sizingInformation.isTablet)
                            ElevatedButton(
                              onPressed: () {
                                pageController.animateTo(
                                    sizingInformation.isDesktop
                                        ? SizeConfig.sH! * 520
                                        : SizeConfig.sH! * 870,
                                    duration: Duration(milliseconds: 1500),
                                    curve: Curves.easeIn);
                              },
                              //  => Scrollable.ensureVisible(
                              //     dataKey4!.currentContext!,
                              //     duration: Duration(seconds: 2),
                              //     curve: Curves.easeIn),
                              clipBehavior: Clip.hardEdge,
                              child: Text(
                                "Hire Me",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        )),
              ),
        body: Stack(
          children: [
            Container(
              color: Colors.transparent,
              margin: EdgeInsets.only(
                top: SizeConfig.sW! * 1,
                bottom: SizeConfig.sW! * 1,
                left: sizingInformation.isMobile
                    ? 0
                    : sizingInformation.isTablet
                        ? SizeConfig.sW! * 4
                        : SizeConfig.sW! * 8,
                right: sizingInformation.isMobile
                    ? 0
                    : sizingInformation.isTablet
                        ? SizeConfig.sW! * 4
                        : SizeConfig.sW! * 8,
              ),
              child: ScreenTypeLayout(
                mobile: SingleChildScrollView(
                  controller: mobileController,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FadeInLeft(
                          duration: Duration(milliseconds: 1500),
                          child: MobileHomePage()),
                      FadeInRight(
                        duration: Duration(milliseconds: 2500),
                        child: MobileAboutScreen(),
                      ),
                      FadeInLeft(
                        duration: Duration(milliseconds: 2500),
                        child: MobileServicesScreen(),
                      ),
                      FadeInRight(
                        duration: Duration(milliseconds: 2500),
                        child: MobilePortfolioScreen(),
                      ),
                      FadeInLeft(
                        duration: Duration(milliseconds: 2500),
                        child: MobileContactScreen(),
                      ),
                    ],
                  ),
                ),
                tablet: SizedBox(
                  child: ListView(
                    controller: pageController,
                    scrollDirection: Axis.vertical,
                    children: [
                      FadeInLeft(
                          duration: Duration(milliseconds: 1500),
                          child: HomePage()),
                      FadeInRight(
                        duration: Duration(milliseconds: 2500),
                        child: AboutScreen(),
                      ),
                      FadeInLeft(
                        duration: Duration(milliseconds: 2500),
                        child: ServicesPageDesktopTab(),
                      ),
                      FadeInRight(
                        duration: Duration(milliseconds: 2500),
                        child: PortfolioScreen(),
                      ),
                      FadeInLeft(
                        duration: Duration(milliseconds: 2500),
                        child: ContactScreen(),
                      ),
                    ],
                  ),
                ),
                desktop: ListView(
                  controller: pageController,
                  scrollDirection: Axis.vertical,
                  children: [
                    FadeInLeftBig(
                        duration: Duration(milliseconds: 1500),
                        child: HomePage()),
                    FadeInRightBig(
                      duration: Duration(milliseconds: 2500),
                      child: AboutScreen(),
                    ),
                    FadeInLeftBig(
                      duration: Duration(milliseconds: 2500),
                      child: ServicesPageDesktopTab(),
                    ),
                    FadeInRightBig(
                      duration: Duration(milliseconds: 2500),
                      child: PortfolioScreen(),
                    ),
                    FadeInLeftBig(
                      duration: Duration(milliseconds: 2500),
                      child: ContactScreen(),
                    ),
                  ],
                ),
              ),
            ),

            if (sizingInformation.isMobile)
              Transform.translate(
                  offset: Offset(drawerOffset, 0),
                  child: CoolToolbar(hideDrawer: hideDrawer, controller: mobileController)),

           
          ],
        ),
      ),
    );
  }
}
