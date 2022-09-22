import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Credits: https://github.com/Zfinix/worddle

class ThirdleKeyboard extends StatefulWidget {
  const ThirdleKeyboard({
    Key? key,
    required this.controller,
    this.height,
    this.width,
    this.spacing = 8.0,
    this.borderRadius,
    this.color = Colors.grey,
    this.letterStyle = const TextStyle(fontSize: 2, color: Colors.black),
    this.enableSpaceBar = false,
    this.enableBackSpace = true,
    this.enableCapsLock = false,
    this.enableAllUppercase = true,
    this.enableLongPressUppercase = false,
    this.highlightColor,
    this.splashColor,
    this.onEnterTap,
  }) : super(key: key);

  // The controller connected to the InputField
  final TextEditingController controller;

  // The controller connected to the InputField
  final ValueChanged<String>? onEnterTap;

  // Vertical spacing between key rows
  final double spacing;

  // Border radius of the keys
  final BorderRadius? borderRadius;

  // Color of the keys
  final Color color;

  // TextStyle of the letters in the keys (fontsize, fontface)
  final TextStyle letterStyle;

  // the additional key that can be added to the keyboard
  final bool enableSpaceBar;
  final bool enableBackSpace;
  final bool enableCapsLock;

  // height and width of each key
  final double? height;
  final double? width;

  // Additional functionality for the keys //

  // Makes the keyboard uppercase
  final bool enableAllUppercase;

  // Long press to write uppercase letters
  final bool enableLongPressUppercase;

  // The color displayed when the key is pressed
  final Color? highlightColor;
  final Color? splashColor;

  @override
  ThirdleKeyboardState createState() => ThirdleKeyboardState();
}

class ThirdleKeyboardState extends State<ThirdleKeyboard> {
  double height = 0;
  double width = 0;
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    height = screenHeight > 800 ? screenHeight * 0.059 : screenHeight * 0.07;
    width = screenWidth > 350 ? screenWidth * 0.082 : screenWidth * 0.083;
    var keyboardLayout = layout();
    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 6,
          runSpacing: 5,
          children: keyboardLayout.sublist(0, 10),
        ),
        SizedBox(
          height: widget.spacing,
        ),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 6,
          runSpacing: 5,
          children: keyboardLayout.sublist(10, 19),
        ),
        SizedBox(
          height: widget.spacing,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            enter(),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 6,
              runSpacing: 5,
              children: keyboardLayout.sublist(19),
            ),
            widget.enableBackSpace
                ? backSpace()
                : SizedBox(
                    width: (widget.width ?? width) + 20,
                  ),
          ],
        ),
        widget.enableSpaceBar
            ? Column(
                children: [
                  SizedBox(
                    height: widget.spacing,
                  ),
                  spaceBar(),
                ],
              )
            : const Offstage(),
      ],
    );
  }

  // Letter button widget
  Widget buttonLetter(String letter) {
    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(0),
      child: SizedBox(
        height: widget.height ?? height,
        width: widget.width ?? width,
        child: Material(
          type: MaterialType.button,
          color: widget.color,
          child: InkWell(
            highlightColor: widget.highlightColor,
            splashColor: widget.splashColor,
            onTap: () {
              HapticFeedback.heavyImpact();

              if (widget.controller.text.length == 5) {
                return;
              }
              widget.controller.text += letter;
            },
            onLongPress: () {
              if (widget.enableLongPressUppercase &&
                  !widget.enableAllUppercase) {
                widget.controller.text += letter.toUpperCase();
              }
            },
            child: Center(
              child: Text(
                letter,
                style: const TextStyle(
                  fontSize: 19,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Spacebar button widget
  Widget spaceBar() {
    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(0),
      child: SizedBox(
        height: widget.height ?? height,
        width: (widget.width ?? width) + 160,
        child: Material(
          type: MaterialType.button,
          color: widget.color,
          child: InkWell(
            highlightColor: widget.highlightColor,
            splashColor: widget.splashColor,
            onTap: () {
              HapticFeedback.heavyImpact();
              widget.controller.text += ' ';
            },
            child: Center(
              child: Text(
                '_________',
                style: TextStyle(
                  fontSize: widget.letterStyle.fontSize,
                  color: widget.letterStyle.color,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Backspace button widget
  Widget backSpace() {
    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(0),
      child: SizedBox(
        height: widget.height ?? height,
        width: (widget.width ?? width) + 20,
        child: Material(
          type: MaterialType.button,
          color: widget.color,
          child: InkWell(
            highlightColor: widget.highlightColor,
            splashColor: widget.splashColor,
            onTap: () {
              HapticFeedback.heavyImpact();
              if (widget.controller.text.isNotEmpty) {
                widget.controller.text = widget.controller.text
                    .substring(0, widget.controller.text.length - 1);
              }
            },
            onLongPress: () {
              if (widget.controller.text.isNotEmpty) {
                widget.controller.text = '';
                widget.controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: widget.controller.text.length));
              }
            },
            child: Center(
              child: Icon(
                Icons.backspace,
                size: widget.letterStyle.fontSize,
                color: widget.letterStyle.color,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Capslock button widget
  Widget enter() {
    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(0),
      child: SizedBox(
        height: widget.height ?? height,
        width: (widget.width ?? width) + 20,
        child: Material(
          type: MaterialType.button,
          color: widget.color,
          child: InkWell(
            highlightColor: widget.highlightColor,
            splashColor: widget.splashColor,
            onTap: () {
              HapticFeedback.heavyImpact();

              if (widget.onEnterTap != null) {
                widget.onEnterTap!(widget.controller.text);
              }
            },
            child: Center(
              child: Text(
                'ENTER',
                style: TextStyle(
                  fontSize: 11,
                  color: widget.letterStyle.color,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Keyboard layout list
  List<Widget> layout() {
    var letters = <String>[];
    if (widget.enableAllUppercase) {
      letters = 'qwertyuiopasdfghjklzxcvbnm'.toUpperCase().split('');
    } else {
      letters = 'qwertyuiopasdfghjklzxcvbnm'.split('');
    }

    final keyboard = <Widget>[];
    for (var letter in letters) {
      keyboard.add(
        buttonLetter(letter),
      );
    }
    return keyboard;
  }
}
