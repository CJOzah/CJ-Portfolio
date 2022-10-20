import 'package:flutter/widgets.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static double? blockSizeHorizontal;
  static double? blockSizeVertical;

  static late double _bsW;
  static late double _bsH;
  static double? sW;
  static double? sH;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    _bsW = _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _bsH = _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    sW = (screenWidth - _bsW) / 100;
    sH = (screenHeight - _bsH) / 100;
  }
}
