import 'dart:ui';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:portfolyo/UIs/custom_appbar.dart';
import 'package:portfolyo/UIs/custom_button_anim.dart';
import 'package:portfolyo/UIs/custom_textfield.dart';
import 'package:portfolyo/UIs/cvs/cv1.dart';
import 'package:portfolyo/UIs/widgeet_personal_infos.dart';
import 'package:portfolyo/UIs/widget_blur_animation.dart';
import 'package:portfolyo/everything/funcs.dart';
import 'package:portfolyo/everything/lists.dart';
import 'package:portfolyo/everything/simple_UIs.dart';
import 'package:portfolyo/firebase/auth.dart';
import 'package:portfolyo/firebase/firestore.dart';
import 'package:portfolyo/icons/custom_icons_icons.dart';
import 'package:portfolyo/models/cv.dart';
import 'package:portfolyo/models/user.dart';
import 'package:portfolyo/models/work.dart';
import 'package:portfolyo/pages/cv_page.dart';
import 'package:portfolyo/pages/works_page.dart';
import 'package:transparent_image/transparent_image.dart';

import '../everything/colors.dart';

enum Status {
  loading,
  error,
  exist,
  empty,
}

class UserPage extends StatefulWidget {
  const UserPage({
    Key? key,
    required this.link,
  }) : super(key: key);

  final String link;

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  double height = 0;
  double width = 0;

  Status status = Status.loading;

  User? user;

  Map params = {};

  String errorMessage = "";

  String? passwordForPrivacy;

  @override
  void initState() {
    super.initState();
    List<String> paramsList = widget.link.split("?")[1].split("&");

    for (var item in paramsList) {
      params[item.split("=")[0]] = item.split("=")[1];
    }

    Funcs.uID = params['uid'];

    if (params.containsKey('pw')) {
      passwordForPrivacy = params['pw'];
    }

    WidgetsBinding.instance!.addPostFrameCallback((_) => start());
  }

  start() {
    Firestore.getUser(
            uid: params['uid'], passwordForPrivacy: passwordForPrivacy)
        .then((value) {
      if (value != null && value.fullName!.contains("error-found")) {
        status == Status.error;
        errorMessage = value.fullName!.split("&")[1];
      } else {
        user = value;
        status = value == null ? Status.empty : Status.exist;
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Title(
        color: Colors.white,
        title: user == null ? "Portfolion" : "Portfolion - ${user!.fullName}",
        child: Stack(
          children: [
            SimpleUIs.background(),
            body(),
          ],
        ),
      ),
    );
  }

  body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomAppbar(
            width: width,
            icons: [
              SimpleUIs.buttonLogOut(context: context),
            ],
          ),
          getWidgetForBody(),
        ],
      ),
    );
  }

  Widget getWidgetForBody() {
    if (errorMessage != "") {
      return widgetTextMessage(errorMessage);
    } else if (status == Status.loading) {
      return widgetLoading();
    } else if (status == Status.empty && Auth().isItMe()) {
      return SizedBox(
        height: height - (height / 6),
        width: width,
        child: Center(
          child: SingleChildScrollView(
            child: WidgetCreateAccount(
              onUser: (value) {
                setState(() {
                  user = value;
                  status = Status.exist;
                });
              },
            ),
          ),
        ),
      );
    } else if (status == Status.empty && Auth().isItMe() == false) {
      return widgetTextMessage("User not found!");
    } else {
      return WidgetExist(
        height: height,
        width: width,
        user: user ?? User(),
      );
    }
  }

  SizedBox widgetTextMessage(String text) {
    return SizedBox(
      height: height - (height / 6),
      width: width,
      child: Center(
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .headline3!
              .copyWith(color: Colors.white),
        ),
      ),
    );
  }

  SizedBox widgetLoading() {
    return SizedBox(
      height: height - (height / 6),
      width: width,
      child: SimpleUIs().progressIndicator(),
    );
  }
}

