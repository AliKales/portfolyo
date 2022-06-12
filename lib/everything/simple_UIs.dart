import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:portfolyo/UIs/custom_button_anim.dart';
import 'package:portfolyo/everything/funcs.dart';
import 'package:portfolyo/everything/lists.dart';
import 'package:portfolyo/everything/size.dart';
import 'package:portfolyo/firebase/auth.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'colors.dart';

class SimpleUIs {
  static Widget elevatedButton({
    required context,
    required Function() onPress,
    required String text,
  }) {
    return ElevatedButton(
      onPressed: () {
        onPress.call();
      },
      style: ElevatedButton.styleFrom(primary: color3),
      child: Text(text),
    );
  }

  static Widget outlinedButton({
    required context,
    required Function() onPress,
    required String text,
  }) {
    return OutlinedButton(
      onPressed: onPress,
      style: OutlinedButton.styleFrom(side: const BorderSide(color: color3)),
      child: Text(
        text,
        style: const TextStyle(color: color5),
      ),
    );
  }

  static Widget textButton({
    required context,
    required Function() onPress,
    required String text,
    IconData? icon,
    Color? color,
  }) {
    if (icon != null) {
      return TextButton.icon(
        onPressed: onPress,
        icon: Icon(icon, color: color ?? color5),
        label: Text(
          text,
          style: TextStyle(color: color ?? color5),
        ),
      );
    }
    return TextButton(
      onPressed: onPress,
      child: Text(
        text,
        style: TextStyle(color: color ?? color5),
      ),
    );
  }

  static Widget widgetWithAuth({
    required Widget widget,
  }) {
    if (Funcs.uID == "" || Auth().getUID() != Funcs.uID) {
      return const SizedBox.shrink();
    } else {
      return widget;
    }
  }

  Widget progressIndicator() {
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }

  Widget progressIndicatorNotCentered() {
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }

  static Widget widgetWithProgress({
    required Widget widget,
    required bool progress,
    bool isCentered = true,
  }) {
    if (progress) {
      if (isCentered) {
        return SimpleUIs().progressIndicator();
      } else {
        return const CircularProgressIndicator.adaptive();
      }
    } else {
      return widget;
    }
  }

  Future showProgressIndicator(context) async {
    FocusScope.of(context).unfocus();
    if (ModalRoute.of(context)?.isCurrent ?? true) {
      await showGeneralDialog(
          barrierLabel: "Barrier",
          barrierDismissible: false,
          barrierColor: Colors.black.withOpacity(0.5),
          transitionDuration: const Duration(milliseconds: 500),
          context: context,
          pageBuilder: (_, __, ___) {
            return WillPopScope(
              onWillPop: () async => false,
              child: Center(
                child: progressIndicator(),
              ),
            );
          });
    }
  }

