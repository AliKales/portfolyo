import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:portfolyo/UIs/custom_appbar.dart';
import 'package:portfolyo/UIs/custom_button_anim.dart';
import 'package:portfolyo/UIs/custom_textfield.dart';
import 'package:portfolyo/UIs/cvs/cv1.dart';
import 'package:portfolyo/everything/colors.dart';
import 'package:portfolyo/everything/funcs.dart';
import 'package:portfolyo/everything/simple_UIs.dart';
import 'package:portfolyo/firebase/firestore.dart';
import 'package:portfolyo/firebase/storage.dart';
import 'package:portfolyo/models/cv.dart';

class CvPage extends StatefulWidget {
  const CvPage({Key? key, required this.cv}) : super(key: key);

  final CV cv;

  @override
  State<CvPage> createState() => _CvPageState();
}

class _CvPageState extends State<CvPage> {
  double height = 0;
  double width = 0;

  ScrollController sc = ScrollController();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          SimpleUIs.background(),
          body(),
        ],
      ),
    );
  }

  body() {
    return WidgetBody(sc: sc, width: width, cv: widget.cv);
  }
}

class WidgetBody extends StatefulWidget {
  const WidgetBody({
    Key? key,
    required this.sc,
    required this.width,
    required this.cv,
  }) : super(key: key);

  final ScrollController sc;
  final double width;
  final CV cv;

  @override
  State<WidgetBody> createState() => _WidgetBodyState();
}

class _WidgetBodyState extends State<WidgetBody> {
  CV cv = CV();

  List<TextEditingController> tECs =
      List.generate(5, (i) => TextEditingController());

  List<TextEditingController> tECsLinks =
      List.generate(2, (i) => TextEditingController());

  List<TextEditingController> tECsReferences =
      List.generate(4, (i) => TextEditingController());

  List<TextEditingController> tECsInfos =
      List.generate(5, (i) => TextEditingController());

  TextEditingController tECLevel = TextEditingController();
  TextEditingController tECString = TextEditingController();
  TextEditingController tECAboutMe = TextEditingController();

  double _sliderValue = 1;