class WidgetExist extends StatefulWidget {
  const WidgetExist(
      {Key? key, required this.height, required this.width, required this.user})
      : super(key: key);
  final double height;
  final double width;
  final User user;

  @override
  State<WidgetExist> createState() => _WidgetExistState();
}

class _WidgetExistState extends State<WidgetExist> {
  ScrollController sc = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: sc,
      isAlwaysShown: true,
      child: SingleChildScrollView(
        controller: sc,
        child: Column(
          children: [
            SizedBox(height: widget.height / 8),
            WidgetPersonalInfos(
              user: widget.user,
              onCopyLink: () {
                String uri = Uri.base.toString();
                List listUri = uri.split("?");
                Funcs.copy(
                    value:
                        "${listUri[0]}?uid=${Auth().getUID()}&pw=${widget.user.passwordForPrivacy}",
                    context: context);
              },
              onPrivacyPasswordChange: (value) {
                widget.user.passwordForPrivacy = value;
              },
              onPrivateChange: (value) {
                setState(() {
                  widget.user.private = value;
                });
              },
            ),
            SizedBox(height: widget.height / 8),
            WidgetBlurAnimation(
              title: "CV",
              width: 889,
              widget: widget.user.cv == null
                  ? getButton(
                      text: "Add CV",
                      function: () {
                        cvFunction();
                      },
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Cv1(
                        cv: widget.user.cv!,
                        width: widget.width,
                        onEditClicked: () {
                          cvFunction();
                        },
                      ),
                    ),
            ),
            SizedBox(height: widget.height / 8),
            WidgetBlurAnimation(
              title: "WORKS",
              widget: Column(
                children: [
                  getButton(
                    text: "Add a Work",
                    function: () {
                      worksFunction();
                    },
                  ),
                  widget.user.works == null
                      ? const SizedBox.shrink()
                      : Wrap(
                          children: widget.user.works!
                              .map(
                                (e) => WidgetContainerWork(
                                  work: e,
                                  onDelete: (work) async {
                                    SimpleUIs().showProgressIndicator(context);
                                    bool response =
                                        await Firestore.deleteWork(work: work);
                                    if (response) {
                                      setState(() {
                                        widget.user.works!.remove(work);
                                      });
                                      Navigator.pop(context);
                                      Funcs().showSnackBar(context, "DONE!");
                                    }
                                  },
                                  onClicked: () {
                                    onWorkClicked(e);
                                  },
                                ),
                              )
                              .toList(),
                        ),
                ],
              ),
              width: widget.width / 1.8,
            ),
            SizedBox(height: widget.height / 8),
          ],
        ),
      ),
    );
  }

  Widget getButton({
    required String text,
    required Function function,
  }) {
    return SimpleUIs.widgetWithAuth(
      widget: CustomButtonWithAni(
        text: text,
        onClicked: () {
          function.call();
        },
      ),
    );
  }

  //FUNCTIONSSSSSS
  Future onWorkClicked(Work work) async {
    var response = await Funcs().navigatorPush(
        context,
        WorksPage(
          work: work,
        ));
    if (response != null) {
      widget.user.works![widget.user.works!
          .indexWhere((element) => element.id == response.id)] = response;
      setState(() {});
    }
  }

  Future cvFunction() async {
    var response = await Funcs().navigatorPush(
        context,
        CvPage(
          cv: widget.user.cv ?? CV(),
        ));
    if (response != null) {
      setState(() {
        widget.user.cv = response;
      });
    }
  }

  Future worksFunction() async {
    var response = await Funcs().navigatorPush(context, const WorksPage());
    if (response != null) {
      if (widget.user.works == null) {
        widget.user.works = [response];
      } else {
        int integer = widget.user.works!
            .indexWhere((element) => element.id == response.id);
        if (integer == -1) {
          widget.user.works!.add(response);
        } else {
          widget.user.works![integer] = response;
        }
      }
      setState(() {});
    }
  }
}

