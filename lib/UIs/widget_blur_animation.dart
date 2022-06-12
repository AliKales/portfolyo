import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:portfolyo/everything/colors.dart';

class WidgetBlurAnimation extends StatefulWidget {
  const WidgetBlurAnimation(
      {Key? key, required this.widget, this.width, required this.title})
      : super(key: key);

  final Widget widget;
  final double? width;
  final String title;

  @override
  State<WidgetBlurAnimation> createState() => _WidgetBlurAnimationState();
}

class _WidgetBlurAnimationState extends State<WidgetBlurAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 450));

  bool progress1 = true;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10,
          sigmaY: 10,
        ),
        child: Container(
          color: color5.withOpacity(0.1),
          width: widget.width,
          padding: progress1
              ? const EdgeInsets.fromLTRB(0, 10, 0, 20)
              : const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 450),
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Stack(
                  children: [
                    Visibility(
                      visible: !progress1,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          widget.title,
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              progress1 = !progress1;
                            });
                            if (progress1) {
                              _animationController.reverse();
                            } else {
                              _animationController.forward();
                            }
                          },
                          child: AnimatedIcon(
                            icon: AnimatedIcons.close_menu,
                            progress: _animationController,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                progress1 ? widget.widget : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
