import 'package:board_games_companion/common/animation_tags.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/stores/playthrough_store.dart';
import 'package:board_games_companion/widgets/common/icon_and_text_button.dart';
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
    return Container(
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
                  playerAvatar,
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.standardSpacing,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
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
                              playerScore: store,
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
          title: Text('${playerScore.player.name}\'s score'),
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
}