class WidgetContainerWork extends StatelessWidget {
  const WidgetContainerWork({
    Key? key,
    required this.work,
    required this.onClicked,
    required this.onDelete,
  }) : super(key: key);

  final Work work;
  final Function() onClicked;
  final Function(Work) onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            onClicked.call();
          },
          child: Container(
            color: Colors.white,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            height: 750,
            width: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 500,
                  width: 250,
                  decoration: const BoxDecoration(color: Colors.grey),
                  child: Stack(
                    children: [
                      work.thumbnail == null
                          ? const SizedBox.shrink()
                          : SizedBox(
                              height: 500,
                              width: 250,
                              child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: work.thumbnail!,
                                fit: BoxFit.fill,
                                imageErrorBuilder: (_, __, ___) {
                                  return const SizedBox(
                                    height: 500,
                                    width: 250,
                                  );
                                },
                              ),
                            ),
                      WidgetOnMouseCursor(
                        urls: [work.github, work.playstore, work.appstore],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  work.title ?? "",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Text(
                    work.description ?? "",
                    overflow: TextOverflow.fade,
                    softWrap: true,
                    maxLines: null,
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Colors.grey[850],
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 3),
        Visibility(
          visible: Auth().isItMe(),
          child: IconButton(
            onPressed: () => onDelete.call(work),
            icon: Icon(
              Icons.delete_forever,
              color: Colors.red[900],
            ),
          ),
        ),
      ],
    );
  }
}

class WidgetOnMouseCursor extends StatefulWidget {
  const WidgetOnMouseCursor({Key? key, required this.urls}) : super(key: key);
  final List<String?> urls;

  @override
  State<WidgetOnMouseCursor> createState() => _WidgetOnMouseCursorState();
}

class _WidgetOnMouseCursorState extends State<WidgetOnMouseCursor> {
  bool isShown = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        if (widget.urls.any((element) => element.runtimeType == String)) {
          setState(() {
            isShown = true;
          });
        }
      },
      onExit: (event) {
        setState(() {
          isShown = false;
        });
      },
      child: !isShown
          ? const SizedBox(
              height: 500,
              width: 250,
            )
          : Container(
              height: 500,
              width: 250,
              color: Colors.black.withOpacity(0.9),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  WidgetLink(
                      text: "GITHUB",
                      icon: CustomIcons.github,
                      url: widget.urls[0]),
                  WidgetLink(
                      text: "PLAY STORE",
                      icon: CustomIcons.play_store,
                      url: widget.urls[1]),
                  WidgetLink(
                      text: "APP STORE",
                      icon: CustomIcons.app_store,
                      url: widget.urls[2]),
                ],
              ),
            ),
    );
  }
}
///////////////////////////////////

class WidgetLink extends StatefulWidget {
  const WidgetLink(
      {Key? key, required this.text, required this.icon, this.url, this.onEdit})
      : super(key: key);
  final String text;
  final IconData icon;
  final String? url;
  final Function(String)? onEdit;

  @override
  State<WidgetLink> createState() => _WidgetLinkState();
}

