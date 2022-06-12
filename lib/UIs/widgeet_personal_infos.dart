import 'package:flutter/material.dart';
import 'package:portfolyo/UIs/widget_blur_animation.dart';
import 'package:portfolyo/everything/funcs.dart';
import 'package:portfolyo/everything/simple_UIs.dart';
import 'package:portfolyo/firebase/auth.dart';
import 'package:portfolyo/firebase/firestore.dart';
import 'package:portfolyo/models/user.dart';

class WidgetPersonalInfos extends StatefulWidget {
  const WidgetPersonalInfos(
      {Key? key,
      required this.user,
      required this.onPrivateChange,
      required this.onPrivacyPasswordChange,
      required this.onCopyLink})
      : super(key: key);
  final User user;
  final Function(bool) onPrivateChange;
  final Function(String) onPrivacyPasswordChange;
  final Function() onCopyLink;

  @override
  State<WidgetPersonalInfos> createState() => _WidgetPersonalInfosState();
}

class _WidgetPersonalInfosState extends State<WidgetPersonalInfos>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    DateTime? birthTime =
        widget.user.birth == null ? null : DateTime.parse(widget.user.birth!);
    return WidgetBlurAnimation(
      title: "INFO",
      width: 444,
      widget: Column(
        children: [
          widgetColumnTexts(
              textDescription: "Full Name",
              textValue: widget.user.fullName ?? "",
              bunuAnlamanaGerekYok: true),
          widgetColumnTexts(
              textDescription: "Date of Birth",
              textValue:
                  birthTime == null ? "" : birthTime.toString().split(" ")[0]),
          widgetColumnTexts(
              textDescription: "Age",
              textValue: birthTime == null
                  ? ""
                  : Funcs().ageCalculator(birthTime).toString()),
          widgetColumnTexts(
            textDescription: "Country",
            textValue: widget.user.country ?? "",
            isDividerShown: true,
          ),
          widgetColumnTexts(
            textDescription: "Private Account",
            textValue: widget.user.private.toString(),
            isDividerShown: true,
          ),
          Visibility(
            visible: Auth().isItMe(),
            child: widgetColumnTexts(
              textDescription: "Privacy Password",
              textValue: "privacy-password",
              isDividerShown: true,
            ),
          ),
          Visibility(
            visible: Auth().isItMe(),
            child: widgetColumnTexts(
              textDescription: "Share Your Page",
              textValue: "share-page",
              isDividerShown: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget widgetColumnTexts({
    required String textDescription,
    required String textValue,
    bool isDividerShown = true,
    bool bunuAnlamanaGerekYok = false,
  }) {
    return Column(
      children: [
        Text(
          textDescription + ":",
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(color: Colors.white),
        ),
        getWidget(bunuAnlamanaGerekYok, textValue, textDescription),
        Visibility(
          visible: isDividerShown,
          child: const Divider(
            color: Colors.white,
          ),
        )
      ],
    );
  }

  Widget getWidget(
      bool bunuAnlamanaGerekYok, String textValue, String textDescription) {
    if (widget.user.email == "ali.kales@hotmail.com" && bunuAnlamanaGerekYok) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Tooltip(
            message: "Owner of this Website",
            child: Icon(
              Icons.star_border_purple500,
              color: Colors.amber,
            ),
          ),
          Text(
            textValue,
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  color: Colors.white,
                ),
          ),
        ],
      );
    } else if (textDescription == "Private Account") {
      return Tooltip(
        message: getString(),
        child: IconButton(
          onPressed: () async {
            if (!Auth().isItMe()) return;
            bool response = false;
            SimpleUIs().showProgressIndicator(context);
            if (widget.user.private ?? false) {
              response = await Firestore.update(
                  context: context, val: false, where: "private");
            } else {
              response = await Firestore.update(
                  context: context, val: true, where: "private");
            }
            Navigator.pop(context);
            if (response) {
              if (widget.user.private == null) {
                widget.onPrivateChange.call(true);
              } else {
                widget.onPrivateChange.call(widget.user.private!);
              }
            }
          },
          iconSize: 29,
          icon: Icon(
              widget.user.private ?? false
                  ? Icons.lock_outline_rounded
                  : Icons.lock_open_outlined,
              color: Colors.white),
        ),
      );
    } else if (textValue == "privacy-password") {
      return Tooltip(
        message:
            "If you have a private account, people need this password to see your page.",
        child: TextButton(
          onPressed: () async {
            SimpleUIs().showProgressIndicator(context);
            String newPass = Funcs().generateRandomString(16);
            bool response = await Firestore.update(
                context: context, val: newPass, where: "passwordForPrivacy");
            Navigator.pop(context);
            if (response) {
              widget.onPrivacyPasswordChange.call(newPass);
            }
          },
          child: Text(
            "Reset",
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: Colors.white),
          ),
        ),
      );
    } else if (textValue == "share-page") {
      return Tooltip(
        message: "Copy your link",
        child: IconButton(
          onPressed: () {
            widget.onCopyLink.call();
          },
          icon: Icon(
            Icons.copy,
            size: 29,
            color: Colors.white,
          ),
        ),
      );
    } else {
      return Text(
        textValue,
        style: Theme.of(context).textTheme.headline6!.copyWith(
              color: Colors.white,
            ),
      );
    }
  }

  String getString() {
    String stringOwner = Auth().isItMe() ? "You have" : "This is";
    if (widget.user.private ?? false) {
      return "$stringOwner a private account right now";
    } else {
      return "$stringOwner not a private account right now";
    }
  }
}
