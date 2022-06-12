import 'package:flutter/material.dart';
import 'package:portfolyo/UIs/custom_appbar.dart';
import 'package:portfolyo/everything/colors.dart';
import 'package:portfolyo/everything/funcs.dart';
import 'package:portfolyo/everything/simple_UIs.dart';
import 'package:portfolyo/firebase/auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          SimpleUIs.background(),
          widgetScrollView(width, context, height),
        ],
      ),
    );
  }

  widgetScrollView(width, context, height) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomAppbar(
            width: width,
            icons: [
              IconButton(
                onPressed: () {
                  String? uid = Auth().getUID();
                  if (uid == null) {
                    Funcs().showSnackBar(context, "Please log-in!");
                  } else {
                    Navigator.pushNamed(
                        context, "/user?uid=${Auth().getUID()}");
                  }
                },
                icon: const Icon(
                  Icons.account_circle_sharp,
                  color: color5,
                  size: 30,
                ),
              ),
              SimpleUIs.buttonLogOut(context: context),
            ],
          ),
          SizedBox(height: (height / 8) * 3),
          WidgetTextFieldSearch(
            height: height,
            width: width,
          ),
        ],
      ),
    );
  }
}

class WidgetTextFieldSearch extends StatefulWidget {
  const WidgetTextFieldSearch({
    Key? key,
    required this.height,
    required this.width,
  }) : super(key: key);

  final double height;
  final double width;

  @override
  State<WidgetTextFieldSearch> createState() => _WidgetTextFieldSearchState();
}

class _WidgetTextFieldSearchState extends State<WidgetTextFieldSearch>
    with SingleTickerProviderStateMixin {
  double customWidth = 9;

  FocusNode focusNode = FocusNode();
  TextEditingController tEC = TextEditingController();

  late final AnimationController _controller1 = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );

  late final Animation<double> _doubleAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(_controller1);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode.addListener(onFocusChange);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller1.dispose();
    focusNode.removeListener(onFocusChange);
    focusNode.dispose();
    super.dispose();
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      setState(() {
        customWidth = 5;
      });
    } else {
      setState(() {
        customWidth = 9;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: widget.width / customWidth,
          child: TextField(
            controller: tEC,
            focusNode: focusNode,
            maxLines: 1,
            onSubmitted: (text) => search(),
            onChanged: (text) {
              if (text == "") {
                _controller1.reverse();
              } else {
                _controller1.forward();
              }
            },
            style: const TextStyle(fontSize: 17),
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              filled: true,
              prefixIcon: Icon(Icons.person_search_sharp,
                  color: Theme.of(context).iconTheme.color),
              border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              fillColor: color5,
              contentPadding: EdgeInsets.zero,
              hintText: 'Search User',
            ),
          ),
        ),
        FadeTransition(
          opacity: _doubleAnimation,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () => search(),
              child: const Icon(
                Icons.search,
                color: color5,
                size: 40,
              ),
            ),
          ),
        )
      ],
    );
  }

  void search() {
    if (tEC.text.trim() == "") return;
    Navigator.pushNamed(context, "/user?uid=${tEC.text.trim()}");
  }
}
