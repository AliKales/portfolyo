import 'package:flutter/material.dart';
import 'package:portfolyo/everything/colors.dart';

class CustomButtonWithAni extends StatefulWidget {
  const CustomButtonWithAni(
      {Key? key,
      required this.text,
      this.onClicked})
      : super(key: key);
  final String text;
  final Function()? onClicked;

  @override
  State<CustomButtonWithAni> createState() => _CustomButtonWithAniState();
}

class _CustomButtonWithAniState extends State<CustomButtonWithAni> {
  double height = 45;
  double width = 180;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MouseRegion(
        onExit: (event) {
          setState(() {
            height = 45;
            width = 180;
          });
        },
        onEnter: (event) {
          setState(() {
            height = 55;
            width = 190;
          });
        },
        child: InkWell(
          onTap: () {
            widget.onClicked?.call();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: height,
            width: width,
            color: color1,
            child: SizedBox(
              height: height - 10,
              width: width - 10,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  widget.text,
                  style: TextStyle(color: color5),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
