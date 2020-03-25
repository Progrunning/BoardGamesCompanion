import 'package:async/async.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:board_games_companion/common/routes.dart';
import 'package:board_games_companion/models/player.dart';
import 'package:board_games_companion/services/player_service.dart';
import 'package:board_games_companion/widgets/custom_icon_button.dart';
import 'package:board_games_companion/widgets/player_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayersPage extends StatefulWidget {
  PlayersPage({Key key}) : super(key: key);

  @override
  _PlayersPageState createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
  final int _numberOfPlayerColumns = 3;
  AsyncMemoizer _memoizer;
  PlayerService _playerService;

  @override
  void initState() {
    super.initState();

    _memoizer = AsyncMemoizer();
  }

  Widget _buildTopRightCornerAction(Player player) => Align(
        alignment: Alignment.topRight,
        child: CustomIconButton(
          Icon(
            Icons.edit,
            size: Dimensions.defaultButtonIconSize,
            color: Colors.white,
          ),
          onTap: () async {
            await _navigateToCreateOrEditPlayer(context, player);
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    _playerService = Provider.of<PlayerService>(context);
    return FutureBuilder(
      future: _memoizer.runOnce(() async {
        return await _playerService.retrievePlayers();
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var players = (snapshot.data as List<Player>);
          if (players?.isEmpty ?? true) {
            return Padding(
              padding: const EdgeInsets.all(Dimensions.doubleStandardSpacing),
              child: Center(
                child: Text('It looks empty here, try adding a new player'),
              ),
            );
          }

          players.sort((a, b) => a.name?.compareTo(b.name));

          return SafeArea(
            child: GridView.count(
              crossAxisCount: _numberOfPlayerColumns,
              children: List.generate(
                players.length,
                (int index) {
                  final player = players[index];
                  return PlayerGridItem(
                    player,
                    topRightCornerActionWidget:
                        _buildTopRightCornerAction(player),
                    onTap: () async {
                      _navigateToCreateOrEditPlayer(context, player);
                    },
                  );
                },
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
                ' Oops, we ran into issue with retrieving your data. Please contact support at feedback@progrunning.net'),
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Future _navigateToCreateOrEditPlayer(
      BuildContext context, Player player) async {
    await Navigator.pushNamed(context, Routes.createEditPlayer,
        arguments: player);
  }

  @override
  void dispose() {
    _playerService.closeBox(HiveBoxes.Players);
    super.dispose();
  }
}
