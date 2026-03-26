import 'contact.dart';
import '../github_api.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../content/moblie_homePage.dart';
import 'package:animate_do/animate_do.dart';
import '../content/mobile_about_screen.dart';
import '../content/mobile_contacts_screen.dart';
import '../content/mobile_services_screen.dart';
import '../content/mobile_portfolio_screen.dart';
import 'package:canaan_portfolio/size_config.dart';
import 'package:canaan_portfolio/screens/HomePage.dart';
import 'package:canaan_portfolio/navbar/nav_bar_item.dart';
import 'package:canaan_portfolio/navbar/nav_bar_logo.dart';
import 'package:canaan_portfolio/screens/about_screen.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:canaan_portfolio/nav_drawer/nav_drawer.dart';
import 'package:flutter/material.dart' hide NavigationDrawer;
import 'package:canaan_portfolio/screens/portfolio_screen.dart';
import 'package:canaan_portfolio/content/home_content_mobile.dart';
import 'package:canaan_portfolio/screens/services_desktop_tablet.dart';

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
  final GlobalKey _homeSectionKey = GlobalKey();
  final GlobalKey _aboutSectionKey = GlobalKey();
  final GlobalKey _servicesSectionKey = GlobalKey();
  final GlobalKey _portfolioSectionKey = GlobalKey();
  final GlobalKey _contactSectionKey = GlobalKey();
   AnimationController? _drawerController;
  double drawerOffset = 0;

  /// Scrolls the desktop/tablet ListView to the exact section.
  void _scrollToSection(GlobalKey sectionKey) {
    final BuildContext? sectionContext = sectionKey.currentContext;
    if (sectionContext == null) {
      return;
    }
    Scrollable.ensureVisible(
      sectionContext,
      duration: Duration(milliseconds: 1200),
      curve: Curves.easeInOut,
      alignment: 0.02,
    );
  }

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
        backgroundColor:   const Color(0xFF042840),
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
                                      _scrollToSection(_homeSectionKey);
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
                                      _scrollToSection(_aboutSectionKey);
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
                                      _scrollToSection(_servicesSectionKey);
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
                                      _scrollToSection(_portfolioSectionKey);
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
                                      _scrollToSection(_contactSectionKey);
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
                                _scrollToSection(_contactSectionKey);
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
              color: const Color(0xFF042840),
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
                  child: SingleChildScrollView(
                    controller: pageController,
                    child: Column(
                      children: [
                      FadeInLeft(
                          duration: Duration(milliseconds: 1500),
                          child: Container(
                            key: _homeSectionKey,
                            child: HomePage(),
                          )),
                      FadeInRight(
                        duration: Duration(milliseconds: 2500),
                        child: Container(
                          key: _aboutSectionKey,
                          child: AboutScreen(),
                        ),
                      ),
                      FadeInLeft(
                        duration: Duration(milliseconds: 2500),
                        child: Container(
                          key: _servicesSectionKey,
                          child: ServicesPageDesktopTab(),
                        ),
                      ),
                      FadeInRight(
                        duration: Duration(milliseconds: 2500),
                        child: Container(
                          key: _portfolioSectionKey,
                          child: PortfolioScreen(),
                        ),
                      ),
                      FadeInLeft(
                        duration: Duration(milliseconds: 2500),
                        child: Container(
                          key: _contactSectionKey,
                          child: ContactScreen(),
                        ),
                      ),
                    ],
                    ),
                  ),
                ),
                desktop: SingleChildScrollView(
                  controller: pageController,
                  child: Column(
                    children: [
                    FadeInLeftBig(
                        duration: Duration(milliseconds: 1500),
                        child: Container(
                          key: _homeSectionKey,
                          child: HomePage(),
                        )),
                    FadeInRightBig(
                      duration: Duration(milliseconds: 2500),
                      child: Container(
                        key: _aboutSectionKey,
                        child: AboutScreen(),
                      ),
                    ),
                    FadeInLeftBig(
                      duration: Duration(milliseconds: 2500),
                      child: Container(
                        key: _servicesSectionKey,
                        child: ServicesPageDesktopTab(),
                      ),
                    ),
                    FadeInRightBig(
                      duration: Duration(milliseconds: 2500),
                      child: Container(
                        key: _portfolioSectionKey,
                        child: PortfolioScreen(),
                      ),
                    ),
                    FadeInLeftBig(
                      duration: Duration(milliseconds: 2500),
                      child: Container(
                        key: _contactSectionKey,
                        child: ContactScreen(),
                      ),
                    ),
                    ],
                  ),
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
