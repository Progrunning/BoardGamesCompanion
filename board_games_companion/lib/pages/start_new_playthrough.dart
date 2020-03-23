import 'package:async/async.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:board_games_companion/models/player.dart';
import 'package:board_games_companion/services/player_service.dart';
import 'package:board_games_companion/widgets/player_grid_item.dart';
import 'package:board_games_companion/widgets/ripple_effect.dart';
import 'package:flutter/material.dart';

class StartNewPlaythroughPage extends StatefulWidget {
  StartNewPlaythroughPage({Key key}) : super(key: key);

  @override
  _StartNewPlaythroughPageState createState() =>
      _StartNewPlaythroughPageState();
}

class _StartNewPlaythroughPageState extends State<StartNewPlaythroughPage> {
  final PlayerService _playerService = PlayerService();
  final int _numberOfPlayerColumns = 2;

  AsyncMemoizer _memoizer;

  @override
  void initState() {
    super.initState();

    _memoizer = AsyncMemoizer();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _memoizer.runOnce(() async {
        return _playerService.retrievePlayers();
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data is List<Player>) {
            return Padding(
              padding: const EdgeInsets.all(
                Dimensions.standardSpacing,
              ),
              child: GridView.count(
                crossAxisCount: _numberOfPlayerColumns,
                children: List.generate(
                  (snapshot.data as List<Player>).length,
                  (int index) {
                    return Stack(
                      children: <Widget>[
                        PlayerGridItem(snapshot.data[index]),
                        Align(
                          alignment: Alignment.topRight,
                          child: Checkbox(
                            value: false,
                            onChanged: (checked) {},
                          ),
                        ),
                        Positioned.fill(
                            child: StackRippleEffect(
                          onTap: () {},
                        )),
                      ],
                    );
                  },
                ),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(Dimensions.doubleStandardSpacing),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(Dimensions.standardSpacing),
                  child: Center(
                    child: Text('It looks empty here, try adding a new players'),
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Oops, something went wrong'));
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  void dispose() {
    _playerService.closeBox(HiveBoxes.Players);
    super.dispose();
  }
}
