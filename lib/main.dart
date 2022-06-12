import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:portfolyo/everything/colors.dart';
import 'package:portfolyo/everything/funcs.dart';
import 'package:portfolyo/pages/home_page.dart';
import 'package:portfolyo/pages/start_page.dart';
import 'package:portfolyo/pages/user_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAGyRy686Tx1rSe0jYhckarkLIrZoa_1W4",
          appId: "1:654767523604:web:2ebbd62fce09dccef4a401",
          storageBucket: "gs://portfolyo-8f544.appspot.com",
          messagingSenderId: "654767523604",
          projectId: "portfolyo-8f544"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
              builder: (_) => const StartPage(), settings: settings);
        },
        onGenerateInitialRoutes: (navigator) {
          return [generateRoute(navigator, null)];
        },
        onGenerateRoute: (settings) {
          return generateRoute(settings.name ?? "", settings);
        },
        title: 'Portfolion',
        theme: ThemeData(
          primarySwatch: color1Map,
          tooltipTheme: TooltipTheme.of(context).copyWith(
              textStyle: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(color: Colors.white)),
          scrollbarTheme: const ScrollbarThemeData().copyWith(
              thumbColor: MaterialStateProperty.all(Colors.grey[500])),
        ) //fontFamily: "RobotoSlab-Regular"),
        );
  }

  dynamic generateRoute(String link, RouteSettings? settings) {
    if (link.contains("/home")) {
      return MaterialPageRoute(
          builder: (_) => const HomePage(), settings: settings);
    } else if ((link.contains("/user")) &&
        (link.contains("?uid=")) &&
        (link.endsWith("?uid=") == false)) {
      return MaterialPageRoute(
          builder: (_) => UserPage(link: link), settings: settings);
    } else {
      return MaterialPageRoute(
          builder: (_) => const StartPage(), settings: settings);
    }
  }
}
