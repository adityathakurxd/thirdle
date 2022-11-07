import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:thirdle/game_logic/game_kit.dart';
import 'package:thirdle/meet_logic/meet_kit.dart';
import 'package:thirdle/ui/components/peer_tile.dart';
import 'package:thirdle/utils/palette.dart';

class MeetBoard extends StatefulWidget {
  MeetBoard({super.key});

  @override
  State<MeetBoard> createState() => _MeetBoardState();
}

class _MeetBoardState extends State<MeetBoard> {
  @override
  void initState() {
    final gameKit = context.read<GameKit>();
    final meetKit = context.read<MeetKit>();

    meetKit.actions.updateMetadata(
      words: gameKit.guessWords,
      guessNo: gameKit.guessNo,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 135,
      width: 380,
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.share),
                color: Palette.secondaryColor,
                iconSize: 30,
                onPressed: (() {
                  final meetKit = context.read<MeetKit>();
                  Uri uri = Uri(
                      scheme: "http",
                      host: "app.thirdle.live",
                      queryParameters: <String, dynamic>{
                        "roomId": meetKit.actions.userRoomId,
                        "subdomain": meetKit.actions.userSubdomain,
                      });
                  Share.share(uri.toString());
                }),
              ),
            ),
          ),
          ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: context
                .watch<MeetKit>()
                .allPeers
                .map<Widget>(
                  (peer) => PeerTile(peer: peer),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
