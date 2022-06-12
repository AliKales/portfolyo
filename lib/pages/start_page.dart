import 'dart:async';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:portfolyo/UIs/custom_appbar.dart';
import 'package:portfolyo/UIs/custom_button_anim.dart';
import 'package:portfolyo/UIs/custom_textfield.dart';
import 'package:portfolyo/everything/colors.dart';
import 'package:portfolyo/everything/funcs.dart';
import 'package:portfolyo/everything/simple_UIs.dart';
import 'package:portfolyo/firebase/auth.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> with TickerProviderStateMixin {
  ScrollController scrollController = ScrollController();

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..forward();

  late final AnimationController _controller2 = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );

  late final AnimationController _controller3 = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );

  late final AnimationController _controller4 = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(0.0, -1.5),
    end: Offset.zero,
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ),
  );

  late final Animation<double> _doubleAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

  late final Animation<double> _doubleAnimationLogIn =
      Tween<double>(begin: 0.0, end: 1.0).animate(_controller4);

  late final Animation<Offset> _animationIcon = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0.0, 10),
  ).animate(
    CurvedAnimation(
      parent: _controller2,
      curve: Curves.easeInOut,
    ),
  );

  late final Animation<Offset> _offsetAnimationText = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(4, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller3,
    curve: Curves.easeInOut,
  ));

  TextEditingController tECEmailSignUp = TextEditingController();
  TextEditingController tECPasswordSignUp1 = TextEditingController();
  TextEditingController tECPasswordSignUp2 = TextEditingController();

  TextEditingController tECEmailLogIn = TextEditingController();
  TextEditingController tECPasswordLogIn = TextEditingController();

  StreamSubscription<User?>? _listener;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listener = FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, "/home", ModalRoute.withName("/start"));
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _listener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SimpleUIs.background(
        child: SmoothScrollWeb(
          controller: scrollController,
          child: widgetScrollView(width, context, height),
        ),
      ),
    );
  }

  SingleChildScrollView widgetScrollView(
      double width, BuildContext context, double height) {
    return SingleChildScrollView(
      controller: scrollController,
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomAppbar(width: width),
          SlideTransition(
            position: _offsetAnimation,
            child: FadeTransition(
              opacity: _doubleAnimation,
              child: SizedBox(
                child: Column(
                  children: [
                    SizedBox(height: (height / 8) * 2),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Text(
                        "Do You Need Somewhere For You Portfolio?",
                        style: Theme.of(context).textTheme.headline2!.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      "You are at the right place!",
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 30),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/home");
                      },
                      child: const Text(
                        "Continue as guest",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 60),
                    Text(
                      "Or scroll down",
                      style: Theme.of(context)
                          .textTheme
                          .button!
                          .copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    const Icon(
                      Icons.arrow_downward_rounded,
                      color: Colors.white,
                    ),
                    SizedBox(height: (height / 8) * 6),
                  ],
                ),
              ),
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              FadeTransition(
                opacity: _doubleAnimationLogIn,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 10,
                      sigmaY: 10,
                    ),
                    child: Container(
                      height: 395,
                      width: 889,
                      color: color5.withOpacity(0.1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: (width / 1.8) / 24,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  "Create An Account!",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .copyWith(color: color5),
                                ),
                                const Spacer(),
                                CustomTextField(
                                    text: "Email", tEC: tECEmailSignUp),
                                CustomTextField(
                                    text: "Password",
                                    tEC: tECPasswordSignUp1,
                                    isVisible: true),
                                CustomTextField(
                                    text: "Password",
                                    tEC: tECPasswordSignUp2,
                                    isVisible: true),
                                const Spacer(),
                                CustomButtonWithAni(
                                    text: "SIGN UP",
                                    onClicked: () {
                                      _signUp();
                                    }),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (width / 1.8) / 12,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  "Already Have An Account?",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .copyWith(color: color5),
                                ),
                                const Spacer(),
                                CustomTextField(
                                    text: "Email", tEC: tECEmailLogIn),
                                CustomTextField(
                                    text: "Password",
                                    tEC: tECPasswordLogIn,
                                    isVisible: true),
                                const Spacer(),
                                CustomButtonWithAni(
                                    text: "LOG IN",
                                    onClicked: () {
                                      _logIn();
                                    }),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (width / 1.8) / 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SlideTransition(
                    position: _offsetAnimationText,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Text(
                        "Let's start?",
                        style: Theme.of(context).textTheme.headline2!.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SlideTransition(
                    position: _animationIcon,
                    child: IconButton(
                      onPressed: () {
                        scrollController
                            .animateTo(
                                scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeIn)
                            .then((value) {
                          scrollController.jumpTo(
                              scrollController.position.maxScrollExtent);
                          _controller2.forward().then((value) {
                            _controller3.forward().then((value) {
                              _controller4.forward();
                            });
                          });
                        });
                      },
                      icon: const Icon(
                        Icons.play_circle_fill,
                        color: color5,
                        size: 48,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: (height / 8) * 2),
        ],
      ),
    );
  }

  //FUNCTIONSSSSSSSSSSSSS

  Future _signUp() async {
    if (tECEmailSignUp.text.trim().isEmpty ||
        tECPasswordSignUp1.text.trim().isEmpty ||
        tECPasswordSignUp2.text.trim().isEmpty) {
      Funcs().showSnackBar(context, "Email & Passwords can not be empty!");
      return;
    } else if (tECPasswordSignUp1.text.trim() !=
        tECPasswordSignUp2.text.trim()) {
      Funcs().showSnackBar(context, "Passwords do not match!");
      return;
    } else {
      SimpleUIs().showProgressIndicator(context);
      String? response = await Auth.signUp(
          email: tECEmailSignUp.text, password: tECPasswordSignUp1.text);
      if (response != null) {
        Navigator.pop(context);
        Funcs().showSnackBar(context, response);
      }
    }
  }

  Future _logIn() async {
    if (tECEmailLogIn.text.trim().isEmpty ||
        tECPasswordLogIn.text.trim().isEmpty) {
      Funcs().showSnackBar(context, "Email & Passwords can not be empty!");
      return;
    } else {
      SimpleUIs().showProgressIndicator(context);
      String? response = await Auth.logIn(
          email: tECEmailLogIn.text, password: tECPasswordLogIn.text);
      if (response != null) {
        Navigator.pop(context);
        Funcs().showSnackBar(context, response);
      }
    }
  }
}
