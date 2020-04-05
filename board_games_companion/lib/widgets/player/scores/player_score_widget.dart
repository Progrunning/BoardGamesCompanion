import 'package:board_games_companion/common/animation_tags.dart';
import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/stores/playthrough_store.dart';
import 'package:board_games_companion/stores/playthroughs_store.dart';
import 'package:board_games_companion/widgets/common/icon_and_text_button.dart';
import 'package:board_games_companion/widgets/common/rank_ribbon.dart';
import 'package:board_games_companion/widgets/common/shadow_box_widget.dart';
import 'package:board_games_companion/widgets/player/player_avatar.dart';
import 'package:board_games_companion/widgets/player/scores/player_score_edit_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:board_games_companion/models/player_score.dart'
    as player_score_model;

class PlayerScore extends StatelessWidget {
  final player_score_model.PlayerScore _playerScore;
  final bool readonly;
  final bool editMode;

  const PlayerScore(
    this._playerScore, {
    this.readonly = true,
    this.editMode = false,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerScoreController = TextEditingController();
    playerScoreController.text = _playerScore?.score?.value;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          child: SizedBox(
            height: Dimensions.defaultPlayerAvatarHeight,
            child: ChangeNotifierProvider.value(
              value: _playerScore,
              child: Consumer<player_score_model.PlayerScore>(
                builder: (_, store, __) {
                  Widget playerAvatar = SizedBox(
                    height: 100,
                    width: 100,
                    child: ShadowBox(
                      child: PlayerAvatar(
                        imageUri: store?.player?.imageUri,
                        medal: store?.medal,
                      ),
                      shadowOffset: Styles.defaultShadowOffset,
                      shadowColor: Theme.of(context).accentColor,
                    ),
                  );
                  if ((store?.player?.id?.isNotEmpty ?? false) &&
                      (store.score?.id?.isNotEmpty ?? false)) {
                    playerAvatar = Hero(
                        tag:
                            '${AnimationTags.playerImageHeroTag}${store?.player?.id}${store?.score?.id}',
                        child: playerAvatar);
                  }

                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          playerAvatar,
                          if ((store?.score?.value?.isNotEmpty ?? false) &&
                              store.place != null)
                            Positioned(
                              top:
                                  -2, // TODO MK Find out why there's a need for negative value
                              right: Dimensions.halfStandardSpacing,
                              child: RankRibbon(store?.place),
                            ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.standardSpacing,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Text(
                                    'Name',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(
                                    width: Dimensions.halfStandardSpacing,
                                  ),
                                  Text(
                                    store?.player?.name ?? '-',
                                    style: TextStyle(
                                      fontSize: Dimensions.largeFontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              if (editMode)
                                PlayerScoreEdit(
                                  controller: playerScoreController,
                                  onSubmit: (value) async {
                                    await _updatePlayerScore(
                                        _playerScore, value, context);
                                  },
                                ),
                              if (!editMode)
                                Text(
                                  'Score',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              if (!editMode)
                                Expanded(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          store?.score?.value ?? '-',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 32),
                                        ),
                                      ),
                                      SizedBox(
                                        width: Dimensions.standardSpacing,
                                      ),
                                      if (!readonly)
                                        IconAndTextButton(
                                          icon: Icons.edit,
                                          horizontalPadding:
                                              Dimensions.standardSpacing,
                                          onPressed: () =>
                                              _showCreateOrEditScoreDialog(
                                                  context, store),
                                        ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        if (editMode)
          SizedBox(
            height: Dimensions.standardSpacing,
          ),
        if (editMode)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconAndTextButton(
                icon: Icons.cancel,
                title: 'Cancel',
                backgroundColor: Colors.red,
                onPressed: () => Navigator.pop(context),
              ),
              SizedBox(
                width: Dimensions.standardSpacing,
              ),
              IconAndTextButton(
                icon: Icons.save,
                title: 'Save',
                onPressed: () => _updatePlayerScore(
                    _playerScore, playerScoreController.value.text, context),
              ),
            ],
          )
      ],
    );
  }

  Future<void> _showCreateOrEditScoreDialog(
      BuildContext context, player_score_model.PlayerScore playerScore) async {
    final playthroughStore = Provider.of<PlaythroughStore>(
      context,
      listen: false,
    );

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return AlertDialog(
          backgroundColor: AppTheme.primaryColor,
          title: Text(
            '${playerScore.player.name}\'s score',
            style: TextStyle(
              color: AppTheme.defaultTextColor,
            ),
          ),
          content: ChangeNotifierProvider.value(
            value: playthroughStore,
            child: PlayerScore(
              playerScore,
              editMode: true,
            ),
          ),
        );
      },
    );
  }

  Future<void> _updatePlayerScore(player_score_model.PlayerScore store,
      String value, BuildContext context) async {
    if (!await store.updatePlayerScore(value)) {
      return;
    }

    final playthroughsStore = Provider.of<PlaythroughsStore>(
      context,
      listen: false,
    );
    final playthroughStore = Provider.of<PlaythroughStore>(
      context,
      listen: false,
    );

    await playthroughsStore.updatePlaythrough(playthroughStore.playthrough);
    Navigator.pop(context);
  }
}
