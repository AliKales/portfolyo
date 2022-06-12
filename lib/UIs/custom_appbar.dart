import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:portfolyo/everything/colors.dart';
import 'package:portfolyo/firebase/auth.dart';

class CustomAppbar extends StatefulWidget {
  const CustomAppbar({Key? key, required this.width, this.icons})
      : super(key: key);
  final double width;
  final List<Widget>? icons;

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar> {
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10,
          sigmaY: 10,
        ),
        child: Container(
          width: widget.width,
          padding: EdgeInsets.symmetric(
              horizontal: 10, vertical: widget.icons == null ? 18 : 10),
          color: Colors.white.withOpacity(0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  if (Auth().getEmail() == null) {
                    Navigator.pushNamed(
                        context, "");
                  }else{
                    Navigator.pushNamed(
                        context, "/home");
                  }
                },
                child: Text(
                  "Portfolyon",
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: color5, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: widget.icons ?? [],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