  static Future<DateTime?> showDatePicker({
    required context,
    required double height,
    required double width,
  }) async {
    DateTime? dateTime;
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Builder(
          builder: (context) {
            // Get available height and width of the build area of this widget. Make a choice depending on the size.
            var height = MediaQuery.of(context).size.height;
            var width = MediaQuery.of(context).size.width;
            return SizedBox(
              height: height / 2,
              width: width / 3.6,
              child: Column(
                children: [
                  SfDateRangePicker(
                    onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
                      dateTime = dateRangePickerSelectionChangedArgs.value;
                    },
                  ),
                  CustomButtonWithAni(
                    text: "DONE",
                    onClicked: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
    return dateTime;
  }

  static Widget bluredBackGround({required Widget child}) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10,
          sigmaY: 10,
        ),
        child: Container(
          color: color5.withOpacity(0.1),
          child: child,
        ),
      ),
    );
  }

  static Future<int?> showCountryPicker({
    required context,
    bool? barrierDismissible,
  }) async {
    int? response;
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Builder(
          builder: (context) {
            // Get available height and width of the build area of this widget. Make a choice depending on the size.
            var height = MediaQuery.of(context).size.height;
            var width = MediaQuery.of(context).size.width;
            return SizedBox(
              height: height / 3,
              width: width / 5,
              child: ListView.builder(
                itemCount: Lists().countries.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      response = index;
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(Lists().countries[index]),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
    return response;
  }

  ///* [showCustomDialog] shows picker from list like IOS design
  Future<int> showGeneralDialogFunc(context, List list, int value) async {
    FocusScope.of(context).unfocus();
    int val = 0;
    bool isSelected = false;
    await showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              margin: const EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              height: SizeConfig.safeBlockVertical! * 30,
              decoration: const BoxDecoration(
                  color: color1,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: SizeConfig.safeBlockVertical! * 4,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey))),
                  ),
                  NotificationListener<OverscrollIndicatorNotification>(
                    onNotification:
                        (OverscrollIndicatorNotification overscroll) {
                      overscroll.disallowIndicator();
                      return true;
                    },
                    child: ListWheelScrollView(
                      itemExtent: SizeConfig.safeBlockVertical! * 5,
                      onSelectedItemChanged: (selectedItem) {
                        val = selectedItem;
                      },
                      perspective: 0.005,
                      children: getChildrenForListWheel(
                        context,
                        list,
                      ),
                      physics: const FixedExtentScrollPhysics(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: ElevatedButton(
                        onPressed: () {
                          isSelected = true;
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.grey, elevation: 0),
                        child: const Text(
                          "Done",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              )),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
              .animate(anim),
          child: child,
        );
      },
    );
    if (isSelected) {
      return val;
    } else {
      return value;
    }
  }

  ///* [getChildrenForListWheel] shouldn't be used from anywhere, it's a specific code for [showGeneralDialogFunc]
  List<Widget> getChildrenForListWheel(context, List list) {
    List<Widget> listForWiget = [];
    for (var i = 0; i < list.length; i++) {
      listForWiget.add(Center(
        child: Text(
          list[i].toString(),
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ));
    }
    return listForWiget;
  }

  static void showCustomDialog(
      {required context,
      String title = "",
      Widget? content,
      bool? barriedDismissible,
      bool? onWillPop,
      List<Widget>? actions,
      bool activeCancelButton = false}) {
    if (activeCancelButton && actions != null) {
      actions.insert(
          0, TextButton(onPressed: () {}, child: const Text("Cancel")));
    }
    showDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      context: context,
      barrierDismissible: barriedDismissible ?? true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => onWillPop ?? true,
          child: AlertDialog(
            backgroundColor: color1,
            title: Text(
              title,
              style: const TextStyle(color: color4),
            ),
            content: content,
            actions: actions ??
                <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'OK',
                      style: TextStyle(color: color4),
                    ),
                  ),
                ],
          ),
        );
      },
    );
  }

  static Widget emptyWidget({
    double? height,
    double? width,
  }) {
    if (height == null && width == null) {
      return const SizedBox.shrink();
    } else if (width == null) {
      return SizedBox(
        height: SizeConfig().setHight(height!),
      );
    } else {
      return SizedBox(
        width: SizeConfig().setHight(width),
      );
    }
  }

  static Widget background({
    context,
    Widget? child,
  }) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter:
              ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken),
              image: const AssetImage("assets/backgrounds/bg1.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        child ?? const SizedBox.shrink(),
      ],
    );
  }

  static Widget buttonLogOut({required context}) {
    if (Auth().getEmail() == null) return const SizedBox.shrink();
    return IconButton(
      onPressed: () async {
        await Auth.signOut(context: context);
      },
      icon: const Icon(
        Icons.logout,
        color: color5,
        size: 30,
      ),
    );
  }
}

const int DEFAULT_NORMAL_SCROLL_ANIMATION_LENGTH_MS = 250;
const int DEFAULT_SCROLL_SPEED = 130;

class SmoothScrollWeb extends StatelessWidget {
  ///Same ScrollController as the child widget's.
  final ScrollController controller;

  ///Child scrollable widget.
  final Widget child;

  ///Scroll speed px/scroll.
  final int scrollSpeed;

  ///Scroll animation length in milliseconds.
  final int scrollAnimationLength;

  ///Curve of the animation.
  final Curve curve;

  double _scroll = 0;

  SmoothScrollWeb({
    required this.controller,
    required this.child,
    this.scrollSpeed = DEFAULT_SCROLL_SPEED,
    this.scrollAnimationLength = DEFAULT_NORMAL_SCROLL_ANIMATION_LENGTH_MS,
    this.curve = Curves.linear,
  });

  @override
  Widget build(BuildContext context) {
    controller.addListener(() {
      if (controller.position.activity is IdleScrollActivity) {
        _scroll = controller.position.extentBefore;
      }
    });

    return Listener(
      onPointerSignal: (pointerSignal) {
        int millis = scrollAnimationLength;
        if (pointerSignal is PointerScrollEvent) {
          if (pointerSignal.scrollDelta.dy > 0) {
            _scroll += scrollSpeed;
          } else {
            _scroll -= scrollSpeed;
          }
          if (_scroll > controller.position.maxScrollExtent) {
            _scroll = controller.position.maxScrollExtent;
            millis = scrollAnimationLength ~/ 2;
          }
          if (_scroll < 0) {
            _scroll = 0;
            millis = scrollAnimationLength ~/ 2;
          }

          controller.animateTo(
            _scroll,
            duration: Duration(milliseconds: millis),
            curve: curve,
          );
        }
      },
      child: child,
    );
  }
}
