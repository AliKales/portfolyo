import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:portfolyo/UIs/custom_appbar.dart';
import 'package:portfolyo/UIs/custom_button_anim.dart';
import 'package:portfolyo/UIs/custom_textfield.dart';
import 'package:portfolyo/everything/funcs.dart';
import 'package:portfolyo/everything/simple_UIs.dart';
import 'package:portfolyo/firebase/auth.dart';
import 'package:portfolyo/firebase/firestore.dart';
import 'package:portfolyo/firebase/storage.dart';
import 'package:portfolyo/icons/custom_icons_icons.dart';
import 'package:portfolyo/models/work.dart';
import 'package:portfolyo/pages/user_page.dart';
import 'package:transparent_image/transparent_image.dart';

class WorksPage extends StatefulWidget {
  const WorksPage({Key? key, this.work}) : super(key: key);
  final Work? work;

  @override
  State<WorksPage> createState() => _WorksPageState();
}

class _WorksPageState extends State<WorksPage> {
  double height = 0;
  double width = 0;

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
    return WidgetBody(
      work: widget.work,
    );
  }
}

class WidgetBody extends StatefulWidget {
  const WidgetBody({Key? key, required this.work}) : super(key: key);
  final Work? work;

  @override
  State<WidgetBody> createState() => _WidgetBodyState();
}

class _WidgetBodyState extends State<WidgetBody> {
  late Work work;

  ScrollController sc = ScrollController();

  bool progress1 = true;
  bool progress2 = true;

