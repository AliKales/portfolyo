import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:portfolyo/UIs/custom_button_anim.dart';
import 'package:portfolyo/everything/colors.dart';
import 'package:portfolyo/firebase/auth.dart';
import 'package:portfolyo/models/cv.dart';
import 'package:flutter/rendering.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:transparent_image/transparent_image.dart';

class Cv1 extends StatelessWidget {
  Cv1({
    Key? key,
    required this.cv,
    required this.width,
    this.isSaveable = true,
    this.image,
    this.onImageClicked,
    this.onEditClicked,
    this.onDelete,
  }) : super(key: key);

  final Function(Map)? onDelete;
  final CV cv;
  final double width;
  final bool isSaveable;
  final Uint8List? image;
  final Function()? onImageClicked;
  final Function()? onEditClicked;

  var context;

  final GlobalKey _globalKey = GlobalKey();

  bool progress1 = false;

  @override
  Widget build(BuildContext c) {
    context = c;
    return Column(
      children: [
        Visibility(
          visible: isSaveable,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: InkWell(
                onTap: () async {
                  await takePicture();
                },
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Icon(Icons.download, color: Colors.white),
                    Text(
                      "Save the CV as PDF",
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: Colors.white),
                    ),
                    Visibility(
                      visible: Auth().isItMe(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 180),
                        child: CustomButtonWithAni(
                          text: "Edit CV",
                          onClicked: () {
                            onEditClicked?.call();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        RepaintBoundary(
          key: _globalKey,
          child: Container(
            decoration: BoxDecoration(
              color: color1,
              border: Border.all(color: Colors.black, width: 1),
            ),
            margin: const EdgeInsets.symmetric(vertical: 20),
            width: 800,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 300,
                  color: color1,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      StatefulBuilder(builder: (context, _setState) {
                        return MouseRegion(
                          onEnter: (_) {
                            if (onImageClicked != null) {
                              _setState(() {
                                progress1 = true;
                              });
                            }
                          },
                          onExit: (_) {
                            if (onImageClicked != null) {
                              _setState(() {
                                progress1 = false;
                              });
                            }
                          },
                          child: ClipOval(
                            child: Stack(
                              children: [
                                image == null
                                    ? FadeInImage.memoryNetwork(
                                        placeholder: kTransparentImage,
                                        image: cv.linkToPP ?? "asd",
                                        fit: BoxFit.scaleDown,
                                        imageErrorBuilder: (_, __, ___) {
                                          return Container(
                                            width: ((width / 2) / 3) / 1.5,
                                            height: ((width / 2) / 3) / 1.5,
                                            color: Colors.grey,
                                          );
                                        },
                                        width: ((width / 2) / 3) / 1.5,
                                        height: ((width / 2) / 3) / 1.5,
                                      )
                                    : Image.memory(
                                        image!,
                                        width: ((width / 2) / 3) / 1.5,
                                        height: ((width / 2) / 3) / 1.5,
                                        fit: BoxFit.scaleDown,
                                      ),
                                progress1
                                    ? InkWell(
                                        onTap: () {
                                          onImageClicked?.call();
                                        },
                                        child: Container(
                                          width: ((width / 2) / 3) / 1.5,
                                          height: ((width / 2) / 3) / 1.5,
                                          color: Colors.black.withOpacity(0.8),
                                          child: const Icon(
                                              Icons.camera_alt_sharp,
                                              size: 30,
                                              color: color5),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 20),
                      widgetForLeftPart("ABOUT ME", 1, context),
                      widgetForLeftPart("LINKS", 2, context),
                      widgetForLeftPart("REFERENCES", 3, context),
                      widgetForLeftPart("LANGUAGES", 4, context),
                      widgetForLeftPart("ADDITIONAL DETAILS", 5, context),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 250,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cv.fullName ?? "Full Name",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4!
                                          .copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Text(
                                      cv.job ?? "Job",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5!
                                          .copyWith(
                                            color: Colors.black,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 225,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    widgetRowTextWIcons(
                                        cv.location ?? "Location",
                                        Icons.location_on_sharp),
                                    widgetRowTextWIcons(
                                        cv.phoneNumber ?? "Phone Num.",
                                        Icons.phone),
                                    widgetRowTextWIcons(
                                        cv.email ?? "E-Mail", Icons.mail),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        widgetColumn("WORK EXPERIENCE", 1),
                        widgetColumn("EDUCATION", 2),
                        widgetColumn("SKILLS", 3),
                        widgetColumn("HOBBIES", 4),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Column widgetColumn(String text, int type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Divider(
            color: Colors.grey,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              widgetsWithTypes(type),
            ],
          ),
        ),
      ],
    );
  }

  widgetsWithTypes(int type) {
    if (type == 1 || type == 2) {
      List<WEE>? list = type == 1 ? cv.workExperiences : cv.educations;
      return ListView.builder(
        itemCount: list?.length ?? 0,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          if (Auth().isItMe() && onDelete != null) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(child: widgetType1(list![index])),
                  widgetIconButtonDelete(
                      what: type == 1 ? "workExperiences" : "educations",
                      index: index),
                ],
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: widgetType1(list![index]),
            );
          }
        },
      );
    } else if (type == 3) {
      return Wrap(
        spacing: 10,
        runSpacing: 15,
        children: cv.skills?.map((e) => widgetType2(e)).toList() ?? [],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: widgetGridViewForText(list: cv.hobbies ?? [], what: "hobbies"),
      );
    }
  }

  IconButton widgetIconButtonDelete(
      {required String what, required int index}) {
    return IconButton(
      onPressed: () {
        onDelete?.call({"what": what, "index": index});
      },
      icon: Icon(
        Icons.delete_forever,
        color: Colors.red[900],
      ),
    );
  }

  Widget widgetType2(Skill skill) {
    Widget widgetMain = SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            skill.name ?? "Skill",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Stack(
            children: [
              Container(
                height: 10,
                width: 200,
                color: Colors.black.withOpacity(0.5),
              ),
              Container(
                height: 10,
                width: 200 / ((4 - (skill.capability ?? 1)) + 1),
                color: Colors.black,
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "(${skill.capability ?? "1"}/4)",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        ],
      ),
    );
    if (Auth().isItMe() && onDelete != null) {
      return Wrap(
        children: [
          widgetMain,
          widgetIconButtonDelete(
              what: "skills",
              index: cv.skills!.indexWhere((element) => element == skill))
        ],
      );
    }
    return widgetMain;
  }

  Column widgetForLeftPart(String text, int type, context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Divider(
            color: Colors.grey,
          ),
        ),
        Text(
          text,
          style: Theme.of(context).textTheme.headline6!.copyWith(color: color5),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: widgetTypeForLeftPart(type),
        ),
      ],
    );
  }

  Widget widgetTypeForLeftPart(int type) {
    if (type == 1) {
      return widgetText(text: cv.aboutMe ?? "-");
    } else if (type == 2) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: cv.links?.length ?? 0,
        itemBuilder: (context, index) {
          Widget mainWidget = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widgetText(text: cv.links?[index].name ?? ""),
              widgetText(text: cv.links?[index].link ?? ""),
              const SizedBox(
                height: 5,
              )
            ],
          );
          if (Auth().isItMe() && onDelete != null) {
            return Row(
              children: [
                Expanded(child: mainWidget),
                widgetIconButtonDelete(what: "links", index: index)
              ],
            );
          }
          return mainWidget;
        },
      );
    } else if (type == 3) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: cv.references?.length ?? 0,
        itemBuilder: (context, index) {
          Widget mainWidget = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widgetText(text: cv.references?[index].name ?? "", isBold: true),
              widgetText(text: cv.references?[index].jobTitle ?? ""),
              widgetText(text: cv.references?[index].phoneNumber ?? ""),
              widgetText(text: cv.references?[index].email ?? ""),
              const SizedBox(
                height: 15,
              )
            ],
          );

          if (Auth().isItMe() && onDelete != null) {
            return Row(
              children: [
                Expanded(child: mainWidget),
                widgetIconButtonDelete(what: "references", index: index)
              ],
            );
          }
          return mainWidget;
        },
      );
    } else if (type == 4) {
      return widgetGridViewForText(
          list: cv.languages ?? [], color: color5, what: "languages");
    } else {
      return ListView.builder(
        itemCount: cv.additionalDetails?.length ?? 0,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          Widget mainWidget =
              widgetText(text: cv.additionalDetails?[index] ?? "");

          if (Auth().isItMe() && onDelete != null) {
            return Row(
              children: [
                Expanded(child: mainWidget),
                widgetIconButtonDelete(what: "additionalDetails", index: index)
              ],
            );
          }
          return mainWidget;
        },
      );
    }
  }

  Text widgetText({
    required String text,
    bool isBold = false,
  }) {
    return Text(
      text,
      style: Theme.of(context).textTheme.subtitle1!.copyWith(
          color: color5,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
    );
  }

  Widget widgetGridViewForText(
      {required List list, Color? color, required String what}) {
    List<Widget> widgets = [];
    for (var i = 0; i < list.length; i++) {
      widgets.add(
        widgetRow(color, list[i], what, i),
      );
    }
    return Wrap(
      children: widgets,
      spacing: 10,
      runSpacing: 15,
    );
  }

  Widget widgetRow(Color? color, String text, String what, int index) {
    Widget textWidget = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.circle,
          size: 18,
          color: color,
        ),
        Expanded(
          child: Text(
            text,
            style: color == null
                ? Theme.of(context).textTheme.subtitle1
                : Theme.of(context).textTheme.subtitle1!.copyWith(color: color),
          ),
        ),
        if (Auth().isItMe() && onDelete != null)
          widgetIconButtonDelete(what: what, index: index)
      ],
    );

    return textWidget;
  }

  Row widgetType1(WEE wee) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
              "${wee.name ?? "Place Name"}\n${wee.location ?? "Location"}\n${wee.years ?? "Years"}",
              style: Theme.of(context).textTheme.subtitle1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Container(
                height: 10,
                width: 10,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.black),
              ),
              Container(color: Colors.black, width: 2, height: 20),
            ],
          ),
        ),
        Expanded(
          child: Text(
              "${wee.title ?? "Front-End Dev"}\n${wee.description ?? "Explanation of what you were doing."}",
              style: Theme.of(context).textTheme.subtitle1),
        ),
      ],
    );
  }

  Widget widgetRowTextWIcons(String text, IconData iconData) {
    return Row(
      children: [
        Icon(iconData),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context)
                .textTheme
                .subtitle2!
                .copyWith(color: Colors.black),
          ),
        ),
      ],
    );
  }

  Future takePicture() async {
    final boundary =
        _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    final image = await boundary?.toImage();
    final byteData = await image?.toByteData(format: ImageByteFormat.png);
    final imageBytes = byteData?.buffer.asUint8List();
    final pdf = pw.Document();

    final imageMemory = pw.MemoryImage(imageBytes!);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Image(imageMemory);
        },
      ),
    );

    final content = base64Encode((await pdf.save()).toList());
    AnchorElement(
        href: "data:application/octet-stream;charset=utf-16le;base64,$content")
      ..setAttribute("download", "aha.pdf")
      ..click();
  }
}
