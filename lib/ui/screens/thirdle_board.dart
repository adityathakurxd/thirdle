import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:thirdle/game_logic/game_kit.dart';
import 'package:thirdle/meet_logic/meet_kit.dart';
import 'package:thirdle/ui/components/guess_word_box.dart';
import 'package:thirdle/ui/components/thirdle_keyboard.dart';
import 'package:thirdle/ui/components/word_bar.dart';

class ThirdleBoard extends StatefulWidget {
  const ThirdleBoard({super.key});

  @override
  State<ThirdleBoard> createState() => _ThirdleBoardState();
}

class _ThirdleBoardState extends State<ThirdleBoard> {
  @override
  void initState() {
    context.read<GameKit>().startNewRound(9);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameKit>(
      builder: ((context, thirdleKit, child) {
        final ScrollController scrollController = ScrollController();

        void animateToCurrentWord() {
          scrollController.animateTo(
            thirdleKit.guessNo * 35.0,
            duration: const Duration(milliseconds: 600),
            curve: Curves.bounceInOut,
          );
        }

        return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Container(
              height: 150,
              width: 380,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: ListView(
                controller: scrollController,
                children: thirdleKit.guessWords
                    .map(
                      (guessWord) => WordBar(
                        word: guessWord,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          Container(
            width: 380,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: GuessWordBox(),
          ),
          ThirdleKeyboard(
            maxWordLimit: thirdleKit.wordSize,
            onEnterTap: (guessWordString) async {
              thirdleKit.makeGuess(guessWordString);

              if (context.read<GameKit>().guessStatus ==
                  GuessStatus.validGuess) {
                context
                    .read<MeetKit>()
                    .actions
                    .updateMetadata(words: context.read<GameKit>().guessWords);
                animateToCurrentWord();
              } else {
                showToastWidget(
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      child: Container(
                          height: 40,
                          width: 200,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                          ),
                          child: const Center(
                            child: Text("Invalid Word",
                                style: TextStyle(color: Colors.white)),
                          )),
                    ),
                    position: ToastPosition.bottom);
              }
            },
          ),
        ]);
      }),
    );
  }
}