  PlatformFile? logoBase64;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cv = CV.fromJson(widget.cv.toJson());
    tECsInfos[0].text = cv.fullName ?? "";
    tECsInfos[1].text = cv.job ?? "";
    tECsInfos[2].text = cv.location ?? "";
    tECsInfos[3].text = cv.phoneNumber ?? "";
    tECsInfos[4].text = cv.email ?? "";
    tECAboutMe.text = cv.aboutMe ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: widget.sc,
      isAlwaysShown: true,
      child: SingleChildScrollView(
        controller: widget.sc,
        child: Column(
          children: [
            CustomAppbar(width: widget.width),
            const SizedBox(height: 20),
            SimpleUIs.bluredBackGround(child: widgetFirshChapter()),
            const SizedBox(height: 20),
            SimpleUIs.bluredBackGround(child: widgetSecondChapter()),
            const SizedBox(height: 20),
            SimpleUIs.bluredBackGround(child: widgetThirdChapter(context)),
            const SizedBox(height: 20),
            SimpleUIs.bluredBackGround(child: widgetFourthChapter()),
            const SizedBox(height: 20),
            SimpleUIs.bluredBackGround(
              child: Column(
                children: [
                  CustomTextField(
                    text: "About Me",
                    textInputType: TextInputType.multiline,
                    tEC: tECAboutMe,
                  ),
                  CustomButtonWithAni(
                    text: "Save",
                    onClicked: () {
                      if (tECAboutMe.text.trim() != "") {
                        cv.aboutMe = tECAboutMe.text.trim();
                        setState(() {});
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SimpleUIs.bluredBackGround(child: widgetFifthChapter()),
            const SizedBox(height: 20),
            SimpleUIs.bluredBackGround(
              child: widgetSixthChapter(),
            ),
            Scrollbar(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Cv1(
                  cv: cv,
                  width: widget.width,
                  isSaveable: false,
                  image: logoBase64?.bytes,
                  onDelete: (map) {
                    switch (map['what']) {
                      case "workExperiences":
                        setState(() {
                          cv.workExperiences!.removeAt(map["index"]);
                        });
                        break;
                      case "educations":
                        setState(() {
                          cv.educations!.removeAt(map["index"]);
                        });
                        break;
                      case "languages":
                        setState(() {
                          cv.languages!.removeAt(map["index"]);
                        });
                        break;
                      case "hobbies":
                        setState(() {
                          cv.hobbies!.removeAt(map["index"]);
                        });
                        break;
                      case "skills":
                        setState(() {
                          cv.skills!.removeAt(map["index"]);
                        });
                        break;
                      case "links":
                        setState(() {
                          cv.links!.removeAt(map["index"]);
                        });
                        break;
                      case "references":
                        setState(() {
                          cv.references!.removeAt(map["index"]);
                        });
                        break;
                      case "additionalDetails":
                        setState(() {
                          cv.additionalDetails!.removeAt(map["index"]);
                        });
                        break;
                      default:
                    }
                  },
                  onImageClicked: () async {
                    var response = await Funcs().pickImage();
                    if (response != null) {
                      setState(() {
                        logoBase64 = response;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            CustomButtonWithAni(
              text: "Save CV",
              onClicked: saveCV,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Column widgetSixthChapter() {
    return Column(
      children: [
        Wrap(
          children: [
            CustomTextField(text: "Full Name", tEC: tECsReferences[0]),
            CustomTextField(text: "Job", tEC: tECsReferences[1]),
            CustomTextField(text: "Email", tEC: tECsReferences[2]),
            CustomTextField(text: "Phone", tEC: tECsReferences[3]),
          ],
        ),
        CustomButtonWithAni(
          text: "Add Reference",
          onClicked: () {
            addReference();
          },
        )
      ],
    );
  }

  Column widgetFifthChapter() {
    return Column(
      children: [
        Wrap(
          children: [
            CustomTextField(text: "Name", tEC: tECsLinks[0]),
            CustomTextField(text: "Link", tEC: tECsLinks[1]),
          ],
        ),
        CustomButtonWithAni(
          text: "Add Link",
          onClicked: () {
            addLink();
          },
        )
      ],
    );
  }

  Column widgetFourthChapter() {
    return Column(
      children: [
        CustomTextField(text: "Hobby/Language/Additional Det.", tEC: tECString),
        Wrap(
          children: [
            CustomButtonWithAni(
              text: "Add Hobby",
              onClicked: () {
                addStringToList(text: tECString.text.trim(), which: 1);
              },
            ),
            CustomButtonWithAni(
              text: "Add Language",
              onClicked: () {
                addStringToList(text: tECString.text.trim(), which: 2);
              },
            ),
            CustomButtonWithAni(
              text: "Add Addi. Det.",
              onClicked: () {
                addStringToList(text: tECString.text.trim(), which: 3);
              },
            ),
          ],
        ),
      ],
    );
  }

  Column widgetThirdChapter(BuildContext context) {
    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            CustomTextField(text: "Skill Name", tEC: tECLevel),
            Column(
              children: [
                Text(
                  "Level: $_sliderValue",
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: color5),
                ),
                SizedBox(
                  width: 300,
                  child: Slider(
                    value: _sliderValue,
                    min: 1,
                    max: 4,
                    divisions: 3,
                    activeColor: color5,
                    onChanged: (value) {
                      setState(() {
                        _sliderValue = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        CustomButtonWithAni(
          text: "Add Skill",
          onClicked: () {
            addSkill();
          },
        )
      ],
    );
  }

  Column widgetSecondChapter() {
    return Column(
      children: [
        Wrap(
          children: [
            CustomTextField(
              text: "Name",
              tEC: tECs[0],
            ),
            CustomTextField(
              text: "Location",
              tEC: tECs[1],
            ),
            CustomTextField(
              text: "Years (2012-2020)",
              tEC: tECs[2],
            ),
            CustomTextField(
              text: "Title",
              tEC: tECs[3],
            ),
            CustomTextField(
              text: "Description",
              tEC: tECs[4],
            ),
          ],
        ),
        Wrap(
          children: [
            CustomButtonWithAni(
              text: "Add Work Exp.",
              onClicked: () {
                addWEE(true);
              },
            ),
            CustomButtonWithAni(
              text: "Add Education",
              onClicked: () {
                addWEE(false);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget widgetFirshChapter() {
    return Column(
      children: [
        Wrap(
          children: [
            CustomTextField(
              text: "Full Name",
              tEC: tECsInfos[0],
            ),
            CustomTextField(
              text: "Job",
              tEC: tECsInfos[1],
            ),
            CustomTextField(
              text: "Location",
              tEC: tECsInfos[2],
            ),
            CustomTextField(
              text: "Phone Number",
              tEC: tECsInfos[3],
            ),
            CustomTextField(
              text: "Email",
              tEC: tECsInfos[4],
            ),
          ],
        ),
        CustomButtonWithAni(
          text: "Save",
          onClicked: () {
            saveInfos();
          },
        )
      ],
    );
  }

  //FUNCTIONSSSSSSSSSSSSSSSSS

  Future saveCV() async {
    // if (Funcs().checkEquality(cv.toJson(), widget.cv.toJson()) &&
    //     logoBase64 == null) {
    //   Funcs().showSnackBar(context, "You have not edited anything!");
    //   return;
    // }

    SimpleUIs().showProgressIndicator(context);

    if (logoBase64 != null) {
      String? url = await Storage.uploadImage(
          context: context,
          locationWithName:
              "users/${Funcs.uID}/pp.${logoBase64!.name.split(".").last}",
          data: logoBase64!.bytes!);

      if (url == null) return;

      setState(() {
        cv.linkToPP = url;
      });
    }

    bool? response =
        await Firestore.update(context: context, val: cv.toJson(), where: "cv");
    Navigator.pop(context);

    if (!response) {
      Navigator.pop(context, cv);
    }
  }

  void saveInfos() {
    if (tECsInfos.every((element) => element.text.trim() == "")) {
      return;
    }
    cv.fullName = tECsInfos[0].text.trim();
    cv.job = tECsInfos[1].text.trim();
    cv.location = tECsInfos[2].text.trim();
    cv.phoneNumber = tECsInfos[3].text.trim();
    cv.email = tECsInfos[4].text.trim();

    setState(() {});
  }

  void addReference() {
    if (tECsReferences.every((element) => element.text.trim() == "")) {
      return;
    }

    Reference reference = Reference(
      name: tECsReferences[0].text.trim(),
      jobTitle: tECsReferences[1].text.trim(),
      email: tECsReferences[2].text.trim(),
      phoneNumber: tECsReferences[3].text.trim(),
    );

    cv.references == null
        ? cv.references = [reference]
        : cv.references!.add(reference);

    for (var element in tECsReferences) {
      element.clear();
    }
    setState(() {});
  }

  void addLink() {
    if (tECsLinks.every((element) => element.text.trim() == "")) {
      return;
    }

    Link link = Link(
      name: tECsLinks[0].text.trim(),
      link: tECsLinks[1].text.trim(),
    );

    cv.links == null ? cv.links = [link] : cv.links!.add(link);

    for (var element in tECsLinks) {
      element.clear();
    }

    setState(() {});
  }

  void addStringToList({
    required String text,
    required int which,
  }) {
    if (text == "") {
      return;
    }

    if (which == 1) {
      cv.hobbies == null ? cv.hobbies = [text] : cv.hobbies!.add(text);
    } else if (which == 2) {
      cv.languages == null ? cv.languages = [text] : cv.languages!.add(text);
    } else if (which == 3) {
      cv.additionalDetails == null
          ? cv.additionalDetails = [text]
          : cv.additionalDetails!.add(text);
    }
    tECString.clear();
    setState(() {});
  }

  void addSkill() {
    if (tECLevel.text.trim() == "") {
      return;
    }
    Skill skill =
        Skill(capability: _sliderValue.toInt(), name: tECLevel.text.trim());
    if (cv.skills == null) {
      cv.skills = [skill];
    } else {
      cv.skills!.add(skill);
    }

    tECLevel.clear();
    _sliderValue = 1;
    setState(() {});
  }

  void addWEE(bool isWorkExp) {
    int response = tECs.indexWhere((element) => element.text.trim() == "");

    if (response != -1) return;

    WEE wee = WEE(
      name: tECs[0].text.trim(),
      years: tECs[1].text.trim(),
      description: tECs[2].text.trim(),
      location: tECs[3].text.trim(),
      title: tECs[4].text.trim(),
    );
    if (isWorkExp) {
      cv.workExperiences ??= <WEE>[];
      cv.workExperiences!.add(wee);
    } else {
      cv.educations ??= <WEE>[];
      cv.educations!.add(wee);
    }
    for (var element in tECs) {
      element.clear();
    }
    setState(() {});
  }
}
