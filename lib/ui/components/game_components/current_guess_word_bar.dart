import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thirdle/logic/game_logic/game_kit.dart';
import 'package:thirdle/utils/palette.dart';

class CurrentGuessWordBar extends StatefulWidget {
  const CurrentGuessWordBar({super.key, this.noOfLetters = 5});

  final int noOfLetters;

  @override
  State<CurrentGuessWordBar> createState() => _CurrentGuessWordBarState();
}

class _CurrentGuessWordBarState extends State<CurrentGuessWordBar> {
  @override
  Widget build(BuildContext context) {
    final gameKit = context.watch<GameKit>();

    return SizedBox(
      width: 350,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        ...gameKit.currentGuessWord.split('').map(
              (letterText) => CurrentGuessLetterTile(letterText: letterText),
            ),
        ...List.generate(
          (widget.noOfLetters - gameKit.currentGuessWord.length),
          (index) => const CurrentGuessLetterTile(letterText: ""),
        ),
      ]),
    );
  }
}

class CurrentGuessLetterTile extends StatelessWidget {
  const CurrentGuessLetterTile({super.key, required this.letterText});

  final String letterText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
            color: Palette.wordleLetterTileGreyColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Palette.secondaryColor)),
        child: Center(
          child: Text(
            letterText.toUpperCase(),
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
