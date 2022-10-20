import 'package:canaan_portfolio/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ToolbarItem extends StatelessWidget {
  const ToolbarItem(
    this.toolbarItem, {
    required this.height,
    required this.scrollScale,
    this.isLongPressed = false,
    this.gutter = 10,
    Key? key,
  }) : super(key: key);

  final ToolbarItemData toolbarItem;
  final double height;
  final double scrollScale;
  final bool isLongPressed;
  final double gutter;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height + gutter,
      child: Stack(
        children: [
          AnimatedScale(
            scale: scrollScale,
            duration: Constants.scrollScaleAnimationDuration,
            curve: Constants.scrollScaleAnimationCurve,
            child: AnimatedContainer(
              duration: Constants.longPressAnimationDuration,
              curve: Constants.longPressAnimationCurve,
              height: height + (isLongPressed ? 10 : 0),
              width: isLongPressed ? Constants.toolbarWidth * 2 : 50,
              decoration: BoxDecoration(
                color: toolbarItem.color,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.1),
                  ),
                ],
              ),
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                bottom: gutter,
                left: isLongPressed ? Constants.itemsOffset : 0,
              ),
            ),
          ),
          Positioned.fill(
            child: AnimatedPadding(
              duration: Constants.longPressAnimationDuration,
              curve: Constants.longPressAnimationCurve,
              padding: EdgeInsets.only(
                bottom: gutter,
                left: 12 + (isLongPressed ? Constants.itemsOffset : 0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AnimatedScale(
                    scale: scrollScale,
                    duration: Constants.scrollScaleAnimationDuration,
                    curve: Constants.scrollScaleAnimationCurve,
                    child: Icon(
                      toolbarItem.icon,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AnimatedOpacity(
                      duration: Constants.longPressAnimationDuration,
                      curve: Constants.longPressAnimationCurve,
                      opacity: isLongPressed ? 1 : 0,
                      child: Text(
                        toolbarItem.title,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CoolToolbar extends StatefulWidget {
  const CoolToolbar(
      {Key? key, required this.hideDrawer, required this.controller})
      : super(key: key);

  final bool hideDrawer;
  final ScrollController controller;
  @override
  _CoolToolbarState createState() => _CoolToolbarState();
}

class _CoolToolbarState extends State<CoolToolbar>
    with SingleTickerProviderStateMixin {
  late ScrollController scrollController;

  double get itemHeight =>
      Constants.toolbarWidth - (Constants.toolbarHorizontalPadding * 2);

  void scrollListener() {
    if (scrollController.hasClients) {
      _updateItemsScrollData(
        scrollPosition: scrollController.position.pixels,
      );
    }
  }

  List<double> itemScrollScaleValues = [];
  List<double> itemYPositions = [];

  void _updateItemsScrollData({double scrollPosition = 0}) {
    List<double> _itemScrollScaleValues = [];
    List<double> _itemYPositions = [];
    for (int i = 0; i <= toolbarItems.length - 1; i++) {
      double itemTopPosition = i * (itemHeight + Constants.itemsGutter);
      _itemYPositions.add(itemTopPosition - scrollPosition);

      double itemBottomPosition =
          (i + 1) * (itemHeight + Constants.itemsGutter);
      double distanceToMaxScrollExtent =
          Constants.toolbarHeight + scrollPosition - itemTopPosition;
      bool itemIsOutOfView =
          distanceToMaxScrollExtent < 0 || scrollPosition > itemBottomPosition;
      _itemScrollScaleValues.add(itemIsOutOfView ? 0.4 : 1);
    }
    setState(() {
      itemScrollScaleValues = _itemScrollScaleValues;
      itemYPositions = _itemYPositions;
    });
  }

  List<bool> longPressedItemsFlags = [];

  void _updateLongPressedItemsFlags({double longPressYLocation = 0}) {
    List<bool> _longPressedItemsFlags = [];
    for (int i = 0; i <= toolbarItems.length - 1; i++) {
      bool isLongPressed = itemYPositions[i] >= 0 &&
          longPressYLocation > itemYPositions[i] &&
          longPressYLocation <
              (itemYPositions.length > i + 1
                  ? itemYPositions[i + 1]
                  : Constants.toolbarHeight);
      _longPressedItemsFlags.add(isLongPressed);
    }
    setState(() {
      longPressedItemsFlags = _longPressedItemsFlags;
    });
  }

  @override
  void initState() {
    super.initState();
    _updateItemsScrollData();
    _updateLongPressedItemsFlags();
    scrollController = ScrollController();
    scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  double width = 70;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      width: width,
      height: Constants.toolbarHeight,
      margin: const EdgeInsets.only(left: 10, top: 200),
      child: Stack(
        children: [
          Positioned(
            child: Container(
              width: Constants.toolbarWidth,
              decoration: BoxDecoration(
                color:
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    color: Colors.black.withOpacity(0.2),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onLongPressStart: (LongPressStartDetails details) {
              setState(() {
                width = SizeConfig.sW! * 90;
              });
              _updateLongPressedItemsFlags(
                longPressYLocation: details.localPosition.dy,
              );
            },
            onLongPressMoveUpdate: (details) {
              _updateLongPressedItemsFlags(
                longPressYLocation: details.localPosition.dy,
              );
            },
            onLongPressEnd: (LongPressEndDetails details) {
              _updateLongPressedItemsFlags(longPressYLocation: 0);
            },
            onLongPressCancel: () {
              width = 70;
              _updateLongPressedItemsFlags(longPressYLocation: 0);
            },
            child: ListView.builder(
              controller: scrollController,
              // clipBehavior: Clip.none,
              padding: const EdgeInsets.all(10),
              itemCount: toolbarItems.length,
              itemBuilder: (c, i) => InkWell(
                onTap: () {
                  if (i == 0) {
                    widget.controller.animateTo(
                        MediaQuery.of(context).size.height * 0,
                        duration: Duration(milliseconds: 1500),
                        curve: Curves.easeIn);
                  } else if (i == 1) {
                    widget.controller.animateTo(
                        MediaQuery.of(context).size.height * 1.1,
                        duration: Duration(milliseconds: 1500),
                        curve: Curves.easeIn);
                  } else if (i == 2) {
                    widget.controller.animateTo(
                        MediaQuery.of(context).size.height * 2.1,
                        duration: Duration(milliseconds: 1500),
                        curve: Curves.easeIn);
                  } else if (i == 3) {
                    widget.controller.animateTo(
                        MediaQuery.of(context).size.height * 3.7,
                        duration: Duration(milliseconds: 1500),
                        curve: Curves.easeIn);
                  } else if (i == 4) {
                    widget.controller.animateTo(
                        MediaQuery.of(context).size.height * 4.7,
                        duration: Duration(milliseconds: 1500),
                        curve: Curves.easeIn);
                  }
                },
                child: ToolbarItem(
                  toolbarItems[i],
                  height: itemHeight,
                  scrollScale: itemScrollScaleValues[i],
                  isLongPressed: longPressedItemsFlags[i],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ToolbarItemData {
  final String title;
  final Color color;
  final IconData icon;

  ToolbarItemData({
    required this.title,
    required this.color,
    required this.icon,
  });
}

List<ToolbarItemData> toolbarItems = [
  ToolbarItemData(
    title: 'Home',
    color: Colors.pinkAccent,
    icon: CupertinoIcons.home,
  ),
  ToolbarItemData(
    title: 'About',
    color: Colors.lightBlueAccent,
    icon: CupertinoIcons.info,
  ),
  ToolbarItemData(
    title: 'Services',
    color: Colors.deepOrangeAccent,
    icon: CupertinoIcons.settings,
  ),
  ToolbarItemData(
    title: 'Portfolio',
    color: Colors.pink,
    icon: CupertinoIcons.folder_solid,
  ),
  ToolbarItemData(
    title: 'Contact',
    color: Colors.amber,
    icon: Icons.contact_mail,
  ),
];

class Constants {
  static const double itemsGutter = 10;
  static const double toolbarHeight = 320;
  static const double toolbarWidth = 70;
  static const double itemsOffset = toolbarWidth - 10;
  static const int itemsInView = 7;
  static const double toolbarVerticalPadding = 10;
  static const double toolbarHorizontalPadding = 10;

  static const Duration longPressAnimationDuration =
      Duration(milliseconds: 400);
  static const Duration scrollScaleAnimationDuration =
      Duration(milliseconds: 700);

  static const Curve longPressAnimationCurve = Curves.easeOutSine;
  static const Curve scrollScaleAnimationCurve = Curves.ease;
}
