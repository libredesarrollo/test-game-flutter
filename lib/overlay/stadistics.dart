import 'package:flutter/material.dart';
import 'package:testgame/main.dart';

class Statistics extends StatefulWidget {
  final MyGame game;
  Statistics({Key? key, required this.game}) : super(key: key);

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Count colision ${widget.game.colisionMeteors}',
                style: const TextStyle(color: Colors.white, fontSize: 30),
              ),
              const Expanded(
                child: SizedBox(
                  height: 10,
                ),
              ),
              GestureDetector(
                  onTap: () {
                    widget.game.paused = !widget.game.paused;
                    setState(() {});
                  },
                  child: Icon(
                      widget.game.paused == true
                          ? Icons.play_arrow
                          : Icons.pause,
                      color: Colors.white,
                      size: 40)),
              GestureDetector(
                  onTap: () {
                    print("ssssss");
                    widget.game.player.reset();
                  },
                  child:
                      const Icon(Icons.replay, color: Colors.white, size: 40)),
            ],
          ),
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              Icon(
                widget.game.colisionMeteors >= 3
                    ? Icons.favorite_border
                    : Icons.favorite,
                color: Colors.red,
              ),
              Icon(
                widget.game.colisionMeteors >= 2
                    ? Icons.favorite_border
                    : Icons.favorite,
                color: Colors.red,
              ),
              Icon(
                widget.game.colisionMeteors >= 1
                    ? Icons.favorite_border
                    : Icons.favorite,
                color: Colors.red,
              )
            ],
          )
        ],
      ),
    );
  }
}
