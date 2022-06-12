import 'package:flutter/material.dart';
import 'package:portfolyo/everything/colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    this.tEC,
    required this.text,
    this.isVisible = false,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.textInputType,
    this.width = 280,
  }) : super(key: key);

  final String text;
  final TextEditingController? tEC;
  final bool isVisible;
  final bool readOnly;
  final Function()? onTap;
  final Function(String)? onChanged;
  final TextInputType? textInputType;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return widgetMain(context);
  }

  Column widgetMain(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            text,
            style:
                Theme.of(context).textTheme.headline6!.copyWith(color: color5),
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: textInputType == null ? 40 : null,
              width: width,
              child: TextField(
                onTap: onTap,
                keyboardType: textInputType,
                onChanged: (text) {
                  onChanged?.call(text);
                },
                readOnly: readOnly,
                controller: tEC,
                obscureText: isVisible,
                maxLines: textInputType == null ? 1 : null,
                style: const TextStyle(fontSize: 18),
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  filled: true,
                  hintText: text,
                  border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  fillColor: color5,
                  contentPadding: const EdgeInsets.only(left: 5),
                ),
              ),
            )),
      ],
    );
  }
}
