import '../random_moving_shapes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:canaan_portfolio/size_config.dart';
import 'package:canaan_portfolio/theme/theme_provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:canaan_portfolio/custom%20paint/custom_paint.dart';
// ignore_for_file: unused_local_variable, import_of_legacy_library_into_null_safe

// import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
// import 'package:mailgun/mailgun.dart';

class MobileContactScreen extends StatefulWidget {
  const MobileContactScreen({Key? key}) : super(key: key);

  @override
  _MobileContactScreenState createState() => _MobileContactScreenState();
}

class _MobileContactScreenState extends State<MobileContactScreen> {
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPhone = TextEditingController();
  TextEditingController _controllerText = TextEditingController();

  String name = "";
  String email = "";
  String phone = "";
  String text = "";
  String errorMessage = "Make sure all fields are filled";
  bool validEmail = false;

  //a method to show the message
  void _showMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    // SVProgressHUD.dismiss();
    super.initState();
  }

  contactMe(
      {required String? to,
      required String? text,
      required String? subject,
      required String? from,
      Function(String)? cb,
      Function(String)? data}) async {
    // var mailgun = MailgunMailer(
    //     domain: "sandbox17d1a892a8114788abdd98b7336e0ffd.mailgun.org",
    //     apiKey: "c849b01b2311f5dd277e228cfb630aed-523596d9-73f1351f");

    // try {
    //   cb!("loading");
    //   var response = await mailgun
    //       .send(from: from, to: [to!], subject: subject, text: text)
    //       .whenComplete(() {
    //     data!("");
    //     SVProgressHUD.dismiss();
    //   });
    // } catch (e) {
    //   SVProgressHUD.dismiss();
    //   cb!("failed to send email");
    //   debugPrint("$e");
    // }
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerName.dispose();
    _controllerPhone.dispose();
    _controllerText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // SVProgressHUD.dismiss();
    SizeConfig().init(context);
    return ResponsiveBuilder(builder: (context, sizingInformation) {
      // var textAlignment =
      //     sizingInformation.deviceScreenType == DeviceScreenType.desktop
      //         ? TextAlign.left
      //         : TextAlign.left;
      // double titleSize =
      //     sizingInformation.deviceScreenType == DeviceScreenType.tablet
      //         ? 50
      //         : 80;
      // double descriptionSize =
      //     sizingInformation.deviceScreenType == DeviceScreenType.mobile
      //         ? 16
              // : 21;
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Contact Me",
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Get In Touch",
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "I am available for professional job offers and getting in touch is just a click away.",
                  style: Theme.of(context).textTheme.bodyText1!,
                ),
                SizedBox(
                  height: 50,
                ),
                CustTextField(
                  controller: _controllerName,
                  border: true,
                  theme: Theme.of(context),
                  text: "Full Name",
                  validate: (value) {
                    return null;
                  },
                  onchanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustTextField(
                        controller: _controllerEmail,
                        border: true,
                        theme: Theme.of(context),
                        text: "Email",
                        validate: (value) {
                          return null;
                        },
                        onchanged: (value) {
                          setState(() {
                            // if (!EmailValidator.validate(email)) {
                            //   email = "";

                            //   errorMessage = "Invalid email address";
                            //   validEmail = false;
                            // } else {
                            errorMessage =
                                "Make sure other fields are not empty";
                            validEmail = true;
                            email = value;
                            // }
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: CustTextField(
                        controller: _controllerPhone,
                        border: true,
                        theme: Theme.of(context),
                        text: "Phone Number",
                        validate: (value) {
                          return null;
                        },
                        onchanged: (value) {
                          setState(() {
                            phone = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                CustTextField(
                  controller: _controllerText,
                  border: true,
                  heigth: 200,
                  theme: Theme.of(context),
                  text: "Write a Message",
                  validate: (value) {
                    return null;
                  },
                  onchanged: (value) {
                    setState(() {
                      text = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      // if (name.isEmpty ||
                      //     phone.isEmpty ||
                      //     text.isEmpty ||
                      //     email.isEmpty) {
                      //   _showMessage(errorMessage);
                      // } else {
                      //   await contactMe(
                      //       cb: ((cb) {
                      //         if (cb == "loading") {
                      //           SVProgressHUD.show(status: "Loading");
                      //           debugPrint(
                      //               "Loading...............................");
                      //         }
                      //         if (cb == "failed") {
                      //           SVProgressHUD.dismiss();
                      //           debugPrint("failed..........................");
                      //           _showMessage("Error occured, try again");
                      //         }
                      //       }),
                      //       data: ((data) {
                      //         SVProgressHUD.dismiss();
                      //         debugPrint(
                      //             "Successful.....................................");

                      //         _showMessage("Mail sent");
                      //       }),
                      //       to: "bdiamondozah@gmail.com",
                      //       text: "$text with phone number: $phone",
                      //       subject: name,
                      //       from: email);
                      // }

                      // SVProgressHUD.dismiss();
                    },
                    child: Text(
                      "Contact Me",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Stack(
                  alignment: AlignmentDirectional.bottomStart,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 60.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ContactLinls(
                            text: "Warri, Delta State",
                            icon: FontAwesomeIcons.locationArrow,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ContactLinls(
                            text: "bdiamondozah@gmail.com",
                            icon: FontAwesomeIcons.solidEnvelope,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ContactLinls(
                            text: "+234-705-652-4189",
                            icon: FontAwesomeIcons.phone,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          RandomMovingShape(
            minX: SizeConfig.sW!.toInt() * 60,
            minY: SizeConfig.sH!.toInt() * 30,
            painter: Circle(
              color: Theme.of(context).primaryColor,
            ),
            radius: BorderRadius.zero,
            color: Theme.of(context).primaryColor,
            curve: Curves.slowMiddle,
            maxY: SizeConfig.sH!.toInt() * 70,
            maxX: SizeConfig.sW!.toInt() * 100,
          ),
          RandomMovingShape(
            minX: SizeConfig.sW!.toInt() * 30,
            minY: SizeConfig.sH!.toInt() * 30,
            painter: DrawTriangleShape(
              color: Theme.of(context).primaryColorLight,
            ),
            radius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50)),
            color: Theme.of(context).primaryColorLight,
            curve: Curves.fastOutSlowIn,
            maxY: SizeConfig.sH!.toInt() * 70,
            maxX: SizeConfig.sW!.toInt() * 100,
          ),
          RandomMovingShape(
            minX: SizeConfig.sW!.toInt() * 70,
            minY: SizeConfig.sH!.toInt() * 50,
            painter: Rectangle(
              color: Theme.of(context).secondaryHeaderColor,
            ),
            radius: BorderRadius.circular(50),
            curve: Curves.decelerate,
            color: Theme.of(context).secondaryHeaderColor,
            maxY: SizeConfig.sH!.toInt() * 70,
            maxX: SizeConfig.sW!.toInt() * 100,
          ),
          RandomMovingShape(
            minX: SizeConfig.sW!.toInt() * 40,
            minY: SizeConfig.sH!.toInt() * 30,
            painter: StarPainter(
                color: Theme.of(context).secondaryHeaderColor, isFilled: false),
            radius: BorderRadius.circular(50),
            curve: Curves.decelerate,
            color: Theme.of(context).secondaryHeaderColor,
            maxY: SizeConfig.sH!.toInt() * 70,
            maxX: SizeConfig.sW!.toInt() * 100,
          ),
          Container(
            padding: EdgeInsets.all(4),
            width: double.infinity,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Center(
              child: Text(
                "Copyright CJ 2024",
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: Colors.white,
                      fontSize: 14
                    ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

class ContactLinls extends StatelessWidget {
  const ContactLinls({
    Key? key,
    required this.text,
    required this.icon,
  }) : super(key: key);

  final String? text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Theme.of(context).primaryColorLight,
          ),
          child: Icon(
            icon!,
            color: Colors.white,
            size: 15,
          ),
        ),
        Flexible(
          child: Text(
            text!,
            overflow: TextOverflow.clip,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontSize: 20,
                ),
          ),
        ),
      ],
    );
  }
}

class CustTextField extends StatelessWidget {
  const CustTextField({
    Key? key,
    required TextEditingController? controller,
    required this.theme,
    this.text,
    this.validate,
    this.onchanged,
    this.border = false,
    this.obscure = false,
    this.textInputType = TextInputType.text,
    this.iconOntap,
    this.obscureIcon = false,
    this.maxValue,
    this.isEnabled = true,
    this.heigth = 10,
  })  : _controller = controller,
        super(key: key);

  final TextEditingController? _controller;
  final ThemeData theme;
  final String? text;
  final bool? border;
  final bool? obscure;
  final bool isEnabled;
  final int? maxValue;
  final bool? obscureIcon;
  final String? Function(String?)? validate;
  final Function(String)? onchanged;
  final Function()? iconOntap;
  final TextInputType textInputType;
  final double heigth;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    return TextFormField(
      enabled: isEnabled,
      obscureText: obscure!,
      maxLength: maxValue,
      controller: _controller,
      decoration: InputDecoration(
        fillColor: isDarkMode
            ? const Color(0xFF0B0511)
            : Theme.of(context).primaryColorLight,
        filled: false,
        enabledBorder: border! == true
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  style: BorderStyle.solid,
                  width: 2.0,
                  color: theme.primaryColorLight,
                ),
              )
            : InputBorder.none,
        border: border! == true
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  style: BorderStyle.solid,
                  width: 2.0,
                  color: theme.primaryColorLight,
                ),
              )
            : InputBorder.none,
        hintText: text,
        contentPadding:
            EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0, bottom: heigth),
        hintStyle: theme.textTheme.bodyMedium!.copyWith(
            color: isDarkMode ? Colors.white : const Color(0xFF607288)),
      ),
      keyboardType: textInputType,
      cursorColor: theme.primaryColor,
      textAlign: TextAlign.start,
      textAlignVertical: TextAlignVertical.top,
      style: theme.textTheme.bodyText1,
      onChanged: onchanged,
      validator: validate,
    );
  }
}