class _WidgetLinkState extends State<WidgetLink> {
  bool isCurserOn = false;
  bool progress1 = true;
  TextEditingController tEC = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tEC.text = widget.url ?? "";
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onEdit == null && (widget.url == null || widget.url == "")) {
      return const SizedBox.shrink();
    }
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          isCurserOn = true;
        });
      },
      onExit: (event) {
        setState(() {
          isCurserOn = false;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            html.window.open(widget.url!, 'new tab');
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: progress1,
                child: Icon(widget.icon,
                    color: isCurserOn ? Colors.blue : Colors.white,
                    size: isCurserOn ? 32 : 28),
              ),
              Visibility(
                visible: progress1,
                child: Text(
                  widget.text,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: isCurserOn ? Colors.blue : Colors.white,
                      fontWeight: isCurserOn ? FontWeight.bold : null),
                ),
              ),
              Visibility(
                visible: !progress1,
                child: CustomTextField(text: widget.text, tEC: tEC),
              ),
              Visibility(
                visible: (Auth().isItMe() && widget.onEdit != null),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      progress1 = !progress1;
                    });
                    if (progress1) {
                      widget.onEdit!.call(tEC.text.trim());
                    }
                  },
                  icon: Icon(
                    progress1
                        ? Icons.edit
                        : Icons.check_circle_outline_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////

class WidgetCreateAccount extends StatefulWidget {
  const WidgetCreateAccount({Key? key, required this.onUser}) : super(key: key);

  final Function(User) onUser;

  @override
  State<WidgetCreateAccount> createState() => _WidgetCreateAccountState();
}

class _WidgetCreateAccountState extends State<WidgetCreateAccount> {
  TextEditingController tECFullName = TextEditingController();
  TextEditingController tECBirthDate = TextEditingController();
  TextEditingController tECCountry = TextEditingController();
  TextEditingController tECContantEmail = TextEditingController();
  DateTime? dTBirthDate;
  int? country;
  bool isPrivatAcc = false;

  double height = 0;
  double width = 0;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tECFullName.dispose();
    tECBirthDate.dispose();
    tECCountry.dispose();
    tECContantEmail.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10,
          sigmaY: 10,
        ),
        child: Container(
          color: color5.withOpacity(0.1),
          height: 526,
          width: 444,
          child: Column(
            children: [
              const Spacer(),
              CustomTextField(tEC: tECFullName, text: "Full Name"),
              CustomTextField(
                tEC: tECBirthDate,
                text: "Birth Date",
                readOnly: true,
                onTap: () {
                  showDatePicker();
                },
              ),
              CustomTextField(
                tEC: tECCountry,
                text: "Country",
                readOnly: true,
                onTap: () async {
                  country = await SimpleUIs.showCountryPicker(context: context);
                  if (country != null) {
                    setState(() {
                      tECCountry.text = Lists().countries[country!];
                    });
                  }
                },
              ),
              CustomTextField(
                tEC: tECContantEmail,
                text: "Contact Email",
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Theme(
                    data: Theme.of(context)
                        .copyWith(unselectedWidgetColor: color5),
                    child: Checkbox(
                      value: isPrivatAcc,
                      checkColor: Colors.black, // color of tick Mark
                      activeColor: color5,
                      onChanged: (b) {
                        setState(() {
                          isPrivatAcc = b!;
                        });
                      },
                    ),
                  ),
                  Text(
                    "Private Account",
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: color5),
                  ),
                ],
              ),
              const Spacer(),
              CustomButtonWithAni(
                text: "Create",
                onClicked: createAccount,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showDatePicker() async {
    var response = await SimpleUIs.showDatePicker(
        context: context, height: height, width: width);
    if (response != null) {
      dTBirthDate = response;
      setState(() {
        tECBirthDate.text = dTBirthDate.toString().split(" ")[0];
      });
    }
  }

  Future createAccount() async {
    if (tECFullName.text.trim() == "" ||
        country == null ||
        tECContantEmail.text.trim() == "" ||
        dTBirthDate == null) {
      //
      Funcs().showSnackBar(context, "Please fill everything!");
      return;
    }

    SimpleUIs().showProgressIndicator(context);

    User? user = await Firestore.createUser(
      user: User(
        birth: dTBirthDate!.toIso8601String(),
        contactEmail: tECContantEmail.text.trim(),
        country: tECCountry.text.trim(),
        email: Auth().getEmail(),
        fullName: tECFullName.text.trim(),
        joinDate: DateTime.now(),
        passwordForPrivacy: Funcs().generateRandomString(16),
        private: isPrivatAcc,
        uID: Auth().getUID(),
      ),
    );

    Navigator.pop(context);

    if (user != null) {
      widget.onUser.call(user);
    }
  }
}
