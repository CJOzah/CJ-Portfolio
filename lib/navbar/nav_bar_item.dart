import 'package:flutter/material.dart';

class NavBarItem extends StatelessWidget {
  final String? text;
  final Function()? function;

  const NavBarItem({
    Key? key,
    required this.text,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: function!,
      child: Text(
        text!,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
