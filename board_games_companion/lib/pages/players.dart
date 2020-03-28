import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/enums.dart';
import 'package:board_games_companion/models/hive/player.dart';
import 'package:board_games_companion/stores/players_store.dart';
import 'package:board_games_companion/utilities/navigator_helper.dart';
import 'package:board_games_companion/widgets/common/custom_icon_button.dart';
import 'package:board_games_companion/widgets/common/generic_error_message_widget.dart';
import 'package:board_games_companion/widgets/common/loading_indicator_widget.dart';
import 'package:board_games_companion/widgets/player/player_grid_item.dart';
import 'package:flutter/material.dart';

class PlayersPage extends StatefulWidget {
  final PlayersStore _playersStore;

  PlayersPage(this._playersStore, {Key key}) : super(key: key);

  @override
  _PlayersPageState createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
  final int _numberOfPlayerColumns = 3;

  @override
  void initState() {
    super.initState();

    widget._playersStore.loadPlayers();
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
    if (widget._playersStore.loadDataState == LoadDataState.Loaded) {
      if (widget._playersStore.players?.isEmpty ?? true) {
        return Padding(
          padding: const EdgeInsets.all(Dimensions.doubleStandardSpacing),
          child: Center(
            child: Text('It looks empty here, try adding a new player'),
          ),
        );
      }

      widget._playersStore.players.sort((a, b) => a.name?.compareTo(b.name));

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.standardSpacing),
          child: GridView.count(
            crossAxisCount: _numberOfPlayerColumns,
            children: List.generate(
              widget._playersStore.players.length,
              (int index) {
                final player = widget._playersStore.players[index];
                return PlayerGridItem(
                  player,
                  topRightCornerActionWidget:
                      _buildTopRightCornerAction(player),
                  onTap: () async {
                    await _navigateToCreateOrEditPlayer(context, player);
                  },
                );
              },
            ),
          ),
        ),
      );
    } else if (widget._playersStore.loadDataState == LoadDataState.Error) {
      return Center(
        child: GenericErrorMessage(),
      );
    }

    return LoadingIndicator();
  }

  Future _navigateToCreateOrEditPlayer(
      BuildContext context, Player player) async {
    await NavigatorHelper.navigateToCreatePlayerPage(
      context,
      player: player,
    );
  }
}
