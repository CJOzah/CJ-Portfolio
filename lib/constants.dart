import 'package:canaan_portfolio/shimmer_custom_widget.dart';
import 'package:canaan_portfolio/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

String getWordsExceptFirst(String inputString) {
  List<String> wordList = inputString.split(" ");
  if (wordList.isNotEmpty) {
    wordList.removeAt(0);
    var stringList = wordList.join(" ");
    return stringList;
  } else {
    return ' ';
  }
}

String getFirstWord(String inputString) {
  List<String> wordList = inputString.split(" ");
  if (wordList.isNotEmpty) {
    return wordList[0];
  } else {
    return ' ';
  }
}

Future<void> launchInBrowser(Uri url) async {
  print(url);
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Could not launch $url';
  }
}

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(
          SizeConfig.sW! * 3,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 100,
                    mainAxisSpacing: 50,
                    mainAxisExtent: 500),
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return CustomWidget.rectangular(
                    height: 500,
                    width: 200,
                  );
                }),
          ],
        ),
      ),
    );
  }
}

class LoadingWidgetMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SingleChildScrollView(
      child: Container(
        height: 250,
        child: ListView.separated(
            separatorBuilder: ((context, index) => SizedBox(
                  width: 40,
                )),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: 3,
            itemBuilder: (context, index) {
              return CustomWidget.rectangular(
                height: 250,
                width: 280,
              );
            }),
      ),
    );
  }
}

class LoadingTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SingleChildScrollView(
        child: CustomWidget.rectangular(
      width: double.infinity,
      height: 50,
    ));
  }
}