  List<PlatformFile> images = [];
  List<String> imagesToDelete = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    work = widget.work == null ? Work() : Work.fromJson(widget.work!.toJson());
    if (Auth().isItMe()) {
      work.youtube ??= "";
      work.github ??= "";
      work.appstore ??= "";
      work.playstore ??= "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: sc,
      isAlwaysShown: true,
      child: SingleChildScrollView(
        controller: sc,
        child: Column(
          children: [
            CustomAppbar(width: MediaQuery.of(context).size.width),
            const SizedBox(
              height: 30,
            ),
            WidgetTextWithEdit(
              text: work.title ?? "Title",
              onTextChanged: (text) {
                work.title = text;
              },
              textStyle: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            SimpleUIs.bluredBackGround(
              child: Wrap(
                children: List.generate(
                  5,
                  (index) {
                    int sayi = work.images?.length ?? 0;
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ((work.images != null || images.isNotEmpty) &&
                              index < (sayi + (images.length)))
                          ? widgetImage(index)
                          : SizedBox(
                              height: 450,
                              width: 250,
                              child: SimpleUIs.widgetWithAuth(
                                widget: Center(
                                  child: IconButton(
                                    onPressed: () async {
                                      var response = await Funcs().pickImage();
                                      if (response != null) {
                                        images.add(response);
                                        setState(() {});
                                      }
                                    },
                                    iconSize: 40,
                                    icon: const Icon(
                                      Icons.add_a_photo_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    );
                  },
                ).toList(),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            WidgetTextWithEdit(
              text: work.description ?? "Description",
              onTextChanged: (text) {
                work.description = text;
              },
              isBluredText: true,
              textStyle: Theme.of(context).textTheme.headline6!.copyWith(
                    color: Colors.white,
                  ),
            ),
            const SizedBox(
              height: 60,
            ),
            Visibility(
              visible: checkLinks(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SimpleUIs.bluredBackGround(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          WidgetLink(
                            text: " GITHUB",
                            icon: CustomIcons.github,
                            url: work.github,
                            onEdit: (text) {
                              setState(() {
                                work.github = text;
                              });
                            },
                          ),
                          WidgetLink(
                            text: " YOUTUBE",
                            icon: CustomIcons.youtube,
                            url: work.youtube,
                            onEdit: (text) {
                              setState(() {
                                work.youtube = text;
                              });
                            },
                          ),
                          WidgetLink(
                            text: " PLAY STORE",
                            icon: CustomIcons.play_store,
                            url: work.playstore,
                            onEdit: (text) {
                              setState(() {
                                work.playstore = text;
                              });
                            },
                          ),
                          WidgetLink(
                            text: " APP STORE",
                            icon: CustomIcons.app_store,
                            url: work.appstore,
                            onEdit: (text) {
                              setState(() {
                                work.appstore = text;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SimpleUIs.widgetWithAuth(
              widget: CustomButtonWithAni(
                text: "SAVE",
                onClicked: saveWork,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  Column widgetImage(int index) {
    return Column(
      children: [
        checkImage(index)
            ? Image.memory(
                images[index - (work.images?.length ?? 0)].bytes!,
                height: 500,
                width: 250,
                fit: BoxFit.fill,
                errorBuilder: (_, __, ___) {
                  return widgetErrorBuilder();
                },
              )
            : FadeInImage.memoryNetwork(
                height: 500,
                width: 250,
                placeholder: kTransparentImage,
                image: work.images![index]['url'],
                imageErrorBuilder: (_, __, ___) {
                  return widgetErrorBuilder();
                },
                fit: BoxFit.fill,
              ),
        SimpleUIs.widgetWithAuth(
          widget: Column(
            children: [
              IconButton(
                onPressed: () {
                  if (checkImage(index)) {
                    setState(() {
                      images.removeAt(index - (work.images?.length ?? 0));
                    });
                  } else {
                    imagesToDelete.add(work.images![index]['path']);
                    setState(() {
                      work.images!.removeAt(index);
                    });
                  }
                },
                icon: const Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                ),
              ),
              checkImage(index)
                  ? const SizedBox.shrink()
                  : IconButton(
                      onPressed: () {
                        if (work.images![index]['url'] != work.thumbnail) {
                          setState(() {
                            work.thumbnail = work.images![index]['url'];
                          });
                          Funcs().showSnackBar(context, "Thumbnail Selected");
                        }
                      },
                      icon: Icon(
                        work.images![index]['url'] == work.thumbnail
                            ? Icons.photo_size_select_actual
                            : Icons.photo_size_select_actual_outlined,
                        color: Colors.white,
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  SizedBox widgetErrorBuilder() {
    return SizedBox(
      height: 450,
      width: 250,
      child: Center(
        child: Text(
          "ERROR LOADING IMAGE",
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                color: Colors.black,
              ),
        ),
      ),
    );
  }

  //FUNCTIONNNNNNNNN
  bool checkImage(int index) {
    return index >= (work.images?.length ?? 0);
  }

  Future saveWork() async {
    if (widget.work == null) {
      work.id = Funcs().generateRandomString(6);
      SimpleUIs().showProgressIndicator(context);
      await handleImages(false);
      bool response = await Firestore.addWork(work: work);
      Navigator.pop(context);
      if (response) {
        Navigator.pop(context, work);
      }
    } else if (Funcs().checkEquality(work.toJson(), widget.work!.toJson()) &&
        images.isEmpty &&
        imagesToDelete.isEmpty) {
      Funcs().showSnackBar(context, "You have not edited anything!");
    } else {
      SimpleUIs().showProgressIndicator(context);
      bool? response2 = await handleImages(work.images != null);

      bool response = false;

      if (response2 == null) {
        Navigator.pop(context);
        Funcs().showSnackBar(context, "ERROR!");
        return;
      } else if (response2) {
        response = await Firestore.updateWork(work: work);
      } else {
        response = await Firestore.updateWork(work: work, exWork: widget.work);
      }

      Navigator.pop(context);
      if (response) {
        Navigator.pop(context, work);
      }
    }
  }

  Future<bool?> handleImages(bool isTherePhoto) async {
    bool boolean = false;
    try {
      for (var item in imagesToDelete) {
        bool response = await Storage.deleteImage(context: context, path: item);
        if (!boolean && work.images != null && response) {
          boolean = true;
          bool response2 = await Firestore.deleteWork(work: widget.work!);
          if (!response2) {
            return null;
          }
        }
      }
      String path = "";
      int length = work.images?.length ?? 0;
      for (var i = 0; i < images.length; i++) {
        path =
            "users/${Funcs.uID}/works/${work.id}/images/${(length + i.toInt()).toString()}.${images[i].name.split(".").last}";

        String? response = await Storage.uploadImage(
            context: context, locationWithName: path, data: images[i].bytes!);
        if (response != null) {
          if (!boolean && isTherePhoto) {
            boolean = true;
            bool response2 = await Firestore.deleteWork(work: widget.work!);
            if (!response2) {
              return null;
            }
          }

          Map workMap = {'url': response, 'path': path};

          if (work.images == null) {
            work.images = [workMap];
          } else {
            work.images!.add(workMap);
          }

          if (i == 0 && work.thumbnail == null) {
            work.thumbnail = work.images?[0]['url'];
          }
        }
      }
    } catch (e) {
    }
    return boolean;
  }

  bool checkLinks() {
    if (work.github == null &&
        work.playstore == null &&
        work.appstore == null &&
        work.youtube == null) {
      return false;
    } else {
      return true;
    }
  }
}

class WidgetTextWithEdit extends StatefulWidget {
  const WidgetTextWithEdit({
    Key? key,
    required this.text,
    this.textStyle,
    this.isBluredText = false,
    required this.onTextChanged,
  }) : super(key: key);

  final String text;
  final TextStyle? textStyle;
  final bool isBluredText;
  final Function(String) onTextChanged;

  @override
  State<WidgetTextWithEdit> createState() => _WidgetTextWithEditState();
}

class _WidgetTextWithEditState extends State<WidgetTextWithEdit> {
  bool progress1 = true;
  TextEditingController tEC = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tEC.text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100),
      child: Column(
        children: [
          SimpleUIs.widgetWithAuth(
            widget: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    progress1 = !progress1;
                  });
                  if (progress1) {
                    widget.onTextChanged.call(tEC.text.trim());
                  }
                },
                icon: Icon(
                  progress1 ? Icons.edit : Icons.check_circle_outline_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          progress1
              ? getText()
              : CustomTextField(
                  text: "",
                  textInputType: TextInputType.multiline,
                  tEC: tEC,
                  width: null,
                ),
        ],
      ),
    );
  }

  Widget getText() {
    if (widget.isBluredText) {
      return SimpleUIs.bluredBackGround(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            tEC.text,
            style: widget.textStyle,
          ),
        ),
      );
    } else {
      return Text(
        tEC.text,
        style: widget.textStyle,
      );
    }
  }
}
